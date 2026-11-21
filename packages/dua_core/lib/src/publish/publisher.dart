import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../db/database.dart';
import '../model/enums.dart';
import '../rules/approval.dart';

class PublishReport {
  int contentVersion = 0;
  final List<String> publishedDuaIds = [];
  final Map<String, List<String>> skipped = {};

  /// Yayına alınmayan kayıtlar ve nedeni.
  final List<String> skippedTracks = [];
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

/// Yayına giden sesi [src]'den [dst]'ye yazar (ör. 64 kbps'ye dönüştürür).
typedef AudioTranscoder = Future<void> Function(File src, File dst);

/// [convert]'ü önbellekle sarar: aynı dosya (yol + boyut + değişme zamanı)
/// ikinci kez dönüştürülmez. Orijinal dosyaya dokunulmaz.
AudioTranscoder cachedTranscoder(Directory cacheDir, AudioTranscoder convert) => (src, dst) async {
      final st = src.statSync();
      final key = sha1
          .convert(utf8.encode('${p.normalize(p.absolute(src.path))}|${st.size}|${st.modified.millisecondsSinceEpoch}'))
          .toString();
      final cached = File(p.join(cacheDir.path, '$key${p.extension(src.path)}'));
      if (!cached.existsSync()) {
        await cacheDir.create(recursive: true);
        final part = File('${cached.path}.part');
        await convert(src, part);
        await part.rename(cached.path);
      }
      await cached.copy(dst.path);
    };

/// Yayınlanabilir içeriği (spec §6.5.2, §6.6) mobil için ayrı bir veritabanına
/// ve ses klasörüne aktarır. Çıktı önce geçici klasörde hazırlanır.
/// [transcode] verilirse sesler kopyalanmak yerine onunla yazılır (orijinaller kalır).
Future<PublishReport> publish(ContentDatabase db,
    {required Directory contentDir, required Directory outDir, AudioTranscoder? transcode}) async {
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

  // Ses zorunlu değil (2026-11-20): dua metin olarak yayınlanır; yalnızca dosyası
  // diskte olan ve tam zamanlı kayıtlar çıkar, diğerleri raporlanır.
  final included = <Track>[];
  for (final t in allTracks) {
    final file = audioFile(t);
    bool ok;
    if (t.ownerKind == TrackOwnerKind.dua) {
      if (!published.contains(t.duaId)) continue;
      ok = cued(t).containsAll(segsByDua[t.duaId] ?? const {});
    } else {
      final members = allItems.where((i) => i.groupId == t.groupId && published.contains(i.duaId)).map((i) => i.duaId);
      final need = {for (final m in members) ...?segsByDua[m]};
      if (need.isEmpty) continue;
      ok = cued(t).containsAll(need);
    }
    if (!file.existsSync()) {
      report.skippedTracks.add('${t.relPath}: ses dosyası diskte yok');
    } else if (!ok) {
      report.skippedTracks.add('${t.relPath}: tam zamanlanmamış');
    } else {
      included.add(t);
    }
  }
  report.publishedDuaIds.addAll(duas.map((d) => d.id).where(published.contains));
  final pubSegIds = {for (final id in published) ...?segsByDua[id]};

  // 3) Geçici klasörde üret
  final tmp = Directory('${p.normalize(p.absolute(outDir.path))}.tmp');
  if (tmp.existsSync()) await tmp.delete(recursive: true);
  await Directory(p.join(tmp.path, 'audio')).create(recursive: true);
  // Mobil pubspec bu klasörü asset olarak listeler; ElevenLabs sesi olmasa da
  // klasör (git'te de) bulunsun diye yer tutucu.
  await Directory(p.join(tmp.path, 'audio', 'tts')).create(recursive: true);
  await File(p.join(tmp.path, 'audio', 'tts', '.keep')).writeAsString('');
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
        if (transcode == null) {
          await audioFile(t).copy(dst.path);
        } else {
          await transcode(audioFile(t), dst);
        }
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
