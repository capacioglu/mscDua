import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../model/enums.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Duas,
  Categories,
  DuaCategories,
  Groups,
  GroupCategories,
  GroupItems,
  Segments,
  Tracks,
  Cues,
  ImportLogs,
])
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase(super.e);

  static ContentDatabase open(File file) => ContentDatabase(NativeDatabase(file));

  static ContentDatabase memory() => ContentDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<Set<String>> categoriesOf(String duaId) async {
    final q = select(categories).join([
      innerJoin(duaCategories, duaCategories.categoryId.equalsExp(categories.id)),
    ])
      ..where(duaCategories.duaId.equals(duaId));
    final rows = await q.get();
    return rows.map((r) => r.readTable(categories).nameTr).toSet();
  }

  Future<List<GroupItem>> groupsOf(String duaId) =>
      (select(groupItems)..where((t) => t.duaId.equals(duaId))).get();

  Future<List<Segment>> segmentsOf(String duaId) => (select(segments)
        ..where((t) => t.duaId.equals(duaId))
        ..orderBy([(t) => OrderingTerm.asc(t.position)]))
      .get();

  /// Kategoriyi adına göre bulur, yoksa oluşturur.
  Future<int> ensureCategory(String nameTr) async {
    final existing = await (select(categories)..where((t) => t.nameTr.equals(nameTr))).getSingleOrNull();
    if (existing != null) return existing.id;
    return into(categories).insert(CategoriesCompanion.insert(nameTr: nameTr));
  }
}
