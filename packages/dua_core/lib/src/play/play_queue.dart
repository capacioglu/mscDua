import '../content/content_queries.dart';
import '../db/database.dart';
import '../sync/cue_timeline.dart';

/// Çalınmak istenen dua ve tekrar sayısı.
class PlayRequest {
  const PlayRequest(this.duaId, this.repeat);
  final String duaId;
  final int repeat;
}

sealed class QueueEntry {
  const QueueEntry();
}

/// Bir duanın kaydının bir turu.
class ClipEntry extends QueueEntry {
  const ClipEntry({
    required this.duaId,
    required this.track,
    required this.turn,
    required this.turns,
    required this.cues,
    required this.segmentIds,
  });
  final String duaId;
  final Track track;
  final int turn;
  final int turns;
  final List<Cue> cues;
  final List<int> segmentIds;
}

/// Dualar arası sessizlik.
class GapEntry extends QueueEntry {
  const GapEntry(this.ms);
  final int ms;
}

/// Kaydı olmayan dua: yalnızca metin gösterilir.
class TextOnlyEntry extends QueueEntry {
  const TextOnlyEntry(this.duaId);
  final String duaId;
}

/// İstekleri çalma kuyruğuna çevirir: her dua `repeat` kez, aralarında `gapMs` sessizlik.
List<QueueEntry> buildQueue(List<PlayRequest> requests, Map<String, DuaView> views, {required int gapMs}) {
  final out = <QueueEntry>[];
  void add(QueueEntry e) {
    if (out.isNotEmpty && gapMs > 0) out.add(GapEntry(gapMs));
    out.add(e);
  }

  for (final r in requests) {
    final v = views[r.duaId];
    if (v == null) continue;
    final track = v.tracks.isEmpty ? null : v.tracks.first;
    if (track == null) {
      add(TextOnlyEntry(r.duaId));
      continue;
    }
    final turns = r.repeat < 1 ? 1 : r.repeat;
    for (var t = 1; t <= turns; t++) {
      add(ClipEntry(
        duaId: r.duaId,
        track: track,
        turn: t,
        turns: turns,
        cues: v.cuesByTrack[track.id] ?? const [],
        segmentIds: v.segments.map((s) => s.id).toList(),
      ));
    }
  }
  return out;
}

class NowPlaying {
  const NowPlaying({this.duaId, this.segmentId, this.turn = 1, this.turns = 1, this.inGap = false});
  final String? duaId;
  final int? segmentId;
  final int turn;
  final int turns;
  final bool inGap;
}

/// Kuyruktaki [index] girişinin [positionMs] anında hangi dua/satırın okunduğu.
NowPlaying nowPlaying(List<QueueEntry> q, int index, int positionMs) {
  if (index < 0 || index >= q.length) return const NowPlaying();
  final e = q[index];
  switch (e) {
    case ClipEntry c:
      final tl = CueTimeline(c.segmentIds, [for (final x in c.cues) CueEntry(startMs: x.startMs, segmentId: x.segmentId)]);
      return NowPlaying(duaId: c.duaId, segmentId: tl.activeAt(positionMs)?.segmentId, turn: c.turn, turns: c.turns);
    case TextOnlyEntry t:
      return NowPlaying(duaId: t.duaId);
    case GapEntry _:
      for (var i = index - 1; i >= 0; i--) {
        final prev = q[i];
        if (prev is ClipEntry) return NowPlaying(duaId: prev.duaId, turn: prev.turn, turns: prev.turns, inGap: true);
        if (prev is TextOnlyEntry) return NowPlaying(duaId: prev.duaId, inGap: true);
      }
      return const NowPlaying(inGap: true);
  }
}
