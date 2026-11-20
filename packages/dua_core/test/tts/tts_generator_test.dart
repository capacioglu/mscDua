import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../helpers.dart';

/// Gelen metnin her karakterini 50 ms'de okuyan sahte ElevenLabs.
ElevenLabsClient fakeClient(List<int> mp3, {List<String>? seenTexts, bool fail = false}) =>
    ElevenLabsClient('k_abcd', client: MockClient((r) async {
      if (fail) return http.Response('{"detail":"invalid"}', 401);
      final text = jsonDecode(r.body)['text'] as String;
      seenTexts?.add(text);
      return http.Response(
          jsonEncode({
            'audio_base64': base64Encode(mp3),
            'alignment': {
              'characters': text.split(''),
              'character_start_times_seconds': [for (var i = 0; i < text.length; i++) i * 0.05],
              'character_end_times_seconds': [for (var i = 0; i < text.length; i++) (i + 1) * 0.05],
            },
          }),
          200);
    }));

void main() {
  late ContentDatabase db;
  late Directory content;
  setUp(() async {
    db = ContentDatabase.memory();
    content = await Directory.systemTemp.createTemp('dualarim_tts');
  });
  tearDown(() async {
    await db.close();
    await content.delete(recursive: true);
  });

  Future<List<Track>> tracksOf(String id) => (db.select(db.tracks)..where((t) => t.duaId.equals(id))).get();

  test('Türkçe ses üretilir: dosya, kayıt bilgileri ve satır işaretleri', () async {
    final s = await seedDua(db, 'D1', ['أ', 'ب', 'ج'], translated: true);
    final g = TtsGenerator(db, content, fakeClient([7, 7, 7]));
    final r = await g.generate('D1', 'tr', voiceId: 'v1', voiceName: 'Ayşe');
    final t = (await tracksOf('D1')).single;
    expect((t.language, t.source, t.voiceId, t.voiceName, t.isPrimary), ('tr', 'elevenlabs', 'v1', 'Ayşe', true));
    expect(t.relPath, 'audio/tts/D1_tr.mp3');
    expect(t.label, 'ElevenLabs – Ayşe');
    expect(t.textHash, ttsHash(buildTtsText(await db.segmentsOf('D1'), 'tr')!));
    expect(File(p.join(content.path, 'audio', 'tts', 'D1_tr.mp3')).readAsBytesSync(), [7, 7, 7]);
    final cues = await cuesOf(db, t.id);
    expect(cues.map((c) => c.segmentId), s);
    expect(cues.first.startMs, 0);
    expect(r.chars, 'anlam 0\nanlam 1\nanlam 2'.length);
    expect(await fullyTimedTracks(db, 'D1'), [t.id]);
  });

  test('yeniden üretim eski ElevenLabs kaydının yerine geçer; elle eklenen kalır ve birincilliği düşer', () async {
    await seedDua(db, 'D1', ['أ'], translated: true);
    final manual = await db.into(db.tracks).insert(TracksCompanion.insert(
        ownerKind: TrackOwnerKind.dua, duaId: const Value('D1'), relPath: 'audio/m.mp3', label: 'el',
        language: const Value('tr')));
    final g = TtsGenerator(db, content, fakeClient([1]));
    await g.generate('D1', 'tr', voiceId: 'v1', voiceName: 'A');
    await g.generate('D1', 'tr', voiceId: 'v2', voiceName: 'B');
    final ts = await tracksOf('D1');
    expect(ts, hasLength(2));
    final el = ts.firstWhere((t) => t.source == 'elevenlabs');
    expect((el.voiceId, el.isPrimary), ('v2', true));
    expect(ts.firstWhere((t) => t.id == manual).isPrimary, isFalse);
    await g.setPrimary(manual);
    final after = await tracksOf('D1');
    expect(after.firstWhere((t) => t.id == manual).isPrimary, isTrue);
    expect(after.firstWhere((t) => t.id == el.id).isPrimary, isFalse);
  });

  test('istemci hata verirse dosya ve kayıt oluşmaz', () async {
    await seedDua(db, 'D1', ['أ'], translated: true);
    final g = TtsGenerator(db, content, fakeClient([1], fail: true));
    await expectLater(g.generate('D1', 'tr', voiceId: 'v', voiceName: 'v'), throwsA(isA<ElevenLabsException>()));
    expect(await tracksOf('D1'), isEmpty);
    final tts = Directory(p.join(content.path, 'audio', 'tts'));
    expect(!tts.existsSync() || tts.listSync().isEmpty, isTrue);
  });

  test('üretilebilirlik: metni eksik dil ve Türkçe duada Arapça olmaz', () async {
    await seedDua(db, 'D1', ['أ', 'ب'], translated: true);
    await (db.update(db.segments)..where((t) => t.duaId.equals('D1') & t.position.equals(1)))
        .write(const SegmentsCompanion(meaningEn: Value(null)));
    final g = TtsGenerator(db, content, fakeClient([1]));
    expect(await g.canGenerate('D1', 'ar'), isTrue);
    expect(await g.canGenerate('D1', 'en'), isFalse);
    await db.into(db.duas).insert(DuasCompanion.insert(id: 'T1', titleTr: 't', textLanguage: const Value('tr')));
    await db.into(db.segments).insert(SegmentsCompanion.insert(duaId: 'T1', position: 0, textAr: '', meaningTr: const Value('Allah\'ım!')));
    expect(await g.canGenerate('T1', 'ar'), isFalse);
    expect(await g.canGenerate('T1', 'tr'), isTrue);
    expect(await g.estimateChars('T1', 'tr'), "Allah'ım!".length);
  });

  final ff = FfmpegService.locate();
  test('uzun metin parçalanır, ses birleştirilir, sonraki parçanın işaretleri kayar', () async {
    final tmp = await Directory.systemTemp.createTemp('dualarim_sine');
    final sine = File(p.join(tmp.path, 's.mp3'));
    await Process.run(ff!.ffmpegPath, ['-y', '-f', 'lavfi', '-i', 'sine=duration=1', '-c:a', 'libmp3lame', sine.path]);
    final s = await seedDua(db, 'D1', ['أ', 'ب', 'ج', 'د'], translated: true);
    final seen = <String>[];
    final g = TtsGenerator(db, content, fakeClient(sine.readAsBytesSync(), seenTexts: seen), ffmpeg: ff, maxChars: 16);
    await g.generate('D1', 'tr', voiceId: 'v', voiceName: 'v');
    expect(seen, ['anlam 0\nanlam 1', 'anlam 2\nanlam 3']);
    final t = (await tracksOf('D1')).single;
    final cues = await cuesOf(db, t.id);
    expect(cues.map((c) => c.segmentId), s);
    expect(cues[2].startMs, inInclusiveRange(950, 1150)); // ikinci parça ~1 sn sonra başlar
    expect(t.durationMs, inInclusiveRange(1900, 2200));
    await tmp.delete(recursive: true);
  }, skip: ff == null ? 'ffmpeg yok' : false);
}
