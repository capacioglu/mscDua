import 'dart:convert';
import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:test/test.dart';

void main() {
  late ContentDatabase db;
  setUp(() async {
    db = ContentDatabase.memory();
    await ArchiveImporter(db).importJson(
        jsonDecode(File('test/fixtures/dua_archive.mini.json').readAsStringSync()) as Map<String, dynamic>,
        fileName: 'mini.json');
  });
  tearDown(() => db.close());

  test('özetler durum, kategori, grup, kayıt ve uyarı bilgisini içerir', () async {
    final list = await listDuaSummaries(db);
    expect(list, hasLength(8));
    final d30 = list.firstWhere((s) => s.id == 'DUA-0030');
    expect(d30.progress, DuaProgress.inReview);
    expect(d30.categories, unorderedEquals(['Tövbe', 'Peygamber duaları']));
    expect(d30.groupIds, unorderedEquals(['GRP-001', 'GRP-005']));
    expect(d30.trackCount, 0);
    expect(d30.hasWarning, isFalse);
    final d6 = list.firstWhere((s) => s.id == 'DUA-0006');
    expect(d6.progress, DuaProgress.awaitingTranslation);
    expect(d6.segmentCount, 4);
    expect(list.firstWhere((s) => s.id == 'DUA-0056-11').hasWarning, isTrue);
    expect(list.firstWhere((s) => s.id == 'VAR-0054-01').variantOf, 'DUA-0054');
  });

  test('progressLabel Türkçe', () {
    expect(progressLabel(DuaProgress.awaitingTranslation), 'Çeviri bekliyor');
    expect(progressLabel(DuaProgress.inReview), 'Gözden geçirilecek');
    expect(progressLabel(DuaProgress.approved), 'Onaylı');
    expect(progressLabel(DuaProgress.draft), 'Taslak');
  });
}
