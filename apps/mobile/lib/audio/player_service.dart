import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'silence.dart';

/// Ses motoru soyutlaması (testte sahte motor kullanılır).
abstract class AudioBackend {
  Future<void> setQueue(
    List<QueueEntry> q,
    File Function(Track) fileOf,
    String Function(String duaId) titleOf,
  );
  Future<void> play();
  Future<void> pause();
  Future<void> seekTo(int index, int ms);

  /// (kuyruk indeksi, konum ms)
  Stream<(int, int)> get progress;
  Stream<bool> get playingStream;
  Future<void> dispose();
}

/// just_audio ile kuyruk: [klip, sessizlik, klip, …]. Kaydı olmayan dua 2 sn sessizliktir.
class JustAudioBackend implements AudioBackend {
  JustAudioBackend({required this.cacheDir, this.background = true});

  /// Mobilde kilit ekranı/bildirim için MediaItem etiketi eklenir.
  final bool background;

  /// Sessizlik dosyalarının yazıldığı klasör.
  final Directory cacheDir;
  final AudioPlayer _p = AudioPlayer();

  @override
  Future<void> setQueue(
    List<QueueEntry> q,
    File Function(Track) fileOf,
    String Function(String duaId) titleOf,
  ) async {
    var n = 0;
    Object? tag(String? duaId, String suffix) => background
        ? MediaItem(
            id: '${n++}',
            title: duaId == null ? 'Dualarım' : titleOf(duaId),
            album: 'Dualarım',
            artist: suffix,
          )
        : null;
    // Boşluklar her platformda çalınabilen gerçek sessiz WAV dosyalarıdır.
    final sources = <AudioSource>[
      for (final e in q)
        switch (e) {
          ClipEntry c => AudioSource.file(
            fileOf(c.track).path,
            tag: tag(
              c.duaId,
              [
                c.track.language.toUpperCase(),
                if (c.turns > 1) '${c.turn}/${c.turns}',
              ].join(' · '),
            ),
          ),
          GapEntry g => AudioSource.file(
            (await silenceWav(cacheDir, g.ms)).path,
            tag: tag(null, ''),
          ),
          TextOnlyEntry t => AudioSource.file(
            (await silenceWav(cacheDir, 2000)).path,
            tag: tag(t.duaId, ''),
          ),
        },
    ];
    await _p.setAudioSources(
      sources,
      initialIndex: 0,
      initialPosition: Duration.zero,
    );
  }

  @override
  Future<void> play() async => unawaited(_p.play());
  @override
  Future<void> pause() => _p.pause();
  @override
  Future<void> seekTo(int index, int ms) =>
      _p.seek(Duration(milliseconds: ms), index: index);
  @override
  Stream<(int, int)> get progress =>
      _p.positionStream.map((d) => (_p.currentIndex ?? 0, d.inMilliseconds));
  @override
  Stream<bool> get playingStream => _p.playingStream;
  @override
  Future<void> dispose() => _p.dispose();
}

/// "Kaldığın yerden devam" için oturumun saklandığı yer (kullanıcı veritabanı).
class SessionStore {
  const SessionStore({required this.load, required this.save});
  final Future<String?> Function() load;
  final Future<void> Function(String? json) save;
}

/// Uygulamanın tek oynatıcısı: kuyruk kurar, o an okunan dua/satırı yayınlar,
/// dinleme oturumunu saklar.
class PlayerService extends ChangeNotifier {
  PlayerService(
    this.backend,
    this.queries, {
    required this.fileOf,
    this.store,
  }) {
    _subs.add(
      backend.progress.listen((e) {
        _index = e.$1;
        _posMs = e.$2;
        _now = nowPlaying(_queue, e.$1, e.$2);
        notifyListeners();
        if (e.$1 != _savedIndex || (e.$2 - _savedMs).abs() >= 3000) {
          _saveSession();
        }
      }),
    );
    _subs.add(
      backend.playingStream.listen((v) {
        _playing = v;
        notifyListeners();
      }),
    );
  }

  final AudioBackend backend;
  final ContentQueries queries;
  final File Function(Track) fileOf;
  final SessionStore? store;
  final List<StreamSubscription<Object?>> _subs = [];

  List<PlayRequest> _requests = [];
  int _gapMs = 0;
  int _posMs = 0;
  int _savedIndex = -1;
  int _savedMs = 0;
  Map<String, dynamic>? _pending;

  /// Kuyruk kurulurken kullanılan dinleme dili (AppServices ayarlar).
  String listenLanguage = 'ar';
  String _queueLang = 'ar';

  List<QueueEntry> _queue = [];
  Map<String, DuaView> _views = {};
  int _index = 0;
  NowPlaying _now = const NowPlaying();
  bool _playing = false;
  String? _title;

  List<QueueEntry> get queue => _queue;
  NowPlaying get now => _now;
  bool get playing => _playing;
  bool get active => _queue.isNotEmpty;
  String? get title => _title;

