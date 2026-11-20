import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../services/settings.dart';

const ttsLanguages = ['ar', 'tr', 'en'];
const ttsLangNames = {'ar': 'Arapça', 'tr': 'Türkçe', 'en': 'İngilizce'};

const _samples = {
  'ar': 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
  'tr': 'Rabbim! Gönlüme genişlik ver, işimi kolaylaştır.',
  'en': 'My Lord, expand for me my chest and ease for me my task.',
};

/// Ayarlar → ElevenLabs sekmesi: anahtar, bağlantı/kota, dil başına ses,
/// kitaplıkta arama, deneme alanı. Değişiklikler [settings] nesnesine anında
/// yazılır; diske kaydetmek çağıranın işidir.
class ElevenLabsSettingsView extends StatefulWidget {
  const ElevenLabsSettingsView({
    super.key,
    required this.settings,
    required this.clientFactory,
    required this.onPlay,
  });
  final ElevenLabsSettings settings;
  final ElevenLabsClient Function(String apiKey) clientFactory;

  /// Deneme sesini çalar (mp3 baytları); dosya kalıcı yazılmaz.
  final Future<void> Function(List<int> mp3) onPlay;

  @override
  State<ElevenLabsSettingsView> createState() => _ElevenLabsSettingsViewState();
}

class _ElevenLabsSettingsViewState extends State<ElevenLabsSettingsView> {
  ElevenLabsSettings get el => widget.settings;

  late final _key = TextEditingController(text: el.apiKey ?? '');
  late final _model = TextEditingController(text: el.modelId);
  late final _ids = {
    for (final l in ttsLanguages)
      l: TextEditingController(text: el.voices[l]?.id ?? ''),
  };
  final _search = TextEditingController();
  late final _sample = TextEditingController(text: _samples['ar']);
  String _sampleLang = 'ar';

  bool _obscure = true;
  bool _busy = false;
  String? _status;
  bool _statusError = false;
  List<Voice> _voices = [];
  List<SharedVoice> _results = [];

  @override
  void dispose() {
    for (final c in [_key, _model, _search, _sample, ..._ids.values]) {
      c.dispose();
    }
    super.dispose();
  }

  void _say(String msg, {bool error = false}) => setState(() {
    _status = msg;
    _statusError = error;
  });

