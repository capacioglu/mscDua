/// Türkçe cümleyi bitiren işaretler; işaret cümlede kalır.
const _ends = {'.', '!', '?', '…'};

/// Türkçe metni satırlara böler: önce boş satırdan paragraflara, sonra cümle
/// sonlarından (ardışık işaretler — "...", "!?" — tek kesim). Tek satır sonu boşluk olur.
List<String> splitTurkish(String text) {
  final out = <String>[];
  for (final paragraph in text.split(RegExp(r'\n\s*\n'))) {
    final flat = paragraph.replaceAll(RegExp(r'\s*\n\s*'), ' ');
    final buf = StringBuffer();
    for (var i = 0; i < flat.length; i++) {
      buf.write(flat[i]);
      final atEnd = _ends.contains(flat[i]) && (i + 1 == flat.length || !_ends.contains(flat[i + 1]));
      if (atEnd) _flush(buf, out);
    }
    _flush(buf, out);
  }
  return out;
}

void _flush(StringBuffer b, List<String> out) {
  final s = b.toString().trim();
  if (s.isNotEmpty) out.add(s);
  b.clear();
}
