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
  final dua = await (db.select(db.duas)..where((t) => t.id.equals(duaId))).getSingle();
  final segs = await db.segmentsOf(duaId);
  final reasons = <String>[];
  if (!dua.readyToPublish) reasons.add('Yayına hazır işaretli değil');
  if (segs.isEmpty) reasons.add('Satır yok');
  final unapproved = segs.where((s) => s.review != ReviewStatus.approved).length;
  if (unapproved > 0) reasons.add('Onaylanmamış satır: $unapproved');
  final timed = await fullyTimedTracks(db, duaId);
  if (timed.isEmpty) reasons.add('Tam zamanlanmış ses kaydı yok');
  return PublishCheck(reasons, timed);
}