  /// Anahtarla istemci kurar, [body]'yi çalıştırır; hatayı durum satırına yazar.
  Future<void> _withClient(
    Future<void> Function(ElevenLabsClient c) body,
  ) async {
    final key = _key.text.trim();
    if (key.isEmpty) return _say('Önce API anahtarını gir.', error: true);
    el.apiKey = key;
    setState(() => _busy = true);
    final c = widget.clientFactory(key);
    try {
      await body(c);
    } catch (e) {
      _say('$e', error: true);
    } finally {
      c.close();
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _test() => _withClient((c) async {
    final q = await c.quota();
    final voices = await c.voices();
    setState(() => _voices = voices);
    _say(
      'Bağlantı tamam. Kalan kota: ${q.remaining} / ${q.limit} karakter · hesapta ${voices.length} ses',
    );
  });

  Future<void> _doSearch() => _withClient((c) async {
    final r = await c.searchLibrary(_search.text.trim());
    setState(() => _results = r);
    if (r.isEmpty) _say('Kitaplıkta sonuç yok.');
  });

  Future<void> _add(SharedVoice v) => _withClient((c) async {
    await c.addSharedVoice(v);
    final voices = await c.voices();
    setState(() => _voices = voices);
    _say('"${v.name}" hesabına eklendi; artık dil listelerinde seçilebilir.');
  });

  Future<void> _speak() async {
    final v = el.voices[_sampleLang];
    if (v == null) {
      return _say('${ttsLangNames[_sampleLang]} için ses seç.', error: true);
    }
    final text = _sample.text.trim();
    if (text.isEmpty) return;
    await _withClient((c) async {
      final mp3 = await c.speak(v.id, text, modelId: el.modelId);
      await widget.onPlay(mp3);
      _say('Çalınıyor: ${v.name} (${text.length} karakter)');
    });
  }

  void _setVoice(String lang, String id, {String? name}) {
    final trimmed = id.trim();
    if (trimmed.isEmpty) {
      el.voices.remove(lang);
    } else {
      final known = _voices.where((v) => v.id == trimmed).firstOrNull;
      final prev = el.voices[lang];
      el.voices[lang] = VoiceRef(
        trimmed,
        name ?? known?.name ?? (prev?.id == trimmed ? prev!.name : trimmed),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('Bağlantı', style: t.titleSmall),
        TextField(
          key: const ValueKey('el-key'),
          controller: _key,
          obscureText: _obscure,
          onChanged: (v) => el.apiKey = v.trim().isEmpty ? null : v.trim(),
          decoration: InputDecoration(
            labelText: 'API anahtarı (yalnızca bu bilgisayarda saklanır)',
            suffixIcon: IconButton(
              tooltip: _obscure ? 'Göster' : 'Gizle',
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        TextField(
          key: const ValueKey('el-model'),
          controller: _model,
          onChanged: (v) => el.modelId = v.trim().isEmpty
              ? ElevenLabsClient.defaultModel
              : v.trim(),
          decoration: const InputDecoration(labelText: 'Model'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            FilledButton.tonalIcon(
              key: const ValueKey('el-test'),
              onPressed: _busy ? null : _test,
              icon: const Icon(Icons.wifi_tethering),
              label: const Text('Bağlantıyı dene'),
            ),
            const SizedBox(width: 12),
            if (_busy)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        if (_status != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SelectableText(
              _status!,
              key: const ValueKey('el-status'),
              style: TextStyle(
                color: _statusError ? Colors.red : Colors.green.shade800,
              ),
            ),
          ),
        const Divider(height: 24),
        Text('Sesler (dil başına)', style: t.titleSmall),
        for (final l in ttsLanguages) _voiceRow(l),
        const Divider(height: 24),
        Text('Ses kitaplığında ara', style: t.titleSmall),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const ValueKey('el-search'),
                controller: _search,
                decoration: const InputDecoration(hintText: 'ör. Hanafi'),
                onSubmitted: (_) => _doSearch(),
              ),
            ),
            IconButton(
              key: const ValueKey('el-search-go'),
              tooltip: 'Ara',
              onPressed: _busy ? null : _doSearch,
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        for (final v in _results)
          ListTile(
            dense: true,
            title: Text(v.name),
            subtitle: Text(
              [v.language, v.voiceId].whereType<String>().join(' · '),
            ),
            trailing: TextButton(
              key: ValueKey('el-add-${v.voiceId}'),
              onPressed: _busy ? null : () => _add(v),
              child: const Text('Hesabıma ekle'),
            ),
          ),
        const Divider(height: 24),
        Text('Deneme', style: t.titleSmall),
        Row(
          children: [
            DropdownButton<String>(
              key: const ValueKey('el-sample-lang'),
              value: _sampleLang,
              items: [
                for (final l in ttsLanguages)
                  DropdownMenuItem(value: l, child: Text(ttsLangNames[l]!)),
              ],
              onChanged: (l) => setState(() {
                if (l == null) return;
                if (_sample.text == _samples[_sampleLang]) {
                  _sample.text = _samples[l]!;
                }
                _sampleLang = l;
              }),
            ),
            const SizedBox(width: 8),
            Text(
              el.voices[_sampleLang]?.name ?? 'ses seçilmedi',
              style: t.bodySmall,
            ),
          ],
        ),
        TextField(
          key: const ValueKey('el-sample'),
          controller: _sample,
          maxLines: 2,
          textDirection: _sampleLang == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            key: const ValueKey('el-speak'),
            onPressed: _busy ? null : _speak,
            icon: const Icon(Icons.record_voice_over),
            label: const Text('Seslendir'),
          ),
        ),
      ],
    );
  }

  Widget _voiceRow(String lang) {
    final current = el.voices[lang];
    final items = [
      for (final v in _voices)
        DropdownMenuItem(value: v.id, child: Text(v.name)),
      if (current != null && !_voices.any((v) => v.id == current.id))
        DropdownMenuItem(value: current.id, child: Text(current.name)),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(ttsLangNames[lang]!)),
          Expanded(
            child: DropdownButton<String>(
              key: ValueKey('el-voice-$lang'),
              isExpanded: true,
              value: current?.id,
              hint: const Text('Hesap sesleri için "Bağlantıyı dene"'),
              items: items,
              onChanged: (id) {
                if (id == null) return;
                _ids[lang]!.text = id;
                _setVoice(
                  lang,
                  id,
                  name: _voices.where((v) => v.id == id).firstOrNull?.name,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 220,
            child: TextField(
              key: ValueKey('el-voice-id-$lang'),
              controller: _ids[lang],
              decoration: const InputDecoration(
                labelText: 'Ses kimliği (voice ID)',
                isDense: true,
              ),
              onChanged: (v) => _setVoice(lang, v),
            ),
          ),
        ],
      ),
    );
  }
}
