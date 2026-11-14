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
Future<void> showReadingPrefs(BuildContext context) => showModalBottomSheet<void>(
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
      child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: [
        Text('Ekranda göster', style: Theme.of(context).textTheme.titleMedium),
        for (final o in ReadingOption.values)
          SwitchListTile(
            key: ValueKey('pref-${o.name}'),
            title: Text(_labels[o]!),
            value: s.prefs.get(o),
            onChanged: (_) => s.toggle(o),
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
        Text('Dualar arası boşluk: ${(s.gapMs / 1000).toStringAsFixed(1)} sn',
            style: Theme.of(context).textTheme.titleMedium),
        Slider(
          key: const ValueKey('gap'),
          value: s.gapMs.toDouble(),
          min: 0,
          max: 5000,
          divisions: 10,
          label: '${(s.gapMs / 1000).toStringAsFixed(1)} sn',
          onChanged: (v) => s.setGapMs(v.round()),
        ),
      ]),
    );
  }
}
