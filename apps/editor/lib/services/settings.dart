import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Editör ayarları: `%APPDATA%\Dualarim\settings.json`.
class Settings {
  Settings({this.lastContentDir, this.ffmpegPath, this.publishDir, this._file});

  String? lastContentDir;
  String? ffmpegPath;

  /// Yayın çıktısı; boşsa `<content>/../apps/mobile/assets/content`.
  String? publishDir;
  final File? _file;

  static File defaultFile() {
    final base = Platform.environment['APPDATA'] ?? Directory.systemTemp.path;
    return File(p.join(base, 'Dualarim', 'settings.json'));
  }

  static Settings load([File? file]) {
    final f = file ?? defaultFile();
    try {
      final j = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      return Settings(
        lastContentDir: j['lastContentDir'] as String?,
        ffmpegPath: j['ffmpegPath'] as String?,
        publishDir: j['publishDir'] as String?,
        file: f,
      );
    } catch (_) {
      return Settings(file: f);
    }
  }

  static Settings inMemory() => Settings();

  Future<void> save() async {
    final f = _file;
    if (f == null) return;
    await f.parent.create(recursive: true);
    await f.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'lastContentDir': lastContentDir,
        'ffmpegPath': ffmpegPath,
        'publishDir': publishDir,
      }),
    );
  }
}
