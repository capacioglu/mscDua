import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:dualarim_mobile/audio/player_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  late ContentDatabase db;
  late FakeBackend backend;
  late PlayerService player;

  setUp(() async {
    db = await seededContent();
    backend = FakeBackend();
    player = PlayerService(backend, ContentQueries(db), fileOf: (t) => File(t.relPath));
  });
  tearDown(() async {
    player.dispose();
    await db.close();
  });

  test('tekrar ve boşlukla kuyruk kurulur, çalmaya başlar', () async {
    await player.start([const PlayRequest('DUA-0006', 2)], gapMs: 500);
    expect(backend.queue, hasLength(3));
    expect(backend.queue[1], isA<GapEntry>());
    expect(backend.playing, isTrue);
  });

  test('ilerleme okunan satırı ve turu günceller', () async {
    await player.start([const PlayRequest('DUA-0006', 2)], gapMs: 500);
    final segs = await db.segmentsOf('DUA-0006');
    backend.emit(2, 1200);
    await pumpEventQueue();
    expect(player.now.duaId, 'DUA-0006');
    expect(player.now.segmentId, segs[1].id);
    expect(player.now.turn, 2);
  });

  test('satıra dokununca o satırın işaretine atlar (çalan tur içinde)', () async {
    await player.start([const PlayRequest('DUA-0013', 1), const PlayRequest('DUA-0006', 2)], gapMs: 500);
    final segs = await db.segmentsOf('DUA-0006');
    backend.emit(4, 0); // DUA-0006 2. tur
    await pumpEventQueue();
    await player.seekToSegment('DUA-0006', segs[3].id);
    expect(backend.lastSeek, (4, 3000));
  });
}
