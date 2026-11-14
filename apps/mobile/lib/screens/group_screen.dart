import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../widgets/mini_player.dart';
import '../widgets/reading_prefs_sheet.dart';
import '../widgets/reading_view.dart';
import 'dua_screen.dart';

/// Grubun duaları sırasıyla; "Tümünü çal" her duayı kendi tekrar sayısıyla art arda çalar.
class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key, required this.group});
  final DuaGroup group;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<GroupEntry> _entries = [];
  List<DuaView> _views = [];
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _load();
    }
  }

  Future<void> _load() async {
    final q = AppScope.of(context).queries;
    final entries = await q.groupEntries(widget.group.id);
    final views = [for (final e in entries) await q.duaView(e.dua.id)];
    if (mounted) {
      setState(() {
        _entries = entries;
        _views = views;
      });
    }
  }

  Future<void> _playAll() async {
    final s = AppScope.of(context);
    await s.player.start(
      [for (final e in _entries) PlayRequest(e.dua.id, e.item.repeatCount)],
      gapMs: s.gapMs,
      title: widget.group.titleTr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final order = _entries.map((e) => e.dua.id).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.titleTr),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () => showReadingPrefs(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('play-all'),
        onPressed: _entries.isEmpty ? null : _playAll,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Tümünü çal'),
      ),
      bottomNavigationBar: const MiniPlayer(),
      body: _views.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                if (widget.group.description != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(widget.group.description!),
                  ),
                ReadingView(
                  views: _views,
                  onTapSegment: (d, seg) => s.player.seekToSegment(d, seg),
                  onTapTitle: (id) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DuaScreen(duaId: id, order: order),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
