import 'package:flutter/material.dart';

import '../app_scope.dart';

/// Yeni liste adı sorar; oluşturulan listenin kimliğini döner.
Future<int?> createPlaylistDialog(BuildContext context) async {
  final ctl = TextEditingController();
  final name = await showDialog<String>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Yeni liste'),
      content: TextField(
        key: const ValueKey('playlist-name'),
        controller: ctl,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Ör. Sabah duaları'),
        onSubmitted: (v) => Navigator.pop(c, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Vazgeç'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, ctl.text),
          child: const Text('Oluştur'),
        ),
      ],
    ),
  );
  if (name == null || name.trim().isEmpty || !context.mounted) return null;
  return AppScope.of(context).user.createPlaylist(name);
}

/// Dualar(ı) var olan ya da yeni bir listeye ekler.
Future<void> addToPlaylist(BuildContext context, List<String> duaIds) async {
  final user = AppScope.of(context).user;
  final lists = await user.allPlaylists();
  if (!context.mounted) return;
  final chosen = await showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (c) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          const ListTile(title: Text('Listeye ekle')),
          for (final l in lists)
            ListTile(
              leading: const Icon(Icons.queue_music),
              title: Text(l.name),
              onTap: () => Navigator.pop(c, l.id),
            ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Yeni liste…'),
            onTap: () => Navigator.pop(c, -1),
          ),
        ],
      ),
    ),
  );
  if (chosen == null || !context.mounted) return;
  final id = chosen == -1 ? await createPlaylistDialog(context) : chosen;
  if (id == null) return;
  await user.addItems(id, duaIds);
  if (context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Listeye eklendi')));
  }
}
