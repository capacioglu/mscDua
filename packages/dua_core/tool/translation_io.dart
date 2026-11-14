import 'dart:convert';
import 'dart:io';

import 'package:dua_core/dua_core.dart';

/// Kullanım:
///   dart run tool/translation_io.dart export <content.db> <pending.json>
///   dart run tool/translation_io.dart apply  <content.db> <done.json>
Future<void> main(List<String> args) async {
  final db = ContentDatabase.open(File(args[1]));
  try {
    if (args[0] == 'export') {
      final p = await buildPending(db);
      await File(args[2]).writeAsString(const JsonEncoder.withIndent('  ').convert(p));
      final duas = p['duas'] as List;
      final segs = duas.fold<int>(0, (a, d) => a + (d['segments'] as List).length);
      stdout.writeln('dua: ${duas.length}, satır: $segs');
    } else {
      final r = await applyDone(db, jsonDecode(await File(args[2]).readAsString()) as Map<String, dynamic>);
      stdout.writeln('uygulanan: ${r.applied}, eski: ${r.staleSegmentIds}, onaylı atlanan: ${r.skippedApprovedIds}, hata: ${r.errors}');
    }
  } finally {
    await db.close();
  }
}
