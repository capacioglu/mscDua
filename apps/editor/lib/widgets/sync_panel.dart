import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' hide Column;
import 'package:dua_core/dua_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import '../app/app_state.dart';
import '../services/playback.dart';
import 'common.dart';
import 'waveform_view.dart';

class _Row {
  _Row(this.seg, this.header);
  final Segment seg;

  /// Grup kaydında yeni bir duanın ilk satırıysa dua başlığı.
  final String? header;
}

const _videoExt = {'.mp4', '.mkv', '.mov', '.webm', '.avi'};
const _rates = [0.5, 0.6, 0.75, 0.9, 1.0];

String fmtMs(int ms) {
  final m = ms ~/ 60000, s = (ms % 60000) ~/ 1000, d = (ms % 1000) ~/ 100;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}.$d';
}

/// "18:22–19:02" → (ms, ms)
(int, int)? parseTimestampRange(String s) {
  final m = RegExp(r'(\d+):(\d+)\s*[–-]\s*(\d+):(\d+)').firstMatch(s);
  if (m == null) return null;
  int v(int i) => int.parse(m.group(i)!);
  return ((v(1) * 60 + v(2)) * 1000, (v(3) * 60 + v(4)) * 1000);
}

/// Ses kaydı seçimi, oynatıcı, dalga formu ve tuşla zamanlama (spec §6.4).
/// Klavye (panel odaktayken): Boşluk oynat/duraklat · Enter sıradaki satırı işaretle ·
/// G metinsiz bölüm · ←/→ seçili işaret ±100 ms (Shift ±10) · Delete sil · Ctrl+Z geri al.
class SyncPanel extends StatefulWidget {
  const SyncPanel({
    super.key,
    required this.state,
    this.duaId,
    this.groupId,
    this.playbackFactory,
  }) : assert((duaId == null) != (groupId == null));
  final AppState state;
  final String? duaId;
  final String? groupId;
  final PlaybackController Function()? playbackFactory;

  @override
  State<SyncPanel> createState() => _SyncPanelState();
}

class _SyncPanelState extends State<SyncPanel> {
  late final PlaybackController _player =
      (widget.playbackFactory ?? MediaKitPlayback.new)();
  final _focus = FocusNode(debugLabel: 'sync');
  StreamSubscription<Duration>? _sub;

  List<Track> _tracks = [];
  Track? _track;
  List<_Row> _rows = [];
  List<(int, int, String)> _hints = [];
  CueTimeline? _tl;
  CueEntry? _selected;
  final List<List<(int, int?)>> _undo = [];
  Float32List? _peaks;
  int _posMs = 0;
  double _rate = 1.0;
  String? _message;

  AppState get s => widget.state;
  ContentDatabase get db => s.db;
  bool get _isGroup => widget.groupId != null;

