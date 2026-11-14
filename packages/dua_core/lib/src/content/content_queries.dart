import 'package:drift/drift.dart';

import '../db/database.dart';
import '../text/search_normalize.dart';

/// Bir duanın ekranda ve oynatmada gereken her şeyi.
class DuaView {
  DuaView({
    required this.dua,
    required this.segments,
    required this.tracks,
    required this.cuesByTrack,
    required this.variants,
    required this.categories,
  });
  final Dua dua;
  final List<Segment> segments;
  final List<Track> tracks;
  final Map<int, List<Cue>> cuesByTrack;
  final List<Dua> variants;
  final List<String> categories;
}

class GroupEntry {
  GroupEntry(this.item, this.dua);
  final GroupItem item;
  final Dua dua;
}

/// Mobil uygulamanın (salt okunur) içerik sorguları.
class ContentQueries {
  ContentQueries(this.db);
  final ContentDatabase db;

  Future<List<DuaGroup>> groups() =>
      (db.select(db.groups)..orderBy([(t) => OrderingTerm.asc(t.sortOrder), (t) => OrderingTerm.asc(t.id)])).get();

  Future<List<GroupEntry>> groupEntries(String groupId) async {
    final items = await (db.select(db.groupItems)
          ..where((t) => t.groupId.equals(groupId))
          ..orderBy([(t) => OrderingTerm.asc(t.position), (t) => OrderingTerm.asc(t.id)]))
        .get();
    final duas = {for (final d in await db.select(db.duas).get()) d.id: d};
    return [for (final i in items) if (duas[i.duaId] != null) GroupEntry(i, duas[i.duaId]!)];
  }

  Future<List<Category>> categories() =>
      (db.select(db.categories)..orderBy([(t) => OrderingTerm.asc(t.sortOrder), (t) => OrderingTerm.asc(t.nameTr)])).get();

  Future<List<Dua>> duasInCategory(int categoryId) async {
    final ids = (await (db.select(db.duaCategories)..where((t) => t.categoryId.equals(categoryId))).get())
        .map((l) => l.duaId)
        .toSet();
    return (await allStandalone()).where((d) => ids.contains(d.id)).toList();
  }

  Future<List<Dua>> allStandalone() => (db.select(db.duas)
        ..where((t) => t.standaloneVisible.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();

  Future<DuaView> duaView(String id) async {
    final dua = await (db.select(db.duas)..where((t) => t.id.equals(id))).getSingle();
    final tracks = await (db.select(db.tracks)
          ..where((t) => t.duaId.equals(id))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
    final cues = <int, List<Cue>>{};
    for (final t in tracks) {
      cues[t.id] = await (db.select(db.cues)
            ..where((c) => c.trackId.equals(t.id))
            ..orderBy([(c) => OrderingTerm.asc(c.startMs)]))
          .get();
    }
    return DuaView(
      dua: dua,
      segments: await db.segmentsOf(id),
      tracks: tracks,
      cuesByTrack: cues,
      variants: await (db.select(db.duas)
            ..where((t) => t.variantOf.equals(id))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get(),
      categories: (await db.categoriesOf(id)).toList(),
    );
  }

  /// Arapça harf içeren sorgu satır metinlerinde (harekesiz), diğerleri başlık,
  /// okunuş, anlam ve kategori adlarında aranır.
  Future<List<Dua>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final duas = await allStandalone();
    final segs = await db.select(db.segments).get();
    final segsBy = <String, List<Segment>>{};
    for (final s in segs) {
      segsBy.putIfAbsent(s.duaId, () => []).add(s);
    }
    if (containsArabic(q)) {
      final nq = normalizeArabic(q);
      return duas
          .where((d) => normalizeArabic((segsBy[d.id] ?? const []).map((s) => s.textAr).join(' ')).contains(nq))
          .toList();
    }
    final nq = normalizeLatin(q);
    final cats = {for (final c in await db.select(db.categories).get()) c.id: c};
    final catsBy = <String, List<String>>{};
    for (final l in await db.select(db.duaCategories).get()) {
      final c = cats[l.categoryId];
      if (c != null) catsBy.putIfAbsent(l.duaId, () => []).addAll([c.nameTr, c.nameEn ?? '']);
    }
    return duas.where((d) {
      final hay = normalizeLatin([
        d.id,
        d.titleTr,
        d.titleEn,
        d.srcPronunciationTr,
        d.srcPronunciationEn,
        d.srcMeaningTr,
        d.srcMeaningEn,
        ...?catsBy[d.id],
        for (final s in segsBy[d.id] ?? const <Segment>[]) ...[s.pronunciationTr, s.meaningTr],
      ].whereType<String>().join(' '));
      return hay.contains(nq);
    }).toList();
  }
}
