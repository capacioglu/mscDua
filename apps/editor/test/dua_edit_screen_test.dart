import 'dart:convert';
import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:dualarim_editor/app/app_state.dart';
import 'package:dualarim_editor/screens/dua_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> open(WidgetTester tester, String id) async {
    await tester.binding.setSurfaceSize(const Size(1800, 1400));
    await tester.pumpWidget(
      MaterialApp(
        home: DuaEditScreen(
          state: state,
          duaId: id,
          syncPanelBuilder: (_) => const SizedBox(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('çeviri alanları düzenlenip kaydedilir; onay düğmesi yok', (
    tester,
  ) async {
    await open(tester, 'DUA-0006');
    await tester.tap(find.byKey(const ValueKey('seg-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('approve')), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('field-meaningTr')),
      'Rabbim! Gönlüme genişlik ver.',
    );
    await tester.tap(find.byKey(const ValueKey('save-fields')));
    await tester.pumpAndSettle();
    expect(
      (await db.segmentsOf('DUA-0006')).first.meaningTr,
      'Rabbim! Gönlüme genişlik ver.',
    );
  });

  testWidgets(
    'duanın bütün anlamı ve kategorileri görünür, yayın durumu yazılır',
    (tester) async {
      await open(tester, 'DUA-0030');
      expect(find.byKey(const ValueKey('cat-Tövbe')), findsOneWidget);
      expect(
        find.textContaining('Rabbimiz! Kendimize zulmettik.'),
        findsWidgets,
      );
      expect(find.text('Yayınlanabilir'), findsOneWidget);
    },
  );

  testWidgets('Arapçayı kopyala düğmesi duanın tüm Arapçasını panoya koyar', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    await open(tester, 'DUA-0006');
    await tester.tap(find.byKey(const ValueKey('copy-arabic')));
    await tester.pumpAndSettle();
    expect(
      copied,
      'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي يَفْقَهُوا قَوْلِي',
    );
  });

  testWidgets('sonraki / önceki dua düğmeleri sıradaki duayı açar', (
    tester,
  ) async {
    await open(tester, 'DUA-0006');
    await tester.tap(find.byKey(const ValueKey('next-dua')));
    await tester.pumpAndSettle();
    expect(find.textContaining('DUA-0013 —'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('prev-dua')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('prev-dua')));
    await tester.pumpAndSettle();
    expect(find.textContaining('DUA-0004 —'), findsOneWidget);
  });
}
