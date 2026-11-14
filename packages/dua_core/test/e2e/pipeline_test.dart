import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// İçe aktar → çeviriye gönder → Claude çevirisi → onayla → ses eşleştir →
/// zamanla → yayınla akışının tamamı, gerçek arşiv dosyasıyla.
void main() {
  test('uçtan uca içerik akışı', () async {
    final db = ContentDatabase.memory();
    final tmp = await Directory.systemTemp.createTemp('dualarim_e2e');
    try {
      final content = await Directory(p.join(tmp.path, 'content')).create();
      final archive = jsonDecode(File('../../content/import/dua_archive.json').readAsStringSync());
      final imp = await ArchiveImporter(db).importJson(archive as Map<String, dynamic>, fileName: 'dua_archive.json');
      expect(imp.duasCreated, 65);

      // DUA-0006 çok satırlı: anlamlar Claude'a gider.
      final pending = await buildPending(db, duaIds: {'DUA-0006'});
      final segs = ((pending['duas'] as List).single['segments'] as List).cast<Map<String, dynamic>>();
      expect(segs, hasLength(4));
      const tr = ['Rabbim! Gönlüme genişlik ver.', 'İşimi kolaylaştır.', 'Dilimdeki düğümü çöz,', 'ki sözümü anlasınlar.'];
      const en = ['My Lord, expand my chest,', 'ease my task,', 'and untie the knot from my tongue', 'so they may understand my speech.'];
      final done = {
        'format': doneFormat,
        'segments': [
          for (var i = 0; i < 4; i++)
            {'segment_id': segs[i]['segment_id'], 'text_ar': segs[i]['text_ar'], 'meaning_tr': tr[i], 'meaning_en': en[i]}
        ],
      };
      final applied = await applyDone(db, done);
      expect(applied.applied, 4);

      final repo = SegmentRepo(db);
      for (final id in ['DUA-0006', 'DUA-0030']) {
        expect(await repo.approveAll(id), greaterThan(0));
        await (db.update(db.duas)..where((t) => t.id.equals(id))).write(const DuasCompanion(readyToPublish: Value(true)));
      }

      // Ses: kimlikten türetilen adlarla eşleşir.
      final src = await Directory(p.join(tmp.path, 'mp3')).create();
      await File(p.join(src.path, 'dua_0006.mp3')).writeAsBytes([1]);
      await File(p.join(src.path, 'dua_0030.mp3')).writeAsBytes([2]);
      final match = await matchAudioFolder(db, src, content);
      expect(match.matched, hasLength(2));

      // Zamanlama
      for (final id in ['DUA-0006', 'DUA-0030']) {
        final track = await (db.select(db.tracks)..where((t) => t.duaId.equals(id))).getSingle();
        final ss = await db.segmentsOf(id);
        final tl = CueTimeline(ss.map((s) => s.id).toList(), []);
        for (var i = 0; i < ss.length; i++) {
          tl.markNext(i * 1500);
        }
        for (final c in tl.sorted) {
          await db.into(db.cues).insert(CuesCompanion.insert(trackId: track.id, startMs: c.startMs, segmentId: Value(c.segmentId)));
        }
      }

      final out = Directory(p.join(tmp.path, 'out'));
      final r = await publish(db, contentDir: content, outDir: out);
      expect(r.publishedDuaIds, ['DUA-0006', 'DUA-0030']);
      expect(r.publishedGroupIds, ['GRP-001', 'GRP-005']);

      final o = ContentDatabase.open(File(p.join(out.path, 'content.db')));
      expect(await o.categoriesOf('DUA-0030'), {'Tövbe', 'Peygamber duaları'});
      expect(await o.categoriesOf('DUA-0006'), {'Peygamber duaları', 'Kolaylık'});
      final pos = {for (final g in await o.groupsOf('DUA-0030')) g.groupId: g.position};
      expect(pos, {'GRP-001': 20, 'GRP-005': 3});
      final s6 = await o.segmentsOf('DUA-0006');
      expect(s6[1].meaningTr, 'İşimi kolaylaştır.');
      expect(s6[1].pronunciationTr, 'Ve yessir lî emrî.');
      expect(await o.select(o.cues).get(), hasLength(5));
      expect(File(p.join(out.path, 'audio', 'dua_0006.mp3')).existsSync(), isTrue);
      await o.close();
    } finally {
      await db.close();
      await tmp.delete(recursive: true);
    }
  });
}
