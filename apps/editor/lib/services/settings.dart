import 'dart:convert';
import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:path/path.dart' as p;

/// Seçilmiş bir ElevenLabs sesi.
class VoiceRef {
  const VoiceRef(this.id, this.name);
  final String id;
  final String name;

  Map<String, String> toJson() => {'id': id, 'name': name};
  static VoiceRef? fromJson(Object? j) {
    if (j is! Map || j['id'] is! String) return null;
    return VoiceRef(
      j['id'] as String,
      (j['name'] as String?) ?? j['id'] as String,
    );
  }
}

/// ElevenLabs ayarları. API anahtarı yalnızca settings.json'da durur;
/// içerik veritabanına, yayına veya git'e girmez.
class ElevenLabsSettings {
  String? apiKey;
  String modelId = ElevenLabsClient.defaultModel;

  /// Dil (`ar` | `tr` | `en`) → ses.
  final Map<String, VoiceRef> voices = {};

  bool get hasKey => (apiKey ?? '').trim().isNotEmpty;

  Map<String, Object?> toJson() => {
    'apiKey': apiKey,
    'modelId': modelId,
    'voices': {for (final e in voices.entries) e.key: e.value.toJson()},
  };

  static ElevenLabsSettings fromJson(Object? j) {
    final s = ElevenLabsSettings();
    if (j is! Map) return s;
    s.apiKey = j['apiKey'] as String?;
    if (j['modelId'] is String && (j['modelId'] as String).isNotEmpty) {
      s.modelId = j['modelId'] as String;
    }
    final v = j['voices'];
    if (v is Map) {
      for (final e in v.entries) {
        final ref = VoiceRef.fromJson(e.value);
        if (ref != null) s.voices['${e.key}'] = ref;
      }
    }
    return s;
  }
}

/// Editör ayarları: `%APPDATA%\Dualarim\settings.json`.
class Settings {
  Settings({
    this.lastContentDir,
    this.ffmpegPath,
    this.publishDir,
    ElevenLabsSettings? elevenLabs,
    this._file,
  }) : elevenLabs = elevenLabs ?? ElevenLabsSettings();

  String? lastContentDir;
  String? ffmpegPath;

  /// Yayın çıktısı; boşsa `<content>/../apps/mobile/assets/content`.
  String? publishDir;
  final ElevenLabsSettings elevenLabs;
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
        elevenLabs: ElevenLabsSettings.fromJson(j['elevenLabs']),
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
        'elevenLabs': elevenLabs.toJson(),
      }),
    );
  }
}
