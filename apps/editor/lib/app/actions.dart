import 'dart:convert';
import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'app_state.dart';

Future<void> showReport(
  BuildContext context,
  String title,
  List<String> lines,
) => showDialog(
  context: context,
  builder: (c) => AlertDialog(
    title: Text(title),
    content: SizedBox(
      width: 640,
      child: SingleChildScrollView(
        child: SelectableText(lines.isEmpty ? 'Tamam.' : lines.join('\n')),
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(c), child: const Text('Kapat')),
    ],
  ),
);

Future<void> _guard(
  BuildContext context,
  String title,
  Future<List<String>> Function() body,
) async {
  try {
    final lines = await body();
    if (context.mounted) await showReport(context, title, lines);
  } catch (e) {
    if (context.mounted) await showReport(context, '$title — hata', ['$e']);
  }
}

Future<void> importArchiveAction(BuildContext context, AppState s) async {
  final picked = await FilePicker.pickFiles(
    dialogTitle: 'Dua arşivi (JSON) seç',
    type: FileType.custom,
    allowedExtensions: ['json'],
    initialDirectory: p.join(s.contentDir.path, 'import'),
  );
  final path = picked.isEmpty ? null : picked.first.path;
  if (path == null || !context.mounted) return;
  await _guard(context, 'JSON içe aktarma', () async {
    final json =
        jsonDecode(await File(path).readAsString()) as Map<String, dynamic>;
    final r = await ArchiveImporter(s.db)
        .importJson(json, fileName: p.basename(path));
    s.changed();
    return [
      'Yeni dua: ${r.duasCreated}, güncellenen: ${r.duasUpdated}, yeni grup: ${r.groupsCreated}, yeni satır: ${r.segmentsCreated}',
      if (r.changedDuaIds.isNotEmpty)
        'JSON\'da değişiklik olan dualar: ${r.changedDuaIds.join(', ')}',
      ...r.warnings.map((w) => '⚠ $w'),
    ];
  });
}

Future<void> matchAudioAction(BuildContext context, AppState s) async {
  final dir = await FilePicker.getDirectoryPath(
    dialogTitle: 'Ses dosyalarının klasörü',
  );
  if (dir == null || !context.mounted) return;
  await _guard(context, 'Sesleri eşleştir', () async {
    final r = await matchAudioFolder(s.db, Directory(dir), s.contentDir);
    s.changed();
    return [
      'Eşleşen: ${r.matched.length}',
      ...r.matched.map((m) => '  ${m.$1} ← ${m.$2}'),
      if (r.unmatchedFiles.isNotEmpty)
        'Eşleşmeyen dosyalar: ${r.unmatchedFiles.join(', ')}',
      if (r.duasWithoutFile.isNotEmpty)
        'Sesi olmayan dualar (${r.duasWithoutFile.length}): ${r.duasWithoutFile.join(', ')}',
    ];
  });
}

Future<void> sendToTranslationAction(BuildContext context, AppState s) =>
    _guard(context, 'Çeviriye gönder', () async {
      final pending = await buildPending(s.db);
      final f = s.translationFile('pending.json');
      await f.writeAsString(
        const JsonEncoder.withIndent('  ').convert(pending),
      );
      final n = (pending['duas'] as List).length;
      return [
        '$n dua ${f.path} dosyasına yazıldı.',
        if (n > 0)
          'Claude\'a "çevirileri yap" deyin; bitince "Çevirileri içe aktar".',
      ];
    });

Future<void> importTranslationsAction(BuildContext context, AppState s) =>
    _guard(context, 'Çevirileri içe aktar', () async {
      final f = s.translationFile('done.json');
      if (!f.existsSync()) return ['${f.path} bulunamadı.'];
      final r = await applyDone(
        s.db,
        jsonDecode(await f.readAsString()) as Map<String, dynamic>,
      );
      s.changed();
      return [
        'Uygulanan satır: ${r.applied}',
        if (r.staleSegmentIds.isNotEmpty)
          'Arapçası değişmiş (uygulanmadı): ${r.staleSegmentIds.join(', ')}',
        if (r.skippedApprovedIds.isNotEmpty)
          'Onaylı olduğu için atlanan: ${r.skippedApprovedIds.join(', ')}',
        ...r.errors.map((e) => '⚠ $e'),
      ];
    });

Future<void> publishAction(
  BuildContext context,
  AppState s,
) => _guard(context, 'Mobil için yayınla', () async {
  final r = await publish(s.db, contentDir: s.contentDir, outDir: s.publishDir);
  s.changed();
  return [
    'İçerik sürümü: ${r.contentVersion} → ${s.publishDir.path}',
    'Yayınlanan dua: ${r.publishedDuaIds.length}, grup: ${r.publishedGroupIds.length}',
    if (r.skipped.isNotEmpty) 'Yayınlanmayan (${r.skipped.length}):',
    ...r.skipped.entries.map((e) => '  ${e.key}: ${e.value.join('; ')}'),
    if (r.groupMissing.isNotEmpty) 'Gruplarda eksik kalan üyeler:',
    ...r.groupMissing.entries.map((e) => '  ${e.key}: ${e.value.join(', ')}'),
  ];
});
