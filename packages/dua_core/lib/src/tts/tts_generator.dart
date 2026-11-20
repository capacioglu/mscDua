import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../audio/ffmpeg_service.dart';
import '../db/database.dart';
import '../model/enums.dart';
import 'elevenlabs_client.dart';
import 'tts_text.dart';

class TtsResult {
  TtsResult(this.trackId, this.relPath, this.chars);
  final int trackId;
  final String relPath;
  final int chars;
}

/// Bir duanın bir dildeki sesini ElevenLabs ile üretir; dosyayı, kaydı ve satır
/// işaretlerini yazar. Hata olursa hiçbir şey bırakmaz (geçici dosya + tek transaction).
class TtsGenerator {
  TtsGenerator(this.db, this.contentDir, this.client, {this.ffmpeg, this.maxChars = 4500});

  final ContentDatabase db;
  final Directory contentDir;
  final ElevenLabsClient client;
  final FfmpegService? ffmpeg;
  final int maxChars;

  Future<TtsText?> textFor(String duaId, String lang) async {
    final dua = await (db.select(db.duas)..where((t) => t.id.equals(duaId))).getSingleOrNull();
    if (dua == null) return null;
    if (dua.textLanguage == 'tr' && lang == 'ar') return null;
    return buildTtsText(await db.segmentsOf(duaId), lang);
  }

  Future<bool> canGenerate(String duaId, String lang) async => await textFor(duaId, lang) != null;

  Future<int> estimateChars(String duaId, String lang) async => (await textFor(duaId, lang))?.text.length ?? 0;

  /// Aynı dua+dildeki kayıtlar arasında telefonda çalacak olanı seçer.
  Future<void> setPrimary(int trackId) => db.transaction(() async {
        final t = await (db.select(db.tracks)..where((x) => x.id.equals(trackId))).getSingle();
        await (db.update(db.tracks)
              ..where((x) => x.duaId.equalsNullable(t.duaId) & x.language.equals(t.language)))
            .write(const TracksCompanion(isPrimary: Value(false)));
        await (db.update(db.tracks)..where((x) => x.id.equals(trackId)))
            .write(const TracksCompanion(isPrimary: Value(true)));
      });

  Future<TtsResult> generate(
    String duaId,
    String lang, {
    required String voiceId,
    required String voiceName,
    String modelId = ElevenLabsClient.defaultModel,
  }) async {
    final text = await textFor(duaId, lang);
    if (text == null) throw StateError('Bu dua için ${_langName(lang)} metin eksik ya da bu dilde üretilemez.');
    final ttsDir = Directory(p.join(contentDir.path, 'audio', 'tts'));
    await ttsDir.create(recursive: true);
    final name = '${duaId}_$lang.mp3';
    final relPath = 'audio/tts/$name';
    final finalFile = File(p.join(ttsDir.path, name));
    final work = await Directory.systemTemp.createTemp('dualarim_tts_');
    try {
      // 1) Ses ve işaretler (parça parça).
      final chunks = chunkTts(text, maxChars: maxChars);
      final cueMs = <int>[];
      final parts = <File>[];
      var offset = 0;
      for (var i = 0; i < chunks.length; i++) {
        final (mp3, al) = await client.speakWithTimestamps(voiceId, chunks[i].text, modelId: modelId);
        final part = File(p.join(work.path, 'part_$i.mp3'));
        await part.writeAsBytes(mp3, flush: true);
        parts.add(part);
        cueMs.addAll(lineCueMs(chunks[i], al).map((ms) => ms + offset));
        if (i < chunks.length - 1) {
          final ff = ffmpeg;
          if (ff == null) throw StateError('Uzun metni birleştirmek için ffmpeg gerekli.');
          offset += await ff.durationMs(part);
        }
      }
      final out = File(p.join(work.path, 'out.mp3'));
      if (parts.length == 1) {
        await parts.single.copy(out.path);
      } else {
        await ffmpeg!.concat(parts, out);
      }
      final durationMs = ffmpeg == null ? null : await ffmpeg!.durationMs(out).then<int?>((v) => v, onError: (_) => null);

      // 2) Kayıt + işaretler (tek transaction), sonra dosyayı yerine koy.
      late int trackId;
      await db.transaction(() async {
        final old = await (db.select(db.tracks)
              ..where((t) => t.duaId.equals(duaId) & t.language.equals(lang) & t.source.equals('elevenlabs')))
            .get();
        for (final o in old) {
          await (db.delete(db.tracks)..where((t) => t.id.equals(o.id))).go();
        }
        await (db.update(db.tracks)..where((t) => t.duaId.equals(duaId) & t.language.equals(lang)))
            .write(const TracksCompanion(isPrimary: Value(false)));
        trackId = await db.into(db.tracks).insert(TracksCompanion.insert(
              ownerKind: TrackOwnerKind.dua,
              duaId: Value(duaId),
              relPath: relPath,
              label: 'ElevenLabs – $voiceName',
              durationMs: Value(durationMs),
              language: Value(lang),
              source: const Value('elevenlabs'),
              voiceId: Value(voiceId),
              voiceName: Value(voiceName),
              isPrimary: const Value(true),
              textHash: Value(ttsHash(text)),
            ));
        for (var i = 0; i < text.segmentIds.length; i++) {
          await db.into(db.cues).insert(
              CuesCompanion.insert(trackId: trackId, startMs: cueMs[i], segmentId: Value(text.segmentIds[i])));
        }
      });
      await out.copy(finalFile.path);
      return TtsResult(trackId, relPath, text.text.length);
    } finally {
      await work.delete(recursive: true);
    }
  }

  static String _langName(String lang) => switch (lang) { 'ar' => 'Arapça', 'tr' => 'Türkçe', 'en' => 'İngilizce', _ => lang };
}
