import 'package:flutter/material.dart';

import '../app_scope.dart';

/// Ekranların altında: çalan dua, tur ve oynat/duraklat.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key, this.onOpen});
  final void Function(String duaId)? onOpen;

  @override
  Widget build(BuildContext context) {
    final p = AppScope.of(context).player;
    return ListenableBuilder(
      listenable: p,
      builder: (context, _) {
        if (!p.active) {
          if (!p.canResume) return const SizedBox.shrink();
          return Material(
            elevation: 6,
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: SafeArea(
              top: false,
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Kaldığın yerden devam'),
                subtitle: Text(
                  p.resumeTitle ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  key: const ValueKey('mini-resume'),
                  icon: const Icon(Icons.play_circle, size: 36),
                  onPressed: p.resume,
                ),
              ),
            ),
          );
        }
        final now = p.now;
        final title = now.duaId == null
            ? (p.title ?? '')
            : (p.viewOf(now.duaId!)?.dua.titleTr ?? now.duaId!);
        return Material(
          elevation: 6,
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: SafeArea(
            top: false,
            child: ListTile(
              key: const ValueKey('mini-player'),
              onTap: now.duaId == null || onOpen == null
                  ? null
                  : () => onOpen!(now.duaId!),
              leading: const Icon(Icons.graphic_eq),
              title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                [
                  if (p.title != null) p.title!,
                  if (now.turns > 1) '${now.turn}/${now.turns}',
                  if (now.inGap) 'ara',
                ].join(' · '),
              ),
              trailing: IconButton(
                key: const ValueKey('mini-toggle'),
                icon: Icon(
                  p.playing ? Icons.pause_circle : Icons.play_circle,
                  size: 36,
                ),
                onPressed: p.togglePlay,
              ),
            ),
          ),
        );
      },
    );
  }
}
