import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import 'group_screen.dart';

class GroupsTab extends StatefulWidget {
  const GroupsTab({super.key});

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab> {
  Future<List<DuaGroup>>? _groups;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _groups ??= AppScope.of(context).queries.groups();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _groups,
    builder: (context, snap) => ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final g in snap.data ?? const <DuaGroup>[])
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const Icon(Icons.auto_stories, size: 36),
              title: Text(
                g.titleTr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: g.titleAr == null
                  ? null
                  : Text(
                      g.titleAr!,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontFamily: 'Amiri', fontSize: 20),
                    ),
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => GroupScreen(group: g))),
            ),
          ),
      ],
    ),
  );
}
