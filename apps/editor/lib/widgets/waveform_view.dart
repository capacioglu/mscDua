import 'dart:typed_data';

import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

/// Dalga formu, oynatma imleci, zamanlama işaretleri ve ipucu bantları.
class WaveformView extends StatefulWidget {
  const WaveformView({
    super.key,
    required this.peaks,
    required this.durationMs,
    required this.positionMs,
    required this.cues,
    required this.cueLabel,
    required this.onSeek,
    this.selected,
    this.onSelectCue,
    this.onMoveCue,
    this.hints = const [],
  });

  final Float32List? peaks;
  final int durationMs;
  final int positionMs;
  final List<CueEntry> cues;
  final String Function(CueEntry) cueLabel;
  final void Function(int ms) onSeek;
  final CueEntry? selected;
  final void Function(CueEntry)? onSelectCue;
  final void Function(CueEntry, int ms)? onMoveCue;

  /// Yarı saydam bantlar (başlangıç ms, bitiş ms, etiket).
  final List<(int, int, String)> hints;

  @override
  State<WaveformView> createState() => _WaveformViewState();
}

class _WaveformViewState extends State<WaveformView> {
  CueEntry? _dragging;

  int _msAt(double x, double width) => width <= 0
      ? 0
      : (x / width * widget.durationMs).round().clamp(0, widget.durationMs);

  CueEntry? _cueNear(double x, double width) {
    for (final c in widget.cues) {
      final cx = widget.durationMs == 0
          ? 0
          : c.startMs / widget.durationMs * width;
      if ((cx - x).abs() <= 6) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final w = box.maxWidth;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (d) {
          final c = _cueNear(d.localPosition.dx, w);
          if (c != null && widget.onSelectCue != null) {
            widget.onSelectCue!(c);
          } else {
            widget.onSeek(_msAt(d.localPosition.dx, w));
          }
        },
        onHorizontalDragStart: (d) =>
            _dragging = _cueNear(d.localPosition.dx, w),
        onHorizontalDragUpdate: (d) {
          final c = _dragging;
          if (c != null) {
            widget.onMoveCue?.call(c, _msAt(d.localPosition.dx, w));
          }
        },
        onHorizontalDragEnd: (_) => _dragging = null,
        child: CustomPaint(
          size: Size(w, box.maxHeight),
          painter: _WavePainter(widget, Theme.of(context).colorScheme),
        ),
      );
    },
  );
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.w, this.scheme);
  final WaveformView w;
  final ColorScheme scheme;

  double _x(int ms, Size size) =>
      w.durationMs == 0 ? 0 : ms / w.durationMs * size.width;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = scheme.surfaceContainerHighest,
    );
    final mid = size.height / 2;
    for (final (a, b, label) in w.hints) {
      final r = Rect.fromLTRB(_x(a, size), 0, _x(b, size), size.height);
      canvas.drawRect(r, Paint()..color = Colors.amber.withValues(alpha: 0.18));
      _text(
        canvas,
        label,
        Offset(r.left + 2, size.height - 14),
        Colors.brown,
        10,
      );
    }
    final peaks = w.peaks;
    if (peaks != null && peaks.isNotEmpty) {
      final paint = Paint()
        ..color = scheme.primary.withValues(alpha: 0.6)
        ..strokeWidth = 1;
      final cols = size.width.floor();
      for (var x = 0; x < cols; x++) {
        final i = (x / cols * peaks.length).floor().clamp(0, peaks.length - 1);
        final h = peaks[i] * mid;
        canvas.drawLine(
          Offset(x.toDouble(), mid - h),
          Offset(x.toDouble(), mid + h),
          paint,
        );
      }
    }
    for (final c in w.cues) {
      final x = _x(c.startMs, size);
      final gap = c.segmentId == null;
      final sel = identical(c, w.selected);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = sel ? Colors.red : (gap ? Colors.grey : scheme.tertiary)
          ..strokeWidth = sel ? 3 : 2,
      );
      _text(
        canvas,
        w.cueLabel(c),
        Offset(x + 3, 2),
        sel ? Colors.red : scheme.onSurface,
        11,
      );
    }
    final px = _x(w.positionMs, size);
    canvas.drawLine(
      Offset(px, 0),
      Offset(px, size.height),
      Paint()
        ..color = scheme.error
        ..strokeWidth = 1.5,
    );
  }

  void _text(Canvas canvas, String s, Offset at, Color color, double size) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(color: color, fontSize: size),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, at);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => true;
}
