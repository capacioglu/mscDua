import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../widgets/add_to_playlist.dart';
import 'dua_screen.dart';

/// Dua listesi: dokununca dua ekranı (önceki/sonraki bu sırayla), uzun basınca listeye ekle.
class DuaList extends StatelessWidget {
  const DuaList({super.key, required this.duas});
  final List<Dua> duas;

  @override
  Widget build(BuildContext context) {
    final order = duas.map((d) => d.id).toList();
    return ListView.separated(
      itemCount: duas.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final d = duas[i];
        return ListTile(
          title: Text(d.titleTr),
          subtitle: d.titleAr == null
              ? null
              : Text(
                  d.titleAr!,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
                ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DuaScreen(duaId: d.id, order: order),
            ),
          ),
          onLongPress: () => addToPlaylist(context, [d.id]),
        );
      },
    );
  }
}
