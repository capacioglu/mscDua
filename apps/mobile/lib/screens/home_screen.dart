import 'package:flutter/material.dart';

import '../widgets/mini_player.dart';
import 'categories_tab.dart';
import 'dua_screen.dart';
import 'groups_tab.dart';
import 'playlists_screen.dart';
import 'search_tab.dart';

/// Alt sekmeler: Gruplar · Kategoriler · Listelerim · Ara.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  static const _titles = ['Gruplar', 'Kategoriler', 'Listelerim', 'Ara'];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_tab == 0 ? 'Dualarım' : _titles[_tab])),
    body: IndexedStack(
      index: _tab,
      children: const [
        GroupsTab(),
        CategoriesTab(),
        PlaylistsScreen(),
        SearchTab(),
      ],
    ),
    bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MiniPlayer(
          onOpen: (id) => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => DuaScreen(duaId: id))),
        ),
        NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.collections_bookmark_outlined),
              label: 'Gruplar',
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined),
              label: 'Kategoriler',
            ),
            NavigationDestination(
              icon: Icon(Icons.queue_music),
              label: 'Listelerim',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: 'Ara'),
          ],
        ),
      ],
    ),
  );
}
