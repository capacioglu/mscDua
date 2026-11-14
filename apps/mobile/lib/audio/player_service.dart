import 'dart:async';
import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

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
  JustAudioBackend({this.background = true});

  /// Mobilde kilit ekranı/bildirim için MediaItem etiketi eklenir.
  final bool background;
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
    final sources = <AudioSource>[
      for (final e in q)
        switch (e) {
          ClipEntry c => AudioSource.file(
            fileOf(c.track).path,
            tag: tag(c.duaId, c.turns > 1 ? '${c.turn}/${c.turns}' : ''),
          ),
          GapEntry g => SilenceAudioSource(
            duration: Duration(milliseconds: g.ms),
            tag: tag(null, ''),
          ),
          TextOnlyEntry t => SilenceAudioSource(
            duration: const Duration(seconds: 2),
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

/// Uygulamanın tek oynatıcısı: kuyruk kurar, o an okunan dua/satırı yayınlar.
class PlayerService extends ChangeNotifier {
  PlayerService(this.backend, this.queries, {required this.fileOf}) {
    _subs.add(
      backend.progress.listen((e) {
        _index = e.$1;
        _now = nowPlaying(_queue, e.$1, e.$2);
        notifyListeners();
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
  final List<StreamSubscription<Object?>> _subs = [];

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
  DuaView? viewOf(String duaId) => _views[duaId];

  Future<void> start(
    List<PlayRequest> requests, {
    required int gapMs,
    String? title,
  }) async {
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
    _queue = buildQueue(requests, views, gapMs: gapMs);
    _title = title;
    _index = 0;
    _now = _queue.isEmpty ? const NowPlaying() : nowPlaying(_queue, 0, 0);
    notifyListeners();
    if (_queue.isEmpty) return;
    await backend.setQueue(
      _queue,
      fileOf,
      (id) => views[id]?.dua.titleTr ?? id,
    );
    await backend.play();
  }

  Future<void> play() => backend.play();
  Future<void> pause() => backend.pause();
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
