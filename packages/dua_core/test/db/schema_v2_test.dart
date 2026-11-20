import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('v1 içerik veritabanı açılınca yeni sütunlar varsayılanlarla eklenir, veri korunur', () async {
    final tmp = await Directory.systemTemp.createTemp('dualarim_v2');
    final f = File(p.join(tmp.path, 'content.db'));
    await File('../../apps/mobile/assets/content/content.db').copy(f.path);
    final db = ContentDatabase.open(f);
    try {
      final tracks = await db.select(db.tracks).get();
      expect(tracks, isNotEmpty);
      expect(tracks.every((t) => t.language == 'ar' && t.source == 'manual' && t.isPrimary), isTrue);
      expect(tracks.every((t) => t.voiceId == null && t.textHash == null), isTrue);
      final duas = await db.select(db.duas).get();
      expect(duas.length, greaterThan(50));
      expect(duas.every((d) => d.textLanguage == 'ar'), isTrue);
      expect(await db.select(db.cues).get(), isNotEmpty);
    } finally {
      await db.close();
      await tmp.delete(recursive: true);
    }
  });

  test('yeni veritabanında varsayılanlar', () async {
    final db = ContentDatabase.memory();
    await db.into(db.duas).insert(DuasCompanion.insert(id: 'D', titleTr: 'd'));
    expect((await db.select(db.duas).getSingle()).textLanguage, 'ar');
    await db.close();
  });
}