  /// Çalan kaydın dili (AR/TR/EN göstermek için); kayıt çalmıyorsa null.
  String? get nowLanguage {
    if (_index < 0 || _index >= _queue.length) return null;
    final e = _queue[_index];
    return e is ClipEntry ? e.track.language : null;
  }

  DuaView? viewOf(String duaId) => _views[duaId];

  /// Uygulama yeniden açılınca devam ettirilebilecek oturum var mı?
  bool get canResume => !active && _pending != null;
  String? get resumeTitle => _pending?['title'] as String?;

  Future<bool> loadSession() async {
    final raw = await store?.load();
    if (raw == null) return false;
    try {
      _pending = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      _pending = null;
    }
    notifyListeners();
    return _pending != null;
  }

  /// Saklanan oturumu aynı dua, tur ve konumdan sürdürür.
  Future<void> resume() async {
    final p = _pending;
    if (p == null) return;
    final reqs = [
      for (final r in (p['requests'] as List))
        PlayRequest(r[0] as String, r[1] as int),
    ];
    await start(
      reqs,
      gapMs: p['gapMs'] as int,
      title: p['title'] as String?,
      autoplay: false,
    );
    final index = (p['index'] as int).clamp(
      0,
      _queue.isEmpty ? 0 : _queue.length - 1,
    );
    if (_queue.isNotEmpty) await backend.seekTo(index, p['ms'] as int);
    _pending = null;
    await backend.play();
  }

  Future<void> _saveSession() async {
    final s = store;
    if (s == null || _requests.isEmpty) return;
    _savedIndex = _index;
    _savedMs = _posMs;
    await s.save(
      jsonEncode({
        'requests': [
          for (final r in _requests) [r.duaId, r.repeat],
        ],
        'gapMs': _gapMs,
        'title': _title,
        'index': _index,
        'ms': _posMs,
      }),
    );
  }

  /// Dokunulan satırdan başlatır: aynı kuyruk çalıyorsa yalnızca atlar,
  /// değilse [requests] kuyruğunu kurup o duanın ilk turunda o satıra atlar.
  Future<void> playFrom(
    List<PlayRequest> requests, {
    required int gapMs,
    String? title,
    required String duaId,
    required int segmentId,
  }) async {
    final same =
        _queue.isNotEmpty &&
        _sameRequests(requests) &&
        _gapMs == gapMs &&
        _queueLang == listenLanguage;
    if (!same) {
      await start(requests, gapMs: gapMs, title: title, autoplay: false);
    }
    await seekToSegment(duaId, segmentId);
    await backend.play();
  }

  bool _sameRequests(List<PlayRequest> other) {
    if (other.length != _requests.length) return false;
    for (var i = 0; i < other.length; i++) {
      if (other[i].duaId != _requests[i].duaId ||
          other[i].repeat != _requests[i].repeat) {
        return false;
      }
    }
    return true;
  }

  Future<void> start(
    List<PlayRequest> requests, {
    required int gapMs,
    String? title,
    bool autoplay = true,
  }) async {
    _requests = List.of(requests);
    _gapMs = gapMs;
    _pending = null;
    final views = <String, DuaView>{};
    for (final r in requests) {
      if (views.containsKey(r.duaId)) continue;
      try {
        views[r.duaId] = await queries.duaView(r.duaId);
      } catch (_) {
        // İçerikte olmayan dua sessizce atlanır.
      }
    }
    _views = views;
    _queue = buildQueue(requests, views, gapMs: gapMs, lang: listenLanguage);
    _queueLang = listenLanguage;
    _title = title;
    _index = 0;
    _posMs = 0;
    _now = _queue.isEmpty ? const NowPlaying() : nowPlaying(_queue, 0, 0);
    notifyListeners();
    if (_queue.isEmpty) return;
    await backend.setQueue(
      _queue,
      fileOf,
      (id) => views[id]?.dua.titleTr ?? id,
    );
    unawaited(_saveSession());
    if (autoplay) await backend.play();
  }

  Future<void> play() => backend.play();

  Future<void> pause() async {
    await backend.pause();
    await _saveSession();
  }

  Future<void> togglePlay() => _playing ? pause() : play();

  /// Satıra dokunulunca: çalan tur o duadaysa onun içinde, değilse duanın ilk turunda o satıra atlar.
  Future<void> seekToSegment(String duaId, int segmentId) async {
    int? index;
    final cur = _index < _queue.length ? _queue[_index] : null;
    if (cur is ClipEntry && cur.duaId == duaId) {
      index = _index;
    } else {
      for (var i = 0; i < _queue.length; i++) {
        final e = _queue[i];
        if (e is ClipEntry && e.duaId == duaId) {
          index = i;
          break;
        }
      }
    }
    if (index == null) return;
    final clip = _queue[index] as ClipEntry;
    final cue = clip.cues.where((c) => c.segmentId == segmentId).firstOrNull;
    if (cue == null) return;
    await backend.seekTo(index, cue.startMs);
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}
