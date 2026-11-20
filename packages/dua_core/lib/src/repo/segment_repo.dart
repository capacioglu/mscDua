import 'package:drift/drift.dart';

import '../db/database.dart';
import '../model/enums.dart';
import '../rules/approval.dart';
import '../text/arabic_segmenter.dart';
import '../text/turkish_segmenter.dart';

/// Satır düzenleme işlemleri; onay kurallarını (spec §6.5.1) uygular.
class SegmentRepo {
  SegmentRepo(this.db);
  final ContentDatabase db;

  Future<Segment> _get(int id) => (db.select(db.segments)..where((t) => t.id.equals(id))).getSingle();

  SegmentsCompanion _clearedTranslations() => const SegmentsCompanion(
        pronunciationTr: Value(null),
        pronunciationEn: Value(null),
        meaningTr: Value(null),
        meaningEn: Value(null),
        pronunciationTrSource: Value(null),
        pronunciationEnSource: Value(null),
        meaningTrSource: Value(null),
        meaningEnSource: Value(null),
        review: Value(ReviewStatus.none),
      );

  /// Yalnızca Türkçe duada satırın ana metni `meaningTr`'dedir (`textAr` boş).
  Future<bool> _isTurkish(String duaId) async =>
      (await (db.select(db.duas)..where((t) => t.id.equals(duaId))).getSingleOrNull())?.textLanguage == 'tr';

  Future<void> _renumber(String duaId, [List<int>? order]) async {
    final ids = order ?? (await db.segmentsOf(duaId)).map((s) => s.id).toList();
    for (var i = 0; i < ids.length; i++) {
      await (db.update(db.segments)..where((t) => t.id.equals(ids[i]))).write(SegmentsCompanion(position: Value(i)));
    }
  }

  Future<void> updateArabic(int segId, String text) async {
    final s = await _get(segId);
    final trimmed = text.trim();
    if (trimmed == s.textAr) return;
    await (db.update(db.segments)..where((t) => t.id.equals(segId))).write(SegmentsCompanion(
      textAr: Value(trimmed),
      review: Value(s.review == ReviewStatus.none ? ReviewStatus.none : ReviewStatus.review),
    ));
  }

  Future<void> updateField(int segId, SegmentField f, String? value) async {
    final v = (value == null || value.trim().isEmpty) ? null : value.trim();
    final src = Value(v == null ? null : FieldSource.user);
    final c = switch (f) {
      SegmentField.pronunciationTr => SegmentsCompanion(pronunciationTr: Value(v), pronunciationTrSource: src),
      SegmentField.pronunciationEn => SegmentsCompanion(pronunciationEn: Value(v), pronunciationEnSource: src),
      SegmentField.meaningTr => SegmentsCompanion(meaningTr: Value(v), meaningTrSource: src),
      SegmentField.meaningEn => SegmentsCompanion(meaningEn: Value(v), meaningEnSource: src),
    };
    await (db.update(db.segments)..where((t) => t.id.equals(segId))).write(c);
    final s = await _get(segId);
    // Kullanıcı bir alanı tamamen silerse onaylı satır artık geçerli olamaz.
    if (s.review == ReviewStatus.approved && !canApprove(s)) {
      await (db.update(db.segments)..where((t) => t.id.equals(segId)))
          .write(const SegmentsCompanion(review: Value(ReviewStatus.review)));
    }
    // Çevirisiz satır, zorunlu alanları tamamlanınca gözden geçirilecek olur (eksikken kuyrukta kalır).
    if (s.review == ReviewStatus.none && canApprove(s)) {
      await (db.update(db.segments)..where((t) => t.id.equals(segId)))
          .write(const SegmentsCompanion(review: Value(ReviewStatus.review)));
    }
  }

  Future<void> approve(int segId) async {
    final s = await _get(segId);
    if (!canApprove(s)) throw StateError('Satır onaylanamaz: eksik alan var');
    await (db.update(db.segments)..where((t) => t.id.equals(segId)))
        .write(const SegmentsCompanion(review: Value(ReviewStatus.approved)));
  }

  Future<void> unapprove(int segId) => (db.update(db.segments)..where((t) => t.id.equals(segId)))
      .write(const SegmentsCompanion(review: Value(ReviewStatus.review)));

