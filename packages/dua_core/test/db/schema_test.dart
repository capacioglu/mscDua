import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

void main() {
  late ContentDatabase db;

  setUp(() => db = ContentDatabase.memory());
  tearDown(() => db.close());

  Future<int> addCategory(String name) =>
      db.into(db.categories).insert(CategoriesCompanion.insert(nameTr: name));

  test('dua iki kategoride ve iki grupta olabilir', () async {
    await db.into(db.duas).insert(DuasCompanion.insert(id: 'DUA-0030', titleTr: "Hz. Âdem'in Tövbe Duası"));
    final c1 = await addCategory('Ramazan');
    final c2 = await addCategory('40 Rabbenâ');
    await db.into(db.duaCategories).insert(DuaCategoriesCompanion.insert(duaId: 'DUA-0030', categoryId: c1));
    await db.into(db.duaCategories).insert(DuaCategoriesCompanion.insert(duaId: 'DUA-0030', categoryId: c2));
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'GRP-005', titleTr: 'Ramazan Kunut Duaları'));
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'GRP-TMP-40-rabbena', titleTr: '40 Rabbenâ'));
    await db.into(db.groupItems).insert(
        GroupItemsCompanion.insert(groupId: 'GRP-005', duaId: 'DUA-0030', position: const Value(3)));
    await db.into(db.groupItems).insert(GroupItemsCompanion.insert(groupId: 'GRP-TMP-40-rabbena', duaId: 'DUA-0030'));

    expect(await db.categoriesOf('DUA-0030'), {'Ramazan', '40 Rabbenâ'});
    final groups = await db.groupsOf('DUA-0030');
    expect(groups, hasLength(2));
    expect(groups.firstWhere((g) => g.groupId == 'GRP-005').position, 3);
    expect(groups.firstWhere((g) => g.groupId == 'GRP-TMP-40-rabbena').position, isNull);
  });

  test('track sahibi tam olarak bir tane olmalı', () async {
    await db.into(db.duas).insert(DuasCompanion.insert(id: 'D1', titleTr: 'x'));
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'G1', titleTr: 'g'));
    expect(
      () => db.into(db.tracks).insert(TracksCompanion.insert(
          ownerKind: TrackOwnerKind.dua,
          duaId: const Value('D1'),
          groupId: const Value('G1'),
          relPath: 'audio/a.mp3',
          label: 'x')),
      throwsA(anything),
    );
    expect(
      () => db.into(db.tracks).insert(
          TracksCompanion.insert(ownerKind: TrackOwnerKind.dua, relPath: 'audio/a.mp3', label: 'x')),
      throwsA(anything),
    );
  });

  test('dua silinince segment, kategori bağı ve grup öğesi silinir', () async {
    await db.into(db.duas).insert(DuasCompanion.insert(id: 'D1', titleTr: 'x'));
    final c = await addCategory('K');
    await db.into(db.duaCategories).insert(DuaCategoriesCompanion.insert(duaId: 'D1', categoryId: c));
    await db.into(db.groups).insert(GroupsCompanion.insert(id: 'G1', titleTr: 'g'));
    await db.into(db.groupItems).insert(GroupItemsCompanion.insert(groupId: 'G1', duaId: 'D1'));
    await db.into(db.segments).insert(SegmentsCompanion.insert(duaId: 'D1', position: 0, textAr: 'نص'));

    await (db.delete(db.duas)..where((t) => t.id.equals('D1'))).go();

    expect(await db.select(db.segments).get(), isEmpty);
    expect(await db.select(db.duaCategories).get(), isEmpty);
    expect(await db.select(db.groupItems).get(), isEmpty);
  });

  test('arapça metin bayt bayt saklanır', () async {
    const text = 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَعَلَىٰ';
    await db.into(db.duas).insert(DuasCompanion.insert(id: 'D1', titleTr: 'x'));
    await db.into(db.segments).insert(SegmentsCompanion.insert(duaId: 'D1', position: 0, textAr: text));
    final row = await db.select(db.segments).getSingle();
    expect(row.textAr, text);
    expect(utf8.encode(row.textAr), utf8.encode(text));
    expect(row.review, ReviewStatus.none);
  });
}
