import 'package:dua_core/dua_core.dart';
import 'package:dualarim_mobile/app_scope.dart';
import 'package:dualarim_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

String describe(QueueEntry e) => switch (e) {
  ClipEntry c => '${c.duaId} ${c.turn}/${c.turns}',
  GapEntry _ => 'gap',
  TextOnlyEntry t => '${t.duaId} metin',
};

void main() {
  late AppServices services;
  late FakeBackend backend;
  late ContentDatabase db;

  setUp(() async => (services, backend, db) = await testServices());
  tearDown(() => db.close());

  testWidgets(
    'liste oluştur, dua seç, tekrar ver, dinle; boşluk 0 iken ara yok; liste kalıcı',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1400));
      await tester.pumpWidget(
        AppScope(
          services: services,
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Listelerim'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('new-playlist')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('playlist-name')),
        'Sabah',
      );
      await tester.tap(find.text('Oluştur'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('add-duas')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('pick-DUA-0013')));
      await tester.tap(find.byKey(const ValueKey('pick-DUA-0006')));
      await tester.tap(find.byKey(const ValueKey('pick-done')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('repeat-plus-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('listen')));
      await tester.pumpAndSettle();
      expect(backend.queue.map(describe), [
        'DUA-0013 1/1',
        'gap',
        'DUA-0006 1/2',
        'gap',
        'DUA-0006 2/2',
      ]);

      await services.setGapMs(0);
      await tester.tap(find.byKey(const ValueKey('listen')));
      await tester.pumpAndSettle();
      expect(backend.queue.whereType<GapEntry>(), isEmpty);

      final lists = await services.user.allPlaylists();
      expect(lists.single.name, 'Sabah');
      expect(
        (await services.user.items(lists.single.id))
            .map((i) => (i.duaId, i.repeatCount)),
        [('DUA-0013', 1), ('DUA-0006', 2)],
      );
    },
  );
}
