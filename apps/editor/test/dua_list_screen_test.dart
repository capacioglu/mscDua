import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
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
      await tester.binding.setSurfaceSize(const Size(1600, 2400));
      await tester.pumpWidget(MaterialApp(home: DuaListScreen(state: state)));
      await tester.pumpAndSettle();

      expect(find.text('DUA-0030'), findsOneWidget);
      expect(find.text('DUA-0006'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('row-DUA-0006')),
          matching: find.text('Ses yok'),
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

      await tester.tap(find.byKey(const ValueKey('filter-category')));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Tövbe ('));
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

  testWidgets(
    'dua dili filtresi: yalnızca Türkçe dualar ve Arapça · Türkçe anlamlı',
    (tester) async {
      await db
          .into(db.duas)
          .insert(
            DuasCompanion.insert(
              id: 'DUA-9001',
              titleTr: 'Sabah duası',
              textLanguage: const Value('tr'),
            ),
          );
      await tester.binding.setSurfaceSize(const Size(1600, 1000));
      await tester.pumpWidget(MaterialApp(home: DuaListScreen(state: state)));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('filter-kind')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yalnızca Türkçe dualar (1)').last);
      await tester.pumpAndSettle();
      expect(find.text('DUA-9001'), findsOneWidget);
      expect(find.text('DUA-0030'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('filter-clear')));
      await tester.pumpAndSettle();
      expect(find.text('DUA-0030'), findsOneWidget);
    },
  );
}
