import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';

/// Bir veya daha çok duayı okuma seçeneklerine göre gösterir; çalan satırı
/// vurgular ve ekranda ortalar; satıra dokununca [onTapSegment] çağrılır.
class ReadingView extends StatefulWidget {
  const ReadingView({
    super.key,
    required this.views,
    this.onTapSegment,
    this.onTapTitle,
    this.showTitles = true,
  });
  final List<DuaView> views;
  final void Function(String duaId, int segmentId)? onTapSegment;
  final void Function(String duaId)? onTapTitle;
  final bool showTitles;

  @override
  State<ReadingView> createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView> {
  final _keys = <int, GlobalKey>{};
  int? _lastActive;

  GlobalKey _keyFor(int segId) => _keys.putIfAbsent(segId, GlobalKey.new);

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return ListenableBuilder(
      listenable: s.player,
      builder: (context, _) {
        final now = s.player.now;
        final active = now.segmentId;
        if (active != null && active != _lastActive) {
          _lastActive = active;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final ctx = _keys[active]?.currentContext;
            if (ctx != null && ctx.mounted) {
              Scrollable.ensureVisible(
                ctx,
                alignment: 0.35,
                duration: const Duration(milliseconds: 300),
              );
            }
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (final v in widget.views) _dua(context, s, v, now)],
        );
      },
    );
  }

  Widget _dua(BuildContext context, AppServices s, DuaView v, NowPlaying now) {
    final p = s.prefs;
    final scale = s.fontScale;
    final theme = Theme.of(context);
    final d = v.dua;
    final allHaveMeaningTr = v.segments.every(
      (x) => (x.meaningTr ?? '').isNotEmpty,
    );
    final allHaveMeaningEn = v.segments.every(
      (x) => (x.meaningEn ?? '').isNotEmpty,
    );
    final allHavePronTr = v.segments.every(
      (x) => (x.pronunciationTr ?? '').isNotEmpty,
    );
    // Satır altında anlam: seçiliyse ve duanın her satırının kendi anlamı varsa.
    // Aksi hâlde (seçim kapalı ya da satır anlamı eksik) anlam duanın sonunda tek paragraf.
    final lineTr = s.meaningPerLine && allHaveMeaningTr;
    final lineEn = s.meaningPerLine && allHaveMeaningEn;
    String? joined(String? Function(Segment) f) {
      final parts = v.segments
          .map(f)
          .whereType<String>()
          .where((x) => x.isNotEmpty)
          .toList();
      return parts.isEmpty ? null : parts.join(' ');
    }

    final endTr = d.srcMeaningTr ?? joined((x) => x.meaningTr);
    final endEn = d.srcMeaningEn ?? joined((x) => x.meaningEn);
    final playingHere = now.duaId == d.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showTitles)
            InkWell(
              onTap: widget.onTapTitle == null
                  ? null
                  : () => widget.onTapTitle!(d.id),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        d.titleTr,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    if (playingHere && now.turns > 1)
                      Text(
                        '${now.turn}/${now.turns}',
                        style: theme.textTheme.labelLarge,
                      ),
                  ],
                ),
              ),
            ),
          for (final seg in v.segments)
            _segment(context, v, seg, p, scale, now, lineTr, lineEn),
          if (p.pronunciationTr &&
              !allHavePronTr &&
              d.srcPronunciationTr != null)
            _para(d.srcPronunciationTr!, scale, italic: true),
          if (p.meaningTr && !lineTr && endTr != null)
            _para(endTr, scale, key: ValueKey('dua-meaning-${d.id}')),
          if (p.meaningEn && !lineEn && endEn != null)
            _para(
              endEn,
              scale,
              key: ValueKey('dua-meaning-en-${d.id}'),
              color: theme.colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }

  Widget _para(
    String text,
    double scale, {
    Key? key,
    bool italic = false,
    Color? color,
  }) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Text(
      text,
      key: key,
      style: TextStyle(
        fontSize: 16 * scale,
        height: 1.45,
        fontStyle: italic ? FontStyle.italic : null,
        color: color,
      ),
    ),
  );

  Widget _segment(
    BuildContext context,
    DuaView v,
    Segment seg,
    ReadingPrefs p,
    double scale,
    NowPlaying now,
    bool lineTr,
    bool lineEn,
  ) {
    final theme = Theme.of(context);
    final isActive = now.duaId == v.dua.id && now.segmentId == seg.id;
    return Container(
      key: _keyFor(seg.id),
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primaryContainer : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        key: isActive
            ? const ValueKey('seg-active')
            : ValueKey('seg-${seg.id}'),
        borderRadius: BorderRadius.circular(10),
        onTap: widget.onTapSegment == null
            ? null
            : () => widget.onTapSegment!(v.dua.id, seg.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (p.arabic)
                Text(
                  seg.textAr,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 28 * scale,
                    height: 1.9,
                  ),
                ),
              if (p.pronunciationTr && (seg.pronunciationTr ?? '').isNotEmpty)
                Text(
                  seg.pronunciationTr!,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (p.pronunciationEn && (seg.pronunciationEn ?? '').isNotEmpty)
                Text(
                  seg.pronunciationEn!,
                  style: TextStyle(
                    fontSize: 15 * scale,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.outline,
                  ),
                ),
              if (p.meaningTr && lineTr)
                Text(
                  seg.meaningTr!,
                  key: ValueKey('seg-meaning-${seg.id}'),
                  style: TextStyle(fontSize: 16 * scale),
                ),
              if (p.meaningEn && lineEn)
                Text(
                  seg.meaningEn!,
                  style: TextStyle(
                    fontSize: 15 * scale,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
