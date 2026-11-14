import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../widgets/mini_player.dart';
import '../widgets/reading_prefs_sheet.dart';
import '../widgets/reading_view.dart';

/// Tek dua: okuma, tekrar sayısıyla dinleme, önceki/sonraki.
class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key, required this.duaId, this.order = const []});
  final String duaId;

  /// Önceki/sonraki için sıra (ör. kategori listesi). Boşsa düğmeler gizlenir.
  final List<String> order;

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  DuaView? _view;
  int _repeat = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_view == null) _load();
  }

  Future<void> _load() async {
    final v = await AppScope.of(context).queries.duaView(widget.duaId);
    if (mounted) setState(() => _view = v);
  }

  String? _neighbor(int d) {
    final i = widget.order.indexOf(widget.duaId);
    final j = i + d;
    return i < 0 || j < 0 || j >= widget.order.length ? null : widget.order[j];
  }

  void _go(String id) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => DuaScreen(duaId: id, order: widget.order),
    ),
  );

  void _open(String id) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => DuaScreen(duaId: id, order: widget.order),
    ),
  );

  Future<void> _play() async {
    final s = AppScope.of(context);
    await s.player.start(
      [PlayRequest(widget.duaId, _repeat)],
      gapMs: s.gapMs,
      title: _view?.dua.titleTr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final v = _view;
    final s = AppScope.of(context);
    final prev = _neighbor(-1), next = _neighbor(1);
    return Scaffold(
      appBar: AppBar(
        title: Text(v?.dua.titleTr ?? ''),
        actions: [
          if (widget.order.isNotEmpty) ...[
            IconButton(
              onPressed: prev == null ? null : () => _go(prev),
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              onPressed: next == null ? null : () => _go(next),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
          IconButton(
            key: const ValueKey('prefs'),
            tooltip: 'Okuma seçenekleri',
            icon: const Icon(Icons.text_fields),
            onPressed: () => showReadingPrefs(context),
          ),
        ],
      ),
      bottomNavigationBar: MiniPlayer(
        onOpen: (id) => id == widget.duaId ? null : _open(id),
      ),
      body: v == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                _info(context, v),
                ReadingView(
                  views: [v],
                  showTitles: false,
                  onTapSegment: (d, seg) => s.player.seekToSegment(d, seg),
                ),
                _controls(context, v),
                if (v.variants.isNotEmpty) ...[
                  const Divider(),
                  Text(
                    'Diğer okunuşlar',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  for (final x in v.variants)
                    ListTile(
                      leading: const Icon(Icons.call_split),
                      title: Text(
                        x.variantKey == 'plural'
                            ? 'Çoğul okunuş'
                            : (x.variantKey ?? x.id),
                      ),
                      subtitle: Text(x.editorialNote ?? ''),
                      onTap: () => _open(x.id),
                    ),
                ],
                ..._extras(context, v.dua),
              ],
            ),
    );
  }

  Widget _info(BuildContext context, DuaView v) {
    final d = v.dua;
    final parts = [
      if (d.quranReference != null) "Kur'an ${d.quranReference}",
      if (d.sourceType == 'hadith' && d.hadithGrade != null)
        'Hadis (${d.hadithGrade})',
      if (d.recitationCount != null) '${d.recitationCount} defa',
      if (d.recitationTimeTr != null) d.recitationTimeTr!,
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          for (final c in v.categories)
            Chip(label: Text(c), visualDensity: VisualDensity.compact),
          if (parts.isNotEmpty)
            Text(
              parts.join(' · '),
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }

  Widget _controls(BuildContext context, DuaView v) {
    final hasAudio = v.tracks.isNotEmpty;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            const Text('Tekrar'),
            IconButton(
              key: const ValueKey('repeat-minus'),
              onPressed: _repeat > 1 ? () => setState(() => _repeat--) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$_repeat',
              key: const ValueKey('repeat-value'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              key: const ValueKey('repeat-plus'),
              onPressed: _repeat < 99 ? () => setState(() => _repeat++) : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
            const Spacer(),
            ListenableBuilder(
              listenable: AppScope.of(context).player,
              builder: (context, _) {
                final now = AppScope.of(context).player.now;
                if (now.duaId != widget.duaId || now.turns < 2) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '${now.turn}/${now.turns}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              },
            ),
            FilledButton.icon(
              key: const ValueKey('play'),
              onPressed: hasAudio ? _play : null,
              icon: const Icon(Icons.play_arrow),
              label: Text(hasAudio ? 'Dinle' : 'Ses yok'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _extras(BuildContext context, Dua d) => [
    if (d.hadithTr != null || d.storyTr != null) const Divider(),
    if (d.hadithTr != null)
      ExpansionTile(
        title: const Text('Hadis'),
        children: [
          Padding(padding: const EdgeInsets.all(8), child: Text(d.hadithTr!)),
        ],
      ),
    if (d.storyTr != null)
      ExpansionTile(
        title: const Text('Kıssa'),
        children: [
          Padding(padding: const EdgeInsets.all(8), child: Text(d.storyTr!)),
        ],
      ),
  ];
}
