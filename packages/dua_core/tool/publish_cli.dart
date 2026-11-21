import 'dart:io';

import 'package:dua_core/dua_core.dart';

/// dart run tool/publish_cli.dart <content dir> <out dir> [ffmpeg yolu → sesler 64 kbps]
Future<void> main(List<String> args) async {
  final content = Directory(args[0]);
  final db = ContentDatabase.open(File('${content.path}/content.db'));
  try {
    final ff = args.length > 2 ? FfmpegService(args[2]) : null;
    final r = await publish(db,
        contentDir: content,
        outDir: Directory(args[1]),
        transcode: ff == null
            ? null
            : cachedTranscoder(Directory('${content.path}/.yayin-64k'), (s, d) => ff.transcodeSpeech(s, d)));
    stdout.writeln('sürüm ${r.contentVersion}: ${r.publishedDuaIds.length} dua, ${r.publishedGroupIds.length} grup; yayınlanmayan: ${r.skipped.length}');
  } finally {
    await db.close();
  }
}
