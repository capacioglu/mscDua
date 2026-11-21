import 'package:drift/drift.dart' show Value, OrderingTerm;
import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/actions.dart';
import '../app/app_state.dart';
import '../widgets/common.dart';
import '../widgets/elevenlabs_settings.dart';

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
  String? _catFilter;
  String? _groupFilter;
  TimingProgress? _progressFilter;
  String? _kindFilter;
  String? _audioFilter;

  /// "Filtreleri temizle" açılır listeleri sıfırlasın diye artar.
  int _filterGen = 0;

  static const _kinds = {
    'ar': 'Arapça dualar',
    'tr': 'Yalnızca Türkçe dualar',
    'ar-tr': 'Arapça · Türkçe anlamlı',
    'ar-en': 'Arapça · İngilizce anlamlı',
    'ar-tr-en': 'Arapça · Türkçe + İngilizce anlamlı',
    'no-meaning': 'Satır anlamı eksik',
  };

  static const _audios = {
    'ar': 'Arapça sesi var',
    'tr': 'Türkçe sesi var',
    'en': 'İngilizce sesi var',
    'none': 'Hiç sesi yok',
    'stale': 'Metin değişti (yeniden üret)',
  };

  static bool _kindMatches(String k, DuaSummary d) => switch (k) {
    'ar' => !d.turkishOnly,
    'tr' => d.turkishOnly,
    'ar-tr' => !d.turkishOnly && d.hasMeaningTr,
    'ar-en' => !d.turkishOnly && d.hasMeaningEn,
    'ar-tr-en' => !d.turkishOnly && d.hasMeaningTr && d.hasMeaningEn,
    'no-meaning' => !d.turkishOnly && !d.hasMeaningTr,
    _ => true,
  };

  static bool _audioMatches(String k, DuaSummary d) => switch (k) {
    'none' => d.trackCount == 0,
    'stale' => d.staleTts,
    _ =>
      (d.timingByLang[k] ?? TimingProgress.noAudio) != TimingProgress.noAudio,
  };

  bool get _anyFilter =>
      _catFilter != null ||
      _groupFilter != null ||
      _progressFilter != null ||
      _kindFilter != null ||
      _audioFilter != null;
  String _query = '';

  /// Çoklu seçim (Ctrl/Shift + tık); sağ tık menüsü seçime uygulanır.
  final Set<String> _selected = {};
  String? _anchor;

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
      if (_catFilter != null && !d.categories.contains(_catFilter)) {
        return false;
      }
      if (_kindFilter != null && !_kindMatches(_kindFilter!, d)) {
        return false;
      }
      if (_audioFilter != null && !_audioMatches(_audioFilter!, d)) {
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
    var turkishOnly = false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Yeni dua'),
        content: StatefulBuilder(
          builder: (c, setLocal) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idCtl,
                decoration: const InputDecoration(labelText: 'Kimlik'),
              ),
              TextField(
                key: const ValueKey('new-dua-title'),
                controller: titleCtl,
                decoration: const InputDecoration(labelText: 'Başlık (Türkçe)'),
              ),
              CheckboxListTile(
                key: const ValueKey('new-dua-tr'),
                contentPadding: EdgeInsets.zero,
                value: turkishOnly,
                onChanged: (v) => setLocal(() => turkishOnly = v ?? false),
                title: const Text('Yalnızca Türkçe'),
                subtitle: const Text(
                  'Arapçası yok; metin Türkçe yazılır ve Türkçe seslendirilir.',
                ),
              ),
            ],
          ),
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
            textLanguage: Value(turkishOnly ? 'tr' : 'ar'),
          ),
        );
    s.changed();
    widget.onOpenDua?.call(idCtl.text.trim());
  }

  void _tap(DuaSummary d, List<DuaSummary> visible) {
    final kb = HardwareKeyboard.instance;
    if (kb.isControlPressed) {
      setState(() {
        if (!_selected.remove(d.id)) _selected.add(d.id);
        _anchor = d.id;
      });
    } else if (kb.isShiftPressed && _anchor != null) {
      final ids = visible.map((x) => x.id).toList();
      final a = ids.indexOf(_anchor!), b = ids.indexOf(d.id);
      if (a < 0 || b < 0) return;
      setState(
        () => _selected
          ..clear()
          ..addAll(ids.sublist(a < b ? a : b, (a < b ? b : a) + 1)),
      );
    } else {
      setState(() {
        _selected.clear();
        _anchor = d.id;
      });
      widget.onOpenDua?.call(d.id);
    }
  }

  /// Seçili kimlikler, listedeki sırasıyla.
  List<String> get _selectedInOrder => [
    for (final d in _all)
      if (_selected.contains(d.id)) d.id,
  ];

  Future<void> _contextMenu(DuaSummary d, Offset at) async {
    if (!_selected.contains(d.id)) {
      setState(() {
        _selected
          ..clear()
          ..add(d.id);
        _anchor = d.id;
      });
    }
    final n = _selected.length;
    final pick = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(at.dx, at.dy, at.dx, at.dy),
      items: [
        for (final l in ttsLanguages)
          PopupMenuItem(value: l, child: Text('${ttsLangNames[l]} sesi üret')),
        if (n == 1) const PopupMenuDivider(),
        if (n == 1) const PopupMenuItem(value: 'open', child: Text('Aç')),
      ],
    );
    if (pick == null || !mounted) return;
    if (pick == 'open') {
      widget.onOpenDua?.call(d.id);
    } else {
      await generateTtsAction(context, s, _selectedInOrder, pick);
    }
  }

  Widget _selectionBar() => Material(
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Row(
        children: [
          Text('${_selected.length} dua seçili'),
          const SizedBox(width: 16),
          const Text('Ses üret:'),
          for (final l in ttsLanguages)
            TextButton(
              key: ValueKey('bulk-tts-$l'),
              onPressed: () =>
                  generateTtsAction(context, s, _selectedInOrder, l),
              child: Text(ttsLangNames[l]!),
            ),
          const Spacer(),
          TextButton(
            onPressed: () => setState(_selected.clear),
            child: const Text('Seçimi temizle'),
          ),
        ],
      ),
    ),
  );

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
          if (_selected.isNotEmpty) _selectionBar(),
          Expanded(
            child: Row(
              children: [
                SizedBox(width: 300, child: _filters()),
                const VerticalDivider(width: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: visible.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) => _row(visible[i], visible),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Küçük yazılı, kenarlıklı açılır liste; ilk seçenek "Hepsi".
  Widget _combo<T>({
    required String id,
    required String label,
    required T? value,
    required Map<T, String> items,
    required ValueChanged<T?> onChanged,
  }) {
    final style = TextStyle(
      fontSize: 13,
      color: Theme.of(context).colorScheme.onSurface,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<T?>(
        key: ValueKey('filter-$id'),
        initialValue: value,
        isDense: true,
        isExpanded: true,
        style: style,
        iconSize: 20,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          isDense: true,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
        ),
        items: [
          DropdownMenuItem<T?>(value: null, child: Text('Hepsi', style: style)),
          for (final e in items.entries)
            DropdownMenuItem<T?>(
              value: e.key,
              child: Text(
                e.value,
                style: style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }

  String _withCount(String label, bool Function(DuaSummary) f) =>
      '$label (${_all.where(f).length})';

  Widget _filters() => ListView(
    padding: const EdgeInsets.all(12),
    children: [
      TextField(
        key: const ValueKey('search'),
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, size: 18),
          hintText: 'Ara (başlık, kimlik)',
          hintStyle: TextStyle(fontSize: 13),
          isDense: true,
          border: OutlineInputBorder(),
        ),
        onChanged: (v) => setState(() => _query = v),
      ),
      const SizedBox(height: 12),
      KeyedSubtree(
        key: ValueKey('filters-$_filterGen'),
        child: Column(
          children: [
            _combo<String>(
              id: 'kind',
              label: 'Dua dili',
              value: _kindFilter,
              items: {
                for (final e in _kinds.entries)
                  e.key: _withCount(e.value, (d) => _kindMatches(e.key, d)),
              },
              onChanged: (v) => setState(() => _kindFilter = v),
            ),
            _combo<String>(
              id: 'category',
              label: 'Kategori',
              value: _catFilter,
              items: {
                for (final c in _categories)
                  c.nameTr: _withCount(
                    c.nameTr,
                    (d) => d.categories.contains(c.nameTr),
                  ),
              },
              onChanged: (v) => setState(() => _catFilter = v),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _combo<String>(
                    id: 'group',
                    label: 'Grup',
                    value: _groupFilter,
                    items: {for (final g in _groups) g.id: g.titleTr},
                    onChanged: (v) => setState(() => _groupFilter = v),
                  ),
                ),
                if (_groupFilter != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.open_in_new, size: 18),
                    tooltip: 'Grubu aç',
                    onPressed: () => widget.onOpenGroup?.call(_groupFilter!),
                  ),
              ],
            ),
            _combo<String>(
              id: 'audio',
              label: 'Ses',
              value: _audioFilter,
              items: {
                for (final e in _audios.entries)
                  e.key: _withCount(e.value, (d) => _audioMatches(e.key, d)),
              },
              onChanged: (v) => setState(() => _audioFilter = v),
            ),
            _combo<TimingProgress>(
              id: 'timing',
              label: 'Zamanlama',
              value: _progressFilter,
              items: {for (final p in TimingProgress.values) p: timingLabel(p)},
              onChanged: (v) => setState(() => _progressFilter = v),
            ),
          ],
        ),
      ),
      if (_anyFilter)
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            key: const ValueKey('filter-clear'),
            onPressed: () => setState(() {
              _catFilter = _groupFilter = _kindFilter = _audioFilter = null;
              _progressFilter = null;
              _filterGen++;
            }),
            icon: const Icon(Icons.filter_alt_off, size: 16),
            label: const Text(
              'Filtreleri temizle',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
    ],
  );

  Widget _row(DuaSummary d, List<DuaSummary> visible) => GestureDetector(
    onSecondaryTapUp: (e) => _contextMenu(d, e.globalPosition),
    child: _tile(d, visible),
  );

  static String _sym(TimingProgress t) => switch (t) {
    TimingProgress.ready => '✓',
    TimingProgress.partial => '◐',
    TimingProgress.untimed => '○',
    TimingProgress.noAudio => '–',
  };

  Widget _tile(DuaSummary d, List<DuaSummary> visible) => ListTile(
    key: ValueKey('row-${d.id}'),
    selected: _selected.contains(d.id),
    onTap: () => _tap(d, visible),
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
        if (d.dua.textLanguage == 'tr')
          const Padding(
            padding: EdgeInsets.only(right: 6),
            child: Tooltip(
              message: 'Yalnızca Türkçe dua',
              child: Icon(Icons.translate, size: 16),
            ),
          ),
        Expanded(child: Text(d.titleTr)),
        if (d.staleTts)
          const Tooltip(
            message: 'Metin değişti — ElevenLabs sesini yeniden üret',
            child: Icon(Icons.sync_problem, color: Colors.deepOrange),
          ),
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
        Tooltip(
          message: '✓ tam zamanlı · ◐ kısmen · ○ zamanlanmamış · – ses yok',
          child: Text(
            [
              for (final l in ttsLanguages)
                if (!(l == 'ar' && d.dua.textLanguage == 'tr'))
                  '${l.toUpperCase()} ${_sym(d.timingByLang[l] ?? TimingProgress.noAudio)}',
            ].join(' · '),
            key: ValueKey('lang-${d.id}'),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        TimingChip(d.timing),
      ],
    ),
  );
}
