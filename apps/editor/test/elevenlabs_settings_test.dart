import 'package:dualarim_editor/services/settings.dart';
import 'package:dualarim_editor/widgets/elevenlabs_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_elevenlabs.dart';

void main() {
  late Settings settings;
  late FakeElevenLabs fake;
  String? usedKey;
  List<int>? played;

  setUp(() {
    settings = Settings.inMemory();
    fake = FakeElevenLabs(used: 1000, limit: 10000);
    usedKey = null;
    played = null;
  });

  Future<void> open(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevenLabsSettingsView(
            settings: settings.elevenLabs,
            clientFactory: (k) {
              usedKey = k;
              return fake;
            },
            onPlay: (mp3) async => played = mp3,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'anahtar girilip "Bağlantıyı dene" → kalan kota ve hesap sesleri',
    (tester) async {
      await open(tester);
      await tester.enterText(
        find.byKey(const ValueKey('el-key')),
        '  sk_abcd1234  ',
      );
      await tester.tap(find.byKey(const ValueKey('el-test')));
      await tester.pumpAndSettle();
      expect(usedKey, 'sk_abcd1234');
      expect(settings.elevenLabs.apiKey, 'sk_abcd1234');
      expect(
        find.textContaining('Kalan kota: 9000 / 10000 karakter'),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('el-voice-ar')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hanafi').last);
      await tester.pumpAndSettle();
      expect(settings.elevenLabs.voices['ar']?.id, 'v-hanafi');
      expect(settings.elevenLabs.voices['ar']?.name, 'Hanafi');
    },
  );

  testWidgets(
    'elle ses kimliği girilebilir; kitaplıkta arayıp hesaba eklenir',
    (tester) async {
      await open(tester);
      await tester.enterText(find.byKey(const ValueKey('el-key')), 'k');
      await tester.enterText(
        find.byKey(const ValueKey('el-voice-id-tr')),
        'manual-voice',
      );
      await tester.pump();
      expect(settings.elevenLabs.voices['tr']?.id, 'manual-voice');

      await tester.enterText(find.byKey(const ValueKey('el-search')), 'Hanafi');
      await tester.tap(find.byKey(const ValueKey('el-search-go')));
      await tester.pumpAndSettle();
      expect(find.text('Hanafi (kitaplık)'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('el-add-lib-1')));
      await tester.pumpAndSettle();
      expect(fake.added, ['lib-1']);
    },
  );

  testWidgets('deneme alanı seçili sesle seslendirip çalar', (tester) async {
    settings.elevenLabs.voices['ar'] = const VoiceRef('v-hanafi', 'Hanafi');
    await open(tester);
    await tester.enterText(find.byKey(const ValueKey('el-key')), 'k');
    await tester.enterText(
      find.byKey(const ValueKey('el-sample')),
      'بِسْمِ اللَّهِ',
    );
    await tester.tap(find.byKey(const ValueKey('el-speak')));
    await tester.pumpAndSettle();
    expect(fake.sent, ['بِسْمِ اللَّهِ']);
    expect(played, [1, 2, 3]);
  });
}
