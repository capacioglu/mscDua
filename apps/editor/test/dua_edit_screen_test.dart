import 'dart:convert';
import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:dualarim_editor/app/app_state.dart';
import 'package:dualarim_editor/screens/dua_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ContentDatabase db;
  late AppState state;

  setUp(() async {
    db = ContentDatabase.memory();
    final json = jsonDecode(File('../../packages/dua_core/test/fixtures/dua_archive.mini.json').readAsStringSync());
    await ArchiveImporter(db).importJson(json as Map<String, dynamic>, fileName: 'mini.json');
    state = AppState.forDatabase(db, Directory.systemTemp);
  });
  tearDown(() => db.close());

  Future<void> open(WidgetTester tester, String id) async {
    await tester.binding.setSurfaceSize(const Size(1800, 1400));
    await tester.pumpWidget(MaterialApp(
        home: DuaEditScreen(state: state, duaId: id, syncPanelBuilder: (_) => const SizedBox())));
    await tester.pumpAndSettle();
  }

  Finder inSeg(int i, Finder f) => find.descendant(of: find.byKey(ValueKey('seg-$i')), matching: f);

  testWidgets('eksik alan varken Onayla pasif; doldurunca onaylanır', (tester) async {
    await open(tester, 'DUA-0006');
    await tester.tap(find.byKey(const ValueKey('seg-0')));
    await tester.pumpAndSettle();
    expect(inSeg(0, find.text('Çeviri yok')), findsOneWidget);

    final approve = find.byKey(const ValueKey('approve'));
    expect(tester.widget<FilledButton>(approve).onPressed, isNull);

    await tester.enterText(find.byKey(const ValueKey('field-meaningTr')), 'Rabbim! Gönlüme genişlik ver.');
    await tester.enterText(find.byKey(const ValueKey('field-meaningEn')), 'My Lord, expand my chest.');
    await tester.tap(find.byKey(const ValueKey('save-fields')));
    await tester.pumpAndSettle();
    expect(inSeg(0, find.text('Gözden geçirilecek')), findsOneWidget);
    expect(tester.widget<FilledButton>(approve).onPressed, isNotNull);

    await tester.tap(approve);
    await tester.pumpAndSettle();
    expect(inSeg(0, find.text('Onaylı')), findsOneWidget);
  });

  testWidgets('Arapça düzenlenince onay gözden geçirilecek olur', (tester) async {
    await open(tester, 'DUA-0013');
    await tester.tap(find.byKey(const ValueKey('seg-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('approve')));
    await tester.pumpAndSettle();
    expect(inSeg(0, find.text('Onaylı')), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('field-arabic')), 'رَبَّنَا آتِنَا');
    await tester.tap(find.byKey(const ValueKey('save-arabic')));
    await tester.pumpAndSettle();
    expect(inSeg(0, find.text('Gözden geçirilecek')), findsOneWidget);
  });

  testWidgets('kategoriler gösterilir ve yayın nedenleri listelenir', (tester) async {
    await open(tester, 'DUA-0030');
    expect(find.byKey(const ValueKey('cat-Tövbe')), findsOneWidget);
    expect(find.textContaining('Tam zamanlanmış ses kaydı yok'), findsOneWidget);
  });
}
