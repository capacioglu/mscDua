import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

void main() {
  late ContentDatabase db;
  setUp(() => db = ContentDatabase.memory());
  tearDown(() => db.close());

  Map<String, dynamic> archive(Map<String, dynamic> dua) => {
        'schema_version': '1.0',
        'duas': [dua],
      };

  test("text_ar olmayan, meaning_tr'si olan dua yalnızca Türkçe dua olarak gelir ve yayınlanabilir", () async {
    await ArchiveImporter(db).importJson(
        archive({
          'id': 'DUA-9001',
          'title_tr': 'Sabah duası',
          'meaning_tr': "Allah'ım! Bana hayırlı bir gün ver.",
          'meaning_en': 'O Allah! Grant me a good day.',
        }),
        fileName: 't.json');
    final d = await (db.select(db.duas)..where((t) => t.id.equals('DUA-9001'))).getSingle();
    expect(d.textLanguage, 'tr');
    final segs = await db.segmentsOf('DUA-9001');
    expect(segs.map((s) => (s.textAr, s.meaningTr)), [('', "Allah'ım!"), ('', 'Bana hayırlı bir gün ver.')]);
    expect((await checkPublishable(db, 'DUA-9001')).ok, isTrue);

    // Yeniden içe aktarma satırları çoğaltmaz.
    await ArchiveImporter(db).importJson(
        archive({'id': 'DUA-9001', 'title_tr': 'Sabah duası', 'meaning_tr': "Allah'ım! Bana hayırlı bir gün ver."}),
        fileName: 't.json');
    expect(await db.segmentsOf('DUA-9001'), hasLength(2));
  });
}