  Future<int> approveAll(String duaId) => db.transaction(() async {
        var n = 0;
        for (final s in await db.segmentsOf(duaId)) {
          if (s.review != ReviewStatus.approved && canApprove(s)) {
            await approve(s.id);
            n++;
          }
        }
        return n;
      });

  /// Satırı [charOffset] (UTF-16 kod birimi) noktasından ikiye böler.
  Future<(int, int)> split(int segId, int charOffset) => db.transaction(() async {
        final s = await _get(segId);
        final tr = await _isTurkish(s.duaId);
        final main = tr ? (s.meaningTr ?? '') : s.textAr;
        final a = main.substring(0, charOffset).trim();
        final b = main.substring(charOffset).trim();
        if (a.isEmpty || b.isEmpty) throw ArgumentError('Bölme noktası satırın içinde olmalı');
        await (db.update(db.segments)..where((t) => t.id.equals(segId))).write(tr
            ? _clearedTranslations().copyWith(meaningTr: Value(a), meaningTrSource: const Value(FieldSource.user))
            : _clearedTranslations().copyWith(textAr: Value(a)));
        final newId = await db.into(db.segments).insert(SegmentsCompanion.insert(
              duaId: s.duaId,
              position: s.position, // aşağıda yeniden numaralanır
              textAr: tr ? '' : b,
              meaningTr: Value(tr ? b : null),
              meaningTrSource: Value(tr ? FieldSource.user : null),
            ));
        final order = (await db.segmentsOf(s.duaId)).map((x) => x.id).where((id) => id != newId).toList();
        order.insert(order.indexOf(segId) + 1, newId);
        await _renumber(s.duaId, order);
        return (segId, newId);
      });

  /// Satırı bir sonrakiyle birleştirir; sonrakinin cue'ları bu satıra taşınır.
  Future<int> merge(int firstSegId) => db.transaction(() async {
        final s = await _get(firstSegId);
        final segs = await db.segmentsOf(s.duaId);
        final idx = segs.indexWhere((x) => x.id == firstSegId);
        if (idx < 0 || idx + 1 >= segs.length) throw StateError('Birleştirilecek sonraki satır yok');
        final next = segs[idx + 1];
        await (db.update(db.cues)..where((c) => c.segmentId.equals(next.id)))
            .write(CuesCompanion(segmentId: Value(firstSegId)));
        final tr = await _isTurkish(s.duaId);
        await (db.update(db.segments)..where((t) => t.id.equals(firstSegId))).write(tr
            ? _clearedTranslations().copyWith(
                meaningTr: Value('${s.meaningTr ?? ''} ${next.meaningTr ?? ''}'.trim()),
                meaningTrSource: const Value(FieldSource.user))
            : _clearedTranslations().copyWith(textAr: Value(mergeArabic(s.textAr, next.textAr))));
        await (db.delete(db.segments)..where((t) => t.id.equals(next.id))).go();
        await _renumber(s.duaId);
        return firstSegId;
      });

  Future<void> move(int segId, int newPosition) => db.transaction(() async {
        final s = await _get(segId);
        final order = (await db.segmentsOf(s.duaId)).map((x) => x.id).toList()..remove(segId);
        order.insert(newPosition.clamp(0, order.length), segId);
        await _renumber(s.duaId, order);
      });

  /// Duanın tüm satırlarını yapıştırılan metinden yeniden oluşturur.
  Future<void> replaceAllFromText(String duaId, String text) => db.transaction(() async {
        final segIds = (await db.segmentsOf(duaId)).map((s) => s.id).toList();
        if (segIds.isNotEmpty) {
          final cued = await (db.select(db.cues)..where((c) => c.segmentId.isIn(segIds))).get();
          if (cued.isNotEmpty) throw StateError('Zamanlanmış satırlar var');
        }
        await (db.delete(db.segments)..where((t) => t.duaId.equals(duaId))).go();
        if (await _isTurkish(duaId)) {
          final parts = splitTurkish(text);
          for (var i = 0; i < parts.length; i++) {
            await db.into(db.segments).insert(SegmentsCompanion.insert(
                duaId: duaId,
                position: i,
                textAr: '',
                meaningTr: Value(parts[i]),
                meaningTrSource: const Value(FieldSource.user)));
          }
          return;
        }
        final parts = splitArabic(text);
        for (var i = 0; i < parts.length; i++) {
          await db.into(db.segments).insert(SegmentsCompanion.insert(duaId: duaId, position: i, textAr: parts[i]));
        }
      });
}
