import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'user_database.g.dart';

/// Kullanıcının çalma listeleri (içerikten ayrı; içerik güncellenince silinmez).
class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class PlaylistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playlistId => integer().references(Playlists, #id, onDelete: KeyAction.cascade)();

  /// İçerikteki dua kimliği (ör. DUA-0030); içerikte yoksa atlanır.
  TextColumn get duaId => text()();
  IntColumn get position => integer()();
  IntColumn get repeatCount => integer().withDefault(const Constant(1))();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

enum ReadingOption { arabic, pronunciationTr, pronunciationEn, meaningTr, meaningEn }

/// Ekranda ne gösterileceği. En az bir seçenek açık kalır.
class ReadingPrefs {
  const ReadingPrefs({
    this.arabic = true,
    this.pronunciationTr = true,
    this.pronunciationEn = false,
    this.meaningTr = true,
    this.meaningEn = false,
  });
  final bool arabic, pronunciationTr, pronunciationEn, meaningTr, meaningEn;

  bool get(ReadingOption o) => switch (o) {
        ReadingOption.arabic => arabic,
        ReadingOption.pronunciationTr => pronunciationTr,
        ReadingOption.pronunciationEn => pronunciationEn,
        ReadingOption.meaningTr => meaningTr,
        ReadingOption.meaningEn => meaningEn,
      };

  int get _onCount => ReadingOption.values.where(get).length;

  /// Seçeneği tersine çevirir; son açık seçenek kapatılamaz.
  ReadingPrefs toggle(ReadingOption o) {
    if (get(o) && _onCount == 1) return this;
    bool v(ReadingOption x) => x == o ? !get(x) : get(x);
    return ReadingPrefs(
      arabic: v(ReadingOption.arabic),
      pronunciationTr: v(ReadingOption.pronunciationTr),
      pronunciationEn: v(ReadingOption.pronunciationEn),
      meaningTr: v(ReadingOption.meaningTr),
      meaningEn: v(ReadingOption.meaningEn),
    );
  }

  String encode() => ReadingOption.values.where(get).map((o) => o.name).join(',');

  static ReadingPrefs decode(String s) {
    final on = s.split(',').toSet();
    return ReadingPrefs(
      arabic: on.contains('arabic'),
      pronunciationTr: on.contains('pronunciationTr'),
      pronunciationEn: on.contains('pronunciationEn'),
      meaningTr: on.contains('meaningTr'),
      meaningEn: on.contains('meaningEn'),
    );
  }
}

@DriftDatabase(tables: [Playlists, PlaylistItems, Settings])
class UserDatabase extends _$UserDatabase {
  UserDatabase(super.e);

  static UserDatabase open(File file) => UserDatabase(NativeDatabase(file));
  static UserDatabase memory() => UserDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(beforeOpen: (_) async => customStatement('PRAGMA foreign_keys = ON'));

  // ---- listeler ----

  Future<List<Playlist>> allPlaylists() =>
      (select(this.playlists)..orderBy([(t) => OrderingTerm.asc(t.sortOrder), (t) => OrderingTerm.asc(t.id)])).get();

  Future<int> createPlaylist(String name) =>
      into(this.playlists).insert(PlaylistsCompanion.insert(name: name.trim(), createdAt: DateTime.now()));

  Future<void> renamePlaylist(int id, String name) =>
      (update(this.playlists)..where((t) => t.id.equals(id))).write(PlaylistsCompanion(name: Value(name.trim())));

  Future<void> deletePlaylist(int id) => (delete(this.playlists)..where((t) => t.id.equals(id))).go();

  Future<List<PlaylistItem>> items(int playlistId) => (select(playlistItems)
        ..where((t) => t.playlistId.equals(playlistId))
        ..orderBy([(t) => OrderingTerm.asc(t.position)]))
      .get();

  Future<void> addItems(int playlistId, List<String> duaIds) => transaction(() async {
        var pos = (await items(playlistId)).length;
        for (final id in duaIds) {
          await into(playlistItems).insert(PlaylistItemsCompanion.insert(playlistId: playlistId, duaId: id, position: pos++));
        }
      });

  Future<void> setRepeat(int itemId, int n) async {
    if (n < 1 || n > 99) throw ArgumentError('Tekrar 1–99 olmalı: $n');
    await (update(playlistItems)..where((t) => t.id.equals(itemId))).write(PlaylistItemsCompanion(repeatCount: Value(n)));
  }

  Future<void> _renumber(int playlistId, List<int> order) async {
    for (var i = 0; i < order.length; i++) {
      await (update(playlistItems)..where((t) => t.id.equals(order[i]))).write(PlaylistItemsCompanion(position: Value(i)));
    }
  }

  Future<void> move(int itemId, int newPosition) => transaction(() async {
        final item = await (select(playlistItems)..where((t) => t.id.equals(itemId))).getSingle();
        final order = (await items(item.playlistId)).map((i) => i.id).toList()..remove(itemId);
        order.insert(newPosition.clamp(0, order.length), itemId);
        await _renumber(item.playlistId, order);
      });

  Future<void> removeItem(int itemId) => transaction(() async {
        final item = await (select(playlistItems)..where((t) => t.id.equals(itemId))).getSingle();
        await (delete(playlistItems)..where((t) => t.id.equals(itemId))).go();
        await _renumber(item.playlistId, (await items(item.playlistId)).map((i) => i.id).toList());
      });

  // ---- ayarlar ----

  Future<String?> _get(String key) async =>
      (await (select(settings)..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _set(String key, String value) =>
      into(settings).insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  Future<ReadingPrefs> readingPrefs() async {
    final s = await _get('reading');
    return s == null ? const ReadingPrefs() : ReadingPrefs.decode(s);
  }

  Future<void> saveReadingPrefs(ReadingPrefs p) => _set('reading', p.encode());

  Future<int> gapMs() async => int.tryParse(await _get('gapMs') ?? '') ?? 1000;

  Future<void> setGapMs(int ms) async {
    if (ms < 0 || ms > 10000) throw ArgumentError('Boşluk 0–10000 ms olmalı: $ms');
    await _set('gapMs', '$ms');
  }

  Future<double> fontScale() async => double.tryParse(await _get('fontScale') ?? '') ?? 1.0;

  Future<void> setFontScale(double v) => _set('fontScale', v.clamp(0.7, 2.0).toString());

  /// 'system' | 'light' | 'dark'
  Future<String> themeMode() async => await _get('themeMode') ?? 'system';

  Future<void> setThemeMode(String mode) async {
    if (!const {'system', 'light', 'dark'}.contains(mode)) throw ArgumentError('Geçersiz tema: $mode');
    await _set('themeMode', mode);
  }

  /// Anlam her Arapça satırın altında mı (true) yoksa duanın sonunda mı (false).
  Future<bool> meaningPerLine() async => (await _get('meaningPerLine') ?? '1') == '1';

  Future<void> setMeaningPerLine(bool v) => _set('meaningPerLine', v ? '1' : '0');
}

