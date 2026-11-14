import 'dart:io';

import 'package:dualarim_editor/app/app_state.dart';
import 'package:dualarim_editor/services/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  test('içerik klasörü yolu Windows biçimine normalleştirilir (karışık eğik çizgi yok)', () async {
    final tmp = await Directory.systemTemp.createTemp('dualarim_state');
    final mixed = Directory('${tmp.path.replaceAll(r'\', '/')}/content');
    final st = await AppState.open(mixed, Settings.inMemory());
    try {
      expect(st.contentDir.path, p.normalize(p.absolute(mixed.path)));
      expect(st.contentDir.path.contains('/'), isFalse);
      expect(st.translationFile('pending.json').path.contains('/'), isFalse);
    } finally {
      await st.close();
      await tmp.delete(recursive: true);
    }
  });

  test('açılışta import klasöründeki JSON kendiliğinden içe aktarılır; değişmediyse tekrar edilmez', () async {
    final tmp = await Directory.systemTemp.createTemp('dualarim_auto');
    final content = Directory(p.join(tmp.path, 'content'));
    final json = File(p.join(content.path, 'import', 'dua_archive.json'));
    await json.parent.create(recursive: true);
    await File('../../packages/dua_core/test/fixtures/dua_archive.mini.json')
        .copy(json.path);

    var st = await AppState.open(content, Settings.inMemory());
    expect(st.lastAutoImport, isNotNull);
    expect(await st.db.select(st.db.duas).get(), hasLength(8));
    await st.close();

    st = await AppState.open(content, Settings.inMemory());
    expect(st.lastAutoImport, isNull);
    expect(await st.db.select(st.db.duas).get(), hasLength(8));
    await st.close();
    await tmp.delete(recursive: true);
  });
}
