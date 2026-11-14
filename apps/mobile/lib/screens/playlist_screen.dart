import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../widgets/mini_player.dart';
import '../widgets/reading_prefs_sheet.dart';
import '../widgets/reading_view.dart';
import 'pick_duas_screen.dart';

/// Bir liste: sırala, tekrar ver, sil; "Oku" (art arda metin) ve "Dinle" (boşluklu sesli).
class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key, required this.playlistId});
  final int playlistId;

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Playlist? _list;
  List<PlaylistItem> _items = [];
  Map<String, Dua> _duas = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_list == null) _load();
  }

  Future<void> _load() async {
    final s = AppScope.of(context);
    final list = (await s.user.allPlaylists()).firstWhere(
      (l) => l.id == widget.playlistId,
    );
    final items = await s.user.items(widget.playlistId);
    final duas = {for (final d in await s.queries.allStandalone()) d.id: d};
    if (mounted) {
      setState(() {
        _list = list;
        _items = items;
        _duas = duas;
      });
    }
  }

  Future<void> _add() async {
    final ids = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(builder: (_) => const PickDuasScreen()),
    );
    if (ids == null || ids.isEmpty || !mounted) return;
    await AppScope.of(context).user.addItems(widget.playlistId, ids);
    await _load();
  }

  List<PlayRequest> get _requests => [
    for (final i in _items)
      if (_duas.containsKey(i.duaId)) PlayRequest(i.duaId, i.repeatCount),
  ];

  Future<void> _listen() async {
    final s = AppScope.of(context);
    await s.player.start(_requests, gapMs: s.gapMs, title: _list?.name);
  }

  Future<void> _read() async {
    final q = AppScope.of(context).queries;
    final views = [for (final r in _requests) await q.duaView(r.duaId)];
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => Scaffold(
          appBar: AppBar(
            title: Text(_list?.name ?? ''),
            actions: [
              IconButton(
                icon: const Icon(Icons.text_fields),
                onPressed: () => showReadingPrefs(c),
              ),
            ],
          ),
          bottomNavigationBar: const MiniPlayer(),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ReadingView(
                views: views,
                onTapSegment: (d, seg) => AppScope.of(c).player.playFrom(
                  _requests,
                  gapMs: AppScope.of(c).gapMs,
                  title: _list?.name,
                  duaId: d,
                  segmentId: seg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _menu(String v) async {
    final user = AppScope.of(context).user;
    if (v == 'rename') {
      final ctl = TextEditingController(text: _list?.name);
      final name = await showDialog<String>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Listeyi yeniden adlandır'),
          content: TextField(controller: ctl, autofocus: true),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(c, ctl.text),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      );
      if (name != null && name.trim().isNotEmpty) {
        await user.renamePlaylist(widget.playlistId, name);
      }
      await _load();
    } else if (v == 'delete') {
      await user.deletePlaylist(widget.playlistId);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_list?.name ?? ''),
        actions: [
          IconButton(
            key: const ValueKey('add-duas'),
            tooltip: 'Dua ekle',
            onPressed: _add,
            icon: const Icon(Icons.playlist_add),
          ),
          PopupMenuButton<String>(
            onSelected: _menu,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'rename', child: Text('Yeniden adlandır')),
              PopupMenuItem(value: 'delete', child: Text('Listeyi sil')),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey('read'),
                    onPressed: _items.isEmpty ? null : _read,
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Oku'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    key: const ValueKey('listen'),
                    onPressed: _items.isEmpty ? null : _listen,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Dinle'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text('Ara: ${(s.gapMs / 1000).toStringAsFixed(1)} sn'),
                Expanded(
                  child: Slider(
                    key: const ValueKey('gap'),
                    value: s.gapMs.toDouble(),
                    max: 5000,
                    divisions: 10,
                    onChanged: (v) => s.setGapMs(v.round()),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.only(bottom: 96),
              onReorderItem: (from, to) async {
                final item = _items[from];
                setState(() {
                  _items.removeAt(from);
                  _items.insert(to, item);
                });
                await s.user.move(item.id, to);
              },
              children: [
                for (var i = 0; i < _items.length; i++) _row(i, _items[i]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(int i, PlaylistItem item) {
    final user = AppScope.of(context).user;
    final dua = _duas[item.duaId];
    return Dismissible(
      key: ValueKey('item-${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        await user.removeItem(item.id);
        await _load();
      },
      child: ListTile(
        title: Text(
          dua?.titleTr ?? 'Bu dua artık yok (${item.duaId})',
          style: dua == null ? const TextStyle(color: Colors.grey) : null,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: ValueKey('repeat-minus-$i'),
              onPressed: item.repeatCount > 1
                  ? () async {
                      await user.setRepeat(item.id, item.repeatCount - 1);
                      await _load();
                    }
                  : null,
              icon: const Icon(Icons.remove),
            ),
            Text('×${item.repeatCount}', key: ValueKey('repeat-$i')),
            IconButton(
              key: ValueKey('repeat-plus-$i'),
              onPressed: item.repeatCount < 99
                  ? () async {
                      await user.setRepeat(item.id, item.repeatCount + 1);
                      await _load();
                    }
                  : null,
              icon: const Icon(Icons.add),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
