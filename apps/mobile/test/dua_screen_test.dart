import 'package:dua_core/dua_core.dart';
import 'package:dualarim_mobile/app_scope.dart';
import 'package:dualarim_mobile/screens/dua_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  late AppServices services;
  late FakeBackend backend;
  late ContentDatabase db;

  setUp(() async => (services, backend, db) = await testServices());
  tearDown(() => db.close());

  Future<void> open(WidgetTester tester, String id) async {
    await tester.binding.setSurfaceSize(const Size(500, 1800));
    await tester.pumpWidget(AppScope(services: services, child: MaterialApp(home: DuaScreen(duaId: id))));
    await tester.pumpAndSettle();
  }

  testWidgets('satırlar, okunuşlar ve duanın bütün anlamı bir kez görünür', (tester) async {
    await open(tester, 'DUA-0006');
    final segs = await db.segmentsOf('DUA-0006');
    for (final s in segs) {
      expect(find.text(s.textAr), findsOneWidget);
    }
    expect(find.text('Ve yessir lî emrî.'), findsOneWidget);
    expect(find.textContaining('Rabbim! Gönlüme genişlik ver.'), findsOneWidget);
  });

  testWidgets('okuma seçenekleri: okunuş kapanır; son açık seçenek kapatılamaz', (tester) async {
    await open(tester, 'DUA-0006');
    await tester.tap(find.byKey(const ValueKey('prefs')));
    await tester.pumpAndSettle();
    for (final k in ['pref-arabic', 'pref-pronunciationTr', 'pref-meaningTr']) {
      await tester.tap(find.byKey(ValueKey(k)));
      await tester.pumpAndSettle();
    }
    Navigator.of(tester.element(find.byKey(const ValueKey('pref-arabic')))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Ve yessir lî emrî.'), findsNothing);
    expect(find.textContaining('Rabbim! Gönlüme genişlik ver.'), findsOneWidget);
    expect((await services.user.readingPrefs()).meaningTr, isTrue);
  });

  testWidgets('tekrar 3 ile çal; ilerleyen ses o satırı vurgular', (tester) async {
    await open(tester, 'DUA-0006');
    await tester.tap(find.byKey(const ValueKey('repeat-plus')));
    await tester.tap(find.byKey(const ValueKey('repeat-plus')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('play')));
    await tester.pumpAndSettle();
    expect(backend.queue.whereType<ClipEntry>(), hasLength(3));

    final segs = await db.segmentsOf('DUA-0006');
    backend.emit(0, 1500);
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byKey(const ValueKey('seg-active')), matching: find.text(segs[1].textAr)),
        findsOneWidget);
    expect(find.text('1/3'), findsWidgets);
  });
}
