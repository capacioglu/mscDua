import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('matchAudioFolder', () {
    late ContentDatabase db;
    late Directory tmp;
    setUp(() async {
      db = ContentDatabase.memory();
      tmp = await Directory.systemTemp.createTemp('dualarim_audio');
      for (final id in ['DUA-0030', 'DUA-0013']) {
        await db.into(db.duas).insert(DuasCompanion.insert(
            id: id, titleTr: id, expectedAudioFile: Value(expectedAudioFileFor(id))));
      }
    });
    tearDown(() async {
      await db.close();
      await tmp.delete(recursive: true);
    });

    test('dosya adına göre büyük/küçük harf duyarsız eşler, kopyalar ve kayıt ekler', () async {
      final src = await Directory(p.join(tmp.path, 'kaynak')).create();
      final content = await Directory(p.join(tmp.path, 'content')).create();
      await File(p.join(src.path, 'DUA_0030.MP3')).writeAsBytes([1, 2, 3]);
      await File(p.join(src.path, 'rastgele.mp3')).writeAsBytes([4]);

      final r = await matchAudioFolder(db, src, content);
      expect(r.matched, [('DUA-0030', 'DUA_0030.MP3')]);
      expect(r.unmatchedFiles, ['rastgele.mp3']);
      expect(r.duasWithoutFile, ['DUA-0013']);
      final t = await db.select(db.tracks).getSingle();
      expect(t.relPath, 'audio/dua_0030.mp3');
      expect(t.duaId, 'DUA-0030');
      expect(t.label, 'ElevenLabs');
      expect(File(p.join(content.path, 'audio', 'dua_0030.mp3')).existsSync(), isTrue);

      await matchAudioFolder(db, src, content);
      expect(await db.select(db.tracks).get(), hasLength(1));

      // Farklı içerikli aynı adlı dosya: eski kayıt ve dosyası korunur, yeni kayıt eklenir.
      await File(p.join(src.path, 'DUA_0030.MP3')).writeAsBytes([9, 9]);
      await matchAudioFolder(db, src, content);
      final tracks = await db.select(db.tracks).get();
      expect(tracks.map((t) => t.relPath), ['audio/dua_0030.mp3', 'audio/dua_0030_2.mp3']);
      expect(File(p.join(content.path, 'audio', 'dua_0030.mp3')).readAsBytesSync(), [1, 2, 3]);
    });
  });

  group('importAudioFile', () {
    late Directory tmp;
    setUp(() async => tmp = await Directory.systemTemp.createTemp('dualarim_uniq'));
    tearDown(() => tmp.delete(recursive: true));

    test('aynı ad farklı içerikse üzerine yazmaz, _2 ekler; aynı içerikse var olanı kullanır', () async {
      final audio = Directory(p.join(tmp.path, 'audio'));
      final a = File(p.join(tmp.path, 'a', 'dua_0030.mp3'))..createSync(recursive: true);
      a.writeAsBytesSync([1, 2]);
      final b = File(p.join(tmp.path, 'b', 'dua_0030.mp3'))..createSync(recursive: true);
      b.writeAsBytesSync([3, 4]);

      final f1 = await importAudioFile(a, audio, 'dua_0030.mp3');
      final f2 = await importAudioFile(b, audio, 'dua_0030.mp3');
      final f3 = await importAudioFile(a, audio, 'dua_0030.mp3');
      expect(p.basename(f1.path), 'dua_0030.mp3');
      expect(p.basename(f2.path), 'dua_0030_2.mp3');
      expect(p.basename(f3.path), 'dua_0030.mp3');
      expect(File(p.join(audio.path, 'dua_0030.mp3')).readAsBytesSync(), [1, 2]);
    });
  });

  test('peaksFromPcm16 kova başına mutlak tepe', () {
    final pcm = Int16List.fromList([0, 16384, -32768, 0]);
    expect(peaksFromPcm16(pcm, 2), [0.5, 1.0]);
  });

  group('FfmpegService', () {
    final ffmpeg = FfmpegService.locate();
    test('Türkçe karakterli dosyadan ses çıkarır, süre ve PCM okur', () async {
      final tmp = await Directory.systemTemp.createTemp('dualarim_ff');
      try {
        final video = File(p.join(tmp.path, 'Kunut Duası 2024.mp4'));
        final gen = await Process.run(ffmpeg!.ffmpegPath,
            ['-y', '-f', 'lavfi', '-i', 'sine=frequency=440:duration=1', '-c:a', 'aac', video.path]);
        expect(gen.exitCode, 0, reason: gen.stderr.toString());

        final out = File(p.join(tmp.path, 'çıktı şeklî.m4a'));
        await ffmpeg.extractAudio(video, out);
        expect(out.existsSync(), isTrue);
        final ms = await ffmpeg.durationMs(out);
        expect(ms, inInclusiveRange(900, 1150));
        final pcm = await ffmpeg.decodePcm(out);
        expect(pcm.length, inInclusiveRange(7000, 9200));
      } finally {
        await tmp.delete(recursive: true);
      }
    }, skip: ffmpeg == null ? 'ffmpeg bulunamadı' : false);
  });
}
