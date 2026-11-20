import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

void main() {
  late ContentDatabase db;
  setUp(() async {
    db = ContentDatabase.memory();
    await ArchiveImporter(db).importJson(
        jsonDecode(File('test/fixtures/dua_archive.mini.json').readAsStringSync()) as Map<String, dynamic>,
        fileName: 'mini.json');
  });
  tearDown(() => db.close());

  test('özetler durum, kategori, grup, kayıt ve uyarı bilgisini içerir', () async {
    final list = await listDuaSummaries(db);
    expect(list, hasLength(8));
    final d30 = list.firstWhere((s) => s.id == 'DUA-0030');
    expect(d30.progress, DuaProgress.inReview);
    expect(d30.categories, unorderedEquals(['Tövbe', 'Peygamber duaları']));
    expect(d30.groupIds, unorderedEquals(['GRP-001', 'GRP-005']));
    expect(d30.trackCount, 0);
    expect(d30.hasWarning, isFalse);
    final d6 = list.firstWhere((s) => s.id == 'DUA-0006');
    expect(d6.progress, DuaProgress.awaitingTranslation);
    expect(d6.segmentCount, 4);
    expect(list.firstWhere((s) => s.id == 'DUA-0056-11').hasWarning, isTrue);
    expect(list.firstWhere((s) => s.id == 'VAR-0054-01').variantOf, 'DUA-0054');
  });

  test('progressLabel Türkçe', () {
    expect(progressLabel(DuaProgress.awaitingTranslation), 'Çeviri bekliyor');
    expect(progressLabel(DuaProgress.inReview), 'Gözden geçirilecek');
    expect(progressLabel(DuaProgress.approved), 'Onaylı');
    expect(progressLabel(DuaProgress.draft), 'Taslak');
  });

  test('zamanlama durumu: ses yok → zamanlanmadı → kısmen → hazır; grup kaydı da sayılır', () async {
    Future<TimingProgress> of(String id) async => (await listDuaSummaries(db)).firstWhere((x) => x.id == id).timing;
    expect(await of('DUA-0006'), TimingProgress.noAudio);

    final t = await db.into(db.tracks).insert(TracksCompanion.insert(
        ownerKind: TrackOwnerKind.dua, duaId: const Value('DUA-0006'), relPath: 'audio/x.mp3', label: 'x'));
    expect(await of('DUA-0006'), TimingProgress.untimed);

    final segs = await db.segmentsOf('DUA-0006');
    await db.into(db.cues).insert(CuesCompanion.insert(trackId: t, startMs: 0, segmentId: Value(segs[0].id)));
    expect(await of('DUA-0006'), TimingProgress.partial);

    for (var i = 1; i < segs.length; i++) {
      await db.into(db.cues).insert(CuesCompanion.insert(trackId: t, startMs: i * 1000, segmentId: Value(segs[i].id)));
    }
    expect(await of('DUA-0006'), TimingProgress.ready);

    await db.into(db.tracks).insert(TracksCompanion.insert(
        ownerKind: TrackOwnerKind.group, groupId: const Value('GRP-005'), relPath: 'audio/g.mp3', label: 'g'));
    expect(await of('DUA-0030'), TimingProgress.untimed);
    expect(timingLabel(TimingProgress.partial), 'Kısmen zamanlandı');
  });

  test('dil bazlı zamanlama ve metin değişti uyarısı', () async {
    Future<DuaSummary> of(String id) async => (await listDuaSummaries(db)).firstWhere((x) => x.id == id);
    final segs = await db.segmentsOf('DUA-0013');
    final text = buildTtsText(segs, 'tr')!;
    final t = await db.into(db.tracks).insert(TracksCompanion.insert(
        ownerKind: TrackOwnerKind.dua, duaId: const Value('DUA-0013'), relPath: 'audio/tts/x.mp3', label: 'el',
        language: const Value('tr'), source: const Value('elevenlabs'), textHash: Value(ttsHash(text))));
    await db.into(db.cues).insert(CuesCompanion.insert(trackId: t, startMs: 0, segmentId: Value(segs.single.id)));
    var s = await of('DUA-0013');
    expect(s.timingByLang, {'ar': TimingProgress.noAudio, 'tr': TimingProgress.ready, 'en': TimingProgress.noAudio});
    expect(s.staleTts, isFalse);
    await (db.update(db.segments)..where((x) => x.id.equals(segs.single.id)))
        .write(const SegmentsCompanion(meaningTr: Value('değişti')));
    s = await of('DUA-0013');
    expect(s.staleTts, isTrue);
  });
}

