import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show OrderingTerm;
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
  static Future<AppState> open(Directory dir, Settings settings) async {
    // Windows kabuk API'leri karışık '/' ve '\' içeren yolları reddeder.
    final contentDir = Directory(p.normalize(p.absolute(dir.path)));
    await contentDir.create(recursive: true);
    for (final sub in ['audio', 'translation', 'import']) {
      await Directory(p.join(contentDir.path, sub)).create(recursive: true);
    }
    final db = ContentDatabase.open(
      File(p.join(contentDir.path, 'content.db')),
    );
    settings.lastContentDir = contentDir.path;
    await settings.save();
    final st = AppState._(db, contentDir, settings);
    st.lastAutoImport = await st._autoImport();
    return st;
  }

  final ContentDatabase db;
  final Directory contentDir;
  final Settings settings;

  /// Açılışta JSON kendiliğinden içe aktarıldıysa raporu (yoksa null).
  ImportReport? lastAutoImport;

  /// Kanonik arşiv: `content/import/dua_archive.json`.
  File get archiveFile =>
      File(p.join(contentDir.path, 'import', 'dua_archive.json'));

  /// Veritabanı boşsa ya da arşiv son içe aktarmadan sonra değiştiyse içe aktarır.
  /// Yeniden içe aktarma kullanıcının onay/düzeltmelerini ezmez (ArchiveImporter).
  Future<ImportReport?> _autoImport() async {
    final f = archiveFile;
    if (!f.existsSync()) return null;
    final last =
        await (db.select(db.importLogs)
              ..orderBy([(t) => OrderingTerm.desc(t.importedAt)])
              ..limit(1))
            .getSingleOrNull();
    final hasDuas = (await (db.select(db.duas)..limit(1)).get()).isNotEmpty;
    if (hasDuas &&
        last != null &&
        !f.lastModifiedSync().isAfter(last.importedAt)) {
      return null;
    }
    final json = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
    return ArchiveImporter(db).importJson(json, fileName: p.basename(f.path));
  }

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

  /// Veritabanını kapatır (başka klasöre geçerken).
  Future<void> close() => db.close();

  /// Veritabanı değişti; ekranlar yeniden yüklensin.
  void changed() => notifyListeners();
}
