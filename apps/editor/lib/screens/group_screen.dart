import 'dart:convert';

import 'package:drift/drift.dart' show Value, OrderingTerm;
import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../widgets/common.dart';
import '../widgets/sync_panel.dart';

/// Grup: bilgiler, sıralı üyeler (sürükle-bırak) ve grubun uzun kayıtları.
class GroupScreen extends StatefulWidget {
  const GroupScreen({
    super.key,
    required this.state,
    required this.groupId,
    this.onOpenDua,
  });
  final AppState state;
  final String groupId;
  final void Function(String duaId)? onOpenDua;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  DuaGroup? _group;
  List<(GroupItem, Dua)> _items = [];

  AppState get s => widget.state;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = s.db;
    final g = await (db.select(
      db.groups,
    )..where((t) => t.id.equals(widget.groupId))).getSingle();
    final items =
        await (db.select(db.groupItems)
              ..where((t) => t.groupId.equals(widget.groupId))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    final out = <(GroupItem, Dua)>[];
    for (final i in items) {
      out.add((
        i,
        await (db.select(
          db.duas,
        )..where((t) => t.id.equals(i.duaId))).getSingle(),
      ));
    }
    if (mounted) {
      setState(() {
        _group = g;
        _items = out;
      });
    }
  }

  Future<void> _reorder(int oldIndex, int newIndex) async {
    final list = [..._items];
    final moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);
    await s.db.transaction(() async {
      for (var i = 0; i < list.length; i++) {
        await (s.db.update(s.db.groupItems)
              ..where((t) => t.id.equals(list[i].$1.id)))
            .write(GroupItemsCompanion(position: Value(i + 1)));
      }
    });
    s.changed();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final g = _group;
    if (g == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final info = g.infoJson == null
        ? null
        : const JsonEncoder.withIndent('  ').convert(jsonDecode(g.infoJson!));
    return Scaffold(
      appBar: AppBar(title: Text('${g.id} — ${g.titleTr}')),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 420,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (g.titleAr != null) ArabicText(g.titleAr!, size: 28),
                if (g.titleEn != null) Text(g.titleEn!),
                if (g.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(g.description!),
                  ),
                if (info != null)
                  ExpansionTile(
                    title: const Text('Kaynak bilgisi'),
                    children: [SelectableText(info)],
                  ),
                const SizedBox(height: 8),
                Text(
                  'Üyeler (${_items.length}) — sürükleyerek sıralayın',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(
                  height: 520,
                  child: ReorderableListView(
                    onReorderItem: _reorder,
                    children: [
                      for (final (i, d) in _items)
                        ListTile(
                          key: ValueKey(i.id),
                          dense: true,
                          leading: Text('${i.position ?? '–'}'),
                          title: Text(d.titleTr),
                          subtitle: Text(
                            [
                              d.id,
                              if (i.repeatCount > 1) '×${i.repeatCount}',
                            ].join('  '),
                          ),
                          onTap: () => widget.onOpenDua?.call(d.id),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: SyncPanel(state: s, groupId: g.id),
          ),
        ],
      ),
    );
  }
}
