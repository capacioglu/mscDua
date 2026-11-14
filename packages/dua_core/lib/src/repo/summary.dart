import 'package:drift/drift.dart';

import '../db/database.dart';
import '../rules/approval.dart';

/// Zamanlama durumu (kullanıcının asıl işi: ses ekle ve zamanla).
enum TimingProgress { noAudio, untimed, partial, ready }

String timingLabel(TimingProgress t) => switch (t) {
      TimingProgress.noAudio => 'Ses yok',
      TimingProgress.untimed => 'Zamanlanmadı',
      TimingProgress.partial => 'Kısmen zamanlandı',
      TimingProgress.ready => 'Hazır',
    };

/// Editörün dua listesinde bir satır.
class DuaSummary {
  DuaSummary({
    required this.dua,
    required this.progress,
    required this.categories,
    required this.groupIds,
    required this.trackCount,
    required this.segmentCount,
    required this.timing,
  });
  final Dua dua;
  final DuaProgress progress;
  final List<String> categories;
  final List<String> groupIds;
  final int trackCount;
  final int segmentCount;
  final TimingProgress timing;

  String get id => dua.id;
  String get titleTr => dua.titleTr;
  String? get variantOf => dua.variantOf;

  /// Kaynağı doğrulanmamış metin veya JSON'da fark varsa uyarı.
  bool get hasWarning =>
      dua.importDiff != null ||
      (dua.editorialStatus != null && dua.editorialStatus != 'source_identified' && dua.variantOf == null);
}

String progressLabel(DuaProgress p) => switch (p) {
      DuaProgress.draft => 'Taslak',
      DuaProgress.awaitingTranslation => 'Çeviri bekliyor',
      DuaProgress.inReview => 'Gözden geçirilecek',
      DuaProgress.approved => 'Onaylı',
    };

Future<List<DuaSummary>> listDuaSummaries(ContentDatabase db) async {
  final duas = await (db.select(db.duas)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
  final segs = await db.select(db.segments).get();
  final segsBy = <String, List<Segment>>{};
  for (final s in segs) {
    segsBy.putIfAbsent(s.duaId, () => []).add(s);
  }
  final cats = {for (final c in await db.select(db.categories).get()) c.id: c.nameTr};
  final catsBy = <String, List<String>>{};
  for (final l in await db.select(db.duaCategories).get()) {
    catsBy.putIfAbsent(l.duaId, () => []).add(cats[l.categoryId]!);
  }
  final groupsBy = <String, List<String>>{};
  for (final g in await db.select(db.groupItems).get()) {
    groupsBy.putIfAbsent(g.duaId, () => []).add(g.groupId);
  }
  final tracks = await db.select(db.tracks).get();
  final tracksBy = <String, int>{};
  for (final t in tracks) {
    if (t.duaId != null) tracksBy[t.duaId!] = (tracksBy[t.duaId!] ?? 0) + 1;
  }
  final cuedBy = <int, Set<int>>{};
  for (final c in await db.select(db.cues).get()) {
    if (c.segmentId != null) cuedBy.putIfAbsent(c.trackId, () => {}).add(c.segmentId!);
  }
  TimingProgress timingOf(String duaId) {
    final groups = (groupsBy[duaId] ?? const []).toSet();
    final relevant = tracks.where((t) => t.duaId == duaId || (t.groupId != null && groups.contains(t.groupId)));
    if (relevant.isEmpty) return TimingProgress.noAudio;
    final segIds = (segsBy[duaId] ?? const []).map((s) => s.id).toSet();
    var any = false;
    for (final t in relevant) {
      final cued = cuedBy[t.id] ?? const <int>{};
      if (segIds.isNotEmpty && cued.containsAll(segIds)) return TimingProgress.ready;
      if (cued.any(segIds.contains)) any = true;
    }
    return any ? TimingProgress.partial : TimingProgress.untimed;
  }
  return [
    for (final d in duas)
      DuaSummary(
        dua: d,
        progress: computeProgress(segsBy[d.id] ?? const []),
        categories: catsBy[d.id] ?? const [],
        groupIds: groupsBy[d.id] ?? const [],
        trackCount: tracksBy[d.id] ?? 0,
        segmentCount: segsBy[d.id]?.length ?? 0,
        timing: timingOf(d.id),
      ),
  ];
}
