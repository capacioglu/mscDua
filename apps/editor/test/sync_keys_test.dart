import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull, Column;
import 'package:dua_core/dua_core.dart';
import 'package:dualarim_editor/app/app_state.dart';
import 'package:dualarim_editor/widgets/sync_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_playback.dart';

void main() {
  late ContentDatabase db;
  late AppState state;
  late FakePlayback player;
  late List<int> segIds;
  late int trackId;

  setUp(() async {
    db = ContentDatabase.memory();
    state = AppState.forDatabase(db, Directory.systemTemp);
    player = FakePlayback();
    await db
        .into(db.duas)
        .insert(DuasCompanion.insert(id: 'D1', titleTr: 'Dua'));
    segIds = [
      for (var i = 0; i < 3; i++)
        await db
            .into(db.segments)
            .insert(
              SegmentsCompanion.insert(duaId: 'D1', position: i, textAr: 'س$i'),
            ),
    ];
    trackId = await db
        .into(db.tracks)
        .insert(
          TracksCompanion.insert(
            ownerKind: TrackOwnerKind.dua,
            duaId: const Value('D1'),
            relPath: 'audio/yok.mp3',
            label: 'test',
          ),
        );
  });
  tearDown(() => db.close());

  Future<List<Cue>> cues() =>
      (db.select(db.cues)
            ..where((c) => c.trackId.equals(trackId))
            ..orderBy([(c) => OrderingTerm.asc(c.startMs)]))
          .get();

  testWidgets(
    'Enter işaretler, ok tuşu kaydırır, G metinsiz bölüm ekler; hepsi kaydedilir',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SyncPanel(
              state: state,
              duaId: 'D1',
              playbackFactory: () => player,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      player.setPosition(1500);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      player.setPosition(3000);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyG);
      await tester.pumpAndSettle();

      final c = await cues();
      expect(c.map((x) => (x.startMs, x.segmentId)), [
        (1600, segIds[0]),
        (3000, null),
      ]);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(player.playing, isTrue);
    },
  );

  testWidgets(
    'satıra tıklamak o satırın işaretine atlar ve sıradaki satır yapar',
    (tester) async {
      await db
          .into(db.cues)
          .insert(
            CuesCompanion.insert(
              trackId: trackId,
              startMs: 4200,
              segmentId: Value(segIds[1]),
            ),
          );
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SyncPanel(
              state: state,
              duaId: 'D1',
              playbackFactory: () => player,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('sync-seg-${segIds[1]}')));
      await tester.pumpAndSettle();
      expect(player.position.inMilliseconds, 4200);

      player.setPosition(9000);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(
        (await cues())
            .where((c) => c.segmentId == segIds[1])
            .map((c) => c.startMs),
        [4200, 9000],
      );
    },
  );

  testWidgets(
    'soldaki satır birleştirilince panel yenilenir; sonraki işaret kaydedilir',
    (tester) async {
      await db
          .into(db.cues)
          .insert(
            CuesCompanion.insert(
              trackId: trackId,
              startMs: 1000,
              segmentId: Value(segIds[1]),
            ),
          );
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SyncPanel(
              state: state,
              duaId: 'D1',
              playbackFactory: () => player,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await SegmentRepo(db)
          .merge(segIds[0]); // satır 2 silinir, işareti satır 1'e geçer
      state.changed();
      await tester.pumpAndSettle();

      player.setPosition(5000);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyG);
      await tester.pumpAndSettle();
      expect((await cues()).map((c) => (c.startMs, c.segmentId)), [
        (1000, segIds[0]),
        (5000, null),
      ]);
      expect(find.byKey(ValueKey('sync-seg-${segIds[1]}')), findsNothing);
    },
  );

  testWidgets('Enter basılı tutulunca tekrar işaretlemez', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SyncPanel(
            state: state,
            duaId: 'D1',
            playbackFactory: () => player,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    player.setPosition(1000);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(await cues(), hasLength(1));
  });
}
