import 'package:drift/drift.dart';

import '../model/enums.dart';

class Duas extends Table {
  TextColumn get id => text()();
  TextColumn get titleTr => text()();
  TextColumn get titleEn => text().nullable()();
  TextColumn get titleAr => text().nullable()();
  TextColumn get variantOf => text().nullable().references(Duas, #id, onDelete: KeyAction.setNull)();
  TextColumn get variantKey => text().nullable()();
  TextColumn get quranReference => text().nullable()();
  TextColumn get editorialStatus => text().nullable()();
  TextColumn get editorialNote => text().nullable()();
  TextColumn get sourceJson => text().nullable()();
  TextColumn get srcPronunciationTr => text().nullable()();
  TextColumn get srcPronunciationEn => text().nullable()();
  TextColumn get srcMeaningTr => text().nullable()();
  TextColumn get srcMeaningEn => text().nullable()();
  TextColumn get expectedAudioFile => text().nullable()();
  BoolColumn get readyToPublish => boolean().withDefault(const Constant(false))();
  IntColumn get version => integer().withDefault(const Constant(0))();
  TextColumn get importDiff => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameTr => text().unique()();
  TextColumn get nameEn => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class DuaCategories extends Table {
  TextColumn get duaId => text().references(Duas, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {duaId, categoryId};
}

@DataClassName('DuaGroup')
class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get titleTr => text()();
  TextColumn get titleEn => text().nullable()();
  TextColumn get titleAr => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get editorialStatus => text().nullable()();
  TextColumn get infoJson => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class GroupCategories extends Table {
  TextColumn get groupId => text().references(Groups, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {groupId, categoryId};
}

class GroupItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get groupId => text().references(Groups, #id, onDelete: KeyAction.cascade)();
  TextColumn get duaId => text().references(Duas, #id, onDelete: KeyAction.cascade)();

  /// null = sırasız üyelik.
  IntColumn get position => integer().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {groupId, duaId}
      ];
}

class Segments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get duaId => text().references(Duas, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get textAr => text()();
  TextColumn get pronunciationTr => text().nullable()();
  TextColumn get pronunciationEn => text().nullable()();
  TextColumn get meaningTr => text().nullable()();
  TextColumn get meaningEn => text().nullable()();
  TextColumn get pronunciationTrSource => textEnum<FieldSource>().nullable()();
  TextColumn get pronunciationEnSource => textEnum<FieldSource>().nullable()();
  TextColumn get meaningTrSource => textEnum<FieldSource>().nullable()();
  TextColumn get meaningEnSource => textEnum<FieldSource>().nullable()();
  TextColumn get review => textEnum<ReviewStatus>().withDefault(Constant(ReviewStatus.none.name))();
}

class Tracks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ownerKind => textEnum<TrackOwnerKind>()();
  TextColumn get duaId => text().nullable().references(Duas, #id, onDelete: KeyAction.cascade)();
  TextColumn get groupId => text().nullable().references(Groups, #id, onDelete: KeyAction.cascade)();

  /// content/ köküne göre göreli, `/` ayraçlı yol.
  TextColumn get relPath => text()();
  TextColumn get label => text()();
  IntColumn get durationMs => integer().nullable()();

  @override
  List<String> get customConstraints => [
        "CHECK ((owner_kind = 'dua' AND dua_id IS NOT NULL AND group_id IS NULL) "
            "OR (owner_kind = 'group' AND group_id IS NOT NULL AND dua_id IS NULL))"
      ];
}

class Cues extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get trackId => integer().references(Tracks, #id, onDelete: KeyAction.cascade)();
  IntColumn get startMs => integer()();

  /// null = metinsiz bölüm (vurgulama yok).
  IntColumn get segmentId => integer().nullable().references(Segments, #id, onDelete: KeyAction.cascade)();
}

class ImportLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get importedAt => dateTime()();
  TextColumn get fileName => text()();
  TextColumn get reportJson => text()();
}
