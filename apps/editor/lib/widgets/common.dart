import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

/// Türkçe büyük/küçük harf duyarsız karşılaştırma için küçültme.
String trLower(String s) =>
    s.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

/// Arapça metin: Amiri, sağdan sola.
class ArabicText extends StatelessWidget {
  const ArabicText(this.text, {super.key, this.size = 26, this.color});
  final String text;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textDirection: TextDirection.rtl,
    textAlign: TextAlign.right,
    style: TextStyle(
      fontFamily: 'Amiri',
      fontSize: size,
      height: 1.8,
      color: color,
    ),
  );
}

Color progressColor(DuaProgress p) => switch (p) {
  DuaProgress.draft => Colors.grey,
  DuaProgress.awaitingTranslation => Colors.orange,
  DuaProgress.inReview => Colors.blue,
  DuaProgress.approved => Colors.green,
};

class ProgressChip extends StatelessWidget {
  const ProgressChip(this.progress, {super.key});
  final DuaProgress progress;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: progressColor(progress).withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      progressLabel(progress),
      style: TextStyle(color: progressColor(progress), fontSize: 12),
    ),
  );
}

Color timingColor(TimingProgress t) => switch (t) {
  TimingProgress.noAudio => Colors.grey,
  TimingProgress.untimed => Colors.orange,
  TimingProgress.partial => Colors.blue,
  TimingProgress.ready => Colors.green,
};

class TimingChip extends StatelessWidget {
  const TimingChip(this.timing, {super.key});
  final TimingProgress timing;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: timingColor(timing).withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      timingLabel(timing),
      style: TextStyle(color: timingColor(timing), fontSize: 12),
    ),
  );
}
