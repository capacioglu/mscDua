import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() {
  late UserDatabase u;
  setUp(() => u = UserDatabase.memory());
  tearDown(() => u.close());

  test('liste: ekle, tekrar ver, taşı, sil', () async {
    final id = await u.createPlaylist('Sabah');
    await u.addItems(id, ['DUA-0013', 'DUA-0030', 'DUA-0004']);
    var items = await u.items(id);
    expect(items.map((i) => i.duaId), ['DUA-0013', 'DUA-0030', 'DUA-0004']);
    await u.setRepeat(items[1].id, 3);
    await u.move(items[2].id, 0);
    items = await u.items(id);
    expect(items.map((i) => (i.duaId, i.repeatCount)), [('DUA-0004', 1), ('DUA-0013', 1), ('DUA-0030', 3)]);
    expect(items.map((i) => i.position), [0, 1, 2]);
    expect(() => u.setRepeat(items[0].id, 0), throwsArgumentError);
    await u.removeItem(items[0].id);
    expect((await u.items(id)).map((i) => i.position), [0, 1]);
    await u.renamePlaylist(id, 'Akşam');
    expect((await u.allPlaylists()).single.name, 'Akşam');
    await u.deletePlaylist(id);
    expect(await u.allPlaylists(), isEmpty);
  });

  test('ayarlar: varsayılanlar ve kalıcılık', () async {
    final p = await u.readingPrefs();
    expect([p.arabic, p.pronunciationTr, p.pronunciationEn, p.meaningTr, p.meaningEn], [true, true, false, true, false]);
    await u.saveReadingPrefs(ReadingPrefs(arabic: false, pronunciationTr: true, pronunciationEn: false, meaningTr: false, meaningEn: true));
    final p2 = await u.readingPrefs();
    expect([p2.arabic, p2.meaningEn], [false, true]);
    expect(await u.gapMs(), 1000);
    await u.setGapMs(2500);
    expect(await u.gapMs(), 2500);
    expect(() => u.setGapMs(20000), throwsArgumentError);
    expect(await u.fontScale(), 1.0);
    await u.setFontScale(1.4);
    expect(await u.fontScale(), 1.4);
  });

  test('ReadingPrefs en az bir seçenek açık kalır', () {
    final p = ReadingPrefs(arabic: true, pronunciationTr: false, pronunciationEn: false, meaningTr: false, meaningEn: false);
    expect(p.toggle(ReadingOption.arabic).arabic, isTrue);
    expect(p.toggle(ReadingOption.meaningTr).meaningTr, isTrue);
  });

  test('tema ve anlam yerleşimi ayarları', () async {
    expect(await u.themeMode(), 'system');
    expect(await u.meaningPerLine(), isTrue);
    await u.setThemeMode('dark');
    await u.setMeaningPerLine(false);
    expect(await u.themeMode(), 'dark');
    expect(await u.meaningPerLine(), isFalse);
    expect(() => u.setThemeMode('mor'), throwsArgumentError);
  });

  test('eski (v1) kullanıcı veritabanı açılınca ayarlar tablosu eklenir, listeler korunur', () async {
    final dir = await Directory.systemTemp.createTemp('dualarim_mig');
    final f = File(p.join(dir.path, 'user.db'));
    final raw = sqlite3.open(f.path);
    raw.execute('CREATE TABLE playlists (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, created_at INTEGER NOT NULL, sort_order INTEGER NOT NULL DEFAULT 0)');
    raw.execute('CREATE TABLE playlist_items (id INTEGER PRIMARY KEY AUTOINCREMENT, playlist_id INTEGER NOT NULL, dua_id TEXT NOT NULL, position INTEGER NOT NULL, repeat_count INTEGER NOT NULL DEFAULT 1)');
    raw.execute('CREATE TABLE settings ("key" TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)');
    raw.execute("INSERT INTO playlists (name, created_at) VALUES ('Eski', 0)");
    raw.execute('PRAGMA user_version = 1');
    raw.close();

    final db = UserDatabase.open(f);
    expect(await db.gapMs(), 1000);
    await db.setGapMs(1500);
    expect(await db.gapMs(), 1500);
    expect((await db.allPlaylists()).single.name, 'Eski');
    await db.close();
    await dir.delete(recursive: true);
  });

  test('son dinleme oturumu saklanır ve silinir', () async {
    expect(await u.lastSession(), isNull);
    await u.saveLastSession('{"a":1}');
    expect(await u.lastSession(), '{"a":1}');
    await u.saveLastSession(null);
    expect(await u.lastSession(), isNull);
  });
}

