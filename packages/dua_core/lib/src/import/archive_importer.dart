import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/database.dart';
import '../model/enums.dart';
import '../text/turkish_segmenter.dart';
import '../text/pronunciation_segmenter.dart';

class ImportReport {
  int duasCreated = 0;
  int duasUpdated = 0;
  int groupsCreated = 0;
  int segmentsCreated = 0;
  final List<String> warnings = [];
  final List<String> changedDuaIds = [];

  Map<String, dynamic> toJson() => {
        'duas_created': duasCreated,
        'duas_updated': duasUpdated,
        'groups_created': groupsCreated,
        'segments_created': segmentsCreated,
        'warnings': warnings,
        'changed_dua_ids': changedDuaIds,
      };
}

String _noSpace(String s) => s.replaceAll(RegExp(r'\s'), '');

/// Kayıt kimliğinden beklenen ses dosyası adı: `DUA-0030` → `dua_0030.mp3`.
String expectedAudioFileFor(String id) => '${id.toLowerCase().replaceAll('-', '_')}.mp3';

const _srcKeys = ['pronunciation_tr', 'pronunciation_en', 'meaning_tr', 'meaning_en'];

/// `dua_archive.json` (schema_version 1.x) içe aktarıcı. Eşleme: spec §6.3.2.
class ArchiveImporter {
  ArchiveImporter(this.db);
  final ContentDatabase db;

  Future<ImportReport> importJson(Map<String, dynamic> json, {required String fileName}) async {
    final version = json['schema_version']?.toString() ?? '';
    if (!version.startsWith('1.')) {
      throw FormatException('Desteklenmeyen schema_version: $version');
    }
    final report = ImportReport();
    await db.transaction(() async {
      final catIds = await _importCategories(json);
      final newGroups = await _importGroups(json, report);
      final newDuas = <String>{};

      final duaCats = <String, List<String>>{};
      for (final d in ((json['duas'] as List?) ?? []).cast<Map<String, dynamic>>()) {
        final id = d['id'] as String;
        final cats = ((d['categories'] as List?) ?? []).cast<String>();
        duaCats[id] = cats;
        if (await _upsertDua(d, id, report)) {
          newDuas.add(id);
          await _setCategories(id, cats, catIds, report);
        } else {
          await _reportCategoryDiff(id, cats, catIds, report);
        }
      }

      for (final v in ((json['variants'] as List?) ?? []).cast<Map<String, dynamic>>()) {
        final id = v['id'] as String;
        final parentId = v['dua_id'] as String;
        final parent = await _dua(parentId);
        if (parent == null) {
          report.warnings.add('$id: ana dua $parentId bulunamadı, varyant alınmadı');
          continue;
        }
        final created = await _upsertDua({
          'title_tr': parent.titleTr,
          'title_en': parent.titleEn,
          'title_ar': parent.titleAr,
          ...v,
        }, id, report, variantOf: parentId, variantKey: v['variant_type'] as String?);
        if (created) {
          newDuas.add(id);
          await _setCategories(id, duaCats[parentId] ?? const [], catIds, report);
        }
      }

      for (final m in ((json['group_memberships'] as List?) ?? []).cast<Map<String, dynamic>>()) {
        final groupId = m['group_id'] as String;
        final target = (m['variant_id'] as String?) ?? m['dua_id'] as String;
        if (await _dua(target) == null) {
          report.warnings.add('$groupId: $target kaydı yok, gruba eklenmedi');
          continue;
        }
        if (await (db.select(db.groups)..where((t) => t.id.equals(groupId))).getSingleOrNull() == null) {
          report.warnings.add('$groupId: grup yok, $target üyeliği alınmadı');
          continue;
        }
        await _setGroupItem(groupId, target, m['sort_order'] as int?, (m['repeat_count'] as int?) ?? 1,
            allowInsert: newGroups.contains(groupId) || newDuas.contains(target), report: report);
      }

      await db.into(db.importLogs).insert(ImportLogsCompanion.insert(
            importedAt: DateTime.now(),
            fileName: fileName,
            reportJson: jsonEncode({'report': report.toJson(), 'metadata': json['metadata']}),
          ));
    });
    return report;
  }

