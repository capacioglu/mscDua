import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

/// Uygulamaya gömülü içeriği (`assets/content/`) destek klasörüne kurar.
/// Sürüm (`manifest.json` → `content_version`) değişmedikçe dokunmaz.
/// Kullanıcı verisi (`user.db`) bu klasörün dışındadır, hiç silinmez.
class ContentInstaller {
  ContentInstaller({
    required this.supportDir,
    required this.loadAsset,
    required this.listAssets,
  });

  final Directory supportDir;
  final Future<ByteData> Function(String key) loadAsset;
  final Future<List<String>> Function() listAssets;

  static const _prefix = 'assets/content/';

  Directory get contentDir => Directory(p.join(supportDir.path, 'content'));
  Directory get audioDir => Directory(p.join(contentDir.path, 'audio'));
  File get dbFile => File(p.join(contentDir.path, 'content.db'));
  File get _versionFile => File(p.join(contentDir.path, 'installed_version'));

  Future<int> _bundledVersion() async {
    final m = await loadAsset('${_prefix}manifest.json');
    final j = jsonDecode(
      utf8.decode(m.buffer.asUint8List(m.offsetInBytes, m.lengthInBytes)),
    );
    return (j['content_version'] as int?) ?? 0;
  }

  Future<File> ensureInstalled() async {
    final version = await _bundledVersion();
    if (dbFile.existsSync() &&
        _versionFile.existsSync() &&
        _versionFile.readAsStringSync().trim() == '$version') {
      return dbFile;
    }
    if (contentDir.existsSync()) await contentDir.delete(recursive: true);
    await audioDir.create(recursive: true);
    for (final key in await listAssets()) {
      if (!key.startsWith(_prefix)) continue;
      final rel = key
          .substring(_prefix.length)
          .split('/')
          .map(_decodePart)
          .toList();
      if (rel.last.isEmpty) continue;
      final out = File(p.joinAll([contentDir.path, ...rel]));
      await out.parent.create(recursive: true);
      final data = await loadAsset(key);
      await out.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    }
    await _versionFile.writeAsString('$version');
    return dbFile;
  }

  /// Asset adları platforma göre kodlanmış (%C4%B1) ya da düz (ı) gelir.
  /// Dart'ın decodeComponent'i düz ASCII dışı karakterde hata verdiği için
  /// yalnızca % içeren adlar çözülür; çözülemezse ad olduğu gibi kalır.
  static String _decodePart(String s) {
    if (!s.contains('%')) return s;
    try {
      return Uri.decodeComponent(s);
    } catch (_) {
      return s;
    }
  }
}
