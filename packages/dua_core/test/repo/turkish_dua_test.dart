import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  late ContentDatabase db;
  late SegmentRepo repo;
  setUp(() async {
    db = ContentDatabase.memory();
    repo = SegmentRepo(db);
    await db.into(db.duas).insert(DuasCompanion.insert(id: 'T1', titleTr: 'T1', textLanguage: const Value('tr')));
  });
  tearDown(() => db.close());

  test('Türkçe duada yapıştırma Türkçe cümlelerden böler, meaningTr\'ye yazar', () async {
    await repo.replaceAllFromText('T1', 'Rabbim! Beni bağışla.');
    final segs = await db.segmentsOf('T1');
    expect(segs.map((s) => (s.textAr, s.meaningTr)), [('', 'Rabbim!'), ('', 'Beni bağışla.')]);
  });

  test('Türkçe duada bölme ve birleştirme Türkçe metinle çalışır', () async {
    await repo.replaceAllFromText('T1', 'Rabbim beni bağışla. Amin.');
    var segs = await db.segmentsOf('T1');
    await repo.split(segs.first.id, 'Rabbim'.length);
    segs = await db.segmentsOf('T1');
    expect(segs.map((s) => s.meaningTr), ['Rabbim', 'beni bağışla.', 'Amin.']);
    await repo.merge(segs[1].id);
    segs = await db.segmentsOf('T1');
    expect(segs.map((s) => s.meaningTr), ['Rabbim', 'beni bağışla. Amin.']);
    expect(segs.every((s) => s.textAr == ''), isTrue);
  });

  test('setPrimaryTrack aynı dua+dildeki diğer kayıtların birincilliğini düşürür', () async {
    await seedDua(db, 'D1', ['أ']);
    final a = await addDuaTrack(db, 'D1');
    final b = await addDuaTrack(db, 'D1', path: 'audio/b.mp3');
    final en = await db.into(db.tracks).insert(TracksCompanion.insert(
        ownerKind: TrackOwnerKind.dua, duaId: const Value('D1'), relPath: 'audio/e.mp3', label: 'e',
        language: const Value('en')));
    await setPrimaryTrack(db, a);
    final ts = {for (final t in await db.select(db.tracks).get()) t.id: t.isPrimary};
    expect(ts, {a: true, b: false, en: true});
  });
}
