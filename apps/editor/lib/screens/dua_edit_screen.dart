import 'dart:convert';

import 'package:drift/drift.dart' show Value, OrderingTerm;
import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/actions.dart';
import '../app/app_state.dart';
import '../widgets/category_chips.dart';
import '../widgets/common.dart';
import '../widgets/elevenlabs_settings.dart';
import '../widgets/review_fields.dart';
import '../widgets/sync_panel.dart';

/// Bir duanın metni, çevirileri, kategorileri ve (sağda) ses/zamanlama paneli.
class DuaEditScreen extends StatefulWidget {
  const DuaEditScreen({
    super.key,
    required this.state,
    required this.duaId,
    this.onOpenDua,
    this.syncPanelBuilder,
  });
  final AppState state;
  final String duaId;
  final void Function(String duaId)? onOpenDua;

  /// Sağ paneli üretir (varsayılan: ses ve zamanlama paneli). Testlerde değiştirilebilir.
  final Widget Function(BuildContext context)? syncPanelBuilder;

  @override
  State<DuaEditScreen> createState() => _DuaEditScreenState();
}

class _DuaEditScreenState extends State<DuaEditScreen> {
  Dua? _dua;
  List<Segment> _segs = [];
  List<Dua> _variants = [];
  PublishCheck? _check;
  List<Track> _ttsTracks = [];
  int? _selectedSegId;
  final _paste = TextEditingController();
  late final SegmentRepo _repo = SegmentRepo(widget.state.db);

  AppState get s => widget.state;
  ContentDatabase get db => s.db;

  /// Yalnızca Türkçe dua: satırın ana metni meaningTr'dedir.
  bool get _tr => _dua?.textLanguage == 'tr';
  String _mainText(Segment seg) => _tr ? (seg.meaningTr ?? '') : seg.textAr;

  @override
  void initState() {
    super.initState();
    s.addListener(_onExternalChange);
    _load();
  }

  @override
  void dispose() {
    s.removeListener(_onExternalChange);
    _paste.dispose();
    super.dispose();
  }

  void _onExternalChange() {
    if (mounted) _load();
  }

  Future<void> _load() async {
    final d = await (db.select(
      db.duas,
    )..where((t) => t.id.equals(widget.duaId))).getSingle();
    final segs = await db.segmentsOf(d.id);
    final variants = await (db.select(
      db.duas,
    )..where((t) => t.variantOf.equals(d.id))).get();
    final check = await checkPublishable(db, d.id);
    final tts =
        await (db.select(db.tracks)
              ..where((t) => t.duaId.equals(d.id))
              ..where((t) => t.source.equals('elevenlabs')))
            .get();
    final order =
        (await (db.select(
              db.duas,
            )..orderBy([(t) => OrderingTerm.asc(t.id)])).get())
            .map((x) => x.id)
            .toList();
    if (!mounted) return;
    setState(() {
      _dua = d;
      _segs = segs;
      _variants = variants;
      _check = check;
      _ttsTracks = tts;
      _order = order;
    });
  }

  Future<void> _changed() async {
    s.changed();
    await _load();
  }

  Future<void> _pasteAndSplit() async {
    if (_segs.isNotEmpty) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          content: const Text(
            'Mevcut satırlar silinip yapıştırılan metinden yeniden oluşturulacak. Devam edilsin mi?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Devam'),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    try {
      await _repo.replaceAllFromText(widget.duaId, _paste.text);
      _paste.clear();
    } on StateError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
    await _changed();
  }

