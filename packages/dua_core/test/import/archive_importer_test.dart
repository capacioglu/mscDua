import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

Map<String, dynamic> loadMini() =>
    jsonDecode(File('test/fixtures/dua_archive.mini.json').readAsStringSync()) as Map<String, dynamic>;

void main() {
  late ContentDatabase db;
  late ArchiveImporter importer;
  setUp(() {
    db = ContentDatabase.memory();
    importer = ArchiveImporter(db);
  });
  tearDown(() => db.close());

  Future<Dua?> dua(String id) => (db.select(db.duas)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<Map<String, int?>> groupPositions(String id) async =>
      {for (final g in await db.groupsOf(id)) g.groupId: g.position};

  test('26 kategori kod ve iki dilli adla gelir; dua birden çok kategoride', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final cats = await db.select(db.categories).get();
    expect(cats, hasLength(26));
    final f = cats.firstWhere((c) => c.code == 'forgiveness');
    expect(f.nameTr, 'Mağfiret');
    expect(f.nameEn, 'Forgiveness');
    expect(await db.categoriesOf('DUA-0030'), {'Tövbe', 'Peygamber duaları'});
    expect(await db.categoriesOf('DUA-0054'), {'Mağfiret', 'Ramazan'});
  });

  test('gruplar ve sıralı üyelikler; dua iki grupta', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final g = {for (final x in await db.select(db.groups).get()) x.id: x};
    expect(g['GRP-001']!.titleTr, '40 Rabbenâ Duası');
    expect(g['GRP-005']!.titleAr, 'دُعَاءُ الْقُنُوتِ');
    expect(g['GRP-005']!.description, startsWith('Yalnızca açıkça tanınan'));
    expect(await groupPositions('DUA-0030'), {'GRP-001': 20, 'GRP-005': 3});
    expect(await groupPositions('DUA-0013'), {'GRP-001': 4, 'GRP-005': 6});
  });

  test('varyant ayrı kayıt; grupta ana dua yerine varyant yer alır', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final v = (await dua('VAR-0054-01'))!;
    expect(v.variantOf, 'DUA-0054');
    expect(v.variantKey, 'plural');
    expect(v.titleTr, (await dua('DUA-0054'))!.titleTr);
    expect(v.editorialNote, startsWith('Kunut transkriptindeki'));
    expect(await groupPositions('VAR-0054-01'), {'GRP-005': 2});
    expect(await groupPositions('DUA-0054'), isEmpty);
    expect(await db.categoriesOf('VAR-0054-01'), {'Mağfiret', 'Ramazan'});
  });

  test('çok cümleli dua okunuşa göre satırlara bölünür, anlamlar beklemede', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final segs = await db.segmentsOf('DUA-0006');
    expect(segs, hasLength(4));
    expect(segs[1].textAr, 'وَيَسِّرْ لِي أَمْرِي');
    expect(segs[1].pronunciationTr, 'Ve yessir lî emrî.');
    expect(segs[1].pronunciationTrSource, FieldSource.imported);
    expect(segs.every((s) => s.meaningTr == null && s.review == ReviewStatus.none), isTrue);
    expect((await dua('DUA-0006'))!.srcMeaningTr, startsWith('Rabbim! Gönlüme'));
  });

  test('tek satırlı dua tüm alanlarıyla gözden geçirilecek olarak gelir', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final s = (await db.segmentsOf('DUA-0013')).single;
    expect(s.meaningEn, startsWith('Our Lord, grant us good'));
    expect(s.meaningTrSource, FieldSource.imported);
    expect(s.review, ReviewStatus.review);
  });

  test('kaynak, hadis, kıssa ve okuma bilgileri saklanır; ses dosyası adı türetilir', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final d4 = (await dua('DUA-0004'))!;
    expect(d4.recitationCount, 3);
    expect(d4.recitationTimeTr, 'Sabah ve akşam');
    expect(d4.hadithGrade, 'sahih');
    expect(d4.sourceType, 'hadith');
    expect(d4.quranReference, isNull);
    expect((jsonDecode(d4.sourceJson!) as List), hasLength(2));
    final d30 = (await dua('DUA-0030'))!;
    expect(d30.quranReference, '7:23');
    expect(d30.storyTr, startsWith('Hz. Âdem ve eşi'));
    expect(d30.editorialStatus, 'source_identified');
    expect(d30.expectedAudioFile, 'dua_0030.mp3');
    expect((await dua('VAR-0054-01'))!.expectedAudioFile, 'var_0054_01.mp3');
  });

  test('ikinci içe aktarma bir şey değiştirmez', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final before = (await db.select(db.segments).get()).length;
    final r = await importer.importJson(loadMini(), fileName: 'mini.json');
    expect(r.duasCreated, 0);
    expect(r.changedDuaIds, isEmpty);
    expect((await db.select(db.segments).get()).length, before);
    expect(await db.select(db.categories).get(), hasLength(26));
  });

  test('yeniden içe aktarma onaylı ve düzeltilmiş satırı ezmez, farkı raporlar', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final repo = SegmentRepo(db);
    final seg = (await db.segmentsOf('DUA-0030')).single;
    await repo.updateField(seg.id, SegmentField.meaningTr, 'benim anlamım');
    await repo.approve(seg.id);

    final mini = loadMini();
    (mini['duas'] as List).firstWhere((d) => d['id'] == 'DUA-0030')['meaning_tr'] = 'JSON yeni anlam';
    final r = await importer.importJson(mini, fileName: 'mini.json');

    final after = (await db.segmentsOf('DUA-0030')).single;
    expect(after.review, ReviewStatus.approved);
    expect(after.meaningTr, 'benim anlamım');
    expect((await dua('DUA-0030'))!.srcMeaningTr, 'JSON yeni anlam');
    expect((await dua('DUA-0030'))!.importDiff, isNotNull);
    expect(r.changedDuaIds, ['DUA-0030']);
  });

  test('yeniden içe aktarma kullanıcının grup sırasını ve kaldırdığı kategoriyi geri almaz', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    await (db.update(db.groupItems)..where((t) => t.groupId.equals('GRP-001') & t.duaId.equals('DUA-0030')))
        .write(const GroupItemsCompanion(position: Value(99)));
    final tovbe = await (db.select(db.categories)..where((t) => t.code.equals('repentance'))).getSingle();
    await (db.delete(db.duaCategories)..where((t) => t.duaId.equals('DUA-0030') & t.categoryId.equals(tovbe.id))).go();

    final r = await importer.importJson(loadMini(), fileName: 'mini.json');
    expect((await groupPositions('DUA-0030'))['GRP-001'], 99);
    expect(await db.categoriesOf('DUA-0030'), {'Peygamber duaları'});
    expect(r.warnings.join('\n'), contains('DUA-0030'));
  });

  test('aynı JSON yeniden aktarılınca kullanıcının Arapça düzeltmesi ve çevirisi korunur', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final repo = SegmentRepo(db);
    final seg = (await db.segmentsOf('DUA-0004')).single;
    await repo.updateArabic(seg.id, '${seg.textAr}ً');
    await repo.updateField(seg.id, SegmentField.meaningTr, 'KULLANICI DÜZELTMESİ');
    final r = await importer.importJson(loadMini(), fileName: 'mini.json');
    final after = (await db.segmentsOf('DUA-0004')).single;
    expect(after.textAr, '${seg.textAr}ً');
    expect(after.meaningTr, 'KULLANICI DÜZELTMESİ');
    expect(after.meaningTrSource, FieldSource.user);
    expect(r.warnings, isEmpty);
    expect(r.changedDuaIds, isEmpty);
  });

  test('JSON Arapçası değişti ama kullanıcı satırlara dokunduysa satırlar korunur, fark raporlanır', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final seg = (await db.segmentsOf('DUA-0004')).single;
    await SegmentRepo(db).updateField(seg.id, SegmentField.meaningTr, 'benim');
    final mini = loadMini();
    (mini['duas'] as List).firstWhere((d) => d['id'] == 'DUA-0004')['text_ar'] = 'بِسْمِ اللَّهِ';
    final r = await importer.importJson(mini, fileName: 'mini.json');
    expect((await db.segmentsOf('DUA-0004')).single.meaningTr, 'benim');
    expect(r.changedDuaIds, ['DUA-0004']);
    expect((await dua('DUA-0004'))!.importDiff, contains('text_ar'));
  });

  test('onaysız ve zamansız duanın Arapçası değiştiyse satırlar yeniden oluşur', () async {
    await importer.importJson(loadMini(), fileName: 'mini.json');
    final mini = loadMini();
    final d = (mini['duas'] as List).firstWhere((d) => d['id'] == 'DUA-0006');
    d['text_ar'] = 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي';
    d['pronunciation_tr'] = 'Rabbişrah lî sadrî. Ve yessir lî emrî.';
    final r = await importer.importJson(mini, fileName: 'mini.json');
    expect((await db.segmentsOf('DUA-0006')).map((s) => s.textAr), ['رَبِّ اشْرَحْ لِي صَدْرِي', 'وَيَسِّرْ لِي أَمْرِي']);
    expect(r.warnings.join(), contains('DUA-0006'));
  });

  test('bilinmeyen kategori ve eksik grup üyesi uyarı verir', () async {
    final mini = loadMini();
    (mini['duas'] as List).first['categories'] = ['yok_boyle'];
    (mini['group_memberships'] as List)
        .add({'group_id': 'GRP-001', 'dua_id': 'DUA-9999', 'sort_order': 99, 'variant_id': null, 'repeat_count': 1});
    final r = await importer.importJson(mini, fileName: 'mini.json');
    expect(r.warnings.join('\n'), allOf(contains('yok_boyle'), contains('DUA-9999')));
  });

  test('desteklenmeyen şema sürümü reddedilir', () {
    expect(() => importer.importJson({'schema_version': '2.0.0'}, fileName: 'x'), throwsFormatException);
  });

  test('tam arşiv: 65 kayıt, 26 kategori, gruplar 40 ve 13 üyeli, uyarısız', () async {
    final full = jsonDecode(File('../../content/import/dua_archive.json').readAsStringSync()) as Map<String, dynamic>;
    final r = await importer.importJson(full, fileName: 'dua_archive.json');
    expect(r.duasCreated, 65);
    expect(r.warnings, isEmpty);
    expect(await db.select(db.categories).get(), hasLength(26));
    Future<int> count(String g) async =>
        (await (db.select(db.groupItems)..where((t) => t.groupId.equals(g))).get()).length;
    expect(await count('GRP-001'), 40);
    expect(await count('GRP-005'), 13);
    expect(await db.select(db.importLogs).get(), hasLength(1));
  });
}