  Future<Dua?> _dua(String id) => (db.select(db.duas)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Map<String, int>> _importCategories(Map<String, dynamic> json) async {
    final ids = <String, int>{};
    final list = ((json['categories'] as List?) ?? []).cast<Map<String, dynamic>>();
    for (var i = 0; i < list.length; i++) {
      final c = list[i];
      final code = c['id'] as String;
      final existing = await (db.select(db.categories)..where((t) => t.code.equals(code))).getSingleOrNull();
      if (existing != null) {
        ids[code] = existing.id;
        if (existing.nameEn == null && c['title_en'] != null) {
          await (db.update(db.categories)..where((t) => t.id.equals(existing.id)))
              .write(CategoriesCompanion(nameEn: Value(c['title_en'] as String)));
        }
        continue;
      }
      ids[code] = await db.into(db.categories).insert(CategoriesCompanion.insert(
            code: Value(code),
            nameTr: c['title_tr'] as String,
            nameEn: Value(c['title_en'] as String?),
            sortOrder: Value(i),
          ));
    }
    return ids;
  }

  Future<Set<String>> _importGroups(Map<String, dynamic> json, ImportReport report) async {
    final created = <String>{};
    final list = ((json['groups'] as List?) ?? []).cast<Map<String, dynamic>>();
    for (var i = 0; i < list.length; i++) {
      final g = list[i];
      final id = g['id'] as String;
      final complete = g['is_complete'];
      final meta = GroupsCompanion(
        description: Value(g['scope_note'] as String?),
        editorialStatus: Value(complete == null ? null : (complete == true ? 'complete' : 'incomplete')),
        infoJson: Value(jsonEncode({'source': g['source'], 'is_complete': complete, 'scope_note': g['scope_note']})),
      );
      final existing = await (db.select(db.groups)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (existing == null) {
        await db.into(db.groups).insert(meta.copyWith(
              id: Value(id),
              titleTr: Value(g['title_tr'] as String),
              titleEn: Value(g['title_en'] as String?),
              titleAr: Value(g['title_ar'] as String?),
              sortOrder: Value(i),
            ));
        report.groupsCreated++;
        created.add(id);
      } else {
        await (db.update(db.groups)..where((t) => t.id.equals(id))).write(meta);
      }
    }
    return created;
  }

  Future<void> _setCategories(String duaId, List<String> codes, Map<String, int> catIds, ImportReport report) async {
    for (final code in codes) {
      final cid = catIds[code];
      if (cid == null) {
        report.warnings.add('$duaId: bilinmeyen kategori "$code"');
        continue;
      }
      await db.into(db.duaCategories).insertOnConflictUpdate(DuaCategoriesCompanion.insert(duaId: duaId, categoryId: cid));
    }
  }

  /// Üyelik yoksa (yeni grup ya da yeni dua ise) ekler; varsa kullanıcının sırasına
  /// dokunmaz, farkı uyarı olarak raporlar.
  Future<void> _setGroupItem(String groupId, String duaId, int? position, int repeat,
      {required bool allowInsert, required ImportReport report}) async {
    final existing = await (db.select(db.groupItems)
          ..where((t) => t.groupId.equals(groupId) & t.duaId.equals(duaId)))
        .getSingleOrNull();
    if (existing == null) {
      if (allowInsert) {
        await db.into(db.groupItems).insert(GroupItemsCompanion.insert(
            groupId: groupId, duaId: duaId, position: Value(position), repeatCount: Value(repeat)));
      } else {
        report.warnings.add("$groupId: $duaId JSON'da grupta ama editörde değil; eklenmedi");
      }
    } else if (existing.position != position || existing.repeatCount != repeat) {
      report.warnings.add("$groupId: $duaId sırası/tekrarı JSON'dan farklı (editör: ${existing.position}, "
          'JSON: $position); editördeki korundu');
    }
  }

  /// Var olan duanın kategorileri JSON'dan farklıysa uyarır; değiştirmez.
  Future<void> _reportCategoryDiff(String duaId, List<String> codes, Map<String, int> catIds, ImportReport report) async {
    final current = (await (db.select(db.duaCategories)..where((t) => t.duaId.equals(duaId))).get())
        .map((l) => l.categoryId)
        .toSet();
    final wanted = codes.map((c) => catIds[c]).whereType<int>().toSet();
    if (current.length != wanted.length || !current.containsAll(wanted)) {
      report.warnings.add("$duaId: kategoriler JSON'dan farklı; editördeki korundu");
    }
  }

  String? _quranRef(Map<String, dynamic> m) {
    for (final s in ((m['sources'] as List?) ?? []).cast<Map<String, dynamic>>()) {
      if (s['type'] == 'quran') return s['reference'] as String?;
    }
    return null;
  }

  /// Arapçası olmayan, Türkçe metni olan dua: yalnızca Türkçe dua.
  static bool _turkishOnly(Map<String, dynamic> m) =>
      ((m['text_ar'] as String?) ?? '').trim().isEmpty && ((m['meaning_tr'] as String?) ?? '').trim().isNotEmpty;

  Future<void> _createSegments(String duaId, Map<String, dynamic> m, ImportReport report) async {
    if (_turkishOnly(m)) {
      final parts = splitTurkish(m['meaning_tr'] as String);
      for (var i = 0; i < parts.length; i++) {
        await db.into(db.segments).insert(SegmentsCompanion.insert(
              duaId: duaId,
              position: i,
              textAr: '',
              meaningTr: Value(parts[i]),
              meaningTrSource: const Value(FieldSource.imported),
            ));
      }
      report.segmentsCreated += parts.length;
      return;
    }
    final text = m['text_ar'] as String?;
    if (text == null) return;
    final drafts = segmentByPronunciation(
      textAr: text,
      pronunciationTr: m['pronunciation_tr'] as String?,
      pronunciationEn: m['pronunciation_en'] as String?,
      meaningTr: m['meaning_tr'] as String?,
      meaningEn: m['meaning_en'] as String?,
    );
    Value<FieldSource?> src(String? v) => Value(v == null ? null : FieldSource.imported);
    for (var i = 0; i < drafts.length; i++) {
      final d = drafts[i];
      final complete = d.pronunciationTr != null && d.meaningTr != null && d.meaningEn != null;
      await db.into(db.segments).insert(SegmentsCompanion.insert(
            duaId: duaId,
            position: i,
            textAr: d.textAr,
            pronunciationTr: Value(d.pronunciationTr),
            pronunciationEn: Value(d.pronunciationEn),
            meaningTr: Value(d.meaningTr),
            meaningEn: Value(d.meaningEn),
            pronunciationTrSource: src(d.pronunciationTr),
            pronunciationEnSource: src(d.pronunciationEn),
            meaningTrSource: src(d.meaningTr),
            meaningEnSource: src(d.meaningEn),
            review: Value(complete ? ReviewStatus.review : ReviewStatus.none),
          ));
    }
    report.segmentsCreated += drafts.length;
  }

  /// Duayı ekler veya günceller; yeni oluşturulduysa true döner.
  Future<bool> _upsertDua(Map<String, dynamic> m, String id, ImportReport report,
      {String? variantOf, String? variantKey}) async {
    final text = m['text_ar'] as String?;
    final time = m['recitation_time'] as Map<String, dynamic>?;
    final meta = DuasCompanion(
      variantOf: Value(variantOf),
      variantKey: Value(variantKey),
      titleArType: Value(m['title_ar_type'] as String?),
      sourceType: Value(m['source_type'] as String?),
      sourceJson: Value(m['sources'] == null ? null : jsonEncode(m['sources'])),
      quranReference: Value(_quranRef(m)),
      hadithTr: Value(m['hadith_tr'] as String?),
      hadithEn: Value(m['hadith_en'] as String?),
      hadithGrade: Value(m['hadith_grade'] as String?),
      storyTr: Value(m['story_tr'] as String?),
      storyEn: Value(m['story_en'] as String?),
      recitationCount: Value(m['recitation_count'] as int?),
      recitationTimeTr: Value(time?['tr'] as String?),
      recitationTimeEn: Value(time?['en'] as String?),
      editorialStatus: Value(m['verification_status'] as String?),
      editorialNote: Value(m['source_note'] as String?),
      standaloneVisible: Value((m['standalone_visible'] as bool?) ?? variantOf == null),
      expectedAudioFile: Value(expectedAudioFileFor(id)),
      textLanguage: Value(_turkishOnly(m) ? 'tr' : 'ar'),
    );

    final existing = await _dua(id);
    if (existing == null) {
      await db.into(db.duas).insert(meta.copyWith(
            id: Value(id),
            titleTr: Value(m['title_tr'] as String? ?? id),
            titleEn: Value(m['title_en'] as String?),
            titleAr: Value(m['title_ar'] as String?),
            srcPronunciationTr: Value(m['pronunciation_tr'] as String?),
            srcPronunciationEn: Value(m['pronunciation_en'] as String?),
            srcMeaningTr: Value(m['meaning_tr'] as String?),
            srcMeaningEn: Value(m['meaning_en'] as String?),
            srcTextAr: Value(text),
          ));
      await _createSegments(id, m, report);
      report.duasCreated++;
      return true;
    }

    report.duasUpdated++;
    final diff = <String, dynamic>{};
    final current = {
      'pronunciation_tr': existing.srcPronunciationTr,
      'pronunciation_en': existing.srcPronunciationEn,
      'meaning_tr': existing.srcMeaningTr,
      'meaning_en': existing.srcMeaningEn,
    };
    for (final k in _srcKeys) {
      final n = m[k] as String?;
      if (n != null && n != current[k]) diff[k] = {'old': current[k], 'new': n};
    }

    var segs = await db.segmentsOf(id);
    if (segs.isEmpty && _turkishOnly(m)) {
      await _createSegments(id, m, report);
      segs = await db.segmentsOf(id);
    }
    final joined = segs.map((s) => s.textAr).join(' ');
    final prevText = existing.srcTextAr ?? joined;
    var recreated = false;
    // Yalnızca JSON'daki metin bir önceki içe aktarımdan farklıysa ilgilen;
    // kullanıcının Arapça düzeltmesi tek başına "JSON değişti" sayılmaz.
    if (text != null && _noSpace(prevText) != _noSpace(text)) {
      final segIds = segs.map((s) => s.id).toList();
      final touched = segs.any((s) =>
          s.review == ReviewStatus.approved ||
          [s.pronunciationTrSource, s.pronunciationEnSource, s.meaningTrSource, s.meaningEnSource]
              .any((src) => src == FieldSource.user || src == FieldSource.claude));
      final hasCues = segIds.isNotEmpty &&
          (await (db.select(db.cues)..where((c) => c.segmentId.isIn(segIds))).get()).isNotEmpty;
      final sameAsImported = _noSpace(joined) == _noSpace(prevText);
      if (!touched && !hasCues && sameAsImported) {
        await (db.delete(db.segments)..where((t) => t.duaId.equals(id))).go();
        await _createSegments(id, m, report);
        report.warnings.add('$id: Arapça metin değişti, satırlar yeniden oluşturuldu');
        recreated = true;
      } else {
        diff['text_ar'] = {'old': prevText, 'new': text, 'current': joined};
      }
    }

    await (db.update(db.duas)..where((t) => t.id.equals(id))).write(meta.copyWith(
          titleEn: existing.titleEn == null ? Value(m['title_en'] as String?) : const Value.absent(),
          titleAr: existing.titleAr == null ? Value(m['title_ar'] as String?) : const Value.absent(),
          srcPronunciationTr:
              diff.containsKey('pronunciation_tr') ? Value(m['pronunciation_tr'] as String?) : const Value.absent(),
          srcPronunciationEn:
              diff.containsKey('pronunciation_en') ? Value(m['pronunciation_en'] as String?) : const Value.absent(),
          srcMeaningTr: diff.containsKey('meaning_tr') ? Value(m['meaning_tr'] as String?) : const Value.absent(),
          srcMeaningEn: diff.containsKey('meaning_en') ? Value(m['meaning_en'] as String?) : const Value.absent(),
          srcTextAr: text == null ? const Value.absent() : Value(text),
          importDiff: diff.isEmpty || recreated ? const Value.absent() : Value(jsonEncode(diff)),
        ));
    if (diff.isNotEmpty && !recreated) report.changedDuaIds.add(id);
    return false;
  }
}
