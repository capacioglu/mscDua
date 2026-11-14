import 'dart:convert';
import 'dart:io';

import 'package:dua_core/dua_core.dart';

/// Arşivdeki tüm metinler için önerilen satır bölmesini yazdırır.
void main(List<String> args) {
  final path = args.isEmpty ? '../../content/import/dua_archive.json' : args.first;
  final j = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  final items = [...(j['duas'] as List), ...(j['variants'] as List)].cast<Map<String, dynamic>>();
  for (final d in items) {
    final segs = segmentByPronunciation(
        textAr: d['text_ar'], pronunciationTr: d['pronunciation_tr'], pronunciationEn: d['pronunciation_en']);
    stdout.writeln('== ${d['id']} (${segs.length})');
    for (final s in segs) {
      stdout.writeln('  ${s.textAr}  ||  ${s.pronunciationTr}  ||EN:${s.pronunciationEn == null ? '-' : 'ok'}');
    }
  }
}
