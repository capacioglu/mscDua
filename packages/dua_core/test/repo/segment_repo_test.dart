import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  late ContentDatabase db;
  late SegmentRepo repo;
  setUp(() {
    db = ContentDatabase.memory();
    repo = SegmentRepo(db);
  });
  tearDown(() => db.close());

  Future<Segment> get(int id) => (db.select(db.segments)..where((t) => t.id.equals(id))).getSingle();

  test('Arapça değişince onay gözden geçirilecek olur', () async {
    final s = await seedDua(db, 'D1', ['أ'], approved: true);
    await repo.updateArabic(s[0], 'أَ');
    final r = await get(s[0]);
    expect(r.textAr, 'أَ');
    expect(r.review, ReviewStatus.review);
  });

  test('çeviri düzeltmesi onayı bozmaz ve kaynağı kullanıcı yapar', () async {
    final s = await seedDua(db, 'D1', ['أ'], approved: true);
    await repo.updateField(s[0], SegmentField.meaningTr, 'yeni anlam');
    final r = await get(s[0]);
    expect(r.meaningTr, 'yeni anlam');
    expect(r.meaningTrSource, FieldSource.user);
    expect(r.review, ReviewStatus.approved);
  });

  test('onaylı satırın zorunlu alanı silinirse gözden geçirilecek olur', () async {
    final s = await seedDua(db, 'D1', ['أ'], approved: true);
    await repo.updateField(s[0], SegmentField.meaningEn, '');
    expect((await get(s[0])).review, ReviewStatus.review);
  });

  test('çevirisiz satır, zorunlu alanlar elle tamamlanınca gözden geçirilecek olur; eksikken kuyrukta kalır', () async {
    final s = await seedDua(db, 'D1', ['أ']);
    await repo.updateField(s[0], SegmentField.meaningTr, 'anlam');
    expect((await get(s[0])).review, ReviewStatus.none);
    await repo.updateField(s[0], SegmentField.pronunciationTr, 'okunuş');
    await repo.updateField(s[0], SegmentField.meaningEn, 'meaning');
    expect((await get(s[0])).review, ReviewStatus.review);
  });

  test('eksik alanlı satır onaylanamaz, approveAll yalnız uygunları onaylar', () async {
    final s = await seedDua(db, 'D1', ['أ', 'ب'], translated: true);
    await repo.updateField(s[1], SegmentField.meaningEn, null);
    expect(() => repo.approve(s[1]), throwsStateError);
    expect(await repo.approveAll('D1'), 1);
    expect((await get(s[0])).review, ReviewStatus.approved);
    expect((await get(s[1])).review, ReviewStatus.review);
  });

  test('bölme çevirileri boşaltır, cue ilk parçada kalır, kayıt tam zamanlı olmaz', () async {
    final s = await seedDua(db, 'D1', ['أَبْ تَثْ'], approved: true, ready: true);
    final t = await addDuaTrack(db, 'D1');
    await addCue(db, t, 0, s[0]);
    expect((await checkPublishable(db, 'D1')).ok, isTrue);

    final (a, b) = await repo.split(s[0], 4);
    final segs = await db.segmentsOf('D1');
    expect(segs.map((x) => x.textAr), ['أَبْ', 'تَثْ']);
    expect(segs.map((x) => x.position), [0, 1]);
    expect(segs.every((x) => x.review == ReviewStatus.none && x.meaningTr == null), isTrue);
    final cues = await cuesOf(db, t);
    expect(cues.map((c) => c.segmentId), [a]);
    expect(b, isNot(a));
    expect((await checkPublishable(db, 'D1')).reasons, contains('Tam zamanlanmış ses kaydı yok'));
  });

  test('birleştirme metni birleştirir, ikinci satırın cuelarını taşır', () async {
    final s = await seedDua(db, 'D1', ['أ،', 'ب.', 'ج'], approved: true);
    final t = await addDuaTrack(db, 'D1');
    await addCue(db, t, 0, s[0]);
    await addCue(db, t, 1000, s[1]);
    final merged = await repo.merge(s[0]);
    expect(merged, s[0]);
    final segs = await db.segmentsOf('D1');
    expect(segs.map((x) => x.textAr), ['أ، ب.', 'ج']);
    expect(segs.map((x) => x.position), [0, 1]);
    expect(segs.first.review, ReviewStatus.none);
    expect((await cuesOf(db, t)).map((c) => c.segmentId), [s[0], s[0]]);
  });

  test('taşıma onayı bozmaz, sıralar ardışık kalır', () async {
    final s = await seedDua(db, 'D1', ['أ', 'ب', 'ج'], approved: true);
    await repo.move(s[2], 0);
    final segs = await db.segmentsOf('D1');
    expect(segs.map((x) => x.id), [s[2], s[0], s[1]]);
    expect(segs.map((x) => x.position), [0, 1, 2]);
    expect(segs.every((x) => x.review == ReviewStatus.approved), isTrue);
  });

  test('replaceAllFromText metni böler; zamanlanmış satır varsa reddeder', () async {
    await seedDua(db, 'D1', ['eski']);
    await repo.replaceAllFromText('D1', 'أ، ب.');
    expect((await db.segmentsOf('D1')).map((x) => x.textAr), ['أ،', 'ب.']);

    final s = await seedDua(db, 'D2', ['x']);
    final t = await addDuaTrack(db, 'D2');
    await addCue(db, t, 0, s[0]);
    expect(() => repo.replaceAllFromText('D2', 'y'), throwsStateError);
  });
}
