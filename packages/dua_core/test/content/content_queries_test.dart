import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

void main() {
  late ContentDatabase db;
  late ContentQueries q;

  setUp(() async {
    db = ContentDatabase.memory();
    await ArchiveImporter(db).importJson(
        jsonDecode(File('test/fixtures/dua_archive.mini.json').readAsStringSync()) as Map<String, dynamic>,
        fileName: 'mini.json');
    final t = await db.into(db.tracks).insert(TracksCompanion.insert(
        ownerKind: TrackOwnerKind.dua, duaId: const Value('DUA-0006'), relPath: 'audio/6.mp3', label: 'x'));
    final segs = await db.segmentsOf('DUA-0006');
    for (var i = 0; i < segs.length; i++) {
      await db.into(db.cues).insert(CuesCompanion.insert(trackId: t, startMs: i * 1000, segmentId: Value(segs[i].id)));
    }
    q = ContentQueries(db);
  });
  tearDown(() => db.close());

  test('gruplar ve sıralı üyeler; grupta varyant yer alır', () async {
    expect((await q.groups()).map((g) => g.id), ['GRP-001', 'GRP-005']);
    final kunut = await q.groupEntries('GRP-005');
    expect(kunut.map((e) => e.dua.id), ['VAR-0054-01', 'DUA-0030', 'DUA-0013', 'DUA-0056-11']);
    expect(kunut.first.item.position, 2);
  });

  test('kategori listesi varyantları tek başına göstermez', () async {
    final cats = await q.categories();
    expect(cats, hasLength(26));
    final magfiret = cats.firstWhere((c) => c.code == 'forgiveness');
    final ids = (await q.duasInCategory(magfiret.id)).map((d) => d.id);
    expect(ids, contains('DUA-0054'));
    expect(ids, isNot(contains('VAR-0054-01')));
    expect((await q.allStandalone()).map((d) => d.id), isNot(contains('VAR-0054-01')));
  });

  test('dua görünümü satır, kayıt, işaret, varyant ve kategori içerir', () async {
    final v = await q.duaView('DUA-0006');
    expect(v.segments, hasLength(4));
    expect(v.tracks, hasLength(1));
    expect(v.cuesByTrack[v.tracks.single.id], hasLength(4));
    expect(v.categories, unorderedEquals(['Peygamber duaları', 'Kolaylık']));
    expect((await q.duaView('DUA-0054')).variants.map((d) => d.id), ['VAR-0054-01']);
  });

  test('normalleştirme', () {
    expect(normalizeArabic('رَبَّنَا آتِنَا'), 'ربنا اتنا');
    expect(normalizeLatin("Rabbenâ İnneke ve'l-Hakk"), 'rabbena inneke velhakk');
  });

  test('arama: harekesiz Arapça, şapkasız ve büyük harfli Türkçe', () async {
    expect((await q.search('ربنا ظلمنا')).map((d) => d.id), contains('DUA-0030'));
    expect((await q.search('rabbena atina')).map((d) => d.id), contains('DUA-0013'));
    expect((await q.search('RABBENÂ ÂTİNÂ')).map((d) => d.id), contains('DUA-0013'));
    expect((await q.search('tövbe')).map((d) => d.id), contains('DUA-0030'));
    expect(await q.search('  '), isEmpty);
  });
}
