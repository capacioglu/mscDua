import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../db/database.dart';

/// ElevenLabs'e gönderilecek birleşik metin: satırlar `\n` ile; her satırın başlangıç ofseti.
class TtsText {
  TtsText(this.text, this.lineStarts, this.segmentIds);
  final String text;
  final List<int> lineStarts;
  final List<int> segmentIds;
}

/// Harf bazlı zamanlama (ElevenLabs `alignment`).
class Alignment {
  Alignment({required this.chars, required this.startsSec});
  final List<String> chars;
  final List<double> startsSec;

  factory Alignment.fromJson(Map<String, dynamic> j) => Alignment(
        chars: (j['characters'] as List).cast<String>(),
        startsSec: [for (final x in j['character_start_times_seconds'] as List) (x as num).toDouble()],
      );
}

String? _lineText(Segment s, String lang) => switch (lang) {
      'ar' => s.textAr,
      'tr' => s.meaningTr,
      'en' => s.meaningEn,
      _ => throw ArgumentError('Bilinmeyen dil: $lang'),
    };

/// Satırların [lang] dilindeki metnini birleştirir; herhangi bir satır boşsa null.
TtsText? buildTtsText(List<Segment> segs, String lang) {
  if (segs.isEmpty) return null;
  final lines = <String>[];
  for (final s in segs) {
    final t = _lineText(s, lang)?.trim() ?? '';
    if (t.isEmpty) return null;
    lines.add(t);
  }
  final starts = <int>[];
  var pos = 0;
  for (final l in lines) {
    starts.add(pos);
    pos += l.length + 1;
  }
  return TtsText(lines.join('\n'), starts, [for (final s in segs) s.id]);
}

/// Metnin SHA-1 özeti (ses üretildikten sonra metin değişti mi?).
String ttsHash(TtsText t) => sha1.convert(utf8.encode(t.text)).toString();

/// Metni satır sınırlarından [maxChars]'ı aşmayan parçalara böler.
List<TtsText> chunkTts(TtsText t, {int maxChars = 4500}) {
  final lines = t.text.split('\n');
  final out = <TtsText>[];
  var cur = <String>[];
  var ids = <int>[];
  void flush() {
    if (cur.isEmpty) return;
    final starts = <int>[];
    var pos = 0;
    for (final l in cur) {
      starts.add(pos);
      pos += l.length + 1;
    }
    out.add(TtsText(cur.join('\n'), starts, ids));
    cur = [];
    ids = [];
  }

  for (var i = 0; i < lines.length; i++) {
    final added = cur.isEmpty ? lines[i].length : cur.join('\n').length + 1 + lines[i].length;
    if (cur.isNotEmpty && added > maxChars) flush();
    cur.add(lines[i]);
    ids.add(t.segmentIds[i]);
  }
  flush();
  return out;
}

bool _ws(String c) => c.trim().isEmpty;

/// Her satırın ilk boşluk-olmayan karakterinin başlangıç zamanı (ms).
/// Boşluk farkları (satır sonu yerine boşluk, fazladan boşluk) tolere edilir;
/// boşluk dışındaki karakterler eşleşmezse [FormatException].
List<int> lineCueMs(TtsText t, Alignment a) {
  final textIdx = <int>[];
  for (var i = 0; i < t.text.length; i++) {
    if (!_ws(t.text[i])) textIdx.add(i);
  }
  final alignIdx = <int>[];
  for (var i = 0; i < a.chars.length; i++) {
    if (!_ws(a.chars[i])) alignIdx.add(i);
  }
  if (textIdx.length != alignIdx.length) throw const FormatException('Hizalama metinle eşleşmedi');
  for (var k = 0; k < textIdx.length; k++) {
    if (t.text[textIdx[k]] != a.chars[alignIdx[k]]) throw const FormatException('Hizalama metinle eşleşmedi');
  }
  return [
    for (final start in t.lineStarts)
      (a.startsSec[alignIdx[textIdx.indexWhere((i) => i >= start)]] * 1000).round(),
  ];
}
