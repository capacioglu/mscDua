/// Arama için Arapça normalleştirme: hareke ve tatvil atılır, elif/ye/te
/// biçimleri birleştirilir. Yalnızca karşılaştırma içindir; metin değiştirilmez.
String normalizeArabic(String s) {
  final b = StringBuffer();
  for (final r in s.runes) {
    final mark = (r >= 0x064B && r <= 0x065F) || r == 0x0670 || (r >= 0x06D6 && r <= 0x06ED) || r == 0x0640;
    if (mark) continue;
    final ch = String.fromCharCode(r);
    b.write(switch (ch) { 'أ' || 'إ' || 'آ' || 'ٱ' => 'ا', 'ى' => 'ي', 'ة' => 'ه', _ => ch });
  }
  return b.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Arama için Latin harfli normalleştirme (Türkçe büyük/küçük, şapka, Türkçe harfler).
String normalizeLatin(String s) {
  const map = {
    'â': 'a', 'î': 'i', 'û': 'u', 'ı': 'i', 'ş': 's', 'ğ': 'g', 'ü': 'u', 'ö': 'o', 'ç': 'c', 'é': 'e', 'á': 'a',
  };
  final lower = s.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();
  final b = StringBuffer();
  for (final ch in lower.split('')) {
    b.write(map[ch] ?? ch);
  }
  return b.toString().replaceAll(RegExp(r"['’‘`ʿʾ\-]"), '').replaceAll(RegExp(r'\s+'), ' ').trim();
}

bool containsArabic(String s) => s.runes.any((r) => r >= 0x0600 && r <= 0x06FF);