  @override
  void initState() {
    super.initState();
    _sub = _player.positionStream.listen((d) {
      if (mounted) setState(() => _posMs = d.inMilliseconds);
    });
    _load();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _player.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _load({int? selectTrackId}) async {
    final tracks =
        await (db.select(db.tracks)
              ..where(
                (t) => _isGroup
                    ? t.groupId.equals(widget.groupId!)
                    : t.duaId.equals(widget.duaId!),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();
    final rows = <_Row>[];
    final hints = <(int, int, String)>[];
    if (_isGroup) {
      final items =
          await (db.select(db.groupItems)
                ..where((t) => t.groupId.equals(widget.groupId!))
                ..orderBy([(t) => OrderingTerm.asc(t.position)]))
              .get();
      for (final i in items) {
        final d = await (db.select(
          db.duas,
        )..where((t) => t.id.equals(i.duaId))).getSingle();
        final segs = await db.segmentsOf(d.id);
        for (var k = 0; k < segs.length; k++) {
          rows.add(
            _Row(segs[k], k == 0 ? '${i.position ?? ''}. ${d.titleTr}' : null),
          );
        }
        for (final src
            in ((d.sourceJson == null ? const [] : jsonDecode(d.sourceJson!))
                as List)) {
          final ts = src is Map ? src['timestamp'] as String? : null;
          final r = ts == null ? null : parseTimestampRange(ts);
          if (r != null) hints.add((r.$1, r.$2, d.id));
        }
      }
    } else {
      for (final seg in await db.segmentsOf(widget.duaId!)) {
        rows.add(_Row(seg, null));
      }
    }
    final pick =
        tracks
            .where((t) => t.id == (selectTrackId ?? _track?.id))
            .firstOrNull ??
        tracks.firstOrNull;
    setState(() {
      _tracks = tracks;
      _rows = rows;
      _hints = hints;
    });
    await _selectTrack(pick);
  }

  Future<void> _selectTrack(Track? t) async {
    _undo.clear();
    _selected = null;
    _peaks = null;
    if (t == null) {
      setState(() {
        _track = null;
        _tl = null;
      });
      return;
    }
    final cues = await (db.select(
      db.cues,
    )..where((c) => c.trackId.equals(t.id))).get();
    setState(() {
      _track = t;
      _tl = CueTimeline(_rows.map((r) => r.seg.id).toList(), [
        for (final c in cues)
          CueEntry(id: c.id, startMs: c.startMs, segmentId: c.segmentId),
      ]);
    });
    final file = s.contentFile(t.relPath);
    if (file.existsSync()) {
      await _player.open(file);
      await _player.setRate(_rate);
      unawaited(_loadPeaks(t, file));
    } else {
      setState(() => _message = 'Ses dosyası bulunamadı: ${t.relPath}');
    }
  }

  Future<void> _loadPeaks(Track t, File file) async {
    final cache = File(
      p.join(
        s.contentDir.path,
        'audio',
        '.peaks',
        '${p.basename(t.relPath)}.f32',
      ),
    );
    try {
      Float32List peaks;
      if (cache.existsSync() &&
          cache.lastModifiedSync().isAfter(file.lastModifiedSync())) {
        final b = await cache.readAsBytes();
        peaks = b.buffer.asFloat32List(b.offsetInBytes, b.lengthInBytes ~/ 4);
      } else {
        final ff = s.ffmpeg;
        if (ff == null) return;
        peaks = peaksFromPcm16(await ff.decodePcm(file), 4000);
        await cache.parent.create(recursive: true);
        await cache.writeAsBytes(peaks.buffer.asUint8List());
        if (t.durationMs == null) {
          final ms = await ff.durationMs(file);
          await (db.update(db.tracks)..where((x) => x.id.equals(t.id))).write(
            TracksCompanion(durationMs: Value(ms)),
          );
        }
      }
      if (mounted && _track?.id == t.id) setState(() => _peaks = peaks);
    } catch (e) {
      if (mounted) setState(() => _message = 'Dalga formu çizilemedi: $e');
    }
  }

  int get _durationMs {
    final d = _player.duration.inMilliseconds;
    if (d > 0) return d;
    return _track?.durationMs ?? 0;
  }

  // ---- değişiklik + kayıt + geri alma ----

  List<(int, int?)> _snapshot() => [
    for (final c in _tl!.sorted) (c.startMs, c.segmentId),
  ];

  Future<void> _mutate(void Function(CueTimeline tl) change) async {
    final tl = _tl;
    if (tl == null) return;
    _undo.add(_snapshot());
    change(tl);
    setState(() {});
    await _save();
  }

  Future<void> _save() async {
    final t = _track, tl = _tl;
    if (t == null || tl == null) return;
    await db.transaction(() async {
      await (db.delete(db.cues)..where((c) => c.trackId.equals(t.id))).go();
      for (final c in tl.sorted) {
        c.id = await db
            .into(db.cues)
            .insert(
              CuesCompanion.insert(
                trackId: t.id,
                startMs: c.startMs,
                segmentId: Value(c.segmentId),
              ),
            );
      }
    });
    s.changed();
  }

  Future<void> _undoLast() async {
    if (_undo.isEmpty || _tl == null) return;
    final snap = _undo.removeLast();
    setState(() {
      _tl = CueTimeline(_rows.map((r) => r.seg.id).toList(), [
        for (final (ms, seg) in snap) CueEntry(startMs: ms, segmentId: seg),
      ]);
      _selected = null;
    });
    await _save();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final k = e.logicalKey;
    final shift = HardwareKeyboard.instance.isShiftPressed;
    final ctrl = HardwareKeyboard.instance.isControlPressed;
    final pos = _player.position.inMilliseconds;
    if (k == LogicalKeyboardKey.space) {
      _player.playOrPause();
    } else if (k == LogicalKeyboardKey.enter ||
        k == LogicalKeyboardKey.numpadEnter) {
      if (_tl?.nextSegmentId == null) return KeyEventResult.handled;
      _mutate((tl) => _selected = tl.markNext(pos));
    } else if (k == LogicalKeyboardKey.keyG) {
      _mutate((tl) => _selected = tl.markGap(pos));
    } else if ((k == LogicalKeyboardKey.arrowLeft ||
            k == LogicalKeyboardKey.arrowRight) &&
        _selected != null) {
      final step =
          (shift ? 10 : 100) * (k == LogicalKeyboardKey.arrowLeft ? -1 : 1);
      _mutate((tl) => tl.nudge(_selected!, step));
    } else if (k == LogicalKeyboardKey.delete && _selected != null) {
      _mutate((tl) => tl.remove(_selected!));
      _selected = null;
    } else if (ctrl && k == LogicalKeyboardKey.keyZ) {
      _undoLast();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  // ---- kayıt ekleme / silme ----

  Future<void> _addTrack() async {
    final picked = await FilePicker.pickFiles(
      dialogTitle: 'Ses veya video dosyası',
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'm4a',
        'wav',
        'aac',
        'ogg',
        'mp4',
        'mkv',
        'mov',
        'webm',
      ],
    );
    final path = picked.isEmpty ? null : picked.first.path;
    if (path == null || !mounted) return;
    final labelCtl = TextEditingController(
      text: _isGroup ? 'Halis Bayancuk' : 'ElevenLabs',
    );
    final label = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Kaydın etiketi (okuyan)'),
        content: TextField(controller: labelCtl, autofocus: true),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(c, labelCtl.text.trim()),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
    if (label == null || label.isEmpty) return;
    setState(() => _message = 'Kayıt hazırlanıyor…');
    try {
      final audioDir = Directory(p.join(s.contentDir.path, 'audio'));
      await audioDir.create(recursive: true);
      final src = File(path);
      final ext = p.extension(path).toLowerCase();
      late File dst;
      if (_videoExt.contains(ext)) {
        final ff = s.ffmpeg;
        if (ff == null) {
          throw StateError('Video için ffmpeg gerekli (Ayarlar).');
        }
        dst = File(
          p.join(audioDir.path, '${p.basenameWithoutExtension(path)}.m4a'),
        );
        await ff.extractAudio(src, dst);
      } else {
        dst = File(p.join(audioDir.path, p.basename(path)));
        if (!p.equals(src.path, dst.path)) await src.copy(dst.path);
      }
      final ms = await s.ffmpeg?.durationMs(dst);
      final id = await db
          .into(db.tracks)
          .insert(
            TracksCompanion.insert(
              ownerKind: _isGroup ? TrackOwnerKind.group : TrackOwnerKind.dua,
              duaId: Value(widget.duaId),
              groupId: Value(widget.groupId),
              relPath: 'audio/${p.basename(dst.path)}',
              label: label,
              durationMs: Value(ms),
            ),
          );
      setState(() => _message = null);
      s.changed();
      await _load(selectTrackId: id);
    } catch (e) {
      setState(() => _message = 'Kayıt eklenemedi: $e');
    }
  }

  Future<void> _deleteTrack() async {
    final t = _track;
    if (t == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(
          '"${t.label}" kaydı ve tüm zamanlamaları silinsin mi? (Ses dosyası diskte kalır.)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await (db.delete(db.tracks)..where((x) => x.id.equals(t.id))).go();
    s.changed();
    _track = null;
    await _load();
  }

  // ---- arayüz ----

  String _cueLabel(CueEntry c) {
    if (c.segmentId == null) return '…';
    final i = _rows.indexWhere((r) => r.seg.id == c.segmentId);
    return '${i + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final tl = _tl;
    final active = tl?.activeAt(_posMs);
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _focus.requestFocus(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: _track?.id,
                      hint: const Text('Kayıt yok — ekleyin'),
                      items: [
                        for (final t in _tracks)
                          DropdownMenuItem(
                            value: t.id,
                            child: Text(
                              '${t.label} — ${p.basename(t.relPath)}',
                            ),
                          ),
                      ],
                      onChanged: (id) =>
                          _selectTrack(_tracks.firstWhere((t) => t.id == id)),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Kayıt ekle (ses/video)',
                    onPressed: _addTrack,
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    tooltip: 'Kaydı sil',
                    onPressed: _track == null ? null : _deleteTrack,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _player.seek(
                      Duration(milliseconds: (_posMs - 2000).clamp(0, 1 << 31)),
                    ),
                    icon: const Icon(Icons.replay),
                    tooltip: '−2 sn',
                  ),
                  IconButton(
                    onPressed: () async {
                      await _player.playOrPause();
                      setState(() {});
                    },
                    icon: Icon(
                      _player.playing ? Icons.pause : Icons.play_arrow,
                    ),
                    tooltip: 'Oynat/Duraklat (Boşluk)',
                  ),
                  IconButton(
                    onPressed: () =>
                        _player.seek(Duration(milliseconds: _posMs + 2000)),
                    icon: const Icon(Icons.forward),
                    tooltip: '+2 sn',
                  ),
                  Text('${fmtMs(_posMs)} / ${fmtMs(_durationMs)}'),
                  const Spacer(),
                  const Text('Hız: '),
                  DropdownButton<double>(
                    value: _rate,
                    items: [
                      for (final r in _rates)
                        DropdownMenuItem(value: r, child: Text('${r}x')),
                    ],
                    onChanged: (r) async {
                      if (r == null) return;
                      setState(() => _rate = r);
                      await _player.setRate(r);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 110,
                child: WaveformView(
                  peaks: _peaks,
                  durationMs: _durationMs,
                  positionMs: _posMs,
                  cues: tl?.sorted ?? const [],
                  cueLabel: _cueLabel,
                  selected: _selected,
                  hints: _hints,
                  onSeek: (ms) => _player.seek(Duration(milliseconds: ms)),
                  onSelectCue: (c) => setState(() => _selected = c),
                  onMoveCue: (c, ms) => _mutate((tl) => tl.move(c, ms)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  _message ??
                      'Enter: sıradaki satırı işaretle (${_nextLabel()}) · G: metinsiz bölüm · ←/→: ±100 ms (Shift ±10) · Del: sil · Ctrl+Z: geri al',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  children: [
                    for (final r in _rows) ...[
                      if (r.header != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            r.header!,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      _segTile(r, active),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _nextLabel() {
    final id = _tl?.nextSegmentId;
    if (id == null) return 'bitti';
    return '${_rows.indexWhere((r) => r.seg.id == id) + 1}. satır';
  }

  Widget _segTile(_Row r, CueEntry? active) {
    final tl = _tl;
    final cues =
        tl?.sorted.where((c) => c.segmentId == r.seg.id).toList() ??
        const <CueEntry>[];
    final isActive = active?.segmentId == r.seg.id;
    final isNext = tl?.nextSegmentId == r.seg.id;
    return ListTile(
      key: ValueKey('sync-seg-${r.seg.id}'),
      dense: true,
      selected: isActive,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
      leading: Text('${_rows.indexOf(r) + 1}${isNext ? ' ▶' : ''}'),
      title: ArabicText(r.seg.textAr, size: 20),
      subtitle: Text(
        cues.isEmpty
            ? 'zamanlanmadı'
            : cues.map((c) => fmtMs(c.startMs)).join(', '),
      ),
      onTap: () {
        if (cues.isNotEmpty) {
          _player.seek(Duration(milliseconds: cues.first.startMs));
        }
        setState(() {
          tl?.selectNext(r.seg.id);
          _selected = cues.isEmpty ? null : cues.first;
        });
        _focus.requestFocus();
      },
    );
  }
}
