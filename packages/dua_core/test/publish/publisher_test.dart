import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  late ContentDatabase db;
  late Directory tmp, content, out;

  setUp(() async {
    db = ContentDatabase.memory();
    tmp = await Directory.systemTemp.createTemp('dualarim_pub');
    content = await Directory(p.join(tmp.path, 'content')).create();
    out = Directory(p.join(tmp.path, 'out'));
    await Directory(p.join(content.path, 'audio')).create();
  });
  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  /// Yayınlanabilir dua: onaylı satırlar + tam zamanlı dua kaydı + ses dosyası.
  Future<void> publishable(String id, {List<String> texts = const ['أَ', 'بِ']}) async {
    final s = await seedDua(db, id, texts, approved: true, ready: true);
    final file = 'audio/${id.toLowerCase()}.mp3';
    await File(p.join(content.path, file)).writeAsBytes([1, 2, 3]);
    final t = await addDuaTrack(db, id, path: file);
    for (var i = 0; i < s.length; i++) {
      await addCue(db, t, i * 1000, s[i]);
    }
    await (db.update(db.duas)..where((x) => x.id.equals(id)))
        .write(const DuasCompanion(srcMeaningTr: Value('kaynak'), importDiff: Value('{}')));
  }

  Future<ContentDatabase> openOut() async => ContentDatabase.open(File(p.join(out.path, 'content.db')));

  test('yalnızca yayınlanabilir dualar ve onaylı satırlar çıkar; nedenler raporlanır', () async {
    await publishable('D1');
    await seedDua(db, 'D2', ['جَ'], translated: true, ready: true);
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedDuaIds, ['D1']);
    expect(r.skipped['D2'], contains('Onaylanmamış satır: 1'));

    final o = await openOut();
    expect((await o.select(o.duas).get()).map((d) => d.id), ['D1']);
    expect(await (o.select(o.segments)..where((t) => t.review.equalsValue(ReviewStatus.approved).not())).get(), isEmpty);
    expect(await o.select(o.cues).get(), hasLength(2));
    final d1 = await o.select(o.duas).getSingle();
    expect(d1.srcMeaningTr, isNull);
    expect(d1.importDiff, isNull);
    await o.close();
  });

  test('Arapça metin bayt bayt aynı; ses dosyası kopyalanır', () async {
    const ar = 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَعَلَىٰ';
    await publishable('D1', texts: [ar]);
    await publish(db, contentDir: content, outDir: out);
    final o = await openOut();
    expect(utf8.encode((await o.select(o.segments).getSingle()).textAr), utf8.encode(ar));
    await o.close();
    expect(File(p.join(out.path, 'audio', 'd1.mp3')).existsSync(), isTrue);
  });

  test('grup yalnızca yayınlanan üyeleriyle, sıra korunarak; boş grup çıkmaz', () async {
    await publishable('D1');
    await seedDua(db, 'D2', ['جَ'], translated: true);
    await publishable('D3');
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'G', titleTr: 'g'));
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'BOS', titleTr: 'boş'));
    for (final (id, pos) in [('D1', 1), ('D2', 2), ('D3', 3)]) {
      await db.into(db.groupItems).insert(GroupItemsCompanion.insert(groupId: 'G', duaId: id, position: Value(pos)));
    }
    await db.into(db.groupItems).insert(GroupItemsCompanion.insert(groupId: 'BOS', duaId: 'D2'));
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedGroupIds, ['G']);
    final o = await openOut();
    final items = await (o.select(o.groupItems)..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    expect(items.map((i) => (i.duaId, i.position)), [('D1', 1), ('D3', 3)]);
    expect((await o.select(o.groups).get()).map((g) => g.id), ['G']);
    await o.close();
  });

  test('kategoriler çoklu olarak taşınır', () async {
    await publishable('D1');
    for (final n in ['Mağfiret', 'Aile']) {
      await db.into(db.duaCategories)
          .insert(DuaCategoriesCompanion.insert(duaId: 'D1', categoryId: await db.ensureCategory(n)));
    }
    await db.ensureCategory('Kullanılmayan');
    await publish(db, contentDir: content, outDir: out);
    final o = await openOut();
    expect(await o.categoriesOf('D1'), {'Mağfiret', 'Aile'});
    expect(await o.select(o.categories).get(), hasLength(2));
    await o.close();
  });

  test('içerik sürümü her yayında artar ve kaynakta da işlenir', () async {
    await publishable('D1');
    final r1 = await publish(db, contentDir: content, outDir: out);
    final r2 = await publish(db, contentDir: content, outDir: out);
    expect([r1.contentVersion, r2.contentVersion], [1, 2]);
    final manifest = jsonDecode(File(p.join(out.path, 'manifest.json')).readAsStringSync());
    expect(manifest['content_version'], 2);
    expect(manifest['duas'], 1);
    expect((await (db.select(db.duas)..where((t) => t.id.equals('D1'))).getSingle()).version, 2);
  });

  Future<int> groupTrack(String groupId, List<(int, int?)> cues) async {
    await File(p.join(content.path, 'audio', 'g.mp3')).writeAsBytes([9]);
    final t = await addGroupTrack(db, groupId, path: 'audio/g.mp3');
    for (final (ms, seg) in cues) {
      await addCue(db, t, ms, seg);
    }
    return t;
  }

  test('grup kaydı: yayınlanmayan üyenin işaretleri metinsiz bölüm olur, dua sessiz kalmaz', () async {
    final a = await seedDua(db, 'A', ['أَ'], approved: true, ready: true);
    final b = await seedDua(db, 'B', ['بَ'], translated: true);
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'G', titleTr: 'g'));
    for (final (id, pos) in [('A', 1), ('B', 2)]) {
      await db.into(db.groupItems).insert(GroupItemsCompanion.insert(groupId: 'G', duaId: id, position: Value(pos)));
    }
    await groupTrack('G', [(0, a[0]), (1000, b[0])]);
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedDuaIds, ['A']);
    final o = await openOut();
    expect(await o.select(o.tracks).get(), hasLength(1));
    expect((await o.select(o.cues).get()).map((c) => c.segmentId), [a[0], null]);
    await o.close();
  });

  test('yayınlanan üyeleri tam zamanlanmamış grup kaydı çıkmaz; ona dayanan dua da çıkmaz', () async {
    final a = await seedDua(db, 'A', ['أَ'], approved: true, ready: true);
    await publishable('C'); // C kendi kaydıyla yayınlanabilir
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'G', titleTr: 'g'));
    for (final (id, pos) in [('A', 1), ('C', 2)]) {
      await db.into(db.groupItems).insert(GroupItemsCompanion.insert(groupId: 'G', duaId: id, position: Value(pos)));
    }
    await groupTrack('G', [(0, a[0])]); // C grup kaydında işaretlenmemiş
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedDuaIds, ['C']);
    expect(r.skipped['A']!.join(), contains('tam zamanlı'));
    expect(r.groupMissing['G'], ['A']);
    final o = await openOut();
    expect((await o.select(o.tracks).get()).map((t) => t.relPath), ['audio/c.mp3']);
    await o.close();
  });

  test('ses dosyası diskte yoksa dua yayınlanmaz', () async {
    await publishable('D1');
    await File(p.join(content.path, 'audio', 'd1.mp3')).delete();
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedDuaIds, isEmpty);
    expect(r.skipped['D1']!.join(), contains('Ses dosyası'));
  });

  test('yayın klasörü içerik klasörü olamaz; yabancı dosya içeren klasör silinmez', () async {
    await publishable('D1');
    expect(() => publish(db, contentDir: content, outDir: content), throwsArgumentError);
    expect(() => publish(db, contentDir: content, outDir: tmp), throwsArgumentError);
    await out.create();
    final foreign = File(p.join(out.path, 'onemli.txt'))..writeAsStringSync('x');
    expect(() => publish(db, contentDir: content, outDir: out), throwsStateError);
    expect(foreign.existsSync(), isTrue);
  });

  test('ana duası yayınlanmayan varyant bağı olmadan yayınlanır', () async {
    await seedDua(db, 'D1', ['أَ'], translated: true);
    await publishable('V1');
    await (db.update(db.duas)..where((t) => t.id.equals('V1'))).write(const DuasCompanion(variantOf: Value('D1')));
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedDuaIds, ['V1']);
    final o = await openOut();
    expect((await o.select(o.duas).getSingle()).variantOf, isNull);
    await o.close();
  });
}
