import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

Segment seg(int id, String ar, {String? tr, String? en}) =>
    Segment(id: id, duaId: 'D', position: id, textAr: ar, meaningTr: tr, meaningEn: en, review: ReviewStatus.review);

/// Her karakteri 100 ms'de bir okuyan sahte hizalama.
Alignment fakeAlign(String text, {double startSec = 0}) => Alignment(
      chars: text.split(''),
      startsSec: [for (var i = 0; i < text.length; i++) startSec + i * 0.1],
    );

void main() {
  final segs = [seg(1, 'أَ ب', tr: 'Bir', en: 'One'), seg(2, 'جَ', tr: 'İki'), seg(3, 'د', tr: 'Üç', en: 'Three')];

  test('dile göre metin ve satır başları; eksik metin null', () {
    final ar = buildTtsText(segs, 'ar')!;
    expect(ar.text, 'أَ ب\nجَ\nد');
    expect(ar.lineStarts, [0, 5, 8]);
    expect(ar.segmentIds, [1, 2, 3]);
    expect(buildTtsText(segs, 'tr')!.text, 'Bir\nİki\nÜç');
    expect(buildTtsText(segs, 'en'), isNull); // 2. satırın İngilizcesi yok
  });

  test('hash kararlı, metin değişince değişir', () {
    final a = buildTtsText(segs, 'tr')!;
    expect(ttsHash(a), ttsHash(buildTtsText(segs, 'tr')!));
    final changed = [seg(1, 'x', tr: 'Bir!'), segs[1], segs[2]];
    expect(ttsHash(buildTtsText(changed, 'tr')!), isNot(ttsHash(a)));
  });

  test('birebir hizalamada satır başlarının zamanı', () {
    final t = buildTtsText(segs, 'tr')!;
    expect(lineCueMs(t, fakeAlign(t.text)), [0, 400, 800]);
  });

  test('hizalamada satır sonu yerine boşluk ve fazladan boşluk olsa da bulunur', () {
    final t = buildTtsText(segs, 'tr')!;
    expect(lineCueMs(t, fakeAlign('Bir  İki Üç')), [0, 500, 900]);
  });

  test('alakasız hizalama hata verir', () {
    final t = buildTtsText(segs, 'tr')!;
    expect(() => lineCueMs(t, fakeAlign('tamamen başka')), throwsFormatException);
  });

  test('uzun metin satır sınırından parçalanır', () {
    final long = [for (var i = 0; i < 20; i++) seg(i, 'x', tr: 'a' * 499)];
    final t = buildTtsText(long, 'tr')!;
    final parts = chunkTts(t, maxChars: 4500);
    expect(parts.length, 3);
    expect(parts.every((p) => p.text.length <= 4500), isTrue);
    expect(parts.expand((p) => p.segmentIds), [for (var i = 0; i < 20; i++) i]);
    expect(parts[1].lineStarts.first, 0);
  });
}
