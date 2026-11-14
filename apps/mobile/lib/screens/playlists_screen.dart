import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../widgets/add_to_playlist.dart';
import 'playlist_screen.dart';

/// "Listelerim" sekmesi.
class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  List<Playlist> _lists = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final l = await AppScope.of(context).user.allPlaylists();
    if (mounted) setState(() => _lists = l);
  }

  Future<void> _open(int id) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PlaylistScreen(playlistId: id)));
    await _load();
  }

  Future<void> _create() async {
    final id = await createPlaylistDialog(context);
    if (id != null) await _open(id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: FloatingActionButton.extended(
      key: const ValueKey('new-playlist'),
      onPressed: _create,
      icon: const Icon(Icons.add),
      label: const Text('Yeni liste'),
    ),
    body: _lists.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Henüz listen yok.\n"Yeni liste" ile dualarını seçip kendi listeni oluştur.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        : ListView(
            children: [
              for (final l in _lists)
                ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(l.name),
                  onTap: () => _open(l.id),
                ),
            ],
          ),
  );
}
