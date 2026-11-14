import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

void main() {
  const s1 = 11, s2 = 12, s3 = 13;
  late CueTimeline t;
  setUp(() => t = CueTimeline([s1, s2, s3], []));

  test('imleç baştan başlar, işaretledikçe ilerler', () {
    expect(t.nextSegmentId, s1);
    t.markNext(1000);
    t.markNext(4000);
    expect(t.nextSegmentId, s3);
    expect(t.untimedSegments, {s3});
  });

  test('metinsiz bölüm ve aktif cue', () {
    t.markNext(1000);
    t.markNext(4000);
    t.markGap(6000);
    expect(t.activeAt(5000)!.segmentId, s2);
    final gap = t.activeAt(6500)!;
    expect(gap.segmentId, isNull);
    expect(t.activeAt(500), isNull);
  });

  test('aynı satır tekrar işaretlenebilir', () {
    t.markNext(1000);
    t.markNext(4000);
    t.selectNext(s1);
    t.markNext(7000);
    expect(t.sorted.where((c) => c.segmentId == s1).map((c) => c.startMs), [1000, 7000]);
    expect(t.nextSegmentId, s2);
  });

  test('kaydırma komşu cue\'yu geçemez ve sıfırın altına inemez', () {
    final a = t.markNext(1000);
    final b = t.markNext(1050);
    t.nudge(a, 100);
    expect(a.startMs, 1049);
    t.nudge(a, -5000);
    expect(a.startMs, 0);
    t.move(b, 0); // önceki cue (0 ms) ile çakışamaz
    expect(b.startMs, 1);
  });

  test('silme ve sıralama', () {
    final c3 = CueEntry(startMs: 3000, segmentId: s3);
    final c1 = CueEntry(startMs: 1000, segmentId: s1);
    t = CueTimeline([s1, s2, s3], [c3, c1]);
    expect(t.sorted.map((c) => c.startMs), [1000, 3000]);
    expect(t.nextSegmentId, isNull); // en son işaretlenen s3, ondan sonra satır yok
    t.remove(c1);
    expect(t.sorted, [c3]);
  });

  test('yüklenen cue\'larda imleç son işaretli satırdan sonrakidir', () {
    t = CueTimeline([s1, s2, s3], [CueEntry(startMs: 0, segmentId: s1), CueEntry(startMs: 900, segmentId: s2)]);
    expect(t.nextSegmentId, s3);
    t.markNext(2000);
    expect(t.nextSegmentId, isNull);
    expect(() => t.markNext(3000), throwsStateError);
  });
}
