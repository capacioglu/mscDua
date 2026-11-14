import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import 'dua_list.dart';

/// Türkçe (şapka/büyük harf duyarsız) veya Arapça (harekesiz) arama.
class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<Dua> _results = [];
  int _seq = 0;

  Future<void> _search(String q) async {
    final mine = ++_seq;
    final r = await AppScope.of(context).queries.search(q);
    if (mounted && mine == _seq) setState(() => _results = r);
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          key: const ValueKey('search-field'),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Başlık, okunuş, anlam veya Arapça',
            border: OutlineInputBorder(),
          ),
          onChanged: _search,
        ),
      ),
      Expanded(child: DuaList(duas: _results)),
    ],
  );
}
