import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../db/database.dart';
import '../model/enums.dart';
import '../rules/approval.dart';

class PublishReport {
  int contentVersion = 0;
  final List<String> publishedDuaIds = [];
  final Map<String, List<String>> skipped = {};
  final List<String> publishedGroupIds = [];

  /// Grup → yayına girmeyen üyeleri.
  final Map<String, List<String>> groupMissing = {};
}

const _allowedOutEntries = {'content.db', 'content.db-journal', 'content.db-wal', 'content.db-shm', 'manifest.json', 'audio'};

/// Yayın klasörünün güvenli olduğunu doğrular (yanlış klasörü silmemek için).
void _validateOutDir(Directory contentDir, Directory outDir) {
  final c = p.normalize(p.absolute(contentDir.path));
  final o = p.normalize(p.absolute(outDir.path));
  if (p.equals(c, o) || p.isWithin(o, c) || p.isWithin(c, o)) {
    throw ArgumentError('Yayın klasörü içerik klasörüyle aynı, onu içeren ya da onun içinde olamaz: $o');
  }
  if (outDir.existsSync()) {
    final foreign = outDir.listSync().map((e) => p.basename(e.path)).where((n) => !_allowedOutEntries.contains(n)).toList();
    if (foreign.isNotEmpty) {
      throw StateError('Yayın klasöründe yayına ait olmayan dosyalar var (${foreign.join(', ')}); silinmedi: $o');
    }
  }
}

