import 'arabic_segmenter.dart';

/// İçe aktarımda bir satır için önerilen içerik.
class SegmentDraft {
  SegmentDraft(this.textAr, {this.pronunciationTr, this.pronunciationEn, this.meaningTr, this.meaningEn});
  final String textAr;
  final String? pronunciationTr;
  final String? pronunciationEn;
  final String? meaningTr;
  final String? meaningEn;
}

final _sentenceEnd = RegExp(r'(?<=[.?!])\s+');
final _clauseEnd = RegExp(r'(?<=[.?!,])\s+');

List<String> _splitLatin(String? s, RegExp re) =>
    s == null ? const [] : s.trim().split(re).map((x) => x.trim()).where((x) => x.isNotEmpty).toList();

/// Harekeler, tatvil ve Kur'an işaretleri hariç Arapça harf sayısı.
int _arabicLetters(String word) {
  var n = 0;
  for (final r in word.runes) {
    final isMark = (r >= 0x064B && r <= 0x065F) || r == 0x0670 || (r >= 0x06D6 && r <= 0x06ED) || r == 0x0640;
    if (!isMark && r >= 0x0600 && r <= 0x06FF) n++;
  }
  return n;
}

/// Arapça harf → Türkçe okunuştaki ünsüz sınıfı ('' = sesli/hemze, atlanır).
const _arConsonant = {
  'ب': 'b', 'ت': 't', 'ط': 't', 'ث': 's', 'س': 's', 'ص': 's', 'ش': 's', 'ج': 'c', 'ح': 'h', 'خ': 'h',
  'ه': 'h', 'ة': 'h', 'د': 'd', 'ذ': 'z', 'ز': 'z', 'ظ': 'z', 'ض': 'd', 'ر': 'r', 'ع': '', 'غ': 'g',
  'ف': 'f', 'ق': 'k', 'ك': 'k', 'ل': 'l', 'م': 'm', 'ن': 'n', 'و': 'v', 'ي': 'y', 'ى': '', 'ا': '',
  'أ': '', 'إ': '', 'آ': '', 'ء': '', 'ؤ': '', 'ئ': '',
};

const _latConsonant = {'ş': 's', 'ğ': 'g', 'ç': 'c', 'q': 'k', 'w': 'v', 'j': 'c', 'x': 'h'};
const _latVowels = 'aeiıoöuüâîû';

String _collapse(String s) {
  final b = StringBuffer();
  for (final ch in s.split('')) {
    if (b.isEmpty || b.toString()[b.length - 1] != ch) b.write(ch);
  }
  return b.toString();
}

/// Arapça kelimenin ünsüz imzası (ör. وَاعْفُ → "vf").
String _arabicSignature(String word) {
  final b = StringBuffer();
  for (final r in word.runes) {
    b.write(_arConsonant[String.fromCharCode(r)] ?? '');
  }
  return _collapse(b.toString());
}

/// Cümlenin ilk iki ünsüzü (ilk kelime kısaysa ikinci kelimeyle tamamlanır).
String _latinSignature(String sentence) {
  final b = StringBuffer();
  for (final token in sentence.toLowerCase().split(RegExp(r'\s+'))) {
    for (final ch in token.split('')) {
      if (_latVowels.contains(ch) || !RegExp(r'\p{L}', unicode: true).hasMatch(ch)) continue;
      b.write(_latConsonant[ch] ?? ch);
    }
    if (_collapse(b.toString()).length >= 2) break;
  }
  final sig = _collapse(b.toString());
  return sig.length >= 2 ? sig.substring(0, 2) : sig;
}

int _latinLetters(String s) => RegExp(r'\p{L}', unicode: true).allMatches(s).length;

