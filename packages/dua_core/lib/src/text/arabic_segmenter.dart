/// Satırı bitiren noktalama işaretleri; işaret önceki parçada kalır.
const _breakChars = {'،', '.', '؟', '?', '؛'};

/// Arapça metni satırlara böler. Önce boş satırdan paragraflara, sonra
/// noktalamadan sonra parçalara ayırır. Metnin kendisine (hareke, özel
/// işaretler) dokunmaz; yalnızca boşlukları kırpar ve tek satır sonunu
/// boşluğa çevirir.
List<String> splitArabic(String text) {
  final result = <String>[];
  for (final paragraph in text.split(RegExp(r'\n\s*\n'))) {
    final flat = paragraph.replaceAll(RegExp(r'\s*\n\s*'), ' ');
    final buffer = StringBuffer();
    for (final rune in flat.runes) {
      final ch = String.fromCharCode(rune);
      buffer.write(ch);
      if (_breakChars.contains(ch)) {
        _flush(buffer, result);
      }
    }
    _flush(buffer, result);
  }
  return result;
}

void _flush(StringBuffer buffer, List<String> out) {
  final s = buffer.toString().trim();
  if (s.isNotEmpty) out.add(s);
  buffer.clear();
}

/// İki satırı birleştirir.
String mergeArabic(String a, String b) => '$a $b';
