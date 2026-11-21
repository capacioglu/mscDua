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

  test('sesi olmayan dua da metin olarak çıkar; duanın bütün anlamı mobile gider', () async {
    await publishable('D1');
    await seedDua(db, 'D2', ['جَ'], translated: true);
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedDuaIds, ['D1', 'D2']);
    expect(r.skipped, isEmpty);

    final o = await openOut();
    expect((await o.select(o.duas).get()).map((d) => d.id), ['D1', 'D2']);
    expect((await o.select(o.tracks).get()).map((t) => t.duaId), ['D1']);
    expect(await o.select(o.cues).get(), hasLength(2));
    final d1 = await (o.select(o.duas)..where((t) => t.id.equals('D1'))).getSingle();
    expect(d1.srcMeaningTr, 'kaynak');
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

  test('dönüştürücü verilirse yayına dönüştürülmüş ses gider, orijinal değişmez', () async {
    await publishable('D1');
    final calls = <String>[];
    await publish(db, contentDir: content, outDir: out, transcode: (src, dst) async {
      calls.add(p.basename(src.path));
      await dst.writeAsBytes([9, 9]);
    });
    expect(calls, ['d1.mp3']);
    expect(File(p.join(out.path, 'audio', 'd1.mp3')).readAsBytesSync(), [9, 9]);
    expect(File(p.join(content.path, 'audio', 'd1.mp3')).readAsBytesSync(), [1, 2, 3]);
  });

  test('önbellekli dönüştürücü aynı dosyayı ikinci yayında yeniden dönüştürmez', () async {
    await publishable('D1');
    var n = 0;
    final cache = Directory(p.join(tmp.path, 'cache'));
    final t = cachedTranscoder(cache, (src, dst) async {
      n++;
      await dst.writeAsBytes([7]);
    });
    await publish(db, contentDir: content, outDir: out, transcode: t);
    await publish(db, contentDir: content, outDir: out, transcode: t);
    expect(n, 1);
    expect(File(p.join(out.path, 'audio', 'd1.mp3')).readAsBytesSync(), [7]);
  });

  test('grup tüm üyeleriyle (sesi olmayan dahil), sıra korunarak; üyesiz grup çıkmaz', () async {
    await publishable('D1');
    await seedDua(db, 'D2', ['جَ'], translated: true);
    await publishable('D3');
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'G', titleTr: 'g'));
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'BOS', titleTr: 'boş'));
    for (final (id, pos) in [('D1', 1), ('D2', 2), ('D3', 3)]) {
      await db.into(db.groupItems).insert(GroupItemsCompanion.insert(groupId: 'G', duaId: id, position: Value(pos)));
    }
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedGroupIds, ['G']);
    final o = await openOut();
    final items = await (o.select(o.groupItems)..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    expect(items.map((i) => (i.duaId, i.position)), [('D1', 1), ('D2', 2), ('D3', 3)]);
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

  test('grup kaydı: tüm üyeler işaretliyse çıkar, eksikse çıkmaz ve raporlanır', () async {
    final a = await seedDua(db, 'A', ['أَ'], approved: true, ready: true);
    final b = await seedDua(db, 'B', ['بَ', 'تَ'], translated: true);
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'G', titleTr: 'g'));
    for (final (id, pos) in [('A', 1), ('B', 2)]) {
      await db.into(db.groupItems).insert(GroupItemsCompanion.insert(groupId: 'G', duaId: id, position: Value(pos)));
    }
    final t = await groupTrack('G', [(0, a[0]), (1000, b[0])]); // B'nin 2. satırı işaretsiz
    var r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedDuaIds, ['A', 'B']);
    expect(r.skippedTracks.join(), contains('tam zamanlanmamış'));
    await addCue(db, t, 2000, b[1]);
    r = await publish(db, contentDir: content, outDir: out);
    final o = await openOut();
    expect(await o.select(o.tracks).get(), hasLength(1));
    expect((await o.select(o.cues).get()).map((c) => c.segmentId), [a[0], b[0], b[1]]);
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
    expect(r.publishedDuaIds, ['A', 'C']); // A metin olarak çıkar
    expect(r.groupMissing, isEmpty);
    final o = await openOut();
    expect((await o.select(o.tracks).get()).map((t) => t.relPath), ['audio/c.mp3']);
    await o.close();
  });

  test('ses dosyası diskte yoksa kayıt çıkmaz, dua metin olarak çıkar; rapor eder', () async {
    await publishable('D1');
    await File(p.join(content.path, 'audio', 'd1.mp3')).delete();
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedDuaIds, ['D1']);
    expect(r.skippedTracks.join(), contains('d1.mp3'));
    final o = await openOut();
    expect(await o.select(o.tracks).get(), isEmpty);
    await o.close();
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
    await seedDua(db, 'D1', []); // satırı yok → yayınlanamaz
    await publishable('V1');
    await (db.update(db.duas)..where((t) => t.id.equals('V1'))).write(const DuasCompanion(variantOf: Value('D1')));
    final r = await publish(db, contentDir: content, outDir: out);
    expect(r.publishedDuaIds, ['V1']);
    final o = await openOut();
    expect((await o.select(o.duas).getSingle()).variantOf, isNull);
    await o.close();
  });
}
