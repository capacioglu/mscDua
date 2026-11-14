import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../services/settings.dart';

/// Açık içerik klasörü, veritabanı ve ayarlar.
class AppState extends ChangeNotifier {
  AppState._(this.db, this.contentDir, this.settings);

  factory AppState.forDatabase(
    ContentDatabase db,
    Directory contentDir, [
    Settings? settings,
  ]) => AppState._(db, contentDir, settings ?? Settings.inMemory());

  /// `content/` klasörünü açar; `content.db` yoksa oluşturur.
  static Future<AppState> open(Directory contentDir, Settings settings) async {
    await contentDir.create(recursive: true);
    for (final sub in ['audio', 'translation', 'import']) {
      await Directory(p.join(contentDir.path, sub)).create(recursive: true);
    }
    final db = ContentDatabase.open(
      File(p.join(contentDir.path, 'content.db')),
    );
    settings.lastContentDir = contentDir.path;
    await settings.save();
    return AppState._(db, contentDir, settings);
  }

  final ContentDatabase db;
  final Directory contentDir;
  final Settings settings;

  FfmpegService? get ffmpeg =>
      FfmpegService.locate(preferred: settings.ffmpegPath);

  Directory get publishDir => Directory(
    settings.publishDir ??
        p.normalize(
          p.join(contentDir.path, '..', 'apps', 'mobile', 'assets', 'content'),
        ),
  );

  File translationFile(String name) =>
      File(p.join(contentDir.path, 'translation', name));

  /// Göreli (`audio/x.mp3`) yolu mutlak dosyaya çevirir.
  File contentFile(String relPath) =>
      File(p.joinAll([contentDir.path, ...relPath.split('/')]));

  /// Veritabanı değişti; ekranlar yeniden yüklensin.
  void changed() => notifyListeners();
}
