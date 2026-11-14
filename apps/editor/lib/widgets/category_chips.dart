import 'package:drift/drift.dart' hide Column;
import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

/// Duanın kategorilerini çoklu seçimle düzenler (bir dua birden fazla kategoride olabilir).
class CategoryChips extends StatefulWidget {
  const CategoryChips({
    super.key,
    required this.db,
    required this.duaId,
    this.onChanged,
  });
  final ContentDatabase db;
  final String duaId;
  final VoidCallback? onChanged;

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  List<Category> _all = [];
  Set<int> _selected = {};
  bool _editing = false;

  ContentDatabase get db => widget.db;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await (db.select(
      db.categories,
    )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    final sel =
        (await (db.select(
              db.duaCategories,
            )..where((t) => t.duaId.equals(widget.duaId))).get())
            .map((l) => l.categoryId)
            .toSet();
    if (mounted) {
      setState(() {
        _all = all;
        _selected = sel;
      });
    }
  }

  Future<void> _toggle(Category c, bool on) async {
    if (on) {
      await db
          .into(db.duaCategories)
          .insertOnConflictUpdate(
            DuaCategoriesCompanion.insert(
              duaId: widget.duaId,
              categoryId: c.id,
            ),
          );
    } else {
      await (db.delete(db.duaCategories)..where(
            (t) => t.duaId.equals(widget.duaId) & t.categoryId.equals(c.id),
          ))
          .go();
    }
    await _load();
    widget.onChanged?.call();
  }

  Future<void> _addCategory() async {
    final ctl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Yeni kategori'),
        content: TextField(
          controller: ctl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Ad (Türkçe)'),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(c, ctl.text.trim()),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    final id = await db.ensureCategory(name);
    await _toggle(
      _all.firstWhere(
        (c) => c.id == id,
        orElse: () => Category(id: id, nameTr: name, sortOrder: 999),
      ),
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shown = _editing
        ? _all
        : _all.where((c) => _selected.contains(c.id)).toList();
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final c in shown)
          FilterChip(
            key: ValueKey('cat-${c.nameTr}'),
            label: Text(c.nameTr),
            selected: _selected.contains(c.id),
            onSelected: _editing ? (on) => _toggle(c, on) : null,
          ),
        if (_editing)
          ActionChip(
            avatar: const Icon(Icons.add, size: 16),
            label: const Text('Yeni'),
            onPressed: _addCategory,
          ),
        IconButton(
          tooltip: _editing ? 'Bitti' : 'Kategorileri düzenle',
          icon: Icon(_editing ? Icons.check : Icons.edit, size: 18),
          onPressed: () => setState(() => _editing = !_editing),
        ),
      ],
    );
  }
}
