import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

const part1 =
    'اللَّهُمَّ اهْدِنَا فِيمَنْ هَدَيْتَ، وَعَافِنَا فِيمَنْ عَافَيْتَ، وَتَوَلَّنَا فِيمَنْ تَوَلَّيْتَ، وَبَارِكْ لَنَا فِيمَا أَعْطَيْتَ، وَقِنَا شَرَّ مَا قَضَيْتَ، فَإِنَّكَ تَقْضِي وَلَا يُقْضَىٰ عَلَيْكَ، وَإِنَّهُ لَا يَذِلُّ مَنْ وَالَيْتَ، وَلَا يَعِزُّ مَنْ عَادَيْتَ، تَبَارَكْتَ رَبَّنَا وَتَعَالَيْتَ.';

const part16 =
    'اللَّهُمَّ إِنْ لَمْ تَنْصُرْهُمْ فَمَنْ يَنْصُرُهُمْ؟\n\nاللَّهُمَّ لَا رَبَّ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا إِلَهَ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا وَكِيلَ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا كَفِيلَ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا نَصِيرَ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا مَوْلَىٰ لَهُمْ سِوَاكَ.';

String noSpace(String s) => s.replaceAll(RegExp(r'\s'), '');

void main() {
  test('parça 1 dokuz satıra bölünür, noktalama önceki parçada kalır', () {
    final parts = splitArabic(part1);
    expect(parts, hasLength(9));
    expect(parts.first, 'اللَّهُمَّ اهْدِنَا فِيمَنْ هَدَيْتَ،');
    expect(parts.last, 'تَبَارَكْتَ رَبَّنَا وَتَعَالَيْتَ.');
  });

  test('parça 16 paragraf ve soru işaretinden bölünür', () {
    final parts = splitArabic(part16);
    expect(parts.first, 'اللَّهُمَّ إِنْ لَمْ تَنْصُرْهُمْ فَمَنْ يَنْصُرُهُمْ؟');
    expect(parts, hasLength(7));
  });

  test('noktalamasız tek cümle tek parça kalır', () {
    const s = 'رَبِّ اغْفِرْ وَارْحَمْ';
    expect(splitArabic(s), [s]);
  });

  test('boşluk dışında hiçbir karakter kaybolmaz', () {
    for (final s in [part1, part16]) {
      expect(noSpace(splitArabic(s).join()), noSpace(s));
    }
  });

  test('tek satır sonu boşluğa dönüşür, ىٰ korunur', () {
    expect(splitArabic('أَعِنَّا عَلَىٰ\nذِكْرِكَ'), ['أَعِنَّا عَلَىٰ ذِكْرِكَ']);
  });

  test('mergeArabic araya boşluk koyar', () {
    expect(mergeArabic('أ،', 'ب.'), 'أ، ب.');
  });
}
