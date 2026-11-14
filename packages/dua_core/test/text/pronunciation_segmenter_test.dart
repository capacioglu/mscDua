import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

String noSpace(String s) => s.replaceAll(RegExp(r'\s'), '');

void main() {
  test('noktalamasız Arapça okunuştaki cümlelere göre bölünür (DUA-0006)', () {
    final r = segmentByPronunciation(
      textAr: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي يَفْقَهُوا قَوْلِي',
      pronunciationTr: 'Rabbişrah lî sadrî. Ve yessir lî emrî. Vahlül ukdeten min lisânî. Yefkahû kavlî.',
      pronunciationEn: 'Rabbi-shrah li sadri. Wa yassir li amri. Wahlul \'uqdatan min lisani. Yafqahu qawli.',
    );
    expect(r.map((s) => s.textAr), [
      'رَبِّ اشْرَحْ لِي صَدْرِي',
      'وَيَسِّرْ لِي أَمْرِي',
      'وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي',
      'يَفْقَهُوا قَوْلِي',
    ]);
    expect(r.map((s) => s.pronunciationTr),
        ['Rabbişrah lî sadrî.', 'Ve yessir lî emrî.', 'Vahlül ukdeten min lisânî.', 'Yefkahû kavlî.']);
    expect(r[2].pronunciationEn, 'Wahlul \'uqdatan min lisani.');
  });

  test('uzun metin beş cümleye doğru bölünür (DUA-0015)', () {
    final r = segmentByPronunciation(
      textAr:
          'رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا أَنْتَ مَوْلَانَا فَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
      pronunciationTr:
          "Rabbenâ lâ tüâhiznâ in nesînâ ev ahta'nâ. Rabbenâ ve lâ tahmil aleynâ ısran kemâ hameltehû alellezîne min kablinâ. Rabbenâ ve lâ tuhammilnâ mâ lâ tâkate lenâ bih. Va'fü annâ vağfir lenâ verhamnâ. Ente mevlânâ fensurnâ alel-kavmil-kâfirîn.",
    );
    expect(r.map((s) => s.textAr), [
      'رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا',
      'رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا',
      'رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ',
      'وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا',
      'أَنْتَ مَوْلَانَا فَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
    ]);
  });

  test('iki Arapça kelimeye karşılık gelen okunuş kelimesinde sınır doğru yerde (DUA-0019)', () {
    final r = segmentByPronunciation(
      textAr: 'رَبَّنَا إِنَّكَ جَامِعُ النَّاسِ لِيَوْمٍ لَا رَيْبَ فِيهِ إِنَّ اللَّهَ لَا يُخْلِفُ الْمِيعَادَ',
      pronunciationTr: 'Rabbenâ inneke câmiun-nâsi liyevmin lâ raybe fîh. İnnallâhe lâ yuhliful-mîâd.',
    );
    expect(r.map((s) => s.textAr),
        ['رَبَّنَا إِنَّكَ جَامِعُ النَّاسِ لِيَوْمٍ لَا رَيْبَ فِيهِ', 'إِنَّ اللَّهَ لَا يُخْلِفُ الْمِيعَادَ']);
  });

  test('kısa ilk kelimeli cümlede sınır doğru yerde (DUA-0056-08)', () {
    final r = segmentByPronunciation(
      textAr:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِرِضَاكَ مِنْ سَخَطِكَ وَبِمُعَافَاتِكَ مِنْ عُقُوبَتِكَ وَأَعُوذُ بِكَ مِنْكَ لَا أُحْصِي ثَنَاءً عَلَيْكَ أَنْتَ كَمَا أَثْنَيْتَ عَلَى نَفْسِكَ',
      pronunciationTr:
          'Allâhümme innî eûzü birıdâke min sehatike ve bimuâfâtike min ukûbetike ve eûzü bike minke. Lâ uhsî senâen aleyke ente kemâ esneyte alâ nefsik.',
    );
    expect(r[1].textAr, 'لَا أُحْصِي ثَنَاءً عَلَيْكَ أَنْتَ كَمَا أَثْنَيْتَ عَلَى نَفْسِكَ');
  });

  test('Arapça noktalıysa ve okunuş virgülleriyle eşleşiyorsa onları kullanır (DUA-0056-11)', () {
    final r = segmentByPronunciation(
      textAr:
          'اللَّهُمَّ إِنْ لَمْ تَنْصُرْهُمْ فَمَنْ يَنْصُرُهُمْ؟ اللَّهُمَّ لَا رَبَّ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا إِلَهَ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا وَكِيلَ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا كَفِيلَ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا نَصِيرَ لَهُمْ سِوَاكَ، اللَّهُمَّ لَا مَوْلَى لَهُمْ سِوَاكَ',
      pronunciationTr:
          'Allâhümme in lem tensurhum femen yensuruhüm? Allâhümme lâ rabbe lehüm sivâk, Allâhümme lâ ilâhe lehüm sivâk, Allâhümme lâ vekîle lehüm sivâk, Allâhümme lâ kefîle lehüm sivâk, Allâhümme lâ nasîra lehüm sivâk, Allâhümme lâ mevlâ lehüm sivâk.',
    );
    expect(r, hasLength(7));
    expect(r[1].textAr, 'اللَّهُمَّ لَا رَبَّ لَهُمْ سِوَاكَ،');
    expect(r[1].pronunciationTr, 'Allâhümme lâ rabbe lehüm sivâk,');
  });

  test('tek cümlelik dua tek satır olur ve anlamlar da satıra yazılır', () {
    final r = segmentByPronunciation(
      textAr: 'رَبَّنَا آمَنَّا فَاكْتُبْنَا مَعَ الشَّاهِدِينَ',
      pronunciationTr: 'Rabbenâ âmennâ fektübnâ meaş-şâhidîn.',
      pronunciationEn: "Rabbana amanna faktubna ma'ash-shahidin.",
      meaningTr: 'Rabbimiz! İman ettik; bizi şahitlerle beraber yaz.',
      meaningEn: 'Our Lord, we believe, so record us among the witnesses.',
    );
    expect(r, hasLength(1));
    expect(r.single.meaningTr, 'Rabbimiz! İman ettik; bizi şahitlerle beraber yaz.');
    expect(r.single.meaningEn, isNotNull);
  });

  test('çok satırlı duada anlamlar satıra yazılmaz (Claude hizalar)', () {
    final r = segmentByPronunciation(
      textAr: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
      pronunciationTr: 'Rabbişrah lî sadrî. Ve yessir lî emrî.',
      meaningTr: 'Rabbim! Gönlüme genişlik ver. İşimi kolaylaştır.',
    );
    expect(r, hasLength(2));
    expect(r.every((s) => s.meaningTr == null), isTrue);
  });

  test('İngilizce okunuş cümle sayısı uymazsa satırlara yazılmaz', () {
    final r = segmentByPronunciation(
      textAr: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
      pronunciationTr: 'Rabbişrah lî sadrî. Ve yessir lî emrî.',
      pronunciationEn: 'Rabbi-shrah li sadri wa yassir li amri.',
    );
    expect(r.every((s) => s.pronunciationEn == null), isTrue);
  });

  test('Arapça metin kelime kelime korunur', () {
    const ar = 'رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ وَاعْفُ عَنَّا';
    final r = segmentByPronunciation(textAr: ar, pronunciationTr: "Rabbenâ ve lâ tuhammilnâ mâ lâ tâkate lenâ bih. Va'fü annâ.");
    expect(noSpace(r.map((s) => s.textAr).join()), noSpace(ar));
  });

  test('okunuş yoksa Arapça noktalamaya göre bölünür', () {
    final r = segmentByPronunciation(textAr: 'أ، ب.');
    expect(r.map((s) => s.textAr), ['أ،', 'ب.']);
    expect(r.first.pronunciationTr, isNull);
  });
}
