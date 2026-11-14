import 'package:drift/drift.dart';

import '../db/database.dart';
import '../model/enums.dart';
import '../rules/approval.dart';

const pendingFormat = 'dualarim.translation.pending/1';
const doneFormat = 'dualarim.translation.done/1';

class TranslationImportReport {
  int applied = 0;
  final List<int> staleSegmentIds = [];
  final List<int> skippedApprovedIds = [];
  final List<String> errors = [];
}

/// Çevirisi eksik (`none`) satırları olan duaları Claude için dışa aktarır.
Future<Map<String, dynamic>> buildPending(ContentDatabase db, {Set<String>? duaIds}) async {
  final pendingSegs = await (db.select(db.segments)
        ..where((t) => t.review.equalsValue(ReviewStatus.none))
        ..orderBy([(t) => OrderingTerm.asc(t.duaId), (t) => OrderingTerm.asc(t.position)]))
      .get();
  final ids = pendingSegs.map((s) => s.duaId).toSet().where((id) => duaIds == null || duaIds.contains(id));
  final out = <Map<String, dynamic>>[];
  for (final id in ids.toList()..sort()) {
    final d = await (db.select(db.duas)..where((t) => t.id.equals(id))).getSingle();
    out.add({
      'dua_id': d.id,
      'title_tr': d.titleTr,
      'variant_of': d.variantOf,
      'quran_reference': d.quranReference,
      'source': {
        'pronunciation_tr': d.srcPronunciationTr,
        'pronunciation_en': d.srcPronunciationEn,
        'meaning_tr': d.srcMeaningTr,
        'meaning_en': d.srcMeaningEn,
      },
      'segments': [
        for (final s in await db.segmentsOf(id))
          {
            'segment_id': s.id,
            'position': s.position,
            'text_ar': s.textAr,
            'pronunciation_tr': s.pronunciationTr,
            'pronunciation_en': s.pronunciationEn,
            'meaning_tr': s.meaningTr,
            'meaning_en': s.meaningEn,
            'review': s.review.name,
          }
      ],
    });
  }
  return {'format': pendingFormat, 'generated_at': DateTime.now().toIso8601String(), 'duas': out};
}

/// Claude'un `done.json` dosyasını uygular. Kurallar: Arapça birebir aynı olmalı,
/// onaylı satıra ve kullanıcının düzelttiği alana dokunulmaz.
Future<TranslationImportReport> applyDone(ContentDatabase db, Map<String, dynamic> done) async {
  if (done['format'] != doneFormat) throw FormatException('Beklenmeyen format: ${done['format']}');
  final report = TranslationImportReport();
  await db.transaction(() async {
    for (final e in ((done['segments'] as List?) ?? []).cast<Map<String, dynamic>>()) {
      final id = e['segment_id'] as int;
      final s = await (db.select(db.segments)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (s == null) {
        report.errors.add('Satır $id bulunamadı');
        continue;
      }
      if (s.textAr != e['text_ar']) {
        report.staleSegmentIds.add(id);
        continue;
      }
      if (s.review == ReviewStatus.approved) {
        report.skippedApprovedIds.add(id);
        continue;
      }
      Value<String?> val(String key, FieldSource? src) {
        final v = e[key] as String?;
        if (v == null || v.trim().isEmpty || src == FieldSource.user) return const Value.absent();
        return Value(v.trim());
      }

      Value<FieldSource?> srcOf(Value<String?> v) => v.present ? const Value(FieldSource.claude) : const Value.absent();
      final pTr = val('pronunciation_tr', s.pronunciationTrSource);
      final pEn = val('pronunciation_en', s.pronunciationEnSource);
      final mTr = val('meaning_tr', s.meaningTrSource);
      final mEn = val('meaning_en', s.meaningEnSource);
      await (db.update(db.segments)..where((t) => t.id.equals(id))).write(SegmentsCompanion(
        pronunciationTr: pTr,
        pronunciationEn: pEn,
        meaningTr: mTr,
        meaningEn: mEn,
        pronunciationTrSource: srcOf(pTr),
        pronunciationEnSource: srcOf(pEn),
        meaningTrSource: srcOf(mTr),
        meaningEnSource: srcOf(mEn),
      ));
      final updated = await (db.select(db.segments)..where((t) => t.id.equals(id))).getSingle();
      await (db.update(db.segments)..where((t) => t.id.equals(id))).write(SegmentsCompanion(
        review: Value(canApprove(updated) ? ReviewStatus.review : ReviewStatus.none),
      ));
      report.applied++;
    }
  });
  return report;
}