/// Arapça kelimeleri, okunuş cümlelerinin harf uzunluklarıyla orantılı olarak böler.
/// Her sınır, hedefe en yakın kelime sınırına yerleşir; her satırda en az bir kelime kalır.
List<String>? _proportionalSplit(String textAr, List<String> sentences) {
  final words = textAr.trim().split(RegExp(r'\s+'));
  final n = sentences.length;
  if (words.length < n) return null;
  final cum = <int>[0];
  for (final w in words) {
    cum.add(cum.last + _arabicLetters(w));
  }
  final totalAr = cum.last;
  final weights = sentences.map(_latinLetters).toList();
  final totalLat = weights.fold<int>(0, (a, b) => a + b);
  if (totalAr == 0 || totalLat == 0) return null;

  final cuts = <int>[];
  var acc = 0;
  for (var k = 0; k < n - 1; k++) {
    acc += weights[k];
    final target = totalAr * acc / totalLat;
    final minCut = (cuts.isEmpty ? 0 : cuts.last) + 1;
    final maxCut = words.length - (n - 1 - k);
    var best = minCut;
    for (var c = minCut; c <= maxCut; c++) {
      if ((cum[c] - target).abs() < (cum[best] - target).abs()) best = c;
    }
    // Sınırı, sonraki cümlenin ilk kelimesiyle ünsüzleri uyan yakındaki Arapça kelimenin önüne hizala.
    final sig = _latinSignature(sentences[k + 1]);
    if (sig.length == 2) {
      int? snapped;
      for (var c = (best - 3).clamp(minCut, maxCut); c <= (best + 3).clamp(minCut, maxCut); c++) {
        if (_arabicSignature(words[c] + (c + 1 < words.length ? words[c + 1] : '')).startsWith(sig) &&
            (snapped == null || (c - best).abs() < (snapped - best).abs())) {
          snapped = c;
        }
      }
      if (snapped != null) best = snapped;
    }
    cuts.add(best);
  }
  final out = <String>[];
  var start = 0;
  for (final c in [...cuts, words.length]) {
    out.add(words.sublist(start, c).join(' '));
    start = c;
  }
  return out;
}

/// Duayı satırlara böler. Kural (kullanıcı kararı): Arapça noktalanmamışsa
/// Türkçe okunuştaki cümle noktaları rehber alınır. Arapça metnin harfleri
/// asla değiştirilmez; yalnızca kelime aralarından bölünür.
List<SegmentDraft> segmentByPronunciation({
  required String textAr,
  String? pronunciationTr,
  String? pronunciationEn,
  String? meaningTr,
  String? meaningEn,
}) {
  final arParts = splitArabic(textAr);
  final sentTr = _splitLatin(pronunciationTr, _sentenceEnd);
  final clauseTr = _splitLatin(pronunciationTr, _clauseEnd);

  List<String> ar;
  List<String>? prTr;
  RegExp? mode;

  if (arParts.length > 1) {
    ar = arParts;
    if (sentTr.length == arParts.length) {
      prTr = sentTr;
      mode = _sentenceEnd;
    } else if (clauseTr.length == arParts.length) {
      prTr = clauseTr;
      mode = _clauseEnd;
    }
  } else if (sentTr.length > 1) {
    final split = _proportionalSplit(textAr, sentTr);
    if (split != null) {
      ar = split;
      prTr = sentTr;
      mode = _sentenceEnd;
    } else {
      ar = arParts;
    }
  } else {
    ar = arParts;
    if (sentTr.length == 1) {
      prTr = sentTr;
      mode = _sentenceEnd;
    }
  }

  List<String>? prEn;
  if (mode != null) {
    final en = _splitLatin(pronunciationEn, mode);
    if (en.length == ar.length) prEn = en;
  }

  final single = ar.length == 1;
  return [
    for (var i = 0; i < ar.length; i++)
      SegmentDraft(
        ar[i],
        pronunciationTr: prTr?[i],
        pronunciationEn: prEn?[i],
        meaningTr: single ? meaningTr : null,
        meaningEn: single ? meaningEn : null,
      ),
  ];
}
