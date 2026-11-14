import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  late ContentDatabase db;
  setUp(() => db = ContentDatabase.memory());
  tearDown(() => db.close());

  Future<Segment> get(int id) => (db.select(db.segments)..where((t) => t.id.equals(id))).getSingle();

  Map<String, dynamic> done(List<Map<String, dynamic>> segs) =>
      {'format': 'dualarim.translation.done/1', 'segments': segs};

  test('pending yalnızca çevirisi eksik satırları ve mevcut alanları içerir', () async {
    final a = await seedDua(db, 'D1', ['أ', 'ب']);
    await seedDua(db, 'D2', ['ج'], translated: true);
    await (db.update(db.duas)..where((t) => t.id.equals('D1')))
        .write(const DuasCompanion(srcMeaningTr: Value('dua anlamı'), quranReference: Value('2:201')));
    await (db.update(db.segments)..where((t) => t.id.equals(a[0])))
        .write(const SegmentsCompanion(pronunciationTr: Value('elif')));

    final p = await buildPending(db);
    expect(p['format'], 'dualarim.translation.pending/1');
    final duas = p['duas'] as List;
    expect(duas.map((d) => d['dua_id']), ['D1']);
    expect(duas.single['quran_reference'], '2:201');
    expect(duas.single['source']['meaning_tr'], 'dua anlamı');
    final segs = duas.single['segments'] as List;
    expect(segs.map((s) => s['segment_id']), a);
    expect(segs.first['text_ar'], 'أ');
    expect(segs.first['pronunciation_tr'], 'elif');
  });

  test('done uygulanınca alanlar dolar, kaynak claude, satır gözden geçirilecek', () async {
    final s = await seedDua(db, 'D1', ['أ']);
    final r = await applyDone(
        db,
        done([
          {'segment_id': s[0], 'text_ar': 'أ', 'pronunciation_tr': 'e', 'pronunciation_en': 'a', 'meaning_tr': 'm', 'meaning_en': 'n'}
        ]));
    expect(r.applied, 1);
    final g = await get(s[0]);
    expect(g.meaningEn, 'n');
    expect(g.meaningEnSource, FieldSource.claude);
    expect(g.review, ReviewStatus.review);
  });

  test('eksik kalan satır çeviri bekliyor durumunda kalır', () async {
    final s = await seedDua(db, 'D1', ['أ']);
    await applyDone(db, done([{'segment_id': s[0], 'text_ar': 'أ', 'meaning_tr': 'yalnız anlam'}]));
    final g = await get(s[0]);
    expect(g.meaningTr, 'yalnız anlam');
    expect(g.review, ReviewStatus.none);
  });

  test('Arapça metni değişmiş satır uygulanmaz', () async {
    final s = await seedDua(db, 'D1', ['أ']);
    final r = await applyDone(db, done([{'segment_id': s[0], 'text_ar': 'ب', 'meaning_tr': 'x'}]));
    expect(r.staleSegmentIds, [s[0]]);
    expect((await get(s[0])).meaningTr, isNull);
  });

  test('onaylı satır atlanır', () async {
    final s = await seedDua(db, 'D1', ['أ'], approved: true);
    final r = await applyDone(db, done([{'segment_id': s[0], 'text_ar': 'أ', 'meaning_tr': 'x'}]));
    expect(r.skippedApprovedIds, [s[0]]);
    expect((await get(s[0])).meaningTr, 'anlam 0');
  });

  test('kullanıcının düzelttiği alan korunur, diğerleri uygulanır', () async {
    final s = await seedDua(db, 'D1', ['أ']);
    await SegmentRepo(db).updateField(s[0], SegmentField.meaningTr, 'benim');
    await applyDone(db, done([
      {'segment_id': s[0], 'text_ar': 'أ', 'meaning_tr': 'claude', 'meaning_en': 'en', 'pronunciation_tr': 'p'}
    ]));
    final g = await get(s[0]);
    expect(g.meaningTr, 'benim');
    expect(g.meaningEn, 'en');
    expect(g.pronunciationTr, 'p');
  });

  test('olmayan satır hata olarak raporlanır; yanlış format reddedilir', () async {
    final r = await applyDone(db, done([{'segment_id': 999, 'text_ar': 'أ'}]));
    expect(r.errors.single, contains('999'));
    expect(() => applyDone(db, {'format': 'baska'}), throwsFormatException);
  });
}
