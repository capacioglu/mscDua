import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dualarim_mobile/data/content_installer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory support;
  late Map<String, List<int>> assets;

  setUp(() async {
    support = await Directory.systemTemp.createTemp('dualarim_inst');
    assets = {
      'assets/content/manifest.json': utf8.encode('{"content_version": 3}'),
      'assets/content/content.db': [1, 2, 3],
      'assets/content/audio/6.mp3': [6],
      'assets/content/audio/dua 7.mp3': [7],
    };
  });
  tearDown(() => support.delete(recursive: true));

  ContentInstaller installer() => ContentInstaller(
        supportDir: support,
        loadAsset: (k) async => ByteData.sublistView(Uint8List.fromList(assets[k]!)),
        listAssets: () async => assets.keys.toList(),
      );

  test('ilk açılışta kopyalar, aynı sürümde dokunmaz, yeni sürümde yeniler; kullanıcı verisi kalır', () async {
    final db = await installer().ensureInstalled();
    expect(db.readAsBytesSync(), [1, 2, 3]);
    final audio = File(p.join(support.path, 'content', 'audio', 'dua 7.mp3'));
    expect(audio.readAsBytesSync(), [7]);
    final userDb = File(p.join(support.path, 'user.db'))..writeAsBytesSync([42]);

    final before = db.lastModifiedSync();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await installer().ensureInstalled();
    expect(db.lastModifiedSync(), before);

    assets['assets/content/manifest.json'] = utf8.encode('{"content_version": 4}');
    assets['assets/content/content.db'] = [9, 9];
    assets.remove('assets/content/audio/6.mp3');
    await installer().ensureInstalled();
    expect(db.readAsBytesSync(), [9, 9]);
    expect(File(p.join(support.path, 'content', 'audio', '6.mp3')).existsSync(), isFalse);
    expect(userDb.readAsBytesSync(), [42]);
    expect(installer().audioDir.path, p.join(support.path, 'content', 'audio'));
  });
}
