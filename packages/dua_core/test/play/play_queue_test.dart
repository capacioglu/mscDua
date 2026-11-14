import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

Dua dua(String id) => Dua(
    id: id, titleTr: id, readyToPublish: false, version: 0, sortOrder: 0, standaloneVisible: true);

DuaView view(String id, {bool withTrack = true, int trackId = 1}) {
  final segs = [
    for (var i = 0; i < 2; i++) Segment(id: trackId * 10 + i, duaId: id, position: i, textAr: 'س$i', review: ReviewStatus.none)
  ];
  final track = Track(id: trackId, ownerKind: TrackOwnerKind.dua, duaId: id, relPath: 'audio/$id.mp3', label: 'x');
  return DuaView(
    dua: dua(id),
    segments: segs,
    tracks: withTrack ? [track] : [],
    cuesByTrack: withTrack
        ? {
            trackId: [
              Cue(id: 1, trackId: trackId, startMs: 0, segmentId: segs[0].id),
              Cue(id: 2, trackId: trackId, startMs: 1000, segmentId: segs[1].id),
              Cue(id: 3, trackId: trackId, startMs: 3000),
            ]
          }
        : {},
    variants: [],
    categories: [],
  );
}

String describe(QueueEntry e) => switch (e) {
      ClipEntry c => '${c.duaId} ${c.turn}/${c.turns}',
      GapEntry g => 'gap ${g.ms}',
      TextOnlyEntry t => '${t.duaId} metin',
    };

void main() {
  final views = {'A': view('A', trackId: 1), 'B': view('B', trackId: 2), 'C': view('C', withTrack: false)};

  test('tekrarlar ve aralara boşluk; sonda boşluk yok', () {
    final q = buildQueue([PlayRequest('A', 1), PlayRequest('B', 3)], views, gapMs: 1000);
    expect(q.map(describe), ['A 1/1', 'gap 1000', 'B 1/3', 'gap 1000', 'B 2/3', 'gap 1000', 'B 3/3']);
  });

  test('boşluk 0 ise boşluk girişi yok; kaydı olmayan dua metin girişi olur; bilinmeyen kimlik atlanır', () {
    final q = buildQueue([PlayRequest('A', 1), PlayRequest('C', 1), PlayRequest('YOK', 1)], views, gapMs: 0);
    expect(q.map(describe), ['A 1/1', 'C metin']);
  });

  test('nowPlaying: tekrar turu, aktif satır, boşluk ve metinsiz bölüm', () {
    final q = buildQueue([PlayRequest('A', 1), PlayRequest('B', 3)], views, gapMs: 1000);
    final n = nowPlaying(q, 4, 1500);
    expect((n.duaId, n.segmentId, n.turn, n.turns, n.inGap), ('B', 21, 2, 3, false));
    final g = nowPlaying(q, 1, 200);
    expect((g.duaId, g.segmentId, g.inGap), ('A', null, true));
    expect(nowPlaying(q, 0, 3500).segmentId, isNull);
    expect(nowPlaying(q, 0, 500).segmentId, 10);
  });
}
