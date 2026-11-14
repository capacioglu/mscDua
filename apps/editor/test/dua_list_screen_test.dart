import 'dart:convert';
import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:dualarim_editor/app/app_state.dart';
import 'package:dualarim_editor/screens/dua_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ContentDatabase db;
  late AppState state;

  setUp(() async {
    db = ContentDatabase.memory();
    final json = jsonDecode(
      File('../../packages/dua_core/test/fixtures/dua_archive.mini.json')
          .readAsStringSync(),
    );
    await ArchiveImporter(db)
        .importJson(json as Map<String, dynamic>, fileName: 'mini.json');
    state = AppState.forDatabase(db, Directory.systemTemp);
  });
  tearDown(() => db.close());

  testWidgets(
    'liste durum ve kategorileri gösterir, kategori filtresi çalışır',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1000));
      await tester.pumpWidget(MaterialApp(home: DuaListScreen(state: state)));
      await tester.pumpAndSettle();

      expect(find.text('DUA-0030'), findsOneWidget);
      expect(find.text('DUA-0006'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('row-DUA-0006')),
          matching: find.text('Çeviri bekliyor'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('row-DUA-0030')),
          matching: find.textContaining('Peygamber duaları'),
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey('filter-cat-Tövbe')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('filter-cat-Tövbe')));
      await tester.pumpAndSettle();
      expect(find.text('DUA-0030'), findsOneWidget);
      expect(find.text('DUA-0006'), findsNothing);
    },
  );

  testWidgets('arama başlıkta ve kimlikte arar', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1000));
    await tester.pumpWidget(MaterialApp(home: DuaListScreen(state: state)));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('search')), 'rabbişrah');
    await tester.pumpAndSettle();
    expect(find.text('DUA-0006'), findsOneWidget);
    expect(find.text('DUA-0030'), findsNothing);
  });
}
