import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

String sourceLabel(FieldSource? s) => switch (s) {
  FieldSource.imported => 'İçe aktarım',
  FieldSource.claude => 'Claude',
  FieldSource.user => 'Siz',
  null => '—',
};

String reviewLabel(ReviewStatus r) => switch (r) {
  ReviewStatus.none => 'Çeviri yok',
  ReviewStatus.review => 'Gözden geçirilecek',
  ReviewStatus.approved => 'Onaylı',
};

Color reviewColor(ReviewStatus r) => switch (r) {
  ReviewStatus.none => Colors.orange,
  ReviewStatus.review => Colors.blue,
  ReviewStatus.approved => Colors.green,
};

/// Seçili satırın Arapçası ve dört çeviri alanı; kaydet / onayla.
class ReviewFields extends StatefulWidget {
  const ReviewFields({
    super.key,
    required this.segment,
    required this.repo,
    required this.onChanged,
  });
  final Segment segment;
  final SegmentRepo repo;
  final VoidCallback onChanged;

  @override
  State<ReviewFields> createState() => _ReviewFieldsState();
}

class _ReviewFieldsState extends State<ReviewFields> {
  late final TextEditingController _ar;
  late final Map<SegmentField, TextEditingController> _ctl;

  Segment get seg => widget.segment;

  String? _value(SegmentField f) => switch (f) {
    SegmentField.pronunciationTr => seg.pronunciationTr,
    SegmentField.pronunciationEn => seg.pronunciationEn,
    SegmentField.meaningTr => seg.meaningTr,
    SegmentField.meaningEn => seg.meaningEn,
  };

  FieldSource? _source(SegmentField f) => switch (f) {
    SegmentField.pronunciationTr => seg.pronunciationTrSource,
    SegmentField.pronunciationEn => seg.pronunciationEnSource,
    SegmentField.meaningTr => seg.meaningTrSource,
    SegmentField.meaningEn => seg.meaningEnSource,
  };

  static const _labels = {
    SegmentField.pronunciationTr: 'Türkçe okunuş *',
    SegmentField.pronunciationEn: 'İngilizce okunuş',
    SegmentField.meaningTr: 'Türkçe anlam *',
    SegmentField.meaningEn: 'İngilizce anlam *',
  };

  @override
  void initState() {
    super.initState();
    _ar = TextEditingController(text: seg.textAr);
    _ar.addListener(_onEdit);
    _ctl = {
      for (final f in SegmentField.values)
        f: TextEditingController(text: _value(f) ?? ''),
    };
    for (final c in _ctl.values) {
      c.addListener(_onEdit);
    }
  }

  void _onEdit() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant ReviewFields old) {
    super.didUpdateWidget(old);
    if (old.segment != widget.segment) {
      _ar.text = seg.textAr;
      for (final f in SegmentField.values) {
        _ctl[f]!.text = _value(f) ?? '';
      }
    }
  }

  @override
  void dispose() {
    _ar.dispose();
    for (final c in _ctl.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _dirty =>
      SegmentField.values.any((f) => _ctl[f]!.text.trim() != (_value(f) ?? ''));

  /// Alanlardaki kaydedilmemiş değişiklikleri yazar (bildirim göndermeden).
  Future<void> _persistFields() async {
    for (final f in SegmentField.values) {
      final now = _ctl[f]!.text.trim();
      if (now != (_value(f) ?? '')) {
        await widget.repo.updateField(seg.id, f, now);
      }
    }
  }

  Future<void> _saveFields() async {
    await _persistFields();
    widget.onChanged();
  }

  Future<void> _saveArabic() async {
    await _persistFields();
    await widget.repo.updateArabic(seg.id, _ar.text);
    widget.onChanged();
  }

  /// Ekranda görüneni onaylar: önce alanları kaydeder, sonra onaylar.
  Future<void> _approve() async {
    await _persistFields();
    final db = widget.repo.db;
    final fresh = await (db.select(
      db.segments,
    )..where((t) => t.id.equals(seg.id))).getSingle();
    if (canApprove(fresh)) {
      await widget.repo.approve(seg.id);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Eksik alan var; onaylanmadı.')),
      );
    }
    widget.onChanged();
  }

  String _text(SegmentField f) => _ctl[f]!.text.trim();

  List<String> get _missing => [
    if (_text(SegmentField.pronunciationTr).isEmpty) 'Türkçe okunuş',
    if (_text(SegmentField.meaningTr).isEmpty) 'Türkçe anlam',
    if (_text(SegmentField.meaningEn).isEmpty) 'İngilizce anlam',
  ];

  @override
  Widget build(BuildContext context) {
    final can =
        _missing.isEmpty &&
        _ar.text.trim().isNotEmpty &&
        (seg.review != ReviewStatus.approved || _dirty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const ValueKey('field-arabic'),
                controller: _ar,
                textDirection: TextDirection.rtl,
                maxLines: null,
                style: const TextStyle(fontFamily: 'Amiri', fontSize: 22),
                decoration: const InputDecoration(
                  labelText: 'Arapça (değişirse onay kalkar)',
                ),
              ),
            ),
            TextButton(
              key: const ValueKey('save-arabic'),
              onPressed: _saveArabic,
              child: const Text('Arapçayı kaydet'),
            ),
          ],
        ),
        for (final f in SegmentField.values)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: TextField(
              key: ValueKey('field-${f.name}'),
              controller: _ctl[f],
              maxLines: null,
              decoration: InputDecoration(
                labelText: _labels[f],
                helperText: 'Kaynak: ${sourceLabel(_source(f))}',
              ),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            OutlinedButton(
              key: const ValueKey('save-fields'),
              onPressed: _saveFields,
              child: const Text('Çevirileri kaydet'),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: _missing.isEmpty ? '' : 'Eksik: ${_missing.join(', ')}',
              child: FilledButton(
                key: const ValueKey('approve'),
                onPressed: can ? _approve : null,
                child: const Text('Onayla'),
              ),
            ),
            if (seg.review == ReviewStatus.approved) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () async {
                  await widget.repo.unapprove(seg.id);
                  widget.onChanged();
                },
                child: const Text('Onayı kaldır'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
