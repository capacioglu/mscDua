import 'package:dua_core/dua_core.dart';
import 'package:dualarim_mobile/app_scope.dart';
import 'package:dualarim_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  late AppServices services;
  late FakeBackend backend;
  late ContentDatabase db;

  setUp(() async => (services, backend, db) = await testServices());
  tearDown(() => db.close());

  Future<void> open(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1400));
    await tester.pumpWidget(
      AppScope(
        services: services,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('gruplar listelenir; grup sırasıyla gösterilir ve tümü çalınır', (
    tester,
  ) async {
    await open(tester);
    expect(find.text('40 Rabbenâ Duası'), findsOneWidget);
    await tester.tap(find.text('Kunut Duası'));
    await tester.pumpAndSettle();
    expect(find.text('Rabbenâ Âtinâ'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('play-all')));
    await tester.pumpAndSettle();
    final ids = backend.queue.map(
      (e) => switch (e) {
        ClipEntry c => c.duaId,
        TextOnlyEntry t => t.duaId,
        GapEntry _ => '-',
      },
    );
    expect(ids.where((x) => x != '-'), [
      'VAR-0054-01',
      'DUA-0030',
      'DUA-0013',
      'DUA-0056-11',
    ]);
  });

  testWidgets('kategoriler ve dua listesi', (tester) async {
    await open(tester);
    await tester.tap(find.text('Kategoriler'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Tövbe'), 200);
    await tester.tap(find.text('Tövbe'));
    await tester.pumpAndSettle();
    expect(find.text("Hz. Âdem ve Havvâ'nın Tövbe Duası"), findsOneWidget);
  });

  testWidgets('arama', (tester) async {
    await open(tester);
    await tester.tap(find.text('Ara'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('search-field')),
      'rabbena atina',
    );
    await tester.pumpAndSettle();
    expect(find.text('Rabbenâ Âtinâ'), findsOneWidget);
  });
}
