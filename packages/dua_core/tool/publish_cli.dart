import 'dart:io';

import 'package:dua_core/dua_core.dart';

/// dart run tool/publish_cli.dart <content dir> <out dir>
Future<void> main(List<String> args) async {
  final content = Directory(args[0]);
  final db = ContentDatabase.open(File('${content.path}/content.db'));
  try {
    final r = await publish(db, contentDir: content, outDir: Directory(args[1]));
    stdout.writeln('sürüm ${r.contentVersion}: ${r.publishedDuaIds.length} dua, ${r.publishedGroupIds.length} grup; yayınlanmayan: ${r.skipped.length}');
  } finally {
    await db.close();
  }
}
