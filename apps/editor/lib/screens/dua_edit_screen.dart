import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../widgets/category_chips.dart';
import '../widgets/common.dart';
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
  int? _selectedSegId;
  final _paste = TextEditingController();
  late final SegmentRepo _repo = SegmentRepo(widget.state.db);

  AppState get s => widget.state;
  ContentDatabase get db => s.db;

  @override
  void initState() {
    super.initState();
    _load();
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
    if (!mounted) return;
    setState(() {
      _dua = d;
      _segs = segs;
      _variants = variants;
      _check = check;
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
    final ctl = TextEditingController(text: seg.textAr);
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
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Amiri', fontSize: 24),
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
    if (offset == null || offset <= 0 || offset >= seg.textAr.length) return;
    await _repo.split(seg.id, offset);
    await _changed();
  }

  Future<void> _merge(Segment seg) async {
    await _repo.merge(seg.id);
    await _changed();
  }

  Future<void> _setReady(bool v) async {
    await (db.update(db.duas)..where((t) => t.id.equals(widget.duaId))).write(
      DuasCompanion(readyToPublish: Value(v)),
    );
    await _changed();
  }

  Future<void> _clearDiff() async {
    await (db.update(db.duas)..where((t) => t.id.equals(widget.duaId))).write(
      const DuasCompanion(importDiff: Value(null)),
    );
    await _changed();
  }

  @override
  Widget build(BuildContext context) {
    final d = _dua;
    if (d == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text('${d.id} — ${d.titleTr}')),
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
        const SizedBox(height: 6),
        CategoryChips(db: db, duaId: d.id, onChanged: () => s.changed()),
        SwitchListTile(
          dense: true,
          title: const Text('Yayına hazır'),
          value: d.readyToPublish,
          onChanged: _setReady,
          subtitle: check == null
              ? null
              : Text(
                  check.ok ? 'Yayınlanabilir' : check.reasons.join(' · '),
                  style: TextStyle(color: check.ok ? Colors.green : Colors.red),
                ),
        ),
        ExpansionTile(
          title: const Text("JSON'daki dua bazlı okunuş ve anlamlar"),
          children: [
            for (final (label, v) in [
              ('Türkçe okunuş', d.srcPronunciationTr),
              ('İngilizce okunuş', d.srcPronunciationEn),
              ('Türkçe anlam', d.srcMeaningTr),
              ('İngilizce anlam', d.srcMeaningEn),
            ])
              if (v != null)
                ListTile(
                  dense: true,
                  title: Text(label),
                  subtitle: SelectableText(v),
                ),
          ],
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
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: reviewColor(seg.review).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      reviewLabel(seg.review),
                      style: TextStyle(
                        color: reviewColor(seg.review),
                        fontSize: 12,
                      ),
                    ),
                  ),
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
              ArabicText(seg.textAr),
              if (seg.pronunciationTr != null)
                Text(
                  seg.pronunciationTr!,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              if (seg.meaningTr != null) Text(seg.meaningTr!),
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

  Widget _pasteBox() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(
        controller: _paste,
        maxLines: 5,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontFamily: 'Amiri', fontSize: 20),
        decoration: const InputDecoration(
          labelText:
              'Arapça metin yapıştır (noktalama ve boş satırlardan bölünür)',
          border: OutlineInputBorder(),
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
