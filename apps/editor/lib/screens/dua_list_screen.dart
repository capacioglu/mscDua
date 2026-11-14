import 'package:drift/drift.dart' show Value, OrderingTerm;
import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app/actions.dart';
import '../app/app_state.dart';
import '../widgets/common.dart';

/// Ana ekran: dualar, filtreler ve içerik eylemleri.
class DuaListScreen extends StatefulWidget {
  const DuaListScreen({
    super.key,
    required this.state,
    this.onOpenDua,
    this.onOpenGroup,
    this.onSettings,
  });
  final AppState state;
  final void Function(String duaId)? onOpenDua;
  final void Function(String groupId)? onOpenGroup;
  final VoidCallback? onSettings;

  @override
  State<DuaListScreen> createState() => _DuaListScreenState();
}

class _DuaListScreenState extends State<DuaListScreen> {
  List<DuaSummary> _all = [];
  List<Category> _categories = [];
  List<DuaGroup> _groups = [];
  final Set<String> _catFilter = {};
  String? _groupFilter;
  TimingProgress? _progressFilter;
  String _query = '';

  AppState get s => widget.state;

  @override
  void initState() {
    super.initState();
    s.addListener(_load);
    _load();
  }

  @override
  void dispose() {
    s.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final all = await listDuaSummaries(s.db);
    final cats = await (s.db.select(
      s.db.categories,
    )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    final groups = await (s.db.select(
      s.db.groups,
    )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    if (!mounted) return;
    setState(() {
      _all = all;
      _categories = cats;
      _groups = groups;
    });
  }

  List<DuaSummary> get _visible {
    final q = trLower(_query.trim());
    return _all.where((d) {
      if (_catFilter.isNotEmpty && !_catFilter.every(d.categories.contains)) {
        return false;
      }
      if (_groupFilter != null && !d.groupIds.contains(_groupFilter)) {
        return false;
      }
      if (_progressFilter != null && d.timing != _progressFilter) {
        return false;
      }
      if (q.isNotEmpty &&
          !trLower('${d.id} ${d.titleTr} ${d.dua.titleEn ?? ''}').contains(q)) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _newDua() async {
    final ids = _all
        .map((d) => RegExp(r'^DUA-(\d{4})$').firstMatch(d.id)?.group(1))
        .whereType<String>();
    final next = (ids.map(int.parse).fold<int>(0, (a, b) => a > b ? a : b) + 1)
        .toString()
        .padLeft(4, '0');
    final idCtl = TextEditingController(text: 'DUA-$next');
    final titleCtl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Yeni dua'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idCtl,
              decoration: const InputDecoration(labelText: 'Kimlik'),
            ),
            TextField(
              controller: titleCtl,
              decoration: const InputDecoration(labelText: 'Başlık (Türkçe)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
    if (ok != true || titleCtl.text.trim().isEmpty) return;
    await s.db
        .into(s.db.duas)
        .insert(
          DuasCompanion.insert(
            id: idCtl.text.trim(),
            titleTr: titleCtl.text.trim(),
            expectedAudioFile: Value(expectedAudioFileFor(idCtl.text.trim())),
          ),
        );
    s.changed();
    widget.onOpenDua?.call(idCtl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dualarım Editörü — ${_all.length} kayıt'),
        actions: [
          IconButton(
            onPressed: widget.onSettings,
            icon: const Icon(Icons.settings),
            tooltip: 'Ayarlar',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                TextButton.icon(
                  onPressed: _newDua,
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni dua'),
                ),
                TextButton.icon(
                  onPressed: () => importArchiveAction(context, s),
                  icon: const Icon(Icons.file_download),
                  label: const Text("JSON'u yeniden yükle"),
                ),
                TextButton.icon(
                  onPressed: () => matchAudioAction(context, s),
                  icon: const Icon(Icons.library_music),
                  label: const Text('Sesleri eşleştir'),
                ),
                TextButton.icon(
                  onPressed: () => publishAction(context, s),
                  icon: const Icon(Icons.publish),
                  label: const Text('Mobil için yayınla'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                SizedBox(width: 300, child: _filters()),
                const VerticalDivider(width: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: visible.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) => _row(visible[i]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filters() => ListView(
    padding: const EdgeInsets.all(12),
    children: [
      TextField(
        key: const ValueKey('search'),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Ara (başlık, kimlik)',
        ),
        onChanged: (v) => setState(() => _query = v),
      ),
      const SizedBox(height: 12),
      DropdownButton<TimingProgress?>(
        isExpanded: true,
        value: _progressFilter,
        hint: const Text('Durum: hepsi'),
        items: [
          const DropdownMenuItem(value: null, child: Text('Durum: hepsi')),
          for (final p in TimingProgress.values)
            DropdownMenuItem(value: p, child: Text(timingLabel(p))),
        ],
        onChanged: (v) => setState(() => _progressFilter = v),
      ),
      const SizedBox(height: 12),
      Text('Gruplar', style: Theme.of(context).textTheme.titleSmall),
      RadioGroup<String?>(
        groupValue: _groupFilter,
        onChanged: (v) => setState(() => _groupFilter = v),
        child: Column(
          children: [
            const RadioListTile<String?>(
              dense: true,
              value: null,
              title: Text('Hepsi'),
            ),
            for (final g in _groups)
              RadioListTile<String?>(
                dense: true,
                value: g.id,
                title: Text(g.titleTr),
                secondary: IconButton(
                  icon: const Icon(Icons.open_in_new, size: 18),
                  tooltip: 'Grubu aç',
                  onPressed: () => widget.onOpenGroup?.call(g.id),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Text('Kategoriler', style: Theme.of(context).textTheme.titleSmall),
      Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final c in _categories)
            FilterChip(
              key: ValueKey('filter-cat-${c.nameTr}'),
              label: Text(c.nameTr),
              selected: _catFilter.contains(c.nameTr),
              onSelected: (on) => setState(
                () =>
                    on ? _catFilter.add(c.nameTr) : _catFilter.remove(c.nameTr),
              ),
            ),
        ],
      ),
    ],
  );

  Widget _row(DuaSummary d) => ListTile(
    key: ValueKey('row-${d.id}'),
    onTap: () => widget.onOpenDua?.call(d.id),
    leading: SizedBox(
      width: 110,
      child: Text(d.id, style: const TextStyle(fontFeatures: [])),
    ),
    title: Row(
      children: [
        if (d.variantOf != null)
          const Padding(
            padding: EdgeInsets.only(right: 6),
            child: Icon(Icons.call_split, size: 16),
          ),
        Expanded(child: Text(d.titleTr)),
        if (d.hasWarning)
          const Tooltip(
            message: 'Doğrulanmamış kaynak veya JSON farkı',
            child: Icon(Icons.warning_amber, color: Colors.orange),
          ),
      ],
    ),
    subtitle: Text(
      [
        d.categories.join(', '),
        if (d.groupIds.isNotEmpty) 'Gruplar: ${d.groupIds.join(', ')}',
        '${d.segmentCount} satır, ${d.trackCount} kayıt',
      ].where((x) => x.isNotEmpty).join('  ·  '),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (d.dua.readyToPublish)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.verified, color: Colors.green),
          ),
        TimingChip(d.timing),
      ],
    ),
  );
}