/// Yayınlanabilir içeriği (spec §6.5.2, §6.6) mobil için ayrı bir veritabanına
/// ve ses klasörüne aktarır. Çıktı önce geçici klasörde hazırlanır.
Future<PublishReport> publish(ContentDatabase db, {required Directory contentDir, required Directory outDir}) async {
  _validateOutDir(contentDir, outDir);
  final report = PublishReport();
  final manifestFile = File(p.join(outDir.path, 'manifest.json'));
  var previous = 0;
  if (manifestFile.existsSync()) {
    previous = (jsonDecode(manifestFile.readAsStringSync())['content_version'] as int?) ?? 0;
  }
  report.contentVersion = previous + 1;

  File audioFile(Track t) => File(p.joinAll([contentDir.path, ...t.relPath.split('/')]));

  // 1) Kurallara uyan dualar
  final duas = await (db.select(db.duas)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
  final published = <String>{};
  for (final d in duas) {
    final check = await checkPublishable(db, d.id);
    if (check.ok) {
      published.add(d.id);
    } else {
      report.skipped[d.id] = check.reasons;
    }
  }

  // 2) Kayıt seçimi: her yayınlanan duanın en az bir çalınabilir, tam zamanlı kaydı olana dek ele.
  final allSegs = await db.select(db.segments).get();
  final segsByDua = <String, Set<int>>{};
  for (final s in allSegs) {
    segsByDua.putIfAbsent(s.duaId, () => {}).add(s.id);
  }
  final allItems = await db.select(db.groupItems).get();
  final allTracks = await db.select(db.tracks).get();
  final cuesByTrack = <int, List<Cue>>{};
  for (final c in await db.select(db.cues).get()) {
    cuesByTrack.putIfAbsent(c.trackId, () => []).add(c);
  }
  Set<int> cued(Track t) => (cuesByTrack[t.id] ?? const []).map((c) => c.segmentId).whereType<int>().toSet();

  var included = <Track>[];
  while (true) {
    included = [];
    for (final t in allTracks) {
      if (!audioFile(t).existsSync()) continue;
      if (t.ownerKind == TrackOwnerKind.dua) {
        if (published.contains(t.duaId) && cued(t).containsAll(segsByDua[t.duaId] ?? const {})) included.add(t);
      } else {
        final members = allItems.where((i) => i.groupId == t.groupId && published.contains(i.duaId)).map((i) => i.duaId);
        final need = {for (final m in members) ...?segsByDua[m]};
        if (need.isNotEmpty && cued(t).containsAll(need)) included.add(t);
      }
    }
    final lost = <String>[];
    for (final id in published) {
      final groups = allItems.where((i) => i.duaId == id).map((i) => i.groupId).toSet();
      final ok = included.any((t) => t.duaId == id || (t.groupId != null && groups.contains(t.groupId)));
      if (!ok) lost.add(id);
    }
    if (lost.isEmpty) break;
    for (final id in lost) {
      published.remove(id);
      final missingFile = allTracks.any((t) =>
          (t.duaId == id) && !audioFile(t).existsSync() && cued(t).containsAll(segsByDua[id] ?? const {}));
      report.skipped[id] = [
        missingFile ? 'Ses dosyası diskte yok' : 'Yayınlanabilir tam zamanlı ses kaydı yok (grup kaydı eksik zamanlanmış olabilir)'
      ];
    }
  }
  report.publishedDuaIds.addAll(duas.map((d) => d.id).where(published.contains));
  final pubSegIds = {for (final id in published) ...?segsByDua[id]};

  // 3) Geçici klasörde üret
  final tmp = Directory('${p.normalize(p.absolute(outDir.path))}.tmp');
  if (tmp.existsSync()) await tmp.delete(recursive: true);
  await Directory(p.join(tmp.path, 'audio')).create(recursive: true);
  final out = ContentDatabase.open(File(p.join(tmp.path, 'content.db')));
  try {
    await out.transaction(() async {
      final links = await (db.select(db.duaCategories)..where((t) => t.duaId.isIn(published))).get();
      final usedCats = links.map((l) => l.categoryId).toSet();
      final items = allItems.where((i) => published.contains(i.duaId)).toList();
      final groupIds = items.map((i) => i.groupId).toSet();
      final groupLinks = await (db.select(db.groupCategories)..where((t) => t.groupId.isIn(groupIds))).get();
      usedCats.addAll(groupLinks.map((l) => l.categoryId));

      for (final c in await (db.select(db.categories)..where((t) => t.id.isIn(usedCats))).get()) {
        await out.into(out.categories).insert(c);
      }
      for (final d in duas.where((d) => published.contains(d.id))) {
        await out.into(out.duas).insert(d.copyWith(
              variantOf: Value(published.contains(d.variantOf) ? d.variantOf : null),
              // src* (duanın bütün okunuş/anlamı) mobilde dua altında gösterilir; korunur.
              srcTextAr: const Value(null),
              importDiff: const Value(null),
              version: report.contentVersion,
            ));
      }
      for (final l in links) {
        await out.into(out.duaCategories).insert(l);
      }
      for (final s in allSegs.where((s) => published.contains(s.duaId))) {
        await out.into(out.segments).insert(s);
      }
      for (final g in await (db.select(db.groups)
            ..where((t) => t.id.isIn(groupIds))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get()) {
        await out.into(out.groups).insert(g.copyWith(infoJson: const Value(null)));
        report.publishedGroupIds.add(g.id);
        final missing = allItems.where((i) => i.groupId == g.id && !published.contains(i.duaId)).map((i) => i.duaId).toList();
        if (missing.isNotEmpty) report.groupMissing[g.id] = missing;
      }
      for (final i in items) {
        await out.into(out.groupItems).insert(i);
      }
      for (final l in groupLinks) {
        await out.into(out.groupCategories).insert(l);
      }
      for (final t in included) {
        await out.into(out.tracks).insert(t);
        for (final c in cuesByTrack[t.id] ?? const <Cue>[]) {
          // Yayınlanmayan satıra ait işaret, metinsiz bölüm olarak kalır.
          final seg = c.segmentId != null && pubSegIds.contains(c.segmentId) ? c.segmentId : null;
          await out.into(out.cues).insert(c.copyWith(segmentId: Value(seg)));
        }
        final dst = File(p.joinAll([tmp.path, ...t.relPath.split('/')]));
        await dst.parent.create(recursive: true);
        await audioFile(t).copy(dst.path);
      }
    });
  } finally {
    await out.close();
  }

  await File(p.join(tmp.path, 'manifest.json')).writeAsString(const JsonEncoder.withIndent('  ').convert({
    'content_version': report.contentVersion,
    'published_at': DateTime.now().toIso8601String(),
    'duas': report.publishedDuaIds.length,
    'groups': report.publishedGroupIds.length,
  }));

  // 4) Değiştir: eski çıktı (doğrulanmış) silinir, geçici klasör yerine geçer.
  if (outDir.existsSync()) await outDir.delete(recursive: true);
  await outDir.parent.create(recursive: true);
  await tmp.rename(outDir.path);

  await (db.update(db.duas)..where((t) => t.id.isIn(report.publishedDuaIds)))
      .write(DuasCompanion(version: Value(report.contentVersion)));
  return report;
}
