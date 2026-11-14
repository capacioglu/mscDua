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
    player = PlayerService(
      backend,
      ContentQueries(db),
      fileOf: (t) => File(t.relPath),
    );
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

  test(
    'satıra dokununca o satırın işaretine atlar (çalan tur içinde)',
    () async {
      await player.start([
        const PlayRequest('DUA-0013', 1),
        const PlayRequest('DUA-0006', 2),
      ], gapMs: 500);
      final segs = await db.segmentsOf('DUA-0006');
      backend.emit(4, 0); // DUA-0006 2. tur
      await pumpEventQueue();
      await player.seekToSegment('DUA-0006', segs[3].id);
      expect(backend.lastSeek, (4, 3000));
    },
  );

  test(
    'dokunulan satırdan başlatma: boştayken kuyruğu kurar, satıra atlar, çalar',
    () async {
      final segs = await db.segmentsOf('DUA-0006');
      await player.playFrom(
        [const PlayRequest('DUA-0006', 1)],
        gapMs: 500,
        duaId: 'DUA-0006',
        segmentId: segs[2].id,
      );
      expect(backend.queue, hasLength(1));
      expect(backend.lastSeek, (0, 2000));
      expect(backend.playing, isTrue);
    },
  );

  test(
    'dokunulan satırdan başlatma: aynı kuyruk çalıyorsa yalnızca atlar',
    () async {
      final reqs = [
        const PlayRequest('DUA-0013', 1),
        const PlayRequest('DUA-0006', 2),
      ];
      await player.start(reqs, gapMs: 500);
      final q = backend.queue;
      backend.emit(4, 0);
      await pumpEventQueue();
      final segs = await db.segmentsOf('DUA-0006');
      await player.playFrom(
        reqs,
        gapMs: 500,
        duaId: 'DUA-0006',
        segmentId: segs[3].id,
      );
      expect(identical(backend.queue, q), isTrue);
      expect(backend.lastSeek, (4, 3000));
    },
  );

  test(
    'kaldığı yerden devam: oturum saklanır, yeni oynatıcı aynı yerden sürdürür',
    () async {
      String? saved;
      final store = SessionStore(
        load: () async => saved,
        save: (s) async => saved = s,
      );
      final p1 = PlayerService(
        backend,
        ContentQueries(db),
        fileOf: (t) => File(t.relPath),
        store: store,
      );
      await p1.start(
        [const PlayRequest('DUA-0006', 2)],
        gapMs: 500,
        title: 'Deneme',
      );
      backend.emit(2, 1200);
      await pumpEventQueue();
      await p1.pause();
      expect(saved, isNotNull);
      p1.dispose();

      final b2 = FakeBackend();
      final p2 = PlayerService(
        b2,
        ContentQueries(db),
        fileOf: (t) => File(t.relPath),
        store: store,
      );
      expect(await p2.loadSession(), isTrue);
      expect(p2.canResume, isTrue);
      expect(p2.resumeTitle, 'Deneme');
      await p2.resume();
      expect(b2.queue, hasLength(3));
      expect(b2.lastSeek, (2, 1200));
      expect(b2.playing, isTrue);
      p2.dispose();
    },
  );
}
