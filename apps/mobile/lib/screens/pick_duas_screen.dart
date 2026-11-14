import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';

/// Çoklu seçimle dua seçer; seçilen kimlikleri seçim sırasıyla döner.
class PickDuasScreen extends StatefulWidget {
  const PickDuasScreen({super.key});

  @override
  State<PickDuasScreen> createState() => _PickDuasScreenState();
}

class _PickDuasScreenState extends State<PickDuasScreen> {
  List<Dua> _all = [];
  List<Dua> _shown = [];
  final List<String> _picked = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_all.isEmpty) _load();
  }

  Future<void> _load() async {
    final all = await AppScope.of(context).queries.allStandalone();
    if (mounted) setState(() => _all = _shown = all);
  }

  Future<void> _filter(String q) async {
    final r = q.trim().isEmpty
        ? _all
        : await AppScope.of(context).queries.search(q);
    if (mounted) setState(() => _shown = r);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Dua seç (${_picked.length})')),
    floatingActionButton: FloatingActionButton.extended(
      key: const ValueKey('pick-done'),
      onPressed: () => Navigator.pop(context, _picked),
      icon: const Icon(Icons.check),
      label: const Text('Ekle'),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Ara',
            ),
            onChanged: _filter,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              for (final d in _shown)
                CheckboxListTile(
                  key: ValueKey('pick-${d.id}'),
                  value: _picked.contains(d.id),
                  title: Text(d.titleTr),
                  onChanged: (v) => setState(
                    () => v == true ? _picked.add(d.id) : _picked.remove(d.id),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
