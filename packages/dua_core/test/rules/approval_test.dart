import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

import '../helpers.dart';

Segment seg({String? pTr = 'p', String? pEn, String? mTr = 'm', String? mEn = 'e', ReviewStatus r = ReviewStatus.review}) =>
    Segment(
        id: 1,
        duaId: 'D',
        position: 0,
        textAr: 'نص',
        pronunciationTr: pTr,
        pronunciationEn: pEn,
        meaningTr: mTr,
        meaningEn: mEn,
        review: r);

void main() {
  group('canApprove', () {
    test('meaningEn boşsa onaylanamaz', () => expect(canApprove(seg(mEn: null)), isFalse));
    test('yalnızca boşluk da boş sayılır', () => expect(canApprove(seg(pTr: '  ')), isFalse));
    test('pronunciationEn isteğe bağlı', () => expect(canApprove(seg(pEn: null)), isTrue));
  });

  group('computeProgress', () {
    test('satır yoksa taslak', () => expect(computeProgress([]), DuaProgress.draft));
    test('çevirisiz satır varsa çeviri bekliyor',
        () => expect(computeProgress([seg(r: ReviewStatus.approved), seg(r: ReviewStatus.none)]), DuaProgress.awaitingTranslation));
    test('gözden geçirilecek varsa',
        () => expect(computeProgress([seg(r: ReviewStatus.approved), seg(r: ReviewStatus.review)]), DuaProgress.inReview));
    test('hepsi onaylıysa onaylı',
        () => expect(computeProgress([seg(r: ReviewStatus.approved), seg(r: ReviewStatus.approved)]), DuaProgress.approved));
  });

  group('checkPublishable', () {
    late ContentDatabase db;
    setUp(() => db = ContentDatabase.memory());
    tearDown(() => db.close());

    test('yayına hazır + onaylı + tam zamanlı dua kaydı → ok', () async {
      final s = await seedDua(db, 'D1', ['أ', 'ب'], approved: true, ready: true);
      final t = await addDuaTrack(db, 'D1');
      await addCue(db, t, 0, s[0]);
      await addCue(db, t, 1000, s[1]);
      final r = await checkPublishable(db, 'D1');
      expect(r.ok, isTrue, reason: r.reasons.join());
      expect(r.fullyTimedTrackIds, [t]);
    });

    test('tam zamanlı grup kaydı da yeterli', () async {
      final s = await seedDua(db, 'D1', ['أ', 'ب'], approved: true, ready: true);
      await db.into(db.groups).insert(GroupsCompanion.insert(id: 'G', titleTr: 'g'));
      await db.into(db.groupItems).insert(GroupItemsCompanion.insert(groupId: 'G', duaId: 'D1', position: const Value(1)));
      final t = await addGroupTrack(db, 'G');
      await addCue(db, t, 0, null);
      await addCue(db, t, 500, s[0]);
      await addCue(db, t, 900, s[1]);
      final r = await checkPublishable(db, 'D1');
      expect(r.ok, isTrue, reason: r.reasons.join());
      expect(r.fullyTimedTrackIds, [t]);
    });

    test('nedenler Türkçe listelenir', () async {
      final s = await seedDua(db, 'D1', ['أ', 'ب'], translated: true);
      final t = await addDuaTrack(db, 'D1');
      await addCue(db, t, 0, s[0]);
      final r = await checkPublishable(db, 'D1');
      expect(r.ok, isFalse);
      expect(r.reasons, containsAll(['Yayına hazır işaretli değil', 'Onaylanmamış satır: 2', 'Tam zamanlanmış ses kaydı yok']));
    });

    test('satırsız dua', () async {
      await seedDua(db, 'D1', [], ready: true);
      expect((await checkPublishable(db, 'D1')).reasons, contains('Satır yok'));
    });
  });
}
