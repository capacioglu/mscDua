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
}

/// Yayınlanabilir içeriği (spec §6.5.2, §6.6) mobil için ayrı bir veritabanına
/// ve ses klasörüne aktarır.
Future<PublishReport> publish(ContentDatabase db, {required Directory contentDir, required Directory outDir}) async {
  final report = PublishReport();
  final manifestFile = File(p.join(outDir.path, 'manifest.json'));
  var previous = 0;
  if (manifestFile.existsSync()) {
    previous = (jsonDecode(manifestFile.readAsStringSync())['content_version'] as int?) ?? 0;
  }
  report.contentVersion = previous + 1;

  if (outDir.existsSync()) await outDir.delete(recursive: true);
  await Directory(p.join(outDir.path, 'audio')).create(recursive: true);
  final out = ContentDatabase.open(File(p.join(outDir.path, 'content.db')));

  try {
    // Hangi dualar ve kayıtlar yayınlanır?
    final timedTracks = <int>{};
    final duas = await (db.select(db.duas)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    for (final d in duas) {
      final check = await checkPublishable(db, d.id);
      if (check.ok) {
        report.publishedDuaIds.add(d.id);
        timedTracks.addAll(check.fullyTimedTrackIds);
      } else {
        report.skipped[d.id] = check.reasons;
      }
    }
    final published = report.publishedDuaIds.toSet();

    await out.transaction(() async {
      // Kategoriler (yalnızca kullanılanlar)
      final links = await (db.select(db.duaCategories)..where((t) => t.duaId.isIn(published))).get();
      final usedCats = links.map((l) => l.categoryId).toSet();

      // Gruplar (en az bir yayınlanan üyesi olanlar)
      final items = await (db.select(db.groupItems)..where((t) => t.duaId.isIn(published))).get();
      final groupIds = items.map((i) => i.groupId).toSet();
      final groupLinks = await (db.select(db.groupCategories)..where((t) => t.groupId.isIn(groupIds))).get();
      usedCats.addAll(groupLinks.map((l) => l.categoryId));

      for (final c in await (db.select(db.categories)..where((t) => t.id.isIn(usedCats))).get()) {
        await out.into(out.categories).insert(c);
      }
      for (final d in duas.where((d) => published.contains(d.id))) {
        await out.into(out.duas).insert(d.copyWith(
              variantOf: Value(published.contains(d.variantOf) ? d.variantOf : null),
              srcPronunciationTr: const Value(null),
              srcPronunciationEn: const Value(null),
              srcMeaningTr: const Value(null),
              srcMeaningEn: const Value(null),
              importDiff: const Value(null),
              version: report.contentVersion,
            ));
      }
      for (final l in links) {
        await out.into(out.duaCategories).insert(l);
      }
      final segs = await (db.select(db.segments)..where((t) => t.duaId.isIn(published))).get();
      for (final s in segs) {
        await out.into(out.segments).insert(s);
      }
      final segIds = segs.map((s) => s.id).toSet();

      for (final g in await (db.select(db.groups)
            ..where((t) => t.id.isIn(groupIds))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get()) {
        await out.into(out.groups).insert(g.copyWith(infoJson: const Value(null)));
        report.publishedGroupIds.add(g.id);
      }
      for (final i in items) {
        await out.into(out.groupItems).insert(i);
      }
      for (final l in groupLinks) {
        await out.into(out.groupCategories).insert(l);
      }

      // Kayıtlar: tam zamanlı dua kayıtları + cue'ları yalnızca yayınlanan satırlara ait grup kayıtları
      final candidates = await (db.select(db.tracks)
            ..where((t) => t.id.isIn(timedTracks) | t.groupId.isIn(groupIds)))
          .get();
      for (final t in candidates) {
        final cues = await (db.select(db.cues)..where((c) => c.trackId.equals(t.id))).get();
        if (t.ownerKind == TrackOwnerKind.group &&
            !cues.every((c) => c.segmentId == null || segIds.contains(c.segmentId))) {
          continue;
        }
        if (t.ownerKind == TrackOwnerKind.dua && !published.contains(t.duaId)) continue;
        if (t.ownerKind == TrackOwnerKind.dua && !timedTracks.contains(t.id)) continue;
        await out.into(out.tracks).insert(t);
        for (final c in cues) {
          await out.into(out.cues).insert(c);
        }
        final src = File(p.joinAll([contentDir.path, ...t.relPath.split('/')]));
        if (src.existsSync()) {
          final dst = File(p.joinAll([outDir.path, ...t.relPath.split('/')]));
          await dst.parent.create(recursive: true);
          await src.copy(dst.path);
        }
      }
    });
  } finally {
    await out.close();
  }

  await (db.update(db.duas)..where((t) => t.id.isIn(report.publishedDuaIds)))
      .write(DuasCompanion(version: Value(report.contentVersion)));
  await manifestFile.writeAsString(const JsonEncoder.withIndent('  ').convert({
    'content_version': report.contentVersion,
    'published_at': DateTime.now().toIso8601String(),
    'duas': report.publishedDuaIds.length,
    'groups': report.publishedGroupIds.length,
  }));
  return report;
}
