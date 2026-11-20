import 'package:drift/drift.dart';

import '../db/database.dart';
import '../model/enums.dart';

bool _filled(String? s) => s != null && s.trim().isNotEmpty;

/// Bir satır onaylanabilir mi: Arapça, Türkçe okunuş, Türkçe ve İngilizce anlam dolu.
bool canApprove(Segment s) =>
    _filled(s.textAr) && _filled(s.pronunciationTr) && _filled(s.meaningTr) && _filled(s.meaningEn);

enum DuaProgress { draft, awaitingTranslation, inReview, approved }

DuaProgress computeProgress(List<Segment> segments) {
  if (segments.isEmpty) return DuaProgress.draft;
  if (segments.any((s) => s.review == ReviewStatus.none)) return DuaProgress.awaitingTranslation;
  if (segments.any((s) => s.review == ReviewStatus.review)) return DuaProgress.inReview;
  return DuaProgress.approved;
}

class PublishCheck {
  PublishCheck(this.reasons, this.fullyTimedTrackIds);
  final List<String> reasons;
  final List<int> fullyTimedTrackIds;
  bool get ok => reasons.isEmpty;
}

/// Duanın satırlarının tamamına cue'su olan kayıtlar (dua kaydı veya üyesi olduğu grubun kaydı).
Future<List<int>> fullyTimedTracks(ContentDatabase db, String duaId) async {
  final segIds = (await db.segmentsOf(duaId)).map((s) => s.id).toSet();
  if (segIds.isEmpty) return [];
  final groupIds = (await db.groupsOf(duaId)).map((g) => g.groupId).toList();
  final tracks = await (db.select(db.tracks)
        ..where((t) => t.duaId.equals(duaId) | t.groupId.isIn(groupIds))
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final result = <int>[];
  for (final t in tracks) {
    final cued = (await (db.select(db.cues)..where((c) => c.trackId.equals(t.id))).get())
        .map((c) => c.segmentId)
        .whereType<int>()
        .toSet();
    if (cued.containsAll(segIds)) result.add(t.id);
  }
  return result;
}

Future<PublishCheck> checkPublishable(ContentDatabase db, String duaId) async {
  final segs = await db.segmentsOf(duaId);
  // Kullanıcı kararları: JSON doğru kabul (2026-11-14); ses zorunlu değil, sesi
  // olmayan dua metin olarak yayınlanır (2026-11-20). Yayın koşulu: satır var.
  final reasons = <String>[];
  if (segs.isEmpty) reasons.add('Satır yok');
  final timed = await fullyTimedTracks(db, duaId);
  return PublishCheck(reasons, timed);
}
