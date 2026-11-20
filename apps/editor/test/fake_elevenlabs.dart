import 'package:dua_core/dua_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ağsız sahte ElevenLabs: her harfe 50 ms verir.
class FakeElevenLabs extends ElevenLabsClient {
  FakeElevenLabs({this.used = 1000, this.limit = 10000})
    : super('test-key-1234');
  final int used;
  final int limit;
  final sent = <String>[];
  final added = <String>[];

  @override
  Future<Quota> quota() async => Quota(used, limit);

  @override
  Future<List<Voice>> voices() async => const [
    Voice(id: 'v-hanafi', name: 'Hanafi'),
    Voice(id: 'v-tr', name: 'Türkçe Ses'),
  ];

  @override
  Future<List<SharedVoice>> searchLibrary(String query) async => [
    SharedVoice(
      voiceId: 'lib-1',
      ownerId: 'own-1',
      name: '$query (kitaplık)',
      language: 'ar',
    ),
  ];

  @override
  Future<void> addSharedVoice(SharedVoice v) async => added.add(v.voiceId);

  @override
  Future<List<int>> speak(
    String voiceId,
    String text, {
    String modelId = ElevenLabsClient.defaultModel,
  }) async {
    sent.add(text);
    return [1, 2, 3];
  }

  @override
  Future<(List<int>, TtsAlignment)> speakWithTimestamps(
    String voiceId,
    String text, {
    String modelId = ElevenLabsClient.defaultModel,
  }) async {
    sent.add(text);
    final chars = text.split('');
    return (
      [1, 2, 3],
      TtsAlignment(
        chars: chars,
        startsSec: [for (var i = 0; i < chars.length; i++) i * 0.05],
      ),
    );
  }
}

/// Gerçek dosya G/Ç'si bitene kadar bekleyip ekranı yeniler.
Future<void> pumpUntil(WidgetTester tester, Finder f, {int tries = 200}) async {
  for (var i = 0; i < tries; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
    if (f.evaluate().isNotEmpty) return;
  }
  fail('Bulunamadı: $f');
}