  Future<void> _split(Segment seg) async {
    final main = _mainText(seg);
    final ctl = TextEditingController(text: main);
    final offset = await showDialog<int>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('İmleci bölünecek yere koyun'),
        content: SizedBox(
          width: 700,
          child: TextField(
            controller: ctl,
            readOnly: true,
            autofocus: true,
            showCursor: true,
            maxLines: null,
            textDirection: _tr ? TextDirection.ltr : TextDirection.rtl,
            style: _tr
                ? const TextStyle(fontSize: 20)
                : const TextStyle(fontFamily: 'Amiri', fontSize: 24),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(c, ctl.selection.baseOffset),
            child: const Text('Böl'),
          ),
        ],
      ),
    );
    if (offset == null || offset <= 0 || offset >= main.length) return;
    await _repo.split(seg.id, offset);
    await _changed();
  }

  Future<void> _merge(Segment seg) async {
    await _repo.merge(seg.id);
    await _changed();
  }

  Future<void> _clearDiff() async {
    await (db.update(db.duas)..where((t) => t.id.equals(widget.duaId))).write(
      const DuasCompanion(importDiff: Value(null)),
    );
    await _changed();
  }

  List<String> _order = [];

  String? _neighbor(int delta) {
    final i = _order.indexOf(widget.duaId);
    if (i < 0) return null;
    final j = i + delta;
    return j >= 0 && j < _order.length ? _order[j] : null;
  }

  void _go(String id) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => DuaEditScreen(
        state: s,
        duaId: id,
        onOpenDua: widget.onOpenDua,
        syncPanelBuilder: widget.syncPanelBuilder,
      ),
    ),
  );

  Future<void> _copyArabic() async {
    final text = _segs.map(_mainText).join(' ');
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _tr ? 'Türkçe metin kopyalandı' : 'Arapça metin kopyalandı',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = _dua;
    if (d == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${d.id} — ${d.titleTr}'),
        actions: [
          TextButton.icon(
            key: const ValueKey('copy-arabic'),
            onPressed: _copyArabic,
            icon: const Icon(Icons.copy),
            label: Text(_tr ? 'Metni kopyala' : 'Arapçayı kopyala'),
          ),
          IconButton(
            key: const ValueKey('prev-dua'),
            tooltip: 'Önceki dua',
            onPressed: _neighbor(-1) == null ? null : () => _go(_neighbor(-1)!),
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            key: const ValueKey('next-dua'),
            tooltip: 'Sonraki dua',
            onPressed: _neighbor(1) == null ? null : () => _go(_neighbor(1)!),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _header(d),
                const Divider(),
                ..._segs.map(_segmentCard),
                const SizedBox(height: 12),
                _pasteBox(),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 4,
            child:
                widget.syncPanelBuilder?.call(context) ??
                SyncPanel(state: s, duaId: widget.duaId),
          ),
        ],
      ),
    );
  }

  Widget _header(Dua d) {
    final check = _check;
    final warn =
        d.editorialStatus != null && d.editorialStatus != 'source_identified';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (d.titleAr != null) ArabicText(d.titleAr!, size: 24),
        Text(
          [
            d.titleEn,
            if (d.quranReference != null) 'Kur\'an ${d.quranReference}',
            if (d.hadithGrade != null) 'Hadis: ${d.hadithGrade}',
          ].whereType<String>().join('  ·  '),
        ),
        if (d.variantOf != null)
          TextButton(
            onPressed: () => widget.onOpenDua?.call(d.variantOf!),
            child: Text('Ana dua: ${d.variantOf}'),
          ),
        if (_variants.isNotEmpty)
          Wrap(
            children: [
              const Text('Diğer okunuşlar: '),
              for (final v in _variants)
                TextButton(
                  onPressed: () => widget.onOpenDua?.call(v.id),
                  child: Text('${v.id} (${v.variantKey ?? ''})'),
                ),
            ],
          ),
        if (warn || d.editorialNote != null)
          Card(
            color: Colors.orange.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                [
                  'Durum: ${d.editorialStatus ?? '-'}',
                  if (d.editorialNote != null) d.editorialNote!,
                ].join('\n'),
              ),
            ),
          ),
        if (d.importDiff != null)
          Card(
            color: Colors.red.withValues(alpha: 0.08),
            child: ListTile(
              title: const Text("JSON'da değişiklik var"),
              subtitle: SelectableText(
                const JsonEncoder.withIndent('  ')
                    .convert(jsonDecode(d.importDiff!)),
              ),
              trailing: TextButton(
                onPressed: _clearDiff,
                child: const Text('Gördüm'),
              ),
            ),
          ),
        if (d.recitationCount != null || d.recitationTimeTr != null)
          Text(
            'Okuma: ${[if (d.recitationCount != null) '${d.recitationCount} defa', d.recitationTimeTr].whereType<String>().join(', ')}',
          ),
        for (final (label, v) in [
          ('Hadis', d.hadithTr),
          ('Hadis (EN)', d.hadithEn),
          ('Kıssa', d.storyTr),
          ('Kıssa (EN)', d.storyEn),
        ])
          if (v != null)
            Text('$label: $v', style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 6),
        CategoryChips(db: db, duaId: d.id, onChanged: () => s.changed()),
        _ttsBar(d),
        ..._staleWarnings(),
        if (check != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              check.ok
                  ? 'Yayınlanabilir'
                  : 'Yayınlanamaz: ${check.reasons.join(' · ')}',
              style: TextStyle(color: check.ok ? Colors.green : Colors.red),
            ),
          ),
        const Divider(),
        if (d.srcPronunciationTr != null)
          SelectableText(
            d.srcPronunciationTr!,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        if (d.srcMeaningTr != null) SelectableText(d.srcMeaningTr!),
        if (d.srcMeaningEn != null)
          SelectableText(
            d.srcMeaningEn!,
            style: const TextStyle(color: Colors.black54),
          ),
      ],
    );
  }

  Widget _segmentCard(Segment seg) {
    final selected = seg.id == _selectedSegId;
    final idx = _segs.indexOf(seg);
    return Card(
      key: ValueKey('seg-$idx'),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedSegId = selected ? null : seg.id),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text('${idx + 1}'),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Böl',
                    icon: const Icon(Icons.content_cut, size: 18),
                    onPressed: () => _split(seg),
                  ),
                  if (idx < _segs.length - 1)
                    IconButton(
                      tooltip: 'Alttakiyle birleştir',
                      icon: const Icon(Icons.merge, size: 18),
                      onPressed: () => _merge(seg),
                    ),
                  if (idx > 0)
                    IconButton(
                      tooltip: 'Yukarı',
                      icon: const Icon(Icons.arrow_upward, size: 18),
                      onPressed: () async {
                        await _repo.move(seg.id, idx - 1);
                        await _changed();
                      },
                    ),
                ],
              ),
              if (_tr)
                Text(seg.meaningTr ?? '', style: const TextStyle(fontSize: 20))
              else
                ArabicText(seg.textAr),
              if (seg.pronunciationTr != null)
                Text(
                  seg.pronunciationTr!,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              if (!_tr && seg.meaningTr != null) Text(seg.meaningTr!),
              if (seg.meaningEn != null)
                Text(
                  seg.meaningEn!,
                  style: const TextStyle(color: Colors.black54),
                ),
              if (selected) ...[
                const Divider(),
                ReviewFields(segment: seg, repo: _repo, onChanged: _changed),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// "Ses üret: [Arapça] [Türkçe] [İngilizce]"; uygun değilse pasif + ipucu.
  Widget _ttsBar(Dua d) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('Ses üret (ElevenLabs):'),
        for (final l in ttsLanguages)
          Tooltip(
            message:
                _ttsBlocker(d, l) ??
                '${ttsLangNames[l]} sesi üret (satır işaretleri kendiliğinden yerleşir)',
            child: OutlinedButton(
              key: ValueKey('tts-$l'),
              onPressed: _ttsBlocker(d, l) != null
                  ? null
                  : () => generateTtsAction(context, s, [d.id], l),
              child: Text(ttsLangNames[l]!),
            ),
          ),
      ],
    ),
  );

  /// Bu dilde üretim neden yapılamaz (yapılabiliyorsa null).
  String? _ttsBlocker(Dua d, String lang) {
    if (lang == 'ar' && d.textLanguage == 'tr') {
      return 'Yalnızca Türkçe duada Arapça ses üretilmez';
    }
    if (_segs.isEmpty) return 'Satır yok';
    final missing = _segs.where((x) {
      final t = switch (lang) {
        'ar' => x.textAr,
        'tr' => x.meaningTr,
        _ => x.meaningEn,
      };
      return (t ?? '').trim().isEmpty;
    }).length;
    return missing == 0
        ? null
        : '$missing satırın ${ttsLangNames[lang]} metni yok';
  }

  /// ElevenLabs kaydı üretildiğinden beri metin değiştiyse uyarı (yayını engellemez).
  List<Widget> _staleWarnings() => [
    for (final t in _ttsTracks)
      if (_isStale(t))
        Card(
          color: Colors.deepOrange.withValues(alpha: 0.1),
          child: ListTile(
            leading: const Icon(Icons.sync_problem, color: Colors.deepOrange),
            title: Text(
              '${ttsLangNames[t.language] ?? t.language} metin değişti — sesi yeniden üret',
            ),
            subtitle: Text(
              '"${t.label}" eski metinle üretildi; satır işaretleri kaymış olabilir.',
            ),
            trailing: TextButton(
              onPressed: () =>
                  generateTtsAction(context, s, [widget.duaId], t.language),
              child: const Text('Yeniden üret'),
            ),
          ),
        ),
  ];

  bool _isStale(Track t) {
    final cur = buildTtsText(_segs, t.language);
    return cur == null || ttsHash(cur) != t.textHash;
  }

  Widget _pasteBox() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(
        controller: _paste,
        maxLines: 5,
        textDirection: _tr ? TextDirection.ltr : TextDirection.rtl,
        style: _tr
            ? const TextStyle(fontSize: 18)
            : const TextStyle(fontFamily: 'Amiri', fontSize: 20),
        decoration: InputDecoration(
          labelText: _tr
              ? 'Türkçe metin yapıştır (cümle sonları ve boş satırlardan bölünür)'
              : 'Arapça metin yapıştır (noktalama ve boş satırlardan bölünür)',
          border: const OutlineInputBorder(),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: _pasteAndSplit,
          icon: const Icon(Icons.splitscreen),
          label: const Text('Satırlara böl'),
        ),
      ),
    ],
  );
}
