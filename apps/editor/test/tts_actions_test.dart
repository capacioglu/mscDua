import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:dua_core/dua_core.dart';
import 'package:dualarim_editor/app/app_state.dart';
import 'package:dualarim_editor/screens/dua_edit_screen.dart';
import 'package:dualarim_editor/screens/dua_list_screen.dart';
import 'package:dualarim_editor/services/settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_elevenlabs.dart';

void main() {
  late ContentDatabase db;
  late AppState state;
  late FakeElevenLabs fake;
  late Directory content;

  setUp(() async {
    db = ContentDatabase.memory();
    final json = jsonDecode(
      File('../../packages/dua_core/test/fixtures/dua_archive.mini.json')
          .readAsStringSync(),
    );
    await ArchiveImporter(db)
        .importJson(json as Map<String, dynamic>, fileName: 'mini.json');
    content = Directory.systemTemp.createTempSync('editor_tts_');
    fake = FakeElevenLabs(used: 1000, limit: 10000);
    final settings = Settings.inMemory()
      ..elevenLabs.apiKey = 'sk_test'
      ..elevenLabs.voices['tr'] = const VoiceRef('v-tr', 'Türkçe Ses');
    state = AppState.forDatabase(
      db,
      content,
      settings,
      (_) => fake,
      () => null,
    );
  });
  tearDown(() async {
    await db.close();
    if (content.existsSync()) content.deleteSync(recursive: true);
  });

  /// Duanın her satırına Türkçe anlam yazar; birleşik metnin uzunluğunu döner.
  Future<int> giveMeanings(String duaId) async {
    final segs = await db.segmentsOf(duaId);
    for (final s in segs) {
      await (db.update(db.segments)..where((t) => t.id.equals(s.id))).write(
        SegmentsCompanion(meaningTr: Value('anlam ${s.position}')),
      );
    }
    return buildTtsText(await db.segmentsOf(duaId), 'tr')!.text.length;
  }

  testWidgets(
    'listede 2 dua seçilip sağ tık "Türkçe sesi üret" → özet → onay → 2 kayıt',
    (tester) async {
      final chars =
          await giveMeanings('DUA-0006') + await giveMeanings('DUA-0030');
      await tester.binding.setSurfaceSize(const Size(1600, 1000));
      await tester.pumpWidget(MaterialApp(home: DuaListScreen(state: state)));
      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.tap(find.byKey(const ValueKey('row-DUA-0006')));
      await tester.tap(find.byKey(const ValueKey('row-DUA-0030')));
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(find.text('2 dua seçili'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('row-DUA-0030')),
        buttons: kSecondaryButton,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Türkçe sesi üret'));
      await pumpUntil(tester, find.byKey(const ValueKey('tts-summary')));
      final summary = tester
          .widget<Text>(find.byKey(const ValueKey('tts-summary')))
          .data!;
      expect(summary, contains('2 dua'));
      expect(summary, contains('$chars karakter'));
      expect(summary, contains('Kalan kota: 9000'));

      await tester.tap(find.byKey(const ValueKey('tts-confirm')));
      await pumpUntil(tester, find.textContaining('Üretilen: 2'));
      final tracks = await db.select(db.tracks).get();
      expect(tracks.map((t) => (t.duaId, t.language, t.source)).toSet(), {
        ('DUA-0006', 'tr', 'elevenlabs'),
        ('DUA-0030', 'tr', 'elevenlabs'),
      });
      expect(
        File('${content.path}/audio/tts/DUA-0006_tr.mp3').existsSync(),
        isTrue,
      );
    },
  );

  testWidgets(
    '"Yalnızca Türkçe" yeni dua: Arapça alanı yok, Arapça ses üretimi pasif',
    (tester) async {
      String? opened;
      await tester.binding.setSurfaceSize(const Size(1600, 1000));
      await tester.pumpWidget(
        MaterialApp(
          home: DuaListScreen(state: state, onOpenDua: (id) => opened = id),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yeni dua'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('new-dua-title')),
        'Sabah duası',
      );
      await tester.tap(find.byKey(const ValueKey('new-dua-tr')));
      await tester.tap(find.text('Oluştur'));
      await tester.pumpAndSettle();
      final d = await (db.select(
        db.duas,
      )..where((t) => t.id.equals(opened!))).getSingle();
      expect(d.textLanguage, 'tr');

      await SegmentRepo(db)
          .replaceAllFromText(d.id, 'Allah\'ım! Bana hayırlı bir gün ver.');
      await tester.binding.setSurfaceSize(const Size(1800, 1400));
      await tester.pumpWidget(
        MaterialApp(
          home: DuaEditScreen(
            state: state,
            duaId: d.id,
            syncPanelBuilder: (_) => const SizedBox(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Arapça metin yapıştır'), findsNothing);
      expect(find.textContaining('Türkçe metin yapıştır'), findsOneWidget);
      expect(find.text('Bana hayırlı bir gün ver.'), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(const ValueKey('tts-ar')))
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(const ValueKey('tts-tr')))
            .onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'metin değişince dua ekranında "sesi yeniden üret" uyarısı çıkar',
    (tester) async {
      await giveMeanings('DUA-0006');
      await tester.runAsync(
        () => state
            .ttsGenerator(fake)
            .generate(
              'DUA-0006',
              'tr',
              voiceId: 'v-tr',
              voiceName: 'Türkçe Ses',
            ),
      );
      final seg = (await db.segmentsOf('DUA-0006')).first;
      await (db.update(db.segments)..where((t) => t.id.equals(seg.id))).write(
        const SegmentsCompanion(meaningTr: Value('değişti')),
      );
      await tester.binding.setSurfaceSize(const Size(1800, 1400));
      await tester.pumpWidget(
        MaterialApp(
          home: DuaEditScreen(
            state: state,
            duaId: 'DUA-0006',
            syncPanelBuilder: (_) => const SizedBox(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Türkçe metin değişti'), findsOneWidget);
    },
  );
}
