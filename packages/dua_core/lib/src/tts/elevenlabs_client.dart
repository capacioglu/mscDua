import 'dart:convert';

import 'package:http/http.dart' as http;

import 'tts_text.dart';

class ElevenLabsException implements Exception {
  ElevenLabsException(this.message);
  final String message;
  @override
  String toString() => message;
}

class Quota {
  const Quota(this.used, this.limit);
  final int used;
  final int limit;
  int get remaining => limit - used;
}

class Voice {
  const Voice({required this.id, required this.name, this.previewUrl, this.labels = const {}});
  final String id;
  final String name;
  final String? previewUrl;
  final Map<String, String> labels;
}

class SharedVoice {
  const SharedVoice({required this.voiceId, required this.ownerId, required this.name, this.language, this.previewUrl});
  final String voiceId;
  final String ownerId;
  final String name;
  final String? language;
  final String? previewUrl;
}

/// ElevenLabs REST v1 istemcisi. API anahtarı yalnızca istek başlığında kullanılır;
/// hata mesajlarında yalnız son 4 hanesi görünür.
class ElevenLabsClient {
  ElevenLabsClient(
    this.apiKey, {
    http.Client? client,
    this.base = 'https://api.elevenlabs.io',
    this.retryDelay = const Duration(seconds: 2),
  }) : _http = client ?? http.Client();

  final String apiKey;
  final String base;
  final Duration retryDelay;
  final http.Client _http;

  static const defaultModel = 'eleven_multilingual_v2';
  static const outputFormat = 'mp3_44100_128';

  String get _masked => apiKey.length <= 4 ? '****' : '…${apiKey.substring(apiKey.length - 4)}';

  Map<String, String> get _headers => {'xi-api-key': apiKey, 'Content-Type': 'application/json', 'Accept': '*/*'};

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    var r = await call();
    if (r.statusCode == 429) {
      await Future<void>.delayed(retryDelay);
      r = await call();
    }
    if (r.statusCode >= 200 && r.statusCode < 300) return r;
    final body = r.body.length > 300 ? '${r.body.substring(0, 300)}…' : r.body;
    if (body.contains('quota_exceeded')) {
      throw ElevenLabsException('ElevenLabs karakter kotası doldu. Planını yükselt ya da ay başını bekle.');
    }
    throw ElevenLabsException(switch (r.statusCode) {
      401 => 'API anahtarı geçersiz ($_masked). Ayarlardan kontrol et.',
      402 => 'ElevenLabs bu işlem için ödeme / plan istiyor (402).',
      429 => 'ElevenLabs çok fazla istek dedi (429); biraz sonra tekrar dene.',
      _ => 'ElevenLabs hatası ${r.statusCode}: $body',
    });
  }

  Future<Map<String, dynamic>> _getJson(String path, [Map<String, String>? q]) async {
    final r = await _send(() => _http.get(Uri.parse('$base$path').replace(queryParameters: q), headers: _headers));
    return jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
  }

  Future<Quota> quota() async {
    final j = await _getJson('/v1/user/subscription');
    return Quota(j['character_count'] as int, j['character_limit'] as int);
  }

  Future<List<Voice>> voices() async {
    final j = await _getJson('/v1/voices');
    return [
      for (final v in (j['voices'] as List).cast<Map<String, dynamic>>())
        Voice(
          id: v['voice_id'] as String,
          name: v['name'] as String,
          previewUrl: v['preview_url'] as String?,
          labels: {for (final e in ((v['labels'] as Map?) ?? {}).entries) '${e.key}': '${e.value}'},
        ),
    ];
  }

  Future<List<SharedVoice>> searchLibrary(String query) async {
    final j = await _getJson('/v1/shared-voices', {'search': query, 'page_size': '30'});
    return [
      for (final v in (j['voices'] as List).cast<Map<String, dynamic>>())
        SharedVoice(
          voiceId: v['voice_id'] as String,
          ownerId: v['public_owner_id'] as String,
          name: v['name'] as String,
          language: v['language'] as String?,
          previewUrl: v['preview_url'] as String?,
        ),
    ];
  }

  Future<void> addSharedVoice(SharedVoice v) async {
    await _send(() => _http.post(Uri.parse('$base/v1/voices/add/${v.ownerId}/${v.voiceId}'),
        headers: _headers, body: jsonEncode({'new_name': v.name})));
  }

  /// Zamanlamasız seslendirme (deneme alanı için): mp3 baytları.
  Future<List<int>> speak(String voiceId, String text, {String modelId = defaultModel}) async {
    final r = await _send(() => _http.post(
        Uri.parse('$base/v1/text-to-speech/$voiceId').replace(queryParameters: {'output_format': outputFormat}),
        headers: _headers,
        body: jsonEncode({'text': text, 'model_id': modelId})));
    return r.bodyBytes;
  }

  /// Zamanlamalı seslendirme: mp3 baytları ve harf zamanları.
  Future<(List<int>, Alignment)> speakWithTimestamps(String voiceId, String text,
      {String modelId = defaultModel}) async {
    final r = await _send(() => _http.post(
        Uri.parse('$base/v1/text-to-speech/$voiceId/with-timestamps')
            .replace(queryParameters: {'output_format': outputFormat}),
        headers: _headers,
        body: jsonEncode({'text': text, 'model_id': modelId})));
    final j = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
    final al = j['alignment'] as Map<String, dynamic>?;
    if (al == null) throw ElevenLabsException('ElevenLabs zamanlama bilgisi döndürmedi.');
    return (base64Decode(j['audio_base64'] as String), Alignment.fromJson(al));
  }

  void close() => _http.close();
}
