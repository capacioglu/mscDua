import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import 'dua_list.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  Future<List<Category>>? _cats;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cats ??= AppScope.of(context).queries.categories();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _cats,
    builder: (context, snap) => ListView(
      children: [
        for (final c in snap.data ?? const <Category>[])
          ListTile(
            leading: const Icon(Icons.label_outline),
            title: Text(c.nameTr),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CategoryScreen(category: c)),
            ),
          ),
      ],
    ),
  );
}

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.category});
  final Category category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Future<List<Dua>>? _duas;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _duas ??= AppScope.of(context).queries.duasInCategory(widget.category.id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.category.nameTr)),
    body: FutureBuilder(
      future: _duas,
      builder: (context, snap) => DuaList(duas: snap.data ?? const []),
    ),
  );
}
