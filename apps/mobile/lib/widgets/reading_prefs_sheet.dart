import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';

const _labels = {
  ReadingOption.arabic: 'Arapça',
  ReadingOption.pronunciationTr: 'Türkçe okunuş',
  ReadingOption.pronunciationEn: 'İngilizce okunuş',
  ReadingOption.meaningTr: 'Türkçe anlam',
  ReadingOption.meaningEn: 'İngilizce anlam',
};

/// Okuma seçenekleri, yazı boyutu ve dualar arası boşluk.
Future<void> showReadingPrefs(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const _PrefsSheet(),
    );

class _PrefsSheet extends StatelessWidget {
  const _PrefsSheet();

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            'Ekranda göster',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final o in ReadingOption.values)
            SwitchListTile(
              key: ValueKey('pref-${o.name}'),
              title: Text(_labels[o]!),
              value: s.prefs.get(o),
              onChanged: (_) => s.toggle(o),
            ),
          SwitchListTile(
            key: const ValueKey('pref-meaning-per-line'),
            title: const Text('Anlamı her Arapça satırın altında göster'),
            subtitle: const Text(
              'Kapalıyken anlam duanın sonunda tek paragraf olur',
            ),
            value: s.meaningPerLine,
            onChanged: s.setMeaningPerLine,
          ),
          const Divider(),
          Text('Dinleme dili', style: Theme.of(context).textTheme.titleMedium),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'ar',
                  label: Text('Arapça', key: ValueKey('listen-ar')),
                ),
                ButtonSegment(
                  value: 'tr',
                  label: Text('Türkçe', key: ValueKey('listen-tr')),
                ),
                ButtonSegment(
                  value: 'en',
                  label: Text('İngilizce', key: ValueKey('listen-en')),
                ),
              ],
              selected: {s.listenLanguage},
              onSelectionChanged: (v) => s.setListenLanguage(v.first),
            ),
          ),
          Text(
            'O dilde sesi olmayan dua Arapça sesiyle, hiç sesi yoksa metin olarak geçer.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Divider(),
          Text('Görünüm', style: Theme.of(context).textTheme.titleMedium),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('Sistem', key: ValueKey('theme-system')),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Açık', key: ValueKey('theme-light')),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Gece', key: ValueKey('theme-dark')),
                  icon: Icon(Icons.dark_mode),
                ),
              ],
              selected: {s.themeMode},
              onSelectionChanged: (v) => s.setThemeMode(v.first),
            ),
          ),
          const Divider(),
          Text('Yazı boyutu', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: s.fontScale,
            min: 0.8,
            max: 1.8,
            divisions: 10,
            label: '${(s.fontScale * 100).round()}%',
            onChanged: s.setFontScale,
          ),
          Text(
            'Dualar arası boşluk: ${(s.gapMs / 1000).toStringAsFixed(1)} sn',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            key: const ValueKey('gap'),
            value: s.gapMs.toDouble(),
            min: 0,
            max: 5000,
            divisions: 10,
            label: '${(s.gapMs / 1000).toStringAsFixed(1)} sn',
            onChanged: (v) => s.setGapMs(v.round()),
          ),
        ],
      ),
    );
  }
}
