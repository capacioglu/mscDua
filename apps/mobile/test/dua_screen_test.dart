import 'package:drift/drift.dart' show Value;
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
    await tester.pumpWidget(
      AppScope(
        services: services,
        child: MaterialApp(home: DuaScreen(duaId: id)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('satırlar, okunuşlar ve duanın bütün anlamı bir kez görünür', (
    tester,
  ) async {
    await open(tester, 'DUA-0006');
    final segs = await db.segmentsOf('DUA-0006');
    for (final s in segs) {
      expect(find.text(s.textAr), findsOneWidget);
    }
    expect(find.text('Ve yessir lî emrî.'), findsOneWidget);
    expect(
      find.textContaining('Rabbim! Gönlüme genişlik ver.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'okuma seçenekleri: okunuş kapanır; son açık seçenek kapatılamaz',
    (tester) async {
      await open(tester, 'DUA-0006');
      await tester.tap(find.byKey(const ValueKey('prefs')));
      await tester.pumpAndSettle();
      for (final k in [
        'pref-arabic',
        'pref-pronunciationTr',
        'pref-meaningTr',
      ]) {
        await tester.tap(find.byKey(ValueKey(k)));
        await tester.pumpAndSettle();
      }
      Navigator.of(tester.element(find.byKey(const ValueKey('pref-arabic'))))
          .pop();
      await tester.pumpAndSettle();
      expect(find.text('Ve yessir lî emrî.'), findsNothing);
      expect(
        find.textContaining('Rabbim! Gönlüme genişlik ver.'),
        findsOneWidget,
      );
      expect((await services.user.readingPrefs()).meaningTr, isTrue);
    },
  );

  testWidgets('tekrar 3 ile çal; ilerleyen ses o satırı vurgular', (
    tester,
  ) async {
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
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('seg-active')),
        matching: find.text(segs[1].textAr),
      ),
      findsOneWidget,
    );
    expect(find.text('1/3'), findsWidgets);
  });

  testWidgets('anlam yerleşimi: satır altında ↔ duanın sonunda', (
    tester,
  ) async {
    await open(tester, 'DUA-0013');
    final seg = (await db.segmentsOf('DUA-0013')).single;
    expect(find.byKey(ValueKey('seg-meaning-${seg.id}')), findsOneWidget);
    expect(find.byKey(const ValueKey('dua-meaning-DUA-0013')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('prefs')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pref-meaning-per-line')));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byKey(const ValueKey('pref-arabic'))))
        .pop();
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('seg-meaning-${seg.id}')), findsNothing);
    expect(find.byKey(const ValueKey('dua-meaning-DUA-0013')), findsOneWidget);
    expect(await services.user.meaningPerLine(), isFalse);
  });

  testWidgets('satır anlamı olmayan çok satırlı duada anlam sonda kalır', (
    tester,
  ) async {
    await open(tester, 'DUA-0006');
    expect(find.byKey(const ValueKey('dua-meaning-DUA-0006')), findsOneWidget);
  });

  testWidgets('gece modu seçilir ve kalıcıdır', (tester) async {
    await open(tester, 'DUA-0013');
    await tester.tap(find.byKey(const ValueKey('prefs')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('theme-dark')));
    await tester.pumpAndSettle();
    expect(services.themeMode, ThemeMode.dark);
    expect(await services.user.themeMode(), 'dark');
  });

  testWidgets('çalmıyorken satıra dokununca ses o satırdan başlar', (
    tester,
  ) async {
    await open(tester, 'DUA-0006');
    final segs = await db.segmentsOf('DUA-0006');
    await tester.tap(find.text(segs[2].textAr));
    await tester.pumpAndSettle();
    expect(backend.queue.whereType<ClipEntry>(), hasLength(1));
    expect(backend.lastSeek, (0, 2000));
    expect(backend.playing, isTrue);
  });

  testWidgets('kaldığın yerden devam: küçük oynatıcı saklı oturumu sürdürür', (
    tester,
  ) async {
    await services.user.saveLastSession(
      '{"requests":[["DUA-0006",2]],"gapMs":500,"title":"Sabah","index":2,"ms":1200}',
    );
    await services.player.loadSession();
    await open(tester, 'DUA-0013');
    expect(find.textContaining('Kaldığın yerden devam'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('mini-resume')));
    await tester.pumpAndSettle();
    expect(backend.queue.whereType<ClipEntry>(), hasLength(2));
    expect(backend.lastSeek, (2, 1200));
  });

  testWidgets('dinleme dili tercih sayfasında değişir ve kalıcıdır', (
    tester,
  ) async {
    await open(tester, 'DUA-0013');
    await tester.tap(find.byKey(const ValueKey('prefs')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('listen-tr')));
    await tester.pumpAndSettle();
    expect(services.listenLanguage, 'tr');
    expect(services.player.listenLanguage, 'tr');
    expect(await services.user.listenLanguage(), 'tr');
  });

  testWidgets(
    'Türkçe dinlerken TR kaydı olan dua TR kaydını, olmayan AR kaydını çalar',
    (tester) async {
      final t = await db
          .into(db.tracks)
          .insert(
            TracksCompanion.insert(
              ownerKind: TrackOwnerKind.dua,
              duaId: const Value('DUA-0006'),
              relPath: 'audio/tts/DUA-0006_tr.mp3',
              label: 'ElevenLabs',
              language: const Value('tr'),
              source: const Value('elevenlabs'),
            ),
          );
      for (final seg in await db.segmentsOf('DUA-0006')) {
        await db
            .into(db.cues)
            .insert(
              CuesCompanion.insert(
                trackId: t,
                startMs: seg.position * 900,
                segmentId: Value(seg.id),
              ),
            );
      }
      await services.setListenLanguage('tr');
      await open(tester, 'DUA-0006');
      await tester.tap(find.byKey(const ValueKey('play')));
      await tester.pumpAndSettle();
      expect(backend.queue.whereType<ClipEntry>().single.track.language, 'tr');

      await open(tester, 'DUA-0013');
      await tester.tap(find.byKey(const ValueKey('play')));
      await tester.pumpAndSettle();
      expect(backend.queue.whereType<ClipEntry>().single.track.language, 'ar');
      expect(find.textContaining('AR'), findsWidgets);
    },
  );

  testWidgets(
    'yalnızca Türkçe dua Türkçe ana metinle görünür, anlam tekrarlanmaz',
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
      for (final (i, m) in ["Allah'ım!", 'Bana hayırlı bir gün ver.'].indexed) {
        await db
            .into(db.segments)
            .insert(
              SegmentsCompanion.insert(
                duaId: 'DUA-9001',
                position: i,
                textAr: '',
                meaningTr: Value(m),
              ),
            );
      }
      await open(tester, 'DUA-9001');
      expect(find.text("Allah'ım!"), findsOneWidget);
      expect(find.text('Bana hayırlı bir gün ver.'), findsOneWidget);
      expect(find.byKey(const ValueKey('dua-meaning-DUA-9001')), findsNothing);
    },
  );
}
