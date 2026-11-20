import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

Dua dua(String id) => Dua(
    id: id, titleTr: id, readyToPublish: false, version: 0, sortOrder: 0, standaloneVisible: true, textLanguage: 'ar');

DuaView view(String id, {bool withTrack = true, int trackId = 1}) {
  final segs = [
    for (var i = 0; i < 2; i++) Segment(id: trackId * 10 + i, duaId: id, position: i, textAr: 'س$i', review: ReviewStatus.none)
  ];
  final track = Track(id: trackId, ownerKind: TrackOwnerKind.dua, duaId: id, relPath: 'audio/$id.mp3', label: 'x', language: 'ar', source: 'manual', isPrimary: true);
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

  group('dinleme dili', () {
    Track tr(int id, String duaId, String lang, {bool primary = true}) => Track(
        id: id, ownerKind: TrackOwnerKind.dua, duaId: duaId, relPath: 'audio/$duaId-$id.mp3', label: 'x',
        language: lang, source: 'manual', isPrimary: primary);

    DuaView v(String id, List<Track> tracks, {String textLanguage = 'ar'}) => DuaView(
          dua: Dua(id: id, titleTr: id, readyToPublish: false, version: 0, sortOrder: 0,
              standaloneVisible: true, textLanguage: textLanguage),
          segments: [Segment(id: 1, duaId: id, position: 0, textAr: 'س', review: ReviewStatus.none)],
          tracks: tracks,
          cuesByTrack: {for (final t in tracks) t.id: [Cue(id: t.id, trackId: t.id, startMs: 0, segmentId: 1)]},
          variants: [],
          categories: [],
        );

    int? picked(List<QueueEntry> q) => q.whereType<ClipEntry>().firstOrNull?.track.id;

    test('TR seçiliyken TR kaydı olan dua TR kaydını, olmayan AR kaydını çalar', () {
      final views = {
        'A': v('A', [tr(1, 'A', 'ar'), tr(2, 'A', 'tr')]),
        'B': v('B', [tr(3, 'B', 'ar')]),
      };
      expect(picked(buildQueue([PlayRequest('A', 1)], views, gapMs: 0, lang: 'tr')), 2);
      expect(picked(buildQueue([PlayRequest('B', 1)], views, gapMs: 0, lang: 'tr')), 3);
      expect(picked(buildQueue([PlayRequest('A', 1)], views, gapMs: 0)), 1);
    });

    test('Türkçe dua Arapça seçiliyken kendi dilindeki TR kaydını çalar', () {
      final views = {'T': v('T', [tr(5, 'T', 'tr')], textLanguage: 'tr')};
      expect(picked(buildQueue([PlayRequest('T', 1)], views, gapMs: 0, lang: 'ar')), 5);
      expect(buildQueue([PlayRequest('T', 1)], views, gapMs: 0, lang: 'en').single, isA<ClipEntry>());
    });

    test('aynı dilde birincil olmayan kayıt seçilmez; seçilen dilde kayıt yoksa ve AR de yoksa metin', () {
      final views = {
        'A': v('A', [tr(1, 'A', 'en', primary: false), tr(2, 'A', 'en')]),
        'B': v('B', [tr(3, 'B', 'en')]),
      };
      expect(picked(buildQueue([PlayRequest('A', 1)], views, gapMs: 0, lang: 'en')), 2);
      expect(buildQueue([PlayRequest('B', 1)], views, gapMs: 0, lang: 'tr').single, isA<TextOnlyEntry>());
    });
  });
}
