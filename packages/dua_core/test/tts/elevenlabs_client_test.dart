import 'dart:convert';

import 'package:dua_core/dua_core.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  const key = 'sk_test_1234567890abcd';

  test('kota: başlık ve yanıt çözümü', () async {
    late http.Request seen;
    final c = ElevenLabsClient(key, client: MockClient((r) async {
      seen = r;
      return http.Response(jsonEncode({'character_count': 1200, 'character_limit': 30000}), 200);
    }));
    final q = await c.quota();
    expect(seen.url.toString(), 'https://api.elevenlabs.io/v1/user/subscription');
    expect(seen.headers['xi-api-key'], key);
    expect((q.used, q.limit, q.remaining), (1200, 30000, 28800));
  });

  test('sesler ve kitaplık araması', () async {
    final c = ElevenLabsClient(key, client: MockClient((r) async {
      if (r.url.path == '/v1/voices') {
        return http.Response(jsonEncode({'voices': [{'voice_id': 'v1', 'name': 'Adam', 'preview_url': 'u'}]}), 200);
      }
      expect(r.url.path, '/v1/shared-voices');
      expect(r.url.queryParameters['search'], 'Hanafi');
      return http.Response(
          jsonEncode({'voices': [{'voice_id': 'h1', 'public_owner_id': 'o1', 'name': 'Hanafi', 'language': 'ar'}]}), 200);
    }));
    expect((await c.voices()).single.name, 'Adam');
    final lib = await c.searchLibrary('Hanafi');
    expect((lib.single.voiceId, lib.single.ownerId, lib.single.name), ('h1', 'o1', 'Hanafi'));
  });

  test('kitaplık sesini hesaba ekleme', () async {
    late http.Request seen;
    final c = ElevenLabsClient(key, client: MockClient((r) async {
      seen = r;
      return http.Response(jsonEncode({'voice_id': 'h1'}), 200);
    }));
    await c.addSharedVoice(const SharedVoice(voiceId: 'h1', ownerId: 'o1', name: 'Hanafi'));
    expect(seen.method, 'POST');
    expect(seen.url.path, '/v1/voices/add/o1/h1');
    expect(jsonDecode(seen.body)['new_name'], 'Hanafi');
  });

  test('zamanlamalı seslendirme: mp3 ve hizalama döner', () async {
    late http.Request seen;
    final c = ElevenLabsClient(key, client: MockClient((r) async {
      seen = r;
      return http.Response(
          jsonEncode({
            'audio_base64': base64Encode([1, 2, 3]),
            'alignment': {'characters': ['a', 'b'], 'character_start_times_seconds': [0.0, 0.5], 'character_end_times_seconds': [0.5, 1.0]},
          }),
          200);
    }));
    final (mp3, al) = await c.speakWithTimestamps('v1', 'ab');
    expect(seen.url.path, '/v1/text-to-speech/v1/with-timestamps');
    expect(seen.url.queryParameters['output_format'], 'mp3_44100_128');
    final body = jsonDecode(seen.body);
    expect((body['text'], body['model_id']), ('ab', 'eleven_multilingual_v2'));
    expect(mp3, [1, 2, 3]);
    expect(al.startsSec, [0.0, 0.5]);
  });

  test('geçersiz anahtar: Türkçe hata, anahtarın yalnız son 4 hanesi', () async {
    final c = ElevenLabsClient(key, client: MockClient((r) async => http.Response('{"detail":"invalid"}', 401)));
    try {
      await c.quota();
      fail('hata bekleniyordu');
    } on ElevenLabsException catch (e) {
      expect(e.message, contains('API anahtarı geçersiz'));
      expect(e.message, contains('abcd'));
      expect(e.message, isNot(contains('1234567890')));
    }
  });

  test('429 bir kez beklenip tekrar denenir; kota bitince anlaşılır hata', () async {
    var n = 0;
    final c = ElevenLabsClient(key, retryDelay: Duration.zero, client: MockClient((r) async {
      n++;
      return n == 1
          ? http.Response('busy', 429)
          : http.Response(jsonEncode({'character_count': 1, 'character_limit': 2}), 200);
    }));
    expect((await c.quota()).remaining, 1);
    expect(n, 2);
    final c2 = ElevenLabsClient(key, client: MockClient((r) async => http.Response('{"detail":{"status":"quota_exceeded"}}', 401)));
    expect(() => c2.speak('v', 't'), throwsA(isA<ElevenLabsException>().having((e) => e.message, 'm', contains('kota'))));
  });
}
