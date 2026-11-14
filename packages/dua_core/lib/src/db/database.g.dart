// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DuasTable extends Duas with TableInfo<$DuasTable, Dua> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleTrMeta = const VerificationMeta(
    'titleTr',
  );
  @override
  late final GeneratedColumn<String> titleTr = GeneratedColumn<String>(
    'title_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleArMeta = const VerificationMeta(
    'titleAr',
  );
  @override
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
    'title_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _variantOfMeta = const VerificationMeta(
    'variantOf',
  );
  @override
  late final GeneratedColumn<String> variantOf = GeneratedColumn<String>(
    'variant_of',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES duas (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _variantKeyMeta = const VerificationMeta(
    'variantKey',
  );
  @override
  late final GeneratedColumn<String> variantKey = GeneratedColumn<String>(
    'variant_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quranReferenceMeta = const VerificationMeta(
    'quranReference',
  );
  @override
  late final GeneratedColumn<String> quranReference = GeneratedColumn<String>(
    'quran_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editorialStatusMeta = const VerificationMeta(
    'editorialStatus',
  );
  @override
  late final GeneratedColumn<String> editorialStatus = GeneratedColumn<String>(
    'editorial_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editorialNoteMeta = const VerificationMeta(
    'editorialNote',
  );
  @override
  late final GeneratedColumn<String> editorialNote = GeneratedColumn<String>(
    'editorial_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceJsonMeta = const VerificationMeta(
    'sourceJson',
  );
  @override
  late final GeneratedColumn<String> sourceJson = GeneratedColumn<String>(
    'source_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _srcPronunciationTrMeta =
      const VerificationMeta('srcPronunciationTr');
  @override
  late final GeneratedColumn<String> srcPronunciationTr =
      GeneratedColumn<String>(
        'src_pronunciation_tr',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _srcPronunciationEnMeta =
      const VerificationMeta('srcPronunciationEn');
  @override
  late final GeneratedColumn<String> srcPronunciationEn =
      GeneratedColumn<String>(
        'src_pronunciation_en',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _srcMeaningTrMeta = const VerificationMeta(
    'srcMeaningTr',
  );
  @override
  late final GeneratedColumn<String> srcMeaningTr = GeneratedColumn<String>(
    'src_meaning_tr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _srcMeaningEnMeta = const VerificationMeta(
    'srcMeaningEn',
  );
  @override
  late final GeneratedColumn<String> srcMeaningEn = GeneratedColumn<String>(
    'src_meaning_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expectedAudioFileMeta = const VerificationMeta(
    'expectedAudioFile',
  );
  @override
  late final GeneratedColumn<String> expectedAudioFile =
      GeneratedColumn<String>(
        'expected_audio_file',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _readyToPublishMeta = const VerificationMeta(
    'readyToPublish',
  );
  @override
  late final GeneratedColumn<bool> readyToPublish = GeneratedColumn<bool>(
    'ready_to_publish',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ready_to_publish" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _importDiffMeta = const VerificationMeta(
    'importDiff',
  );
  @override
  late final GeneratedColumn<String> importDiff = GeneratedColumn<String>(
    'import_diff',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _titleArTypeMeta = const VerificationMeta(
    'titleArType',
  );
  @override
  late final GeneratedColumn<String> titleArType = GeneratedColumn<String>(
    'title_ar_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hadithTrMeta = const VerificationMeta(
    'hadithTr',
  );
  @override
  late final GeneratedColumn<String> hadithTr = GeneratedColumn<String>(
    'hadith_tr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hadithEnMeta = const VerificationMeta(
    'hadithEn',
  );
  @override
  late final GeneratedColumn<String> hadithEn = GeneratedColumn<String>(
    'hadith_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hadithGradeMeta = const VerificationMeta(
    'hadithGrade',
  );
  @override
  late final GeneratedColumn<String> hadithGrade = GeneratedColumn<String>(
    'hadith_grade',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storyTrMeta = const VerificationMeta(
    'storyTr',
  );
  @override
  late final GeneratedColumn<String> storyTr = GeneratedColumn<String>(
    'story_tr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storyEnMeta = const VerificationMeta(
    'storyEn',
  );
  @override
  late final GeneratedColumn<String> storyEn = GeneratedColumn<String>(
    'story_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recitationCountMeta = const VerificationMeta(
    'recitationCount',
  );
  @override
  late final GeneratedColumn<int> recitationCount = GeneratedColumn<int>(
    'recitation_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recitationTimeTrMeta = const VerificationMeta(
    'recitationTimeTr',
  );
  @override
  late final GeneratedColumn<String> recitationTimeTr = GeneratedColumn<String>(
    'recitation_time_tr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recitationTimeEnMeta = const VerificationMeta(
    'recitationTimeEn',
  );
  @override
  late final GeneratedColumn<String> recitationTimeEn = GeneratedColumn<String>(
    'recitation_time_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _standaloneVisibleMeta = const VerificationMeta(
    'standaloneVisible',
  );
  @override
  late final GeneratedColumn<bool> standaloneVisible = GeneratedColumn<bool>(
    'standalone_visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("standalone_visible" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titleTr,
    titleEn,
    titleAr,
    variantOf,
    variantKey,
    quranReference,
    editorialStatus,
    editorialNote,
    sourceJson,
    srcPronunciationTr,
    srcPronunciationEn,
    srcMeaningTr,
    srcMeaningEn,
    expectedAudioFile,
    readyToPublish,
    version,
    importDiff,
    sortOrder,
    titleArType,
    sourceType,
    hadithTr,
    hadithEn,
    hadithGrade,
    storyTr,
    storyEn,
    recitationCount,
    recitationTimeTr,
    recitationTimeEn,
    standaloneVisible,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'duas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dua> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title_tr')) {
      context.handle(
        _titleTrMeta,
        titleTr.isAcceptableOrUnknown(data['title_tr']!, _titleTrMeta),
      );
    } else if (isInserting) {
      context.missing(_titleTrMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    }
    if (data.containsKey('title_ar')) {
      context.handle(
        _titleArMeta,
        titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta),
      );
    }
    if (data.containsKey('variant_of')) {
      context.handle(
        _variantOfMeta,
        variantOf.isAcceptableOrUnknown(data['variant_of']!, _variantOfMeta),
      );
    }
    if (data.containsKey('variant_key')) {
      context.handle(
        _variantKeyMeta,
        variantKey.isAcceptableOrUnknown(data['variant_key']!, _variantKeyMeta),
      );
    }
    if (data.containsKey('quran_reference')) {
      context.handle(
        _quranReferenceMeta,
        quranReference.isAcceptableOrUnknown(
          data['quran_reference']!,
          _quranReferenceMeta,
        ),
      );
    }
    if (data.containsKey('editorial_status')) {
      context.handle(
        _editorialStatusMeta,
        editorialStatus.isAcceptableOrUnknown(
          data['editorial_status']!,
          _editorialStatusMeta,
        ),
      );
    }
    if (data.containsKey('editorial_note')) {
      context.handle(
        _editorialNoteMeta,
        editorialNote.isAcceptableOrUnknown(
          data['editorial_note']!,
          _editorialNoteMeta,
        ),
      );
    }
    if (data.containsKey('source_json')) {
      context.handle(
        _sourceJsonMeta,
        sourceJson.isAcceptableOrUnknown(data['source_json']!, _sourceJsonMeta),
      );
    }
    if (data.containsKey('src_pronunciation_tr')) {
      context.handle(
        _srcPronunciationTrMeta,
        srcPronunciationTr.isAcceptableOrUnknown(
          data['src_pronunciation_tr']!,
          _srcPronunciationTrMeta,
        ),
      );
    }
    if (data.containsKey('src_pronunciation_en')) {
      context.handle(
        _srcPronunciationEnMeta,
        srcPronunciationEn.isAcceptableOrUnknown(
          data['src_pronunciation_en']!,
          _srcPronunciationEnMeta,
        ),
      );
    }
    if (data.containsKey('src_meaning_tr')) {
      context.handle(
        _srcMeaningTrMeta,
        srcMeaningTr.isAcceptableOrUnknown(
          data['src_meaning_tr']!,
          _srcMeaningTrMeta,
        ),
      );
    }
    if (data.containsKey('src_meaning_en')) {
      context.handle(
        _srcMeaningEnMeta,
        srcMeaningEn.isAcceptableOrUnknown(
          data['src_meaning_en']!,
          _srcMeaningEnMeta,
        ),
      );
    }
    if (data.containsKey('expected_audio_file')) {
      context.handle(
        _expectedAudioFileMeta,
        expectedAudioFile.isAcceptableOrUnknown(
          data['expected_audio_file']!,
          _expectedAudioFileMeta,
        ),
      );
    }
    if (data.containsKey('ready_to_publish')) {
      context.handle(
        _readyToPublishMeta,
        readyToPublish.isAcceptableOrUnknown(
          data['ready_to_publish']!,
          _readyToPublishMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('import_diff')) {
      context.handle(
        _importDiffMeta,
        importDiff.isAcceptableOrUnknown(data['import_diff']!, _importDiffMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('title_ar_type')) {
      context.handle(
        _titleArTypeMeta,
        titleArType.isAcceptableOrUnknown(
          data['title_ar_type']!,
          _titleArTypeMeta,
        ),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('hadith_tr')) {
      context.handle(
        _hadithTrMeta,
        hadithTr.isAcceptableOrUnknown(data['hadith_tr']!, _hadithTrMeta),
      );
    }
    if (data.containsKey('hadith_en')) {
      context.handle(
        _hadithEnMeta,
        hadithEn.isAcceptableOrUnknown(data['hadith_en']!, _hadithEnMeta),
      );
    }
    if (data.containsKey('hadith_grade')) {
      context.handle(
        _hadithGradeMeta,
        hadithGrade.isAcceptableOrUnknown(
          data['hadith_grade']!,
          _hadithGradeMeta,
        ),
      );
    }
    if (data.containsKey('story_tr')) {
      context.handle(
        _storyTrMeta,
        storyTr.isAcceptableOrUnknown(data['story_tr']!, _storyTrMeta),
      );
    }
    if (data.containsKey('story_en')) {
      context.handle(
        _storyEnMeta,
        storyEn.isAcceptableOrUnknown(data['story_en']!, _storyEnMeta),
      );
    }
    if (data.containsKey('recitation_count')) {
      context.handle(
        _recitationCountMeta,
        recitationCount.isAcceptableOrUnknown(
          data['recitation_count']!,
          _recitationCountMeta,
        ),
      );
    }
    if (data.containsKey('recitation_time_tr')) {
      context.handle(
        _recitationTimeTrMeta,
        recitationTimeTr.isAcceptableOrUnknown(
          data['recitation_time_tr']!,
          _recitationTimeTrMeta,
        ),
      );
    }
    if (data.containsKey('recitation_time_en')) {
      context.handle(
        _recitationTimeEnMeta,
        recitationTimeEn.isAcceptableOrUnknown(
          data['recitation_time_en']!,
          _recitationTimeEnMeta,
        ),
      );
    }
    if (data.containsKey('standalone_visible')) {
      context.handle(
        _standaloneVisibleMeta,
        standaloneVisible.isAcceptableOrUnknown(
          data['standalone_visible']!,
          _standaloneVisibleMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dua map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dua(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      titleTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_tr'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      ),
      titleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar'],
      ),
      variantOf: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_of'],
      ),
      variantKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_key'],
      ),
      quranReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quran_reference'],
      ),
      editorialStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}editorial_status'],
      ),
      editorialNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}editorial_note'],
      ),
      sourceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_json'],
      ),
      srcPronunciationTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}src_pronunciation_tr'],
      ),
      srcPronunciationEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}src_pronunciation_en'],
      ),
      srcMeaningTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}src_meaning_tr'],
      ),
      srcMeaningEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}src_meaning_en'],
      ),
      expectedAudioFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expected_audio_file'],
      ),
      readyToPublish: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ready_to_publish'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      importDiff: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_diff'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      titleArType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar_type'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      ),
      hadithTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hadith_tr'],
      ),
      hadithEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hadith_en'],
      ),
      hadithGrade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hadith_grade'],
      ),
      storyTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_tr'],
      ),
      storyEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_en'],
      ),
      recitationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recitation_count'],
      ),
      recitationTimeTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recitation_time_tr'],
      ),
      recitationTimeEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recitation_time_en'],
      ),
      standaloneVisible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}standalone_visible'],
      )!,
    );
  }

  @override
  $DuasTable createAlias(String alias) {
    return $DuasTable(attachedDatabase, alias);
  }
}

class Dua extends DataClass implements Insertable<Dua> {
  final String id;
  final String titleTr;
  final String? titleEn;
  final String? titleAr;
  final String? variantOf;
  final String? variantKey;
  final String? quranReference;
  final String? editorialStatus;
  final String? editorialNote;
  final String? sourceJson;
  final String? srcPronunciationTr;
  final String? srcPronunciationEn;
  final String? srcMeaningTr;
  final String? srcMeaningEn;
  final String? expectedAudioFile;
  final bool readyToPublish;
  final int version;
  final String? importDiff;
  final int sortOrder;
  final String? titleArType;
  final String? sourceType;
  final String? hadithTr;
  final String? hadithEn;
  final String? hadithGrade;
  final String? storyTr;
  final String? storyEn;
  final int? recitationCount;
  final String? recitationTimeTr;
  final String? recitationTimeEn;
  final bool standaloneVisible;
  const Dua({
    required this.id,
    required this.titleTr,
    this.titleEn,
    this.titleAr,
    this.variantOf,
    this.variantKey,
    this.quranReference,
    this.editorialStatus,
    this.editorialNote,
    this.sourceJson,
    this.srcPronunciationTr,
    this.srcPronunciationEn,
    this.srcMeaningTr,
    this.srcMeaningEn,
    this.expectedAudioFile,
    required this.readyToPublish,
    required this.version,
    this.importDiff,
    required this.sortOrder,
    this.titleArType,
    this.sourceType,
    this.hadithTr,
    this.hadithEn,
    this.hadithGrade,
    this.storyTr,
    this.storyEn,
    this.recitationCount,
    this.recitationTimeTr,
    this.recitationTimeEn,
    required this.standaloneVisible,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title_tr'] = Variable<String>(titleTr);
    if (!nullToAbsent || titleEn != null) {
      map['title_en'] = Variable<String>(titleEn);
    }
    if (!nullToAbsent || titleAr != null) {
      map['title_ar'] = Variable<String>(titleAr);
    }
    if (!nullToAbsent || variantOf != null) {
      map['variant_of'] = Variable<String>(variantOf);
    }
    if (!nullToAbsent || variantKey != null) {
      map['variant_key'] = Variable<String>(variantKey);
    }
    if (!nullToAbsent || quranReference != null) {
      map['quran_reference'] = Variable<String>(quranReference);
    }
    if (!nullToAbsent || editorialStatus != null) {
      map['editorial_status'] = Variable<String>(editorialStatus);
    }
    if (!nullToAbsent || editorialNote != null) {
      map['editorial_note'] = Variable<String>(editorialNote);
    }
    if (!nullToAbsent || sourceJson != null) {
      map['source_json'] = Variable<String>(sourceJson);
    }
    if (!nullToAbsent || srcPronunciationTr != null) {
      map['src_pronunciation_tr'] = Variable<String>(srcPronunciationTr);
    }
    if (!nullToAbsent || srcPronunciationEn != null) {
      map['src_pronunciation_en'] = Variable<String>(srcPronunciationEn);
    }
    if (!nullToAbsent || srcMeaningTr != null) {
      map['src_meaning_tr'] = Variable<String>(srcMeaningTr);
    }
    if (!nullToAbsent || srcMeaningEn != null) {
      map['src_meaning_en'] = Variable<String>(srcMeaningEn);
    }
    if (!nullToAbsent || expectedAudioFile != null) {
      map['expected_audio_file'] = Variable<String>(expectedAudioFile);
    }
    map['ready_to_publish'] = Variable<bool>(readyToPublish);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || importDiff != null) {
      map['import_diff'] = Variable<String>(importDiff);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || titleArType != null) {
      map['title_ar_type'] = Variable<String>(titleArType);
    }
    if (!nullToAbsent || sourceType != null) {
      map['source_type'] = Variable<String>(sourceType);
    }
    if (!nullToAbsent || hadithTr != null) {
      map['hadith_tr'] = Variable<String>(hadithTr);
    }
    if (!nullToAbsent || hadithEn != null) {
      map['hadith_en'] = Variable<String>(hadithEn);
    }
    if (!nullToAbsent || hadithGrade != null) {
      map['hadith_grade'] = Variable<String>(hadithGrade);
    }
    if (!nullToAbsent || storyTr != null) {
      map['story_tr'] = Variable<String>(storyTr);
    }
    if (!nullToAbsent || storyEn != null) {
      map['story_en'] = Variable<String>(storyEn);
    }
    if (!nullToAbsent || recitationCount != null) {
      map['recitation_count'] = Variable<int>(recitationCount);
    }
    if (!nullToAbsent || recitationTimeTr != null) {
      map['recitation_time_tr'] = Variable<String>(recitationTimeTr);
    }
    if (!nullToAbsent || recitationTimeEn != null) {
      map['recitation_time_en'] = Variable<String>(recitationTimeEn);
    }
    map['standalone_visible'] = Variable<bool>(standaloneVisible);
    return map;
  }

  DuasCompanion toCompanion(bool nullToAbsent) {
    return DuasCompanion(
      id: Value(id),
      titleTr: Value(titleTr),
      titleEn: titleEn == null && nullToAbsent
          ? const Value.absent()
          : Value(titleEn),
      titleAr: titleAr == null && nullToAbsent
          ? const Value.absent()
          : Value(titleAr),
      variantOf: variantOf == null && nullToAbsent
          ? const Value.absent()
          : Value(variantOf),
      variantKey: variantKey == null && nullToAbsent
          ? const Value.absent()
          : Value(variantKey),
      quranReference: quranReference == null && nullToAbsent
          ? const Value.absent()
          : Value(quranReference),
      editorialStatus: editorialStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(editorialStatus),
      editorialNote: editorialNote == null && nullToAbsent
          ? const Value.absent()
          : Value(editorialNote),
      sourceJson: sourceJson == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceJson),
      srcPronunciationTr: srcPronunciationTr == null && nullToAbsent
          ? const Value.absent()
          : Value(srcPronunciationTr),
      srcPronunciationEn: srcPronunciationEn == null && nullToAbsent
          ? const Value.absent()
          : Value(srcPronunciationEn),
      srcMeaningTr: srcMeaningTr == null && nullToAbsent
          ? const Value.absent()
          : Value(srcMeaningTr),
      srcMeaningEn: srcMeaningEn == null && nullToAbsent
          ? const Value.absent()
          : Value(srcMeaningEn),
      expectedAudioFile: expectedAudioFile == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedAudioFile),
      readyToPublish: Value(readyToPublish),
      version: Value(version),
      importDiff: importDiff == null && nullToAbsent
          ? const Value.absent()
          : Value(importDiff),
      sortOrder: Value(sortOrder),
      titleArType: titleArType == null && nullToAbsent
          ? const Value.absent()
          : Value(titleArType),
      sourceType: sourceType == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceType),
      hadithTr: hadithTr == null && nullToAbsent
          ? const Value.absent()
          : Value(hadithTr),
      hadithEn: hadithEn == null && nullToAbsent
          ? const Value.absent()
          : Value(hadithEn),
      hadithGrade: hadithGrade == null && nullToAbsent
          ? const Value.absent()
          : Value(hadithGrade),
      storyTr: storyTr == null && nullToAbsent
          ? const Value.absent()
          : Value(storyTr),
      storyEn: storyEn == null && nullToAbsent
          ? const Value.absent()
          : Value(storyEn),
      recitationCount: recitationCount == null && nullToAbsent
          ? const Value.absent()
          : Value(recitationCount),
      recitationTimeTr: recitationTimeTr == null && nullToAbsent
          ? const Value.absent()
          : Value(recitationTimeTr),
      recitationTimeEn: recitationTimeEn == null && nullToAbsent
          ? const Value.absent()
          : Value(recitationTimeEn),
      standaloneVisible: Value(standaloneVisible),
    );
  }

  factory Dua.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dua(
      id: serializer.fromJson<String>(json['id']),
      titleTr: serializer.fromJson<String>(json['titleTr']),
      titleEn: serializer.fromJson<String?>(json['titleEn']),
      titleAr: serializer.fromJson<String?>(json['titleAr']),
      variantOf: serializer.fromJson<String?>(json['variantOf']),
      variantKey: serializer.fromJson<String?>(json['variantKey']),
      quranReference: serializer.fromJson<String?>(json['quranReference']),
      editorialStatus: serializer.fromJson<String?>(json['editorialStatus']),
      editorialNote: serializer.fromJson<String?>(json['editorialNote']),
      sourceJson: serializer.fromJson<String?>(json['sourceJson']),
      srcPronunciationTr: serializer.fromJson<String?>(
        json['srcPronunciationTr'],
      ),
      srcPronunciationEn: serializer.fromJson<String?>(
        json['srcPronunciationEn'],
      ),
      srcMeaningTr: serializer.fromJson<String?>(json['srcMeaningTr']),
      srcMeaningEn: serializer.fromJson<String?>(json['srcMeaningEn']),
      expectedAudioFile: serializer.fromJson<String?>(
        json['expectedAudioFile'],
      ),
      readyToPublish: serializer.fromJson<bool>(json['readyToPublish']),
      version: serializer.fromJson<int>(json['version']),
      importDiff: serializer.fromJson<String?>(json['importDiff']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      titleArType: serializer.fromJson<String?>(json['titleArType']),
      sourceType: serializer.fromJson<String?>(json['sourceType']),
      hadithTr: serializer.fromJson<String?>(json['hadithTr']),
      hadithEn: serializer.fromJson<String?>(json['hadithEn']),
      hadithGrade: serializer.fromJson<String?>(json['hadithGrade']),
      storyTr: serializer.fromJson<String?>(json['storyTr']),
      storyEn: serializer.fromJson<String?>(json['storyEn']),
      recitationCount: serializer.fromJson<int?>(json['recitationCount']),
      recitationTimeTr: serializer.fromJson<String?>(json['recitationTimeTr']),
      recitationTimeEn: serializer.fromJson<String?>(json['recitationTimeEn']),
      standaloneVisible: serializer.fromJson<bool>(json['standaloneVisible']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titleTr': serializer.toJson<String>(titleTr),
      'titleEn': serializer.toJson<String?>(titleEn),
      'titleAr': serializer.toJson<String?>(titleAr),
      'variantOf': serializer.toJson<String?>(variantOf),
      'variantKey': serializer.toJson<String?>(variantKey),
      'quranReference': serializer.toJson<String?>(quranReference),
      'editorialStatus': serializer.toJson<String?>(editorialStatus),
      'editorialNote': serializer.toJson<String?>(editorialNote),
      'sourceJson': serializer.toJson<String?>(sourceJson),
      'srcPronunciationTr': serializer.toJson<String?>(srcPronunciationTr),
      'srcPronunciationEn': serializer.toJson<String?>(srcPronunciationEn),
      'srcMeaningTr': serializer.toJson<String?>(srcMeaningTr),
      'srcMeaningEn': serializer.toJson<String?>(srcMeaningEn),
      'expectedAudioFile': serializer.toJson<String?>(expectedAudioFile),
      'readyToPublish': serializer.toJson<bool>(readyToPublish),
      'version': serializer.toJson<int>(version),
      'importDiff': serializer.toJson<String?>(importDiff),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'titleArType': serializer.toJson<String?>(titleArType),
      'sourceType': serializer.toJson<String?>(sourceType),
      'hadithTr': serializer.toJson<String?>(hadithTr),
      'hadithEn': serializer.toJson<String?>(hadithEn),
      'hadithGrade': serializer.toJson<String?>(hadithGrade),
      'storyTr': serializer.toJson<String?>(storyTr),
      'storyEn': serializer.toJson<String?>(storyEn),
      'recitationCount': serializer.toJson<int?>(recitationCount),
      'recitationTimeTr': serializer.toJson<String?>(recitationTimeTr),
      'recitationTimeEn': serializer.toJson<String?>(recitationTimeEn),
      'standaloneVisible': serializer.toJson<bool>(standaloneVisible),
    };
  }

  Dua copyWith({
    String? id,
    String? titleTr,
    Value<String?> titleEn = const Value.absent(),
    Value<String?> titleAr = const Value.absent(),
    Value<String?> variantOf = const Value.absent(),
    Value<String?> variantKey = const Value.absent(),
    Value<String?> quranReference = const Value.absent(),
    Value<String?> editorialStatus = const Value.absent(),
    Value<String?> editorialNote = const Value.absent(),
    Value<String?> sourceJson = const Value.absent(),
    Value<String?> srcPronunciationTr = const Value.absent(),
    Value<String?> srcPronunciationEn = const Value.absent(),
    Value<String?> srcMeaningTr = const Value.absent(),
    Value<String?> srcMeaningEn = const Value.absent(),
    Value<String?> expectedAudioFile = const Value.absent(),
    bool? readyToPublish,
    int? version,
    Value<String?> importDiff = const Value.absent(),
    int? sortOrder,
    Value<String?> titleArType = const Value.absent(),
    Value<String?> sourceType = const Value.absent(),
    Value<String?> hadithTr = const Value.absent(),
    Value<String?> hadithEn = const Value.absent(),
    Value<String?> hadithGrade = const Value.absent(),
    Value<String?> storyTr = const Value.absent(),
    Value<String?> storyEn = const Value.absent(),
    Value<int?> recitationCount = const Value.absent(),
    Value<String?> recitationTimeTr = const Value.absent(),
    Value<String?> recitationTimeEn = const Value.absent(),
    bool? standaloneVisible,
  }) => Dua(
    id: id ?? this.id,
    titleTr: titleTr ?? this.titleTr,
    titleEn: titleEn.present ? titleEn.value : this.titleEn,
    titleAr: titleAr.present ? titleAr.value : this.titleAr,
    variantOf: variantOf.present ? variantOf.value : this.variantOf,
    variantKey: variantKey.present ? variantKey.value : this.variantKey,
    quranReference: quranReference.present
        ? quranReference.value
        : this.quranReference,
    editorialStatus: editorialStatus.present
        ? editorialStatus.value
        : this.editorialStatus,
    editorialNote: editorialNote.present
        ? editorialNote.value
        : this.editorialNote,
    sourceJson: sourceJson.present ? sourceJson.value : this.sourceJson,
    srcPronunciationTr: srcPronunciationTr.present
        ? srcPronunciationTr.value
        : this.srcPronunciationTr,
    srcPronunciationEn: srcPronunciationEn.present
        ? srcPronunciationEn.value
        : this.srcPronunciationEn,
    srcMeaningTr: srcMeaningTr.present ? srcMeaningTr.value : this.srcMeaningTr,
    srcMeaningEn: srcMeaningEn.present ? srcMeaningEn.value : this.srcMeaningEn,
    expectedAudioFile: expectedAudioFile.present
        ? expectedAudioFile.value
        : this.expectedAudioFile,
    readyToPublish: readyToPublish ?? this.readyToPublish,
    version: version ?? this.version,
    importDiff: importDiff.present ? importDiff.value : this.importDiff,
    sortOrder: sortOrder ?? this.sortOrder,
    titleArType: titleArType.present ? titleArType.value : this.titleArType,
    sourceType: sourceType.present ? sourceType.value : this.sourceType,
    hadithTr: hadithTr.present ? hadithTr.value : this.hadithTr,
    hadithEn: hadithEn.present ? hadithEn.value : this.hadithEn,
    hadithGrade: hadithGrade.present ? hadithGrade.value : this.hadithGrade,
    storyTr: storyTr.present ? storyTr.value : this.storyTr,
    storyEn: storyEn.present ? storyEn.value : this.storyEn,
    recitationCount: recitationCount.present
        ? recitationCount.value
        : this.recitationCount,
    recitationTimeTr: recitationTimeTr.present
        ? recitationTimeTr.value
        : this.recitationTimeTr,
    recitationTimeEn: recitationTimeEn.present
        ? recitationTimeEn.value
        : this.recitationTimeEn,
    standaloneVisible: standaloneVisible ?? this.standaloneVisible,
  );
  Dua copyWithCompanion(DuasCompanion data) {
    return Dua(
      id: data.id.present ? data.id.value : this.id,
      titleTr: data.titleTr.present ? data.titleTr.value : this.titleTr,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      variantOf: data.variantOf.present ? data.variantOf.value : this.variantOf,
      variantKey: data.variantKey.present
          ? data.variantKey.value
          : this.variantKey,
      quranReference: data.quranReference.present
          ? data.quranReference.value
          : this.quranReference,
      editorialStatus: data.editorialStatus.present
          ? data.editorialStatus.value
          : this.editorialStatus,
      editorialNote: data.editorialNote.present
          ? data.editorialNote.value
          : this.editorialNote,
      sourceJson: data.sourceJson.present
          ? data.sourceJson.value
          : this.sourceJson,
      srcPronunciationTr: data.srcPronunciationTr.present
          ? data.srcPronunciationTr.value
          : this.srcPronunciationTr,
      srcPronunciationEn: data.srcPronunciationEn.present
          ? data.srcPronunciationEn.value
          : this.srcPronunciationEn,
      srcMeaningTr: data.srcMeaningTr.present
          ? data.srcMeaningTr.value
          : this.srcMeaningTr,
      srcMeaningEn: data.srcMeaningEn.present
          ? data.srcMeaningEn.value
          : this.srcMeaningEn,
      expectedAudioFile: data.expectedAudioFile.present
          ? data.expectedAudioFile.value
          : this.expectedAudioFile,
      readyToPublish: data.readyToPublish.present
          ? data.readyToPublish.value
          : this.readyToPublish,
      version: data.version.present ? data.version.value : this.version,
      importDiff: data.importDiff.present
          ? data.importDiff.value
          : this.importDiff,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      titleArType: data.titleArType.present
          ? data.titleArType.value
          : this.titleArType,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      hadithTr: data.hadithTr.present ? data.hadithTr.value : this.hadithTr,
      hadithEn: data.hadithEn.present ? data.hadithEn.value : this.hadithEn,
      hadithGrade: data.hadithGrade.present
          ? data.hadithGrade.value
          : this.hadithGrade,
      storyTr: data.storyTr.present ? data.storyTr.value : this.storyTr,
      storyEn: data.storyEn.present ? data.storyEn.value : this.storyEn,
      recitationCount: data.recitationCount.present
          ? data.recitationCount.value
          : this.recitationCount,
      recitationTimeTr: data.recitationTimeTr.present
          ? data.recitationTimeTr.value
          : this.recitationTimeTr,
      recitationTimeEn: data.recitationTimeEn.present
          ? data.recitationTimeEn.value
          : this.recitationTimeEn,
      standaloneVisible: data.standaloneVisible.present
          ? data.standaloneVisible.value
          : this.standaloneVisible,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dua(')
          ..write('id: $id, ')
          ..write('titleTr: $titleTr, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleAr: $titleAr, ')
          ..write('variantOf: $variantOf, ')
          ..write('variantKey: $variantKey, ')
          ..write('quranReference: $quranReference, ')
          ..write('editorialStatus: $editorialStatus, ')
          ..write('editorialNote: $editorialNote, ')
          ..write('sourceJson: $sourceJson, ')
          ..write('srcPronunciationTr: $srcPronunciationTr, ')
          ..write('srcPronunciationEn: $srcPronunciationEn, ')
          ..write('srcMeaningTr: $srcMeaningTr, ')
          ..write('srcMeaningEn: $srcMeaningEn, ')
          ..write('expectedAudioFile: $expectedAudioFile, ')
          ..write('readyToPublish: $readyToPublish, ')
          ..write('version: $version, ')
          ..write('importDiff: $importDiff, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('titleArType: $titleArType, ')
          ..write('sourceType: $sourceType, ')
          ..write('hadithTr: $hadithTr, ')
          ..write('hadithEn: $hadithEn, ')
          ..write('hadithGrade: $hadithGrade, ')
          ..write('storyTr: $storyTr, ')
          ..write('storyEn: $storyEn, ')
          ..write('recitationCount: $recitationCount, ')
          ..write('recitationTimeTr: $recitationTimeTr, ')
          ..write('recitationTimeEn: $recitationTimeEn, ')
          ..write('standaloneVisible: $standaloneVisible')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    titleTr,
    titleEn,
    titleAr,
    variantOf,
    variantKey,
    quranReference,
    editorialStatus,
    editorialNote,
    sourceJson,
    srcPronunciationTr,
    srcPronunciationEn,
    srcMeaningTr,
    srcMeaningEn,
    expectedAudioFile,
    readyToPublish,
    version,
    importDiff,
    sortOrder,
    titleArType,
    sourceType,
    hadithTr,
    hadithEn,
    hadithGrade,
    storyTr,
    storyEn,
    recitationCount,
    recitationTimeTr,
    recitationTimeEn,
    standaloneVisible,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dua &&
          other.id == this.id &&
          other.titleTr == this.titleTr &&
          other.titleEn == this.titleEn &&
          other.titleAr == this.titleAr &&
          other.variantOf == this.variantOf &&
          other.variantKey == this.variantKey &&
          other.quranReference == this.quranReference &&
          other.editorialStatus == this.editorialStatus &&
          other.editorialNote == this.editorialNote &&
          other.sourceJson == this.sourceJson &&
          other.srcPronunciationTr == this.srcPronunciationTr &&
          other.srcPronunciationEn == this.srcPronunciationEn &&
          other.srcMeaningTr == this.srcMeaningTr &&
          other.srcMeaningEn == this.srcMeaningEn &&
          other.expectedAudioFile == this.expectedAudioFile &&
          other.readyToPublish == this.readyToPublish &&
          other.version == this.version &&
          other.importDiff == this.importDiff &&
          other.sortOrder == this.sortOrder &&
          other.titleArType == this.titleArType &&
          other.sourceType == this.sourceType &&
          other.hadithTr == this.hadithTr &&
          other.hadithEn == this.hadithEn &&
          other.hadithGrade == this.hadithGrade &&
          other.storyTr == this.storyTr &&
          other.storyEn == this.storyEn &&
          other.recitationCount == this.recitationCount &&
          other.recitationTimeTr == this.recitationTimeTr &&
          other.recitationTimeEn == this.recitationTimeEn &&
          other.standaloneVisible == this.standaloneVisible);
}

class DuasCompanion extends UpdateCompanion<Dua> {
  final Value<String> id;
  final Value<String> titleTr;
  final Value<String?> titleEn;
  final Value<String?> titleAr;
  final Value<String?> variantOf;
  final Value<String?> variantKey;
  final Value<String?> quranReference;
  final Value<String?> editorialStatus;
  final Value<String?> editorialNote;
  final Value<String?> sourceJson;
  final Value<String?> srcPronunciationTr;
  final Value<String?> srcPronunciationEn;
  final Value<String?> srcMeaningTr;
  final Value<String?> srcMeaningEn;
  final Value<String?> expectedAudioFile;
  final Value<bool> readyToPublish;
  final Value<int> version;
  final Value<String?> importDiff;
  final Value<int> sortOrder;
  final Value<String?> titleArType;
  final Value<String?> sourceType;
  final Value<String?> hadithTr;
  final Value<String?> hadithEn;
  final Value<String?> hadithGrade;
  final Value<String?> storyTr;
  final Value<String?> storyEn;
  final Value<int?> recitationCount;
  final Value<String?> recitationTimeTr;
  final Value<String?> recitationTimeEn;
  final Value<bool> standaloneVisible;
  final Value<int> rowid;
  const DuasCompanion({
    this.id = const Value.absent(),
    this.titleTr = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.variantOf = const Value.absent(),
    this.variantKey = const Value.absent(),
    this.quranReference = const Value.absent(),
    this.editorialStatus = const Value.absent(),
    this.editorialNote = const Value.absent(),
    this.sourceJson = const Value.absent(),
    this.srcPronunciationTr = const Value.absent(),
    this.srcPronunciationEn = const Value.absent(),
    this.srcMeaningTr = const Value.absent(),
    this.srcMeaningEn = const Value.absent(),
    this.expectedAudioFile = const Value.absent(),
    this.readyToPublish = const Value.absent(),
    this.version = const Value.absent(),
    this.importDiff = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.titleArType = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.hadithTr = const Value.absent(),
    this.hadithEn = const Value.absent(),
    this.hadithGrade = const Value.absent(),
    this.storyTr = const Value.absent(),
    this.storyEn = const Value.absent(),
    this.recitationCount = const Value.absent(),
    this.recitationTimeTr = const Value.absent(),
    this.recitationTimeEn = const Value.absent(),
    this.standaloneVisible = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuasCompanion.insert({
    required String id,
    required String titleTr,
    this.titleEn = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.variantOf = const Value.absent(),
    this.variantKey = const Value.absent(),
    this.quranReference = const Value.absent(),
    this.editorialStatus = const Value.absent(),
    this.editorialNote = const Value.absent(),
    this.sourceJson = const Value.absent(),
    this.srcPronunciationTr = const Value.absent(),
    this.srcPronunciationEn = const Value.absent(),
    this.srcMeaningTr = const Value.absent(),
    this.srcMeaningEn = const Value.absent(),
    this.expectedAudioFile = const Value.absent(),
    this.readyToPublish = const Value.absent(),
    this.version = const Value.absent(),
    this.importDiff = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.titleArType = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.hadithTr = const Value.absent(),
    this.hadithEn = const Value.absent(),
    this.hadithGrade = const Value.absent(),
    this.storyTr = const Value.absent(),
    this.storyEn = const Value.absent(),
    this.recitationCount = const Value.absent(),
    this.recitationTimeTr = const Value.absent(),
    this.recitationTimeEn = const Value.absent(),
    this.standaloneVisible = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       titleTr = Value(titleTr);
  static Insertable<Dua> custom({
    Expression<String>? id,
    Expression<String>? titleTr,
    Expression<String>? titleEn,
    Expression<String>? titleAr,
    Expression<String>? variantOf,
    Expression<String>? variantKey,
    Expression<String>? quranReference,
    Expression<String>? editorialStatus,
    Expression<String>? editorialNote,
    Expression<String>? sourceJson,
    Expression<String>? srcPronunciationTr,
    Expression<String>? srcPronunciationEn,
    Expression<String>? srcMeaningTr,
    Expression<String>? srcMeaningEn,
    Expression<String>? expectedAudioFile,
    Expression<bool>? readyToPublish,
    Expression<int>? version,
    Expression<String>? importDiff,
    Expression<int>? sortOrder,
    Expression<String>? titleArType,
    Expression<String>? sourceType,
    Expression<String>? hadithTr,
    Expression<String>? hadithEn,
    Expression<String>? hadithGrade,
    Expression<String>? storyTr,
    Expression<String>? storyEn,
    Expression<int>? recitationCount,
    Expression<String>? recitationTimeTr,
    Expression<String>? recitationTimeEn,
    Expression<bool>? standaloneVisible,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titleTr != null) 'title_tr': titleTr,
      if (titleEn != null) 'title_en': titleEn,
      if (titleAr != null) 'title_ar': titleAr,
      if (variantOf != null) 'variant_of': variantOf,
      if (variantKey != null) 'variant_key': variantKey,
      if (quranReference != null) 'quran_reference': quranReference,
      if (editorialStatus != null) 'editorial_status': editorialStatus,
      if (editorialNote != null) 'editorial_note': editorialNote,
      if (sourceJson != null) 'source_json': sourceJson,
      if (srcPronunciationTr != null)
        'src_pronunciation_tr': srcPronunciationTr,
      if (srcPronunciationEn != null)
        'src_pronunciation_en': srcPronunciationEn,
      if (srcMeaningTr != null) 'src_meaning_tr': srcMeaningTr,
      if (srcMeaningEn != null) 'src_meaning_en': srcMeaningEn,
      if (expectedAudioFile != null) 'expected_audio_file': expectedAudioFile,
      if (readyToPublish != null) 'ready_to_publish': readyToPublish,
      if (version != null) 'version': version,
      if (importDiff != null) 'import_diff': importDiff,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (titleArType != null) 'title_ar_type': titleArType,
      if (sourceType != null) 'source_type': sourceType,
      if (hadithTr != null) 'hadith_tr': hadithTr,
      if (hadithEn != null) 'hadith_en': hadithEn,
      if (hadithGrade != null) 'hadith_grade': hadithGrade,
      if (storyTr != null) 'story_tr': storyTr,
      if (storyEn != null) 'story_en': storyEn,
      if (recitationCount != null) 'recitation_count': recitationCount,
      if (recitationTimeTr != null) 'recitation_time_tr': recitationTimeTr,
      if (recitationTimeEn != null) 'recitation_time_en': recitationTimeEn,
      if (standaloneVisible != null) 'standalone_visible': standaloneVisible,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuasCompanion copyWith({
    Value<String>? id,
    Value<String>? titleTr,
    Value<String?>? titleEn,
    Value<String?>? titleAr,
    Value<String?>? variantOf,
    Value<String?>? variantKey,
    Value<String?>? quranReference,
    Value<String?>? editorialStatus,
    Value<String?>? editorialNote,
    Value<String?>? sourceJson,
    Value<String?>? srcPronunciationTr,
    Value<String?>? srcPronunciationEn,
    Value<String?>? srcMeaningTr,
    Value<String?>? srcMeaningEn,
    Value<String?>? expectedAudioFile,
    Value<bool>? readyToPublish,
    Value<int>? version,
    Value<String?>? importDiff,
    Value<int>? sortOrder,
    Value<String?>? titleArType,
    Value<String?>? sourceType,
    Value<String?>? hadithTr,
    Value<String?>? hadithEn,
    Value<String?>? hadithGrade,
    Value<String?>? storyTr,
    Value<String?>? storyEn,
    Value<int?>? recitationCount,
    Value<String?>? recitationTimeTr,
    Value<String?>? recitationTimeEn,
    Value<bool>? standaloneVisible,
    Value<int>? rowid,
  }) {
    return DuasCompanion(
      id: id ?? this.id,
      titleTr: titleTr ?? this.titleTr,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      variantOf: variantOf ?? this.variantOf,
      variantKey: variantKey ?? this.variantKey,
      quranReference: quranReference ?? this.quranReference,
      editorialStatus: editorialStatus ?? this.editorialStatus,
      editorialNote: editorialNote ?? this.editorialNote,
      sourceJson: sourceJson ?? this.sourceJson,
      srcPronunciationTr: srcPronunciationTr ?? this.srcPronunciationTr,
      srcPronunciationEn: srcPronunciationEn ?? this.srcPronunciationEn,
      srcMeaningTr: srcMeaningTr ?? this.srcMeaningTr,
      srcMeaningEn: srcMeaningEn ?? this.srcMeaningEn,
      expectedAudioFile: expectedAudioFile ?? this.expectedAudioFile,
      readyToPublish: readyToPublish ?? this.readyToPublish,
      version: version ?? this.version,
      importDiff: importDiff ?? this.importDiff,
      sortOrder: sortOrder ?? this.sortOrder,
      titleArType: titleArType ?? this.titleArType,
      sourceType: sourceType ?? this.sourceType,
      hadithTr: hadithTr ?? this.hadithTr,
      hadithEn: hadithEn ?? this.hadithEn,
      hadithGrade: hadithGrade ?? this.hadithGrade,
      storyTr: storyTr ?? this.storyTr,
      storyEn: storyEn ?? this.storyEn,
      recitationCount: recitationCount ?? this.recitationCount,
      recitationTimeTr: recitationTimeTr ?? this.recitationTimeTr,
      recitationTimeEn: recitationTimeEn ?? this.recitationTimeEn,
      standaloneVisible: standaloneVisible ?? this.standaloneVisible,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titleTr.present) {
      map['title_tr'] = Variable<String>(titleTr.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (variantOf.present) {
      map['variant_of'] = Variable<String>(variantOf.value);
    }
    if (variantKey.present) {
      map['variant_key'] = Variable<String>(variantKey.value);
    }
    if (quranReference.present) {
      map['quran_reference'] = Variable<String>(quranReference.value);
    }
    if (editorialStatus.present) {
      map['editorial_status'] = Variable<String>(editorialStatus.value);
    }
    if (editorialNote.present) {
      map['editorial_note'] = Variable<String>(editorialNote.value);
    }
    if (sourceJson.present) {
      map['source_json'] = Variable<String>(sourceJson.value);
    }
    if (srcPronunciationTr.present) {
      map['src_pronunciation_tr'] = Variable<String>(srcPronunciationTr.value);
    }
    if (srcPronunciationEn.present) {
      map['src_pronunciation_en'] = Variable<String>(srcPronunciationEn.value);
    }
    if (srcMeaningTr.present) {
      map['src_meaning_tr'] = Variable<String>(srcMeaningTr.value);
    }
    if (srcMeaningEn.present) {
      map['src_meaning_en'] = Variable<String>(srcMeaningEn.value);
    }
    if (expectedAudioFile.present) {
      map['expected_audio_file'] = Variable<String>(expectedAudioFile.value);
    }
    if (readyToPublish.present) {
      map['ready_to_publish'] = Variable<bool>(readyToPublish.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (importDiff.present) {
      map['import_diff'] = Variable<String>(importDiff.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (titleArType.present) {
      map['title_ar_type'] = Variable<String>(titleArType.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (hadithTr.present) {
      map['hadith_tr'] = Variable<String>(hadithTr.value);
    }
    if (hadithEn.present) {
      map['hadith_en'] = Variable<String>(hadithEn.value);
    }
    if (hadithGrade.present) {
      map['hadith_grade'] = Variable<String>(hadithGrade.value);
    }
    if (storyTr.present) {
      map['story_tr'] = Variable<String>(storyTr.value);
    }
    if (storyEn.present) {
      map['story_en'] = Variable<String>(storyEn.value);
    }
    if (recitationCount.present) {
      map['recitation_count'] = Variable<int>(recitationCount.value);
    }
    if (recitationTimeTr.present) {
      map['recitation_time_tr'] = Variable<String>(recitationTimeTr.value);
    }
    if (recitationTimeEn.present) {
      map['recitation_time_en'] = Variable<String>(recitationTimeEn.value);
    }
    if (standaloneVisible.present) {
      map['standalone_visible'] = Variable<bool>(standaloneVisible.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuasCompanion(')
          ..write('id: $id, ')
          ..write('titleTr: $titleTr, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleAr: $titleAr, ')
          ..write('variantOf: $variantOf, ')
          ..write('variantKey: $variantKey, ')
          ..write('quranReference: $quranReference, ')
          ..write('editorialStatus: $editorialStatus, ')
          ..write('editorialNote: $editorialNote, ')
          ..write('sourceJson: $sourceJson, ')
          ..write('srcPronunciationTr: $srcPronunciationTr, ')
          ..write('srcPronunciationEn: $srcPronunciationEn, ')
          ..write('srcMeaningTr: $srcMeaningTr, ')
          ..write('srcMeaningEn: $srcMeaningEn, ')
          ..write('expectedAudioFile: $expectedAudioFile, ')
          ..write('readyToPublish: $readyToPublish, ')
          ..write('version: $version, ')
          ..write('importDiff: $importDiff, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('titleArType: $titleArType, ')
          ..write('sourceType: $sourceType, ')
          ..write('hadithTr: $hadithTr, ')
          ..write('hadithEn: $hadithEn, ')
          ..write('hadithGrade: $hadithGrade, ')
          ..write('storyTr: $storyTr, ')
          ..write('storyEn: $storyEn, ')
          ..write('recitationCount: $recitationCount, ')
          ..write('recitationTimeTr: $recitationTimeTr, ')
          ..write('recitationTimeEn: $recitationTimeEn, ')
          ..write('standaloneVisible: $standaloneVisible, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameTrMeta = const VerificationMeta('nameTr');
  @override
  late final GeneratedColumn<String> nameTr = GeneratedColumn<String>(
    'name_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, nameTr, nameEn, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('name_tr')) {
      context.handle(
        _nameTrMeta,
        nameTr.isAcceptableOrUnknown(data['name_tr']!, _nameTrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameTrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      nameTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_tr'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;

  /// JSON'daki kalıcı kategori kodu (ör. `forgiveness`); elle eklenen kategoride boş olabilir.
  final String? code;
  final String nameTr;
  final String? nameEn;
  final int sortOrder;
  const Category({
    required this.id,
    this.code,
    required this.nameTr,
    this.nameEn,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['name_tr'] = Variable<String>(nameTr);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      nameTr: Value(nameTr),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String?>(json['code']),
      nameTr: serializer.fromJson<String>(json['nameTr']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String?>(code),
      'nameTr': serializer.toJson<String>(nameTr),
      'nameEn': serializer.toJson<String?>(nameEn),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith({
    int? id,
    Value<String?> code = const Value.absent(),
    String? nameTr,
    Value<String?> nameEn = const Value.absent(),
    int? sortOrder,
  }) => Category(
    id: id ?? this.id,
    code: code.present ? code.value : this.code,
    nameTr: nameTr ?? this.nameTr,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameTr: data.nameTr.present ? data.nameTr.value : this.nameTr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameTr: $nameTr, ')
          ..write('nameEn: $nameEn, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, nameTr, nameEn, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameTr == this.nameTr &&
          other.nameEn == this.nameEn &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String?> code;
  final Value<String> nameTr;
  final Value<String?> nameEn;
  final Value<int> sortOrder;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameTr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    required String nameTr,
    this.nameEn = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : nameTr = Value(nameTr);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nameTr,
    Expression<String>? nameEn,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameTr != null) 'name_tr': nameTr,
      if (nameEn != null) 'name_en': nameEn,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String?>? code,
    Value<String>? nameTr,
    Value<String?>? nameEn,
    Value<int>? sortOrder,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameTr: nameTr ?? this.nameTr,
      nameEn: nameEn ?? this.nameEn,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameTr.present) {
      map['name_tr'] = Variable<String>(nameTr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameTr: $nameTr, ')
          ..write('nameEn: $nameEn, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $DuaCategoriesTable extends DuaCategories
    with TableInfo<$DuaCategoriesTable, DuaCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuaCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _duaIdMeta = const VerificationMeta('duaId');
  @override
  late final GeneratedColumn<String> duaId = GeneratedColumn<String>(
    'dua_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES duas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [duaId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dua_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DuaCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dua_id')) {
      context.handle(
        _duaIdMeta,
        duaId.isAcceptableOrUnknown(data['dua_id']!, _duaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_duaIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {duaId, categoryId};
  @override
  DuaCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DuaCategory(
      duaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dua_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $DuaCategoriesTable createAlias(String alias) {
    return $DuaCategoriesTable(attachedDatabase, alias);
  }
}

class DuaCategory extends DataClass implements Insertable<DuaCategory> {
  final String duaId;
  final int categoryId;
  const DuaCategory({required this.duaId, required this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dua_id'] = Variable<String>(duaId);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  DuaCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DuaCategoriesCompanion(
      duaId: Value(duaId),
      categoryId: Value(categoryId),
    );
  }

  factory DuaCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DuaCategory(
      duaId: serializer.fromJson<String>(json['duaId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'duaId': serializer.toJson<String>(duaId),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  DuaCategory copyWith({String? duaId, int? categoryId}) => DuaCategory(
    duaId: duaId ?? this.duaId,
    categoryId: categoryId ?? this.categoryId,
  );
  DuaCategory copyWithCompanion(DuaCategoriesCompanion data) {
    return DuaCategory(
      duaId: data.duaId.present ? data.duaId.value : this.duaId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DuaCategory(')
          ..write('duaId: $duaId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(duaId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DuaCategory &&
          other.duaId == this.duaId &&
          other.categoryId == this.categoryId);
}

class DuaCategoriesCompanion extends UpdateCompanion<DuaCategory> {
  final Value<String> duaId;
  final Value<int> categoryId;
  final Value<int> rowid;
  const DuaCategoriesCompanion({
    this.duaId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DuaCategoriesCompanion.insert({
    required String duaId,
    required int categoryId,
    this.rowid = const Value.absent(),
  }) : duaId = Value(duaId),
       categoryId = Value(categoryId);
  static Insertable<DuaCategory> custom({
    Expression<String>? duaId,
    Expression<int>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (duaId != null) 'dua_id': duaId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DuaCategoriesCompanion copyWith({
    Value<String>? duaId,
    Value<int>? categoryId,
    Value<int>? rowid,
  }) {
    return DuaCategoriesCompanion(
      duaId: duaId ?? this.duaId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (duaId.present) {
      map['dua_id'] = Variable<String>(duaId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuaCategoriesCompanion(')
          ..write('duaId: $duaId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, DuaGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleTrMeta = const VerificationMeta(
    'titleTr',
  );
  @override
  late final GeneratedColumn<String> titleTr = GeneratedColumn<String>(
    'title_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleArMeta = const VerificationMeta(
    'titleAr',
  );
  @override
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
    'title_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editorialStatusMeta = const VerificationMeta(
    'editorialStatus',
  );
  @override
  late final GeneratedColumn<String> editorialStatus = GeneratedColumn<String>(
    'editorial_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _infoJsonMeta = const VerificationMeta(
    'infoJson',
  );
  @override
  late final GeneratedColumn<String> infoJson = GeneratedColumn<String>(
    'info_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titleTr,
    titleEn,
    titleAr,
    description,
    editorialStatus,
    infoJson,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<DuaGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title_tr')) {
      context.handle(
        _titleTrMeta,
        titleTr.isAcceptableOrUnknown(data['title_tr']!, _titleTrMeta),
      );
    } else if (isInserting) {
      context.missing(_titleTrMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    }
    if (data.containsKey('title_ar')) {
      context.handle(
        _titleArMeta,
        titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('editorial_status')) {
      context.handle(
        _editorialStatusMeta,
        editorialStatus.isAcceptableOrUnknown(
          data['editorial_status']!,
          _editorialStatusMeta,
        ),
      );
    }
    if (data.containsKey('info_json')) {
      context.handle(
        _infoJsonMeta,
        infoJson.isAcceptableOrUnknown(data['info_json']!, _infoJsonMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DuaGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DuaGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      titleTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_tr'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      ),
      titleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      editorialStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}editorial_status'],
      ),
      infoJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}info_json'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class DuaGroup extends DataClass implements Insertable<DuaGroup> {
  final String id;
  final String titleTr;
  final String? titleEn;
  final String? titleAr;
  final String? description;
  final String? editorialStatus;
  final String? infoJson;
  final int sortOrder;
  const DuaGroup({
    required this.id,
    required this.titleTr,
    this.titleEn,
    this.titleAr,
    this.description,
    this.editorialStatus,
    this.infoJson,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title_tr'] = Variable<String>(titleTr);
    if (!nullToAbsent || titleEn != null) {
      map['title_en'] = Variable<String>(titleEn);
    }
    if (!nullToAbsent || titleAr != null) {
      map['title_ar'] = Variable<String>(titleAr);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || editorialStatus != null) {
      map['editorial_status'] = Variable<String>(editorialStatus);
    }
    if (!nullToAbsent || infoJson != null) {
      map['info_json'] = Variable<String>(infoJson);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      titleTr: Value(titleTr),
      titleEn: titleEn == null && nullToAbsent
          ? const Value.absent()
          : Value(titleEn),
      titleAr: titleAr == null && nullToAbsent
          ? const Value.absent()
          : Value(titleAr),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      editorialStatus: editorialStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(editorialStatus),
      infoJson: infoJson == null && nullToAbsent
          ? const Value.absent()
          : Value(infoJson),
      sortOrder: Value(sortOrder),
    );
  }

  factory DuaGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DuaGroup(
      id: serializer.fromJson<String>(json['id']),
      titleTr: serializer.fromJson<String>(json['titleTr']),
      titleEn: serializer.fromJson<String?>(json['titleEn']),
      titleAr: serializer.fromJson<String?>(json['titleAr']),
      description: serializer.fromJson<String?>(json['description']),
      editorialStatus: serializer.fromJson<String?>(json['editorialStatus']),
      infoJson: serializer.fromJson<String?>(json['infoJson']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titleTr': serializer.toJson<String>(titleTr),
      'titleEn': serializer.toJson<String?>(titleEn),
      'titleAr': serializer.toJson<String?>(titleAr),
      'description': serializer.toJson<String?>(description),
      'editorialStatus': serializer.toJson<String?>(editorialStatus),
      'infoJson': serializer.toJson<String?>(infoJson),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DuaGroup copyWith({
    String? id,
    String? titleTr,
    Value<String?> titleEn = const Value.absent(),
    Value<String?> titleAr = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> editorialStatus = const Value.absent(),
    Value<String?> infoJson = const Value.absent(),
    int? sortOrder,
  }) => DuaGroup(
    id: id ?? this.id,
    titleTr: titleTr ?? this.titleTr,
    titleEn: titleEn.present ? titleEn.value : this.titleEn,
    titleAr: titleAr.present ? titleAr.value : this.titleAr,
    description: description.present ? description.value : this.description,
    editorialStatus: editorialStatus.present
        ? editorialStatus.value
        : this.editorialStatus,
    infoJson: infoJson.present ? infoJson.value : this.infoJson,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DuaGroup copyWithCompanion(GroupsCompanion data) {
    return DuaGroup(
      id: data.id.present ? data.id.value : this.id,
      titleTr: data.titleTr.present ? data.titleTr.value : this.titleTr,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      description: data.description.present
          ? data.description.value
          : this.description,
      editorialStatus: data.editorialStatus.present
          ? data.editorialStatus.value
          : this.editorialStatus,
      infoJson: data.infoJson.present ? data.infoJson.value : this.infoJson,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DuaGroup(')
          ..write('id: $id, ')
          ..write('titleTr: $titleTr, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleAr: $titleAr, ')
          ..write('description: $description, ')
          ..write('editorialStatus: $editorialStatus, ')
          ..write('infoJson: $infoJson, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    titleTr,
    titleEn,
    titleAr,
    description,
    editorialStatus,
    infoJson,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DuaGroup &&
          other.id == this.id &&
          other.titleTr == this.titleTr &&
          other.titleEn == this.titleEn &&
          other.titleAr == this.titleAr &&
          other.description == this.description &&
          other.editorialStatus == this.editorialStatus &&
          other.infoJson == this.infoJson &&
          other.sortOrder == this.sortOrder);
}

class GroupsCompanion extends UpdateCompanion<DuaGroup> {
  final Value<String> id;
  final Value<String> titleTr;
  final Value<String?> titleEn;
  final Value<String?> titleAr;
  final Value<String?> description;
  final Value<String?> editorialStatus;
  final Value<String?> infoJson;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.titleTr = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.description = const Value.absent(),
    this.editorialStatus = const Value.absent(),
    this.infoJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    required String id,
    required String titleTr,
    this.titleEn = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.description = const Value.absent(),
    this.editorialStatus = const Value.absent(),
    this.infoJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       titleTr = Value(titleTr);
  static Insertable<DuaGroup> custom({
    Expression<String>? id,
    Expression<String>? titleTr,
    Expression<String>? titleEn,
    Expression<String>? titleAr,
    Expression<String>? description,
    Expression<String>? editorialStatus,
    Expression<String>? infoJson,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titleTr != null) 'title_tr': titleTr,
      if (titleEn != null) 'title_en': titleEn,
      if (titleAr != null) 'title_ar': titleAr,
      if (description != null) 'description': description,
      if (editorialStatus != null) 'editorial_status': editorialStatus,
      if (infoJson != null) 'info_json': infoJson,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? titleTr,
    Value<String?>? titleEn,
    Value<String?>? titleAr,
    Value<String?>? description,
    Value<String?>? editorialStatus,
    Value<String?>? infoJson,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      titleTr: titleTr ?? this.titleTr,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      description: description ?? this.description,
      editorialStatus: editorialStatus ?? this.editorialStatus,
      infoJson: infoJson ?? this.infoJson,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titleTr.present) {
      map['title_tr'] = Variable<String>(titleTr.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (editorialStatus.present) {
      map['editorial_status'] = Variable<String>(editorialStatus.value);
    }
    if (infoJson.present) {
      map['info_json'] = Variable<String>(infoJson.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('titleTr: $titleTr, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleAr: $titleAr, ')
          ..write('description: $description, ')
          ..write('editorialStatus: $editorialStatus, ')
          ..write('infoJson: $infoJson, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupCategoriesTable extends GroupCategories
    with TableInfo<$GroupCategoriesTable, GroupCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [groupId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, categoryId};
  @override
  GroupCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupCategory(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $GroupCategoriesTable createAlias(String alias) {
    return $GroupCategoriesTable(attachedDatabase, alias);
  }
}

class GroupCategory extends DataClass implements Insertable<GroupCategory> {
  final String groupId;
  final int categoryId;
  const GroupCategory({required this.groupId, required this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  GroupCategoriesCompanion toCompanion(bool nullToAbsent) {
    return GroupCategoriesCompanion(
      groupId: Value(groupId),
      categoryId: Value(categoryId),
    );
  }

  factory GroupCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupCategory(
      groupId: serializer.fromJson<String>(json['groupId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  GroupCategory copyWith({String? groupId, int? categoryId}) => GroupCategory(
    groupId: groupId ?? this.groupId,
    categoryId: categoryId ?? this.categoryId,
  );
  GroupCategory copyWithCompanion(GroupCategoriesCompanion data) {
    return GroupCategory(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupCategory(')
          ..write('groupId: $groupId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupCategory &&
          other.groupId == this.groupId &&
          other.categoryId == this.categoryId);
}

class GroupCategoriesCompanion extends UpdateCompanion<GroupCategory> {
  final Value<String> groupId;
  final Value<int> categoryId;
  final Value<int> rowid;
  const GroupCategoriesCompanion({
    this.groupId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupCategoriesCompanion.insert({
    required String groupId,
    required int categoryId,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       categoryId = Value(categoryId);
  static Insertable<GroupCategory> custom({
    Expression<String>? groupId,
    Expression<int>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupCategoriesCompanion copyWith({
    Value<String>? groupId,
    Value<int>? categoryId,
    Value<int>? rowid,
  }) {
    return GroupCategoriesCompanion(
      groupId: groupId ?? this.groupId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupCategoriesCompanion(')
          ..write('groupId: $groupId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupItemsTable extends GroupItems
    with TableInfo<$GroupItemsTable, GroupItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _duaIdMeta = const VerificationMeta('duaId');
  @override
  late final GeneratedColumn<String> duaId = GeneratedColumn<String>(
    'dua_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES duas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatCountMeta = const VerificationMeta(
    'repeatCount',
  );
  @override
  late final GeneratedColumn<int> repeatCount = GeneratedColumn<int>(
    'repeat_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    duaId,
    position,
    repeatCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('dua_id')) {
      context.handle(
        _duaIdMeta,
        duaId.isAcceptableOrUnknown(data['dua_id']!, _duaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_duaIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('repeat_count')) {
      context.handle(
        _repeatCountMeta,
        repeatCount.isAcceptableOrUnknown(
          data['repeat_count']!,
          _repeatCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {groupId, duaId},
  ];
  @override
  GroupItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      duaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dua_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      ),
      repeatCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_count'],
      )!,
    );
  }

  @override
  $GroupItemsTable createAlias(String alias) {
    return $GroupItemsTable(attachedDatabase, alias);
  }
}

class GroupItem extends DataClass implements Insertable<GroupItem> {
  final int id;
  final String groupId;
  final String duaId;

  /// null = sırasız üyelik.
  final int? position;

  /// Grupta bu duanın kaç kez okunacağı.
  final int repeatCount;
  const GroupItem({
    required this.id,
    required this.groupId,
    required this.duaId,
    this.position,
    required this.repeatCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<String>(groupId);
    map['dua_id'] = Variable<String>(duaId);
    if (!nullToAbsent || position != null) {
      map['position'] = Variable<int>(position);
    }
    map['repeat_count'] = Variable<int>(repeatCount);
    return map;
  }

  GroupItemsCompanion toCompanion(bool nullToAbsent) {
    return GroupItemsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      duaId: Value(duaId),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      repeatCount: Value(repeatCount),
    );
  }

  factory GroupItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupItem(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      duaId: serializer.fromJson<String>(json['duaId']),
      position: serializer.fromJson<int?>(json['position']),
      repeatCount: serializer.fromJson<int>(json['repeatCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<String>(groupId),
      'duaId': serializer.toJson<String>(duaId),
      'position': serializer.toJson<int?>(position),
      'repeatCount': serializer.toJson<int>(repeatCount),
    };
  }

  GroupItem copyWith({
    int? id,
    String? groupId,
    String? duaId,
    Value<int?> position = const Value.absent(),
    int? repeatCount,
  }) => GroupItem(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    duaId: duaId ?? this.duaId,
    position: position.present ? position.value : this.position,
    repeatCount: repeatCount ?? this.repeatCount,
  );
  GroupItem copyWithCompanion(GroupItemsCompanion data) {
    return GroupItem(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      duaId: data.duaId.present ? data.duaId.value : this.duaId,
      position: data.position.present ? data.position.value : this.position,
      repeatCount: data.repeatCount.present
          ? data.repeatCount.value
          : this.repeatCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupItem(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('duaId: $duaId, ')
          ..write('position: $position, ')
          ..write('repeatCount: $repeatCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, duaId, position, repeatCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupItem &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.duaId == this.duaId &&
          other.position == this.position &&
          other.repeatCount == this.repeatCount);
}

class GroupItemsCompanion extends UpdateCompanion<GroupItem> {
  final Value<int> id;
  final Value<String> groupId;
  final Value<String> duaId;
  final Value<int?> position;
  final Value<int> repeatCount;
  const GroupItemsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.duaId = const Value.absent(),
    this.position = const Value.absent(),
    this.repeatCount = const Value.absent(),
  });
  GroupItemsCompanion.insert({
    this.id = const Value.absent(),
    required String groupId,
    required String duaId,
    this.position = const Value.absent(),
    this.repeatCount = const Value.absent(),
  }) : groupId = Value(groupId),
       duaId = Value(duaId);
  static Insertable<GroupItem> custom({
    Expression<int>? id,
    Expression<String>? groupId,
    Expression<String>? duaId,
    Expression<int>? position,
    Expression<int>? repeatCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (duaId != null) 'dua_id': duaId,
      if (position != null) 'position': position,
      if (repeatCount != null) 'repeat_count': repeatCount,
    });
  }

  GroupItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? groupId,
    Value<String>? duaId,
    Value<int?>? position,
    Value<int>? repeatCount,
  }) {
    return GroupItemsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      duaId: duaId ?? this.duaId,
      position: position ?? this.position,
      repeatCount: repeatCount ?? this.repeatCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (duaId.present) {
      map['dua_id'] = Variable<String>(duaId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (repeatCount.present) {
      map['repeat_count'] = Variable<int>(repeatCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupItemsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('duaId: $duaId, ')
          ..write('position: $position, ')
          ..write('repeatCount: $repeatCount')
          ..write(')'))
        .toString();
  }
}

class $SegmentsTable extends Segments with TableInfo<$SegmentsTable, Segment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SegmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _duaIdMeta = const VerificationMeta('duaId');
  @override
  late final GeneratedColumn<String> duaId = GeneratedColumn<String>(
    'dua_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES duas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textArMeta = const VerificationMeta('textAr');
  @override
  late final GeneratedColumn<String> textAr = GeneratedColumn<String>(
    'text_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pronunciationTrMeta = const VerificationMeta(
    'pronunciationTr',
  );
  @override
  late final GeneratedColumn<String> pronunciationTr = GeneratedColumn<String>(
    'pronunciation_tr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pronunciationEnMeta = const VerificationMeta(
    'pronunciationEn',
  );
  @override
  late final GeneratedColumn<String> pronunciationEn = GeneratedColumn<String>(
    'pronunciation_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meaningTrMeta = const VerificationMeta(
    'meaningTr',
  );
  @override
  late final GeneratedColumn<String> meaningTr = GeneratedColumn<String>(
    'meaning_tr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meaningEnMeta = const VerificationMeta(
    'meaningEn',
  );
  @override
  late final GeneratedColumn<String> meaningEn = GeneratedColumn<String>(
    'meaning_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FieldSource?, String>
  pronunciationTrSource =
      GeneratedColumn<String>(
        'pronunciation_tr_source',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<FieldSource?>(
        $SegmentsTable.$converterpronunciationTrSourcen,
      );
  @override
  late final GeneratedColumnWithTypeConverter<FieldSource?, String>
  pronunciationEnSource =
      GeneratedColumn<String>(
        'pronunciation_en_source',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<FieldSource?>(
        $SegmentsTable.$converterpronunciationEnSourcen,
      );
  @override
  late final GeneratedColumnWithTypeConverter<FieldSource?, String>
  meaningTrSource = GeneratedColumn<String>(
    'meaning_tr_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<FieldSource?>($SegmentsTable.$convertermeaningTrSourcen);
  @override
  late final GeneratedColumnWithTypeConverter<FieldSource?, String>
  meaningEnSource = GeneratedColumn<String>(
    'meaning_en_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<FieldSource?>($SegmentsTable.$convertermeaningEnSourcen);
  @override
  late final GeneratedColumnWithTypeConverter<ReviewStatus, String> review =
      GeneratedColumn<String>(
        'review',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(ReviewStatus.none.name),
      ).withConverter<ReviewStatus>($SegmentsTable.$converterreview);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    duaId,
    position,
    textAr,
    pronunciationTr,
    pronunciationEn,
    meaningTr,
    meaningEn,
    pronunciationTrSource,
    pronunciationEnSource,
    meaningTrSource,
    meaningEnSource,
    review,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'segments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Segment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dua_id')) {
      context.handle(
        _duaIdMeta,
        duaId.isAcceptableOrUnknown(data['dua_id']!, _duaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_duaIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('text_ar')) {
      context.handle(
        _textArMeta,
        textAr.isAcceptableOrUnknown(data['text_ar']!, _textArMeta),
      );
    } else if (isInserting) {
      context.missing(_textArMeta);
    }
    if (data.containsKey('pronunciation_tr')) {
      context.handle(
        _pronunciationTrMeta,
        pronunciationTr.isAcceptableOrUnknown(
          data['pronunciation_tr']!,
          _pronunciationTrMeta,
        ),
      );
    }
    if (data.containsKey('pronunciation_en')) {
      context.handle(
        _pronunciationEnMeta,
        pronunciationEn.isAcceptableOrUnknown(
          data['pronunciation_en']!,
          _pronunciationEnMeta,
        ),
      );
    }
    if (data.containsKey('meaning_tr')) {
      context.handle(
        _meaningTrMeta,
        meaningTr.isAcceptableOrUnknown(data['meaning_tr']!, _meaningTrMeta),
      );
    }
    if (data.containsKey('meaning_en')) {
      context.handle(
        _meaningEnMeta,
        meaningEn.isAcceptableOrUnknown(data['meaning_en']!, _meaningEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Segment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Segment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      duaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dua_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      textAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_ar'],
      )!,
      pronunciationTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pronunciation_tr'],
      ),
      pronunciationEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pronunciation_en'],
      ),
      meaningTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_tr'],
      ),
      meaningEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_en'],
      ),
      pronunciationTrSource: $SegmentsTable.$converterpronunciationTrSourcen
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}pronunciation_tr_source'],
            ),
          ),
      pronunciationEnSource: $SegmentsTable.$converterpronunciationEnSourcen
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}pronunciation_en_source'],
            ),
          ),
      meaningTrSource: $SegmentsTable.$convertermeaningTrSourcen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}meaning_tr_source'],
        ),
      ),
      meaningEnSource: $SegmentsTable.$convertermeaningEnSourcen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}meaning_en_source'],
        ),
      ),
      review: $SegmentsTable.$converterreview.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}review'],
        )!,
      ),
    );
  }

  @override
  $SegmentsTable createAlias(String alias) {
    return $SegmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FieldSource, String, String>
  $converterpronunciationTrSource = const EnumNameConverter<FieldSource>(
    FieldSource.values,
  );
  static JsonTypeConverter2<FieldSource?, String?, String?>
  $converterpronunciationTrSourcen = JsonTypeConverter2.asNullable(
    $converterpronunciationTrSource,
  );
  static JsonTypeConverter2<FieldSource, String, String>
  $converterpronunciationEnSource = const EnumNameConverter<FieldSource>(
    FieldSource.values,
  );
  static JsonTypeConverter2<FieldSource?, String?, String?>
  $converterpronunciationEnSourcen = JsonTypeConverter2.asNullable(
    $converterpronunciationEnSource,
  );
  static JsonTypeConverter2<FieldSource, String, String>
  $convertermeaningTrSource = const EnumNameConverter<FieldSource>(
    FieldSource.values,
  );
  static JsonTypeConverter2<FieldSource?, String?, String?>
  $convertermeaningTrSourcen = JsonTypeConverter2.asNullable(
    $convertermeaningTrSource,
  );
  static JsonTypeConverter2<FieldSource, String, String>
  $convertermeaningEnSource = const EnumNameConverter<FieldSource>(
    FieldSource.values,
  );
  static JsonTypeConverter2<FieldSource?, String?, String?>
  $convertermeaningEnSourcen = JsonTypeConverter2.asNullable(
    $convertermeaningEnSource,
  );
  static JsonTypeConverter2<ReviewStatus, String, String> $converterreview =
      const EnumNameConverter<ReviewStatus>(ReviewStatus.values);
}

class Segment extends DataClass implements Insertable<Segment> {
  final int id;
  final String duaId;
  final int position;
  final String textAr;
  final String? pronunciationTr;
  final String? pronunciationEn;
  final String? meaningTr;
  final String? meaningEn;
  final FieldSource? pronunciationTrSource;
  final FieldSource? pronunciationEnSource;
  final FieldSource? meaningTrSource;
  final FieldSource? meaningEnSource;
  final ReviewStatus review;
  const Segment({
    required this.id,
    required this.duaId,
    required this.position,
    required this.textAr,
    this.pronunciationTr,
    this.pronunciationEn,
    this.meaningTr,
    this.meaningEn,
    this.pronunciationTrSource,
    this.pronunciationEnSource,
    this.meaningTrSource,
    this.meaningEnSource,
    required this.review,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dua_id'] = Variable<String>(duaId);
    map['position'] = Variable<int>(position);
    map['text_ar'] = Variable<String>(textAr);
    if (!nullToAbsent || pronunciationTr != null) {
      map['pronunciation_tr'] = Variable<String>(pronunciationTr);
    }
    if (!nullToAbsent || pronunciationEn != null) {
      map['pronunciation_en'] = Variable<String>(pronunciationEn);
    }
    if (!nullToAbsent || meaningTr != null) {
      map['meaning_tr'] = Variable<String>(meaningTr);
    }
    if (!nullToAbsent || meaningEn != null) {
      map['meaning_en'] = Variable<String>(meaningEn);
    }
    if (!nullToAbsent || pronunciationTrSource != null) {
      map['pronunciation_tr_source'] = Variable<String>(
        $SegmentsTable.$converterpronunciationTrSourcen.toSql(
          pronunciationTrSource,
        ),
      );
    }
    if (!nullToAbsent || pronunciationEnSource != null) {
      map['pronunciation_en_source'] = Variable<String>(
        $SegmentsTable.$converterpronunciationEnSourcen.toSql(
          pronunciationEnSource,
        ),
      );
    }
    if (!nullToAbsent || meaningTrSource != null) {
      map['meaning_tr_source'] = Variable<String>(
        $SegmentsTable.$convertermeaningTrSourcen.toSql(meaningTrSource),
      );
    }
    if (!nullToAbsent || meaningEnSource != null) {
      map['meaning_en_source'] = Variable<String>(
        $SegmentsTable.$convertermeaningEnSourcen.toSql(meaningEnSource),
      );
    }
    {
      map['review'] = Variable<String>(
        $SegmentsTable.$converterreview.toSql(review),
      );
    }
    return map;
  }

  SegmentsCompanion toCompanion(bool nullToAbsent) {
    return SegmentsCompanion(
      id: Value(id),
      duaId: Value(duaId),
      position: Value(position),
      textAr: Value(textAr),
      pronunciationTr: pronunciationTr == null && nullToAbsent
          ? const Value.absent()
          : Value(pronunciationTr),
      pronunciationEn: pronunciationEn == null && nullToAbsent
          ? const Value.absent()
          : Value(pronunciationEn),
      meaningTr: meaningTr == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningTr),
      meaningEn: meaningEn == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningEn),
      pronunciationTrSource: pronunciationTrSource == null && nullToAbsent
          ? const Value.absent()
          : Value(pronunciationTrSource),
      pronunciationEnSource: pronunciationEnSource == null && nullToAbsent
          ? const Value.absent()
          : Value(pronunciationEnSource),
      meaningTrSource: meaningTrSource == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningTrSource),
      meaningEnSource: meaningEnSource == null && nullToAbsent
          ? const Value.absent()
          : Value(meaningEnSource),
      review: Value(review),
    );
  }

  factory Segment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Segment(
      id: serializer.fromJson<int>(json['id']),
      duaId: serializer.fromJson<String>(json['duaId']),
      position: serializer.fromJson<int>(json['position']),
      textAr: serializer.fromJson<String>(json['textAr']),
      pronunciationTr: serializer.fromJson<String?>(json['pronunciationTr']),
      pronunciationEn: serializer.fromJson<String?>(json['pronunciationEn']),
      meaningTr: serializer.fromJson<String?>(json['meaningTr']),
      meaningEn: serializer.fromJson<String?>(json['meaningEn']),
      pronunciationTrSource: $SegmentsTable.$converterpronunciationTrSourcen
          .fromJson(
            serializer.fromJson<String?>(json['pronunciationTrSource']),
          ),
      pronunciationEnSource: $SegmentsTable.$converterpronunciationEnSourcen
          .fromJson(
            serializer.fromJson<String?>(json['pronunciationEnSource']),
          ),
      meaningTrSource: $SegmentsTable.$convertermeaningTrSourcen.fromJson(
        serializer.fromJson<String?>(json['meaningTrSource']),
      ),
      meaningEnSource: $SegmentsTable.$convertermeaningEnSourcen.fromJson(
        serializer.fromJson<String?>(json['meaningEnSource']),
      ),
      review: $SegmentsTable.$converterreview.fromJson(
        serializer.fromJson<String>(json['review']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'duaId': serializer.toJson<String>(duaId),
      'position': serializer.toJson<int>(position),
      'textAr': serializer.toJson<String>(textAr),
      'pronunciationTr': serializer.toJson<String?>(pronunciationTr),
      'pronunciationEn': serializer.toJson<String?>(pronunciationEn),
      'meaningTr': serializer.toJson<String?>(meaningTr),
      'meaningEn': serializer.toJson<String?>(meaningEn),
      'pronunciationTrSource': serializer.toJson<String?>(
        $SegmentsTable.$converterpronunciationTrSourcen.toJson(
          pronunciationTrSource,
        ),
      ),
      'pronunciationEnSource': serializer.toJson<String?>(
        $SegmentsTable.$converterpronunciationEnSourcen.toJson(
          pronunciationEnSource,
        ),
      ),
      'meaningTrSource': serializer.toJson<String?>(
        $SegmentsTable.$convertermeaningTrSourcen.toJson(meaningTrSource),
      ),
      'meaningEnSource': serializer.toJson<String?>(
        $SegmentsTable.$convertermeaningEnSourcen.toJson(meaningEnSource),
      ),
      'review': serializer.toJson<String>(
        $SegmentsTable.$converterreview.toJson(review),
      ),
    };
  }

  Segment copyWith({
    int? id,
    String? duaId,
    int? position,
    String? textAr,
    Value<String?> pronunciationTr = const Value.absent(),
    Value<String?> pronunciationEn = const Value.absent(),
    Value<String?> meaningTr = const Value.absent(),
    Value<String?> meaningEn = const Value.absent(),
    Value<FieldSource?> pronunciationTrSource = const Value.absent(),
    Value<FieldSource?> pronunciationEnSource = const Value.absent(),
    Value<FieldSource?> meaningTrSource = const Value.absent(),
    Value<FieldSource?> meaningEnSource = const Value.absent(),
    ReviewStatus? review,
  }) => Segment(
    id: id ?? this.id,
    duaId: duaId ?? this.duaId,
    position: position ?? this.position,
    textAr: textAr ?? this.textAr,
    pronunciationTr: pronunciationTr.present
        ? pronunciationTr.value
        : this.pronunciationTr,
    pronunciationEn: pronunciationEn.present
        ? pronunciationEn.value
        : this.pronunciationEn,
    meaningTr: meaningTr.present ? meaningTr.value : this.meaningTr,
    meaningEn: meaningEn.present ? meaningEn.value : this.meaningEn,
    pronunciationTrSource: pronunciationTrSource.present
        ? pronunciationTrSource.value
        : this.pronunciationTrSource,
    pronunciationEnSource: pronunciationEnSource.present
        ? pronunciationEnSource.value
        : this.pronunciationEnSource,
    meaningTrSource: meaningTrSource.present
        ? meaningTrSource.value
        : this.meaningTrSource,
    meaningEnSource: meaningEnSource.present
        ? meaningEnSource.value
        : this.meaningEnSource,
    review: review ?? this.review,
  );
  Segment copyWithCompanion(SegmentsCompanion data) {
    return Segment(
      id: data.id.present ? data.id.value : this.id,
      duaId: data.duaId.present ? data.duaId.value : this.duaId,
      position: data.position.present ? data.position.value : this.position,
      textAr: data.textAr.present ? data.textAr.value : this.textAr,
      pronunciationTr: data.pronunciationTr.present
          ? data.pronunciationTr.value
          : this.pronunciationTr,
      pronunciationEn: data.pronunciationEn.present
          ? data.pronunciationEn.value
          : this.pronunciationEn,
      meaningTr: data.meaningTr.present ? data.meaningTr.value : this.meaningTr,
      meaningEn: data.meaningEn.present ? data.meaningEn.value : this.meaningEn,
      pronunciationTrSource: data.pronunciationTrSource.present
          ? data.pronunciationTrSource.value
          : this.pronunciationTrSource,
      pronunciationEnSource: data.pronunciationEnSource.present
          ? data.pronunciationEnSource.value
          : this.pronunciationEnSource,
      meaningTrSource: data.meaningTrSource.present
          ? data.meaningTrSource.value
          : this.meaningTrSource,
      meaningEnSource: data.meaningEnSource.present
          ? data.meaningEnSource.value
          : this.meaningEnSource,
      review: data.review.present ? data.review.value : this.review,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Segment(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('position: $position, ')
          ..write('textAr: $textAr, ')
          ..write('pronunciationTr: $pronunciationTr, ')
          ..write('pronunciationEn: $pronunciationEn, ')
          ..write('meaningTr: $meaningTr, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('pronunciationTrSource: $pronunciationTrSource, ')
          ..write('pronunciationEnSource: $pronunciationEnSource, ')
          ..write('meaningTrSource: $meaningTrSource, ')
          ..write('meaningEnSource: $meaningEnSource, ')
          ..write('review: $review')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    duaId,
    position,
    textAr,
    pronunciationTr,
    pronunciationEn,
    meaningTr,
    meaningEn,
    pronunciationTrSource,
    pronunciationEnSource,
    meaningTrSource,
    meaningEnSource,
    review,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Segment &&
          other.id == this.id &&
          other.duaId == this.duaId &&
          other.position == this.position &&
          other.textAr == this.textAr &&
          other.pronunciationTr == this.pronunciationTr &&
          other.pronunciationEn == this.pronunciationEn &&
          other.meaningTr == this.meaningTr &&
          other.meaningEn == this.meaningEn &&
          other.pronunciationTrSource == this.pronunciationTrSource &&
          other.pronunciationEnSource == this.pronunciationEnSource &&
          other.meaningTrSource == this.meaningTrSource &&
          other.meaningEnSource == this.meaningEnSource &&
          other.review == this.review);
}

class SegmentsCompanion extends UpdateCompanion<Segment> {
  final Value<int> id;
  final Value<String> duaId;
  final Value<int> position;
  final Value<String> textAr;
  final Value<String?> pronunciationTr;
  final Value<String?> pronunciationEn;
  final Value<String?> meaningTr;
  final Value<String?> meaningEn;
  final Value<FieldSource?> pronunciationTrSource;
  final Value<FieldSource?> pronunciationEnSource;
  final Value<FieldSource?> meaningTrSource;
  final Value<FieldSource?> meaningEnSource;
  final Value<ReviewStatus> review;
  const SegmentsCompanion({
    this.id = const Value.absent(),
    this.duaId = const Value.absent(),
    this.position = const Value.absent(),
    this.textAr = const Value.absent(),
    this.pronunciationTr = const Value.absent(),
    this.pronunciationEn = const Value.absent(),
    this.meaningTr = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.pronunciationTrSource = const Value.absent(),
    this.pronunciationEnSource = const Value.absent(),
    this.meaningTrSource = const Value.absent(),
    this.meaningEnSource = const Value.absent(),
    this.review = const Value.absent(),
  });
  SegmentsCompanion.insert({
    this.id = const Value.absent(),
    required String duaId,
    required int position,
    required String textAr,
    this.pronunciationTr = const Value.absent(),
    this.pronunciationEn = const Value.absent(),
    this.meaningTr = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.pronunciationTrSource = const Value.absent(),
    this.pronunciationEnSource = const Value.absent(),
    this.meaningTrSource = const Value.absent(),
    this.meaningEnSource = const Value.absent(),
    this.review = const Value.absent(),
  }) : duaId = Value(duaId),
       position = Value(position),
       textAr = Value(textAr);
  static Insertable<Segment> custom({
    Expression<int>? id,
    Expression<String>? duaId,
    Expression<int>? position,
    Expression<String>? textAr,
    Expression<String>? pronunciationTr,
    Expression<String>? pronunciationEn,
    Expression<String>? meaningTr,
    Expression<String>? meaningEn,
    Expression<String>? pronunciationTrSource,
    Expression<String>? pronunciationEnSource,
    Expression<String>? meaningTrSource,
    Expression<String>? meaningEnSource,
    Expression<String>? review,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (duaId != null) 'dua_id': duaId,
      if (position != null) 'position': position,
      if (textAr != null) 'text_ar': textAr,
      if (pronunciationTr != null) 'pronunciation_tr': pronunciationTr,
      if (pronunciationEn != null) 'pronunciation_en': pronunciationEn,
      if (meaningTr != null) 'meaning_tr': meaningTr,
      if (meaningEn != null) 'meaning_en': meaningEn,
      if (pronunciationTrSource != null)
        'pronunciation_tr_source': pronunciationTrSource,
      if (pronunciationEnSource != null)
        'pronunciation_en_source': pronunciationEnSource,
      if (meaningTrSource != null) 'meaning_tr_source': meaningTrSource,
      if (meaningEnSource != null) 'meaning_en_source': meaningEnSource,
      if (review != null) 'review': review,
    });
  }

  SegmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? duaId,
    Value<int>? position,
    Value<String>? textAr,
    Value<String?>? pronunciationTr,
    Value<String?>? pronunciationEn,
    Value<String?>? meaningTr,
    Value<String?>? meaningEn,
    Value<FieldSource?>? pronunciationTrSource,
    Value<FieldSource?>? pronunciationEnSource,
    Value<FieldSource?>? meaningTrSource,
    Value<FieldSource?>? meaningEnSource,
    Value<ReviewStatus>? review,
  }) {
    return SegmentsCompanion(
      id: id ?? this.id,
      duaId: duaId ?? this.duaId,
      position: position ?? this.position,
      textAr: textAr ?? this.textAr,
      pronunciationTr: pronunciationTr ?? this.pronunciationTr,
      pronunciationEn: pronunciationEn ?? this.pronunciationEn,
      meaningTr: meaningTr ?? this.meaningTr,
      meaningEn: meaningEn ?? this.meaningEn,
      pronunciationTrSource:
          pronunciationTrSource ?? this.pronunciationTrSource,
      pronunciationEnSource:
          pronunciationEnSource ?? this.pronunciationEnSource,
      meaningTrSource: meaningTrSource ?? this.meaningTrSource,
      meaningEnSource: meaningEnSource ?? this.meaningEnSource,
      review: review ?? this.review,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (duaId.present) {
      map['dua_id'] = Variable<String>(duaId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (textAr.present) {
      map['text_ar'] = Variable<String>(textAr.value);
    }
    if (pronunciationTr.present) {
      map['pronunciation_tr'] = Variable<String>(pronunciationTr.value);
    }
    if (pronunciationEn.present) {
      map['pronunciation_en'] = Variable<String>(pronunciationEn.value);
    }
    if (meaningTr.present) {
      map['meaning_tr'] = Variable<String>(meaningTr.value);
    }
    if (meaningEn.present) {
      map['meaning_en'] = Variable<String>(meaningEn.value);
    }
    if (pronunciationTrSource.present) {
      map['pronunciation_tr_source'] = Variable<String>(
        $SegmentsTable.$converterpronunciationTrSourcen.toSql(
          pronunciationTrSource.value,
        ),
      );
    }
    if (pronunciationEnSource.present) {
      map['pronunciation_en_source'] = Variable<String>(
        $SegmentsTable.$converterpronunciationEnSourcen.toSql(
          pronunciationEnSource.value,
        ),
      );
    }
    if (meaningTrSource.present) {
      map['meaning_tr_source'] = Variable<String>(
        $SegmentsTable.$convertermeaningTrSourcen.toSql(meaningTrSource.value),
      );
    }
    if (meaningEnSource.present) {
      map['meaning_en_source'] = Variable<String>(
        $SegmentsTable.$convertermeaningEnSourcen.toSql(meaningEnSource.value),
      );
    }
    if (review.present) {
      map['review'] = Variable<String>(
        $SegmentsTable.$converterreview.toSql(review.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SegmentsCompanion(')
          ..write('id: $id, ')
          ..write('duaId: $duaId, ')
          ..write('position: $position, ')
          ..write('textAr: $textAr, ')
          ..write('pronunciationTr: $pronunciationTr, ')
          ..write('pronunciationEn: $pronunciationEn, ')
          ..write('meaningTr: $meaningTr, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('pronunciationTrSource: $pronunciationTrSource, ')
          ..write('pronunciationEnSource: $pronunciationEnSource, ')
          ..write('meaningTrSource: $meaningTrSource, ')
          ..write('meaningEnSource: $meaningEnSource, ')
          ..write('review: $review')
          ..write(')'))
        .toString();
  }
}

class $TracksTable extends Tracks with TableInfo<$TracksTable, Track> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TrackOwnerKind, String>
  ownerKind = GeneratedColumn<String>(
    'owner_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TrackOwnerKind>($TracksTable.$converterownerKind);
  static const VerificationMeta _duaIdMeta = const VerificationMeta('duaId');
  @override
  late final GeneratedColumn<String> duaId = GeneratedColumn<String>(
    'dua_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES duas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relPathMeta = const VerificationMeta(
    'relPath',
  );
  @override
  late final GeneratedColumn<String> relPath = GeneratedColumn<String>(
    'rel_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerKind,
    duaId,
    groupId,
    relPath,
    label,
    durationMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Track> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dua_id')) {
      context.handle(
        _duaIdMeta,
        duaId.isAcceptableOrUnknown(data['dua_id']!, _duaIdMeta),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('rel_path')) {
      context.handle(
        _relPathMeta,
        relPath.isAcceptableOrUnknown(data['rel_path']!, _relPathMeta),
      );
    } else if (isInserting) {
      context.missing(_relPathMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Track map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Track(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerKind: $TracksTable.$converterownerKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}owner_kind'],
        )!,
      ),
      duaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dua_id'],
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      relPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rel_path'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
    );
  }

  @override
  $TracksTable createAlias(String alias) {
    return $TracksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TrackOwnerKind, String, String>
  $converterownerKind = const EnumNameConverter<TrackOwnerKind>(
    TrackOwnerKind.values,
  );
}

class Track extends DataClass implements Insertable<Track> {
  final int id;
  final TrackOwnerKind ownerKind;
  final String? duaId;
  final String? groupId;

  /// content/ köküne göre göreli, `/` ayraçlı yol.
  final String relPath;
  final String label;
  final int? durationMs;
  const Track({
    required this.id,
    required this.ownerKind,
    this.duaId,
    this.groupId,
    required this.relPath,
    required this.label,
    this.durationMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['owner_kind'] = Variable<String>(
        $TracksTable.$converterownerKind.toSql(ownerKind),
      );
    }
    if (!nullToAbsent || duaId != null) {
      map['dua_id'] = Variable<String>(duaId);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['rel_path'] = Variable<String>(relPath);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    return map;
  }

  TracksCompanion toCompanion(bool nullToAbsent) {
    return TracksCompanion(
      id: Value(id),
      ownerKind: Value(ownerKind),
      duaId: duaId == null && nullToAbsent
          ? const Value.absent()
          : Value(duaId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      relPath: Value(relPath),
      label: Value(label),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
    );
  }

  factory Track.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Track(
      id: serializer.fromJson<int>(json['id']),
      ownerKind: $TracksTable.$converterownerKind.fromJson(
        serializer.fromJson<String>(json['ownerKind']),
      ),
      duaId: serializer.fromJson<String?>(json['duaId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      relPath: serializer.fromJson<String>(json['relPath']),
      label: serializer.fromJson<String>(json['label']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerKind': serializer.toJson<String>(
        $TracksTable.$converterownerKind.toJson(ownerKind),
      ),
      'duaId': serializer.toJson<String?>(duaId),
      'groupId': serializer.toJson<String?>(groupId),
      'relPath': serializer.toJson<String>(relPath),
      'label': serializer.toJson<String>(label),
      'durationMs': serializer.toJson<int?>(durationMs),
    };
  }

  Track copyWith({
    int? id,
    TrackOwnerKind? ownerKind,
    Value<String?> duaId = const Value.absent(),
    Value<String?> groupId = const Value.absent(),
    String? relPath,
    String? label,
    Value<int?> durationMs = const Value.absent(),
  }) => Track(
    id: id ?? this.id,
    ownerKind: ownerKind ?? this.ownerKind,
    duaId: duaId.present ? duaId.value : this.duaId,
    groupId: groupId.present ? groupId.value : this.groupId,
    relPath: relPath ?? this.relPath,
    label: label ?? this.label,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
  );
  Track copyWithCompanion(TracksCompanion data) {
    return Track(
      id: data.id.present ? data.id.value : this.id,
      ownerKind: data.ownerKind.present ? data.ownerKind.value : this.ownerKind,
      duaId: data.duaId.present ? data.duaId.value : this.duaId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      relPath: data.relPath.present ? data.relPath.value : this.relPath,
      label: data.label.present ? data.label.value : this.label,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Track(')
          ..write('id: $id, ')
          ..write('ownerKind: $ownerKind, ')
          ..write('duaId: $duaId, ')
          ..write('groupId: $groupId, ')
          ..write('relPath: $relPath, ')
          ..write('label: $label, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerKind, duaId, groupId, relPath, label, durationMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Track &&
          other.id == this.id &&
          other.ownerKind == this.ownerKind &&
          other.duaId == this.duaId &&
          other.groupId == this.groupId &&
          other.relPath == this.relPath &&
          other.label == this.label &&
          other.durationMs == this.durationMs);
}

class TracksCompanion extends UpdateCompanion<Track> {
  final Value<int> id;
  final Value<TrackOwnerKind> ownerKind;
  final Value<String?> duaId;
  final Value<String?> groupId;
  final Value<String> relPath;
  final Value<String> label;
  final Value<int?> durationMs;
  const TracksCompanion({
    this.id = const Value.absent(),
    this.ownerKind = const Value.absent(),
    this.duaId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.relPath = const Value.absent(),
    this.label = const Value.absent(),
    this.durationMs = const Value.absent(),
  });
  TracksCompanion.insert({
    this.id = const Value.absent(),
    required TrackOwnerKind ownerKind,
    this.duaId = const Value.absent(),
    this.groupId = const Value.absent(),
    required String relPath,
    required String label,
    this.durationMs = const Value.absent(),
  }) : ownerKind = Value(ownerKind),
       relPath = Value(relPath),
       label = Value(label);
  static Insertable<Track> custom({
    Expression<int>? id,
    Expression<String>? ownerKind,
    Expression<String>? duaId,
    Expression<String>? groupId,
    Expression<String>? relPath,
    Expression<String>? label,
    Expression<int>? durationMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerKind != null) 'owner_kind': ownerKind,
      if (duaId != null) 'dua_id': duaId,
      if (groupId != null) 'group_id': groupId,
      if (relPath != null) 'rel_path': relPath,
      if (label != null) 'label': label,
      if (durationMs != null) 'duration_ms': durationMs,
    });
  }

  TracksCompanion copyWith({
    Value<int>? id,
    Value<TrackOwnerKind>? ownerKind,
    Value<String?>? duaId,
    Value<String?>? groupId,
    Value<String>? relPath,
    Value<String>? label,
    Value<int?>? durationMs,
  }) {
    return TracksCompanion(
      id: id ?? this.id,
      ownerKind: ownerKind ?? this.ownerKind,
      duaId: duaId ?? this.duaId,
      groupId: groupId ?? this.groupId,
      relPath: relPath ?? this.relPath,
      label: label ?? this.label,
      durationMs: durationMs ?? this.durationMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerKind.present) {
      map['owner_kind'] = Variable<String>(
        $TracksTable.$converterownerKind.toSql(ownerKind.value),
      );
    }
    if (duaId.present) {
      map['dua_id'] = Variable<String>(duaId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (relPath.present) {
      map['rel_path'] = Variable<String>(relPath.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TracksCompanion(')
          ..write('id: $id, ')
          ..write('ownerKind: $ownerKind, ')
          ..write('duaId: $duaId, ')
          ..write('groupId: $groupId, ')
          ..write('relPath: $relPath, ')
          ..write('label: $label, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }
}

class $CuesTable extends Cues with TableInfo<$CuesTable, Cue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tracks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startMsMeta = const VerificationMeta(
    'startMs',
  );
  @override
  late final GeneratedColumn<int> startMs = GeneratedColumn<int>(
    'start_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _segmentIdMeta = const VerificationMeta(
    'segmentId',
  );
  @override
  late final GeneratedColumn<int> segmentId = GeneratedColumn<int>(
    'segment_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES segments (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, trackId, startMs, segmentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cues';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('start_ms')) {
      context.handle(
        _startMsMeta,
        startMs.isAcceptableOrUnknown(data['start_ms']!, _startMsMeta),
      );
    } else if (isInserting) {
      context.missing(_startMsMeta);
    }
    if (data.containsKey('segment_id')) {
      context.handle(
        _segmentIdMeta,
        segmentId.isAcceptableOrUnknown(data['segment_id']!, _segmentIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_id'],
      )!,
      startMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_ms'],
      )!,
      segmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}segment_id'],
      ),
    );
  }

  @override
  $CuesTable createAlias(String alias) {
    return $CuesTable(attachedDatabase, alias);
  }
}

class Cue extends DataClass implements Insertable<Cue> {
  final int id;
  final int trackId;
  final int startMs;

  /// null = metinsiz bölüm (vurgulama yok).
  final int? segmentId;
  const Cue({
    required this.id,
    required this.trackId,
    required this.startMs,
    this.segmentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<int>(trackId);
    map['start_ms'] = Variable<int>(startMs);
    if (!nullToAbsent || segmentId != null) {
      map['segment_id'] = Variable<int>(segmentId);
    }
    return map;
  }

  CuesCompanion toCompanion(bool nullToAbsent) {
    return CuesCompanion(
      id: Value(id),
      trackId: Value(trackId),
      startMs: Value(startMs),
      segmentId: segmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(segmentId),
    );
  }

  factory Cue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cue(
      id: serializer.fromJson<int>(json['id']),
      trackId: serializer.fromJson<int>(json['trackId']),
      startMs: serializer.fromJson<int>(json['startMs']),
      segmentId: serializer.fromJson<int?>(json['segmentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<int>(trackId),
      'startMs': serializer.toJson<int>(startMs),
      'segmentId': serializer.toJson<int?>(segmentId),
    };
  }

  Cue copyWith({
    int? id,
    int? trackId,
    int? startMs,
    Value<int?> segmentId = const Value.absent(),
  }) => Cue(
    id: id ?? this.id,
    trackId: trackId ?? this.trackId,
    startMs: startMs ?? this.startMs,
    segmentId: segmentId.present ? segmentId.value : this.segmentId,
  );
  Cue copyWithCompanion(CuesCompanion data) {
    return Cue(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      startMs: data.startMs.present ? data.startMs.value : this.startMs,
      segmentId: data.segmentId.present ? data.segmentId.value : this.segmentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cue(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('startMs: $startMs, ')
          ..write('segmentId: $segmentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackId, startMs, segmentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cue &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.startMs == this.startMs &&
          other.segmentId == this.segmentId);
}

class CuesCompanion extends UpdateCompanion<Cue> {
  final Value<int> id;
  final Value<int> trackId;
  final Value<int> startMs;
  final Value<int?> segmentId;
  const CuesCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.startMs = const Value.absent(),
    this.segmentId = const Value.absent(),
  });
  CuesCompanion.insert({
    this.id = const Value.absent(),
    required int trackId,
    required int startMs,
    this.segmentId = const Value.absent(),
  }) : trackId = Value(trackId),
       startMs = Value(startMs);
  static Insertable<Cue> custom({
    Expression<int>? id,
    Expression<int>? trackId,
    Expression<int>? startMs,
    Expression<int>? segmentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (startMs != null) 'start_ms': startMs,
      if (segmentId != null) 'segment_id': segmentId,
    });
  }

  CuesCompanion copyWith({
    Value<int>? id,
    Value<int>? trackId,
    Value<int>? startMs,
    Value<int?>? segmentId,
  }) {
    return CuesCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      startMs: startMs ?? this.startMs,
      segmentId: segmentId ?? this.segmentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<int>(trackId.value);
    }
    if (startMs.present) {
      map['start_ms'] = Variable<int>(startMs.value);
    }
    if (segmentId.present) {
      map['segment_id'] = Variable<int>(segmentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuesCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('startMs: $startMs, ')
          ..write('segmentId: $segmentId')
          ..write(')'))
        .toString();
  }
}

class $ImportLogsTable extends ImportLogs
    with TableInfo<$ImportLogsTable, ImportLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportJsonMeta = const VerificationMeta(
    'reportJson',
  );
  @override
  late final GeneratedColumn<String> reportJson = GeneratedColumn<String>(
    'report_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, importedAt, fileName, reportJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('report_json')) {
      context.handle(
        _reportJsonMeta,
        reportJson.isAcceptableOrUnknown(data['report_json']!, _reportJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_reportJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      reportJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_json'],
      )!,
    );
  }

  @override
  $ImportLogsTable createAlias(String alias) {
    return $ImportLogsTable(attachedDatabase, alias);
  }
}

class ImportLog extends DataClass implements Insertable<ImportLog> {
  final int id;
  final DateTime importedAt;
  final String fileName;
  final String reportJson;
  const ImportLog({
    required this.id,
    required this.importedAt,
    required this.fileName,
    required this.reportJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['file_name'] = Variable<String>(fileName);
    map['report_json'] = Variable<String>(reportJson);
    return map;
  }

  ImportLogsCompanion toCompanion(bool nullToAbsent) {
    return ImportLogsCompanion(
      id: Value(id),
      importedAt: Value(importedAt),
      fileName: Value(fileName),
      reportJson: Value(reportJson),
    );
  }

  factory ImportLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportLog(
      id: serializer.fromJson<int>(json['id']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      fileName: serializer.fromJson<String>(json['fileName']),
      reportJson: serializer.fromJson<String>(json['reportJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'fileName': serializer.toJson<String>(fileName),
      'reportJson': serializer.toJson<String>(reportJson),
    };
  }

  ImportLog copyWith({
    int? id,
    DateTime? importedAt,
    String? fileName,
    String? reportJson,
  }) => ImportLog(
    id: id ?? this.id,
    importedAt: importedAt ?? this.importedAt,
    fileName: fileName ?? this.fileName,
    reportJson: reportJson ?? this.reportJson,
  );
  ImportLog copyWithCompanion(ImportLogsCompanion data) {
    return ImportLog(
      id: data.id.present ? data.id.value : this.id,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      reportJson: data.reportJson.present
          ? data.reportJson.value
          : this.reportJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportLog(')
          ..write('id: $id, ')
          ..write('importedAt: $importedAt, ')
          ..write('fileName: $fileName, ')
          ..write('reportJson: $reportJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, importedAt, fileName, reportJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportLog &&
          other.id == this.id &&
          other.importedAt == this.importedAt &&
          other.fileName == this.fileName &&
          other.reportJson == this.reportJson);
}

class ImportLogsCompanion extends UpdateCompanion<ImportLog> {
  final Value<int> id;
  final Value<DateTime> importedAt;
  final Value<String> fileName;
  final Value<String> reportJson;
  const ImportLogsCompanion({
    this.id = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.fileName = const Value.absent(),
    this.reportJson = const Value.absent(),
  });
  ImportLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime importedAt,
    required String fileName,
    required String reportJson,
  }) : importedAt = Value(importedAt),
       fileName = Value(fileName),
       reportJson = Value(reportJson);
  static Insertable<ImportLog> custom({
    Expression<int>? id,
    Expression<DateTime>? importedAt,
    Expression<String>? fileName,
    Expression<String>? reportJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (importedAt != null) 'imported_at': importedAt,
      if (fileName != null) 'file_name': fileName,
      if (reportJson != null) 'report_json': reportJson,
    });
  }

  ImportLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? importedAt,
    Value<String>? fileName,
    Value<String>? reportJson,
  }) {
    return ImportLogsCompanion(
      id: id ?? this.id,
      importedAt: importedAt ?? this.importedAt,
      fileName: fileName ?? this.fileName,
      reportJson: reportJson ?? this.reportJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (reportJson.present) {
      map['report_json'] = Variable<String>(reportJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportLogsCompanion(')
          ..write('id: $id, ')
          ..write('importedAt: $importedAt, ')
          ..write('fileName: $fileName, ')
          ..write('reportJson: $reportJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$ContentDatabase extends GeneratedDatabase {
  _$ContentDatabase(QueryExecutor e) : super(e);
  $ContentDatabaseManager get managers => $ContentDatabaseManager(this);
  late final $DuasTable duas = $DuasTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $DuaCategoriesTable duaCategories = $DuaCategoriesTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $GroupCategoriesTable groupCategories = $GroupCategoriesTable(
    this,
  );
  late final $GroupItemsTable groupItems = $GroupItemsTable(this);
  late final $SegmentsTable segments = $SegmentsTable(this);
  late final $TracksTable tracks = $TracksTable(this);
  late final $CuesTable cues = $CuesTable(this);
  late final $ImportLogsTable importLogs = $ImportLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    duas,
    categories,
    duaCategories,
    groups,
    groupCategories,
    groupItems,
    segments,
    tracks,
    cues,
    importLogs,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'duas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('duas', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'duas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dua_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dua_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'duas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'duas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('segments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'duas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tracks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tracks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tracks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cues', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'segments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cues', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$DuasTableCreateCompanionBuilder = DuasCompanion Function({
  required String id,
  required String titleTr,
  Value<String?> titleEn,
  Value<String?> titleAr,
  Value<String?> variantOf,
  Value<String?> variantKey,
  Value<String?> quranReference,
  Value<String?> editorialStatus,
  Value<String?> editorialNote,
  Value<String?> sourceJson,
  Value<String?> srcPronunciationTr,
  Value<String?> srcPronunciationEn,
  Value<String?> srcMeaningTr,
  Value<String?> srcMeaningEn,
  Value<String?> expectedAudioFile,
  Value<bool> readyToPublish,
  Value<int> version,
  Value<String?> importDiff,
  Value<int> sortOrder,
  Value<String?> titleArType,
  Value<String?> sourceType,
  Value<String?> hadithTr,
  Value<String?> hadithEn,
  Value<String?> hadithGrade,
  Value<String?> storyTr,
  Value<String?> storyEn,
  Value<int?> recitationCount,
  Value<String?> recitationTimeTr,
  Value<String?> recitationTimeEn,
  Value<bool> standaloneVisible,
  Value<int> rowid,
});
typedef $$DuasTableUpdateCompanionBuilder = DuasCompanion Function({
  Value<String> id,
  Value<String> titleTr,
  Value<String?> titleEn,
  Value<String?> titleAr,
  Value<String?> variantOf,
  Value<String?> variantKey,
  Value<String?> quranReference,
  Value<String?> editorialStatus,
  Value<String?> editorialNote,
  Value<String?> sourceJson,
  Value<String?> srcPronunciationTr,
  Value<String?> srcPronunciationEn,
  Value<String?> srcMeaningTr,
  Value<String?> srcMeaningEn,
  Value<String?> expectedAudioFile,
  Value<bool> readyToPublish,
  Value<int> version,
  Value<String?> importDiff,
  Value<int> sortOrder,
  Value<String?> titleArType,
  Value<String?> sourceType,
  Value<String?> hadithTr,
  Value<String?> hadithEn,
  Value<String?> hadithGrade,
  Value<String?> storyTr,
  Value<String?> storyEn,
  Value<int?> recitationCount,
  Value<String?> recitationTimeTr,
  Value<String?> recitationTimeEn,
  Value<bool> standaloneVisible,
  Value<int> rowid,
});

final class $$DuasTableReferences
    extends BaseReferences<_$ContentDatabase, $DuasTable, Dua> {
  $$DuasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DuasTable _variantOfTable(_$ContentDatabase db) =>
      db.duas.createAlias('duas__variant_of__duas__id');

  $$DuasTableProcessedTableManager? get variantOf {
    final $_column = $_itemColumn<String>('variant_of');
    if ($_column == null) return null;
    final manager = $$DuasTableTableManager(
      $_db,
      $_db.duas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_variantOfTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DuaCategoriesTable, List<DuaCategory>>
  _duaCategoriesRefsTable(_$ContentDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.duaCategories,
        aliasName: 'duas__id__dua_categories__dua_id',
      );

  $$DuaCategoriesTableProcessedTableManager get duaCategoriesRefs {
    final manager = $$DuaCategoriesTableTableManager(
      $_db,
      $_db.duaCategories,
    ).filter((f) => f.duaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_duaCategoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupItemsTable, List<GroupItem>>
  _groupItemsRefsTable(_$ContentDatabase db) => MultiTypedResultKey.fromTable(
    db.groupItems,
    aliasName: 'duas__id__group_items__dua_id',
  );

  $$GroupItemsTableProcessedTableManager get groupItemsRefs {
    final manager = $$GroupItemsTableTableManager(
      $_db,
      $_db.groupItems,
    ).filter((f) => f.duaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SegmentsTable, List<Segment>> _segmentsRefsTable(
    _$ContentDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.segments,
    aliasName: 'duas__id__segments__dua_id',
  );

  $$SegmentsTableProcessedTableManager get segmentsRefs {
    final manager = $$SegmentsTableTableManager(
      $_db,
      $_db.segments,
    ).filter((f) => f.duaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_segmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TracksTable, List<Track>> _tracksRefsTable(
    _$ContentDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tracks,
    aliasName: 'duas__id__tracks__dua_id',
  );

  $$TracksTableProcessedTableManager get tracksRefs {
    final manager = $$TracksTableTableManager(
      $_db,
      $_db.tracks,
    ).filter((f) => f.duaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tracksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DuasTableFilterComposer
    extends Composer<_$ContentDatabase, $DuasTable> {
  $$DuasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleTr => $composableBuilder(
    column: $table.titleTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variantKey => $composableBuilder(
    column: $table.variantKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quranReference => $composableBuilder(
    column: $table.quranReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editorialStatus => $composableBuilder(
    column: $table.editorialStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editorialNote => $composableBuilder(
    column: $table.editorialNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceJson => $composableBuilder(
    column: $table.sourceJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get srcPronunciationTr => $composableBuilder(
    column: $table.srcPronunciationTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get srcPronunciationEn => $composableBuilder(
    column: $table.srcPronunciationEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get srcMeaningTr => $composableBuilder(
    column: $table.srcMeaningTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get srcMeaningEn => $composableBuilder(
    column: $table.srcMeaningEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectedAudioFile => $composableBuilder(
    column: $table.expectedAudioFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get readyToPublish => $composableBuilder(
    column: $table.readyToPublish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importDiff => $composableBuilder(
    column: $table.importDiff,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleArType => $composableBuilder(
    column: $table.titleArType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hadithTr => $composableBuilder(
    column: $table.hadithTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hadithEn => $composableBuilder(
    column: $table.hadithEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hadithGrade => $composableBuilder(
    column: $table.hadithGrade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storyTr => $composableBuilder(
    column: $table.storyTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storyEn => $composableBuilder(
    column: $table.storyEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recitationCount => $composableBuilder(
    column: $table.recitationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recitationTimeTr => $composableBuilder(
    column: $table.recitationTimeTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recitationTimeEn => $composableBuilder(
    column: $table.recitationTimeEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get standaloneVisible => $composableBuilder(
    column: $table.standaloneVisible,
    builder: (column) => ColumnFilters(column),
  );

  $$DuasTableFilterComposer get variantOf {
    final $$DuasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantOf,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableFilterComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> duaCategoriesRefs(
    Expression<bool> Function($$DuaCategoriesTableFilterComposer f) f,
  ) {
    final $$DuaCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaCategories,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.duaCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupItemsRefs(
    Expression<bool> Function($$GroupItemsTableFilterComposer f) f,
  ) {
    final $$GroupItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupItems,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupItemsTableFilterComposer(
            $db: $db,
            $table: $db.groupItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> segmentsRefs(
    Expression<bool> Function($$SegmentsTableFilterComposer f) f,
  ) {
    final $$SegmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.segments,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SegmentsTableFilterComposer(
            $db: $db,
            $table: $db.segments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tracksRefs(
    Expression<bool> Function($$TracksTableFilterComposer f) f,
  ) {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DuasTableOrderingComposer
    extends Composer<_$ContentDatabase, $DuasTable> {
  $$DuasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleTr => $composableBuilder(
    column: $table.titleTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variantKey => $composableBuilder(
    column: $table.variantKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quranReference => $composableBuilder(
    column: $table.quranReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editorialStatus => $composableBuilder(
    column: $table.editorialStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editorialNote => $composableBuilder(
    column: $table.editorialNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceJson => $composableBuilder(
    column: $table.sourceJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get srcPronunciationTr => $composableBuilder(
    column: $table.srcPronunciationTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get srcPronunciationEn => $composableBuilder(
    column: $table.srcPronunciationEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get srcMeaningTr => $composableBuilder(
    column: $table.srcMeaningTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get srcMeaningEn => $composableBuilder(
    column: $table.srcMeaningEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedAudioFile => $composableBuilder(
    column: $table.expectedAudioFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get readyToPublish => $composableBuilder(
    column: $table.readyToPublish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importDiff => $composableBuilder(
    column: $table.importDiff,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleArType => $composableBuilder(
    column: $table.titleArType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hadithTr => $composableBuilder(
    column: $table.hadithTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hadithEn => $composableBuilder(
    column: $table.hadithEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hadithGrade => $composableBuilder(
    column: $table.hadithGrade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storyTr => $composableBuilder(
    column: $table.storyTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storyEn => $composableBuilder(
    column: $table.storyEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recitationCount => $composableBuilder(
    column: $table.recitationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recitationTimeTr => $composableBuilder(
    column: $table.recitationTimeTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recitationTimeEn => $composableBuilder(
    column: $table.recitationTimeEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get standaloneVisible => $composableBuilder(
    column: $table.standaloneVisible,
    builder: (column) => ColumnOrderings(column),
  );

  $$DuasTableOrderingComposer get variantOf {
    final $$DuasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantOf,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableOrderingComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuasTableAnnotationComposer
    extends Composer<_$ContentDatabase, $DuasTable> {
  $$DuasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleTr =>
      $composableBuilder(column: $table.titleTr, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<String> get variantKey => $composableBuilder(
    column: $table.variantKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quranReference => $composableBuilder(
    column: $table.quranReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editorialStatus => $composableBuilder(
    column: $table.editorialStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editorialNote => $composableBuilder(
    column: $table.editorialNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceJson => $composableBuilder(
    column: $table.sourceJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get srcPronunciationTr => $composableBuilder(
    column: $table.srcPronunciationTr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get srcPronunciationEn => $composableBuilder(
    column: $table.srcPronunciationEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get srcMeaningTr => $composableBuilder(
    column: $table.srcMeaningTr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get srcMeaningEn => $composableBuilder(
    column: $table.srcMeaningEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expectedAudioFile => $composableBuilder(
    column: $table.expectedAudioFile,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get readyToPublish => $composableBuilder(
    column: $table.readyToPublish,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get importDiff => $composableBuilder(
    column: $table.importDiff,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get titleArType => $composableBuilder(
    column: $table.titleArType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hadithTr =>
      $composableBuilder(column: $table.hadithTr, builder: (column) => column);

  GeneratedColumn<String> get hadithEn =>
      $composableBuilder(column: $table.hadithEn, builder: (column) => column);

  GeneratedColumn<String> get hadithGrade => $composableBuilder(
    column: $table.hadithGrade,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storyTr =>
      $composableBuilder(column: $table.storyTr, builder: (column) => column);

  GeneratedColumn<String> get storyEn =>
      $composableBuilder(column: $table.storyEn, builder: (column) => column);

  GeneratedColumn<int> get recitationCount => $composableBuilder(
    column: $table.recitationCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recitationTimeTr => $composableBuilder(
    column: $table.recitationTimeTr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recitationTimeEn => $composableBuilder(
    column: $table.recitationTimeEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get standaloneVisible => $composableBuilder(
    column: $table.standaloneVisible,
    builder: (column) => column,
  );

  $$DuasTableAnnotationComposer get variantOf {
    final $$DuasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantOf,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableAnnotationComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> duaCategoriesRefs<T extends Object>(
    Expression<T> Function($$DuaCategoriesTableAnnotationComposer a) f,
  ) {
    final $$DuaCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaCategories,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.duaCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupItemsRefs<T extends Object>(
    Expression<T> Function($$GroupItemsTableAnnotationComposer a) f,
  ) {
    final $$GroupItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupItems,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> segmentsRefs<T extends Object>(
    Expression<T> Function($$SegmentsTableAnnotationComposer a) f,
  ) {
    final $$SegmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.segments,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SegmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.segments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tracksRefs<T extends Object>(
    Expression<T> Function($$TracksTableAnnotationComposer a) f,
  ) {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.duaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DuasTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $DuasTable,
          Dua,
          $$DuasTableFilterComposer,
          $$DuasTableOrderingComposer,
          $$DuasTableAnnotationComposer,
          $$DuasTableCreateCompanionBuilder,
          $$DuasTableUpdateCompanionBuilder,
          (Dua, $$DuasTableReferences),
          Dua,
          PrefetchHooks Function({
            bool variantOf,
            bool duaCategoriesRefs,
            bool groupItemsRefs,
            bool segmentsRefs,
            bool tracksRefs,
          })
        > {
  $$DuasTableTableManager(_$ContentDatabase db, $DuasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DuasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> titleTr = const Value.absent(),
                Value<String?> titleEn = const Value.absent(),
                Value<String?> titleAr = const Value.absent(),
                Value<String?> variantOf = const Value.absent(),
                Value<String?> variantKey = const Value.absent(),
                Value<String?> quranReference = const Value.absent(),
                Value<String?> editorialStatus = const Value.absent(),
                Value<String?> editorialNote = const Value.absent(),
                Value<String?> sourceJson = const Value.absent(),
                Value<String?> srcPronunciationTr = const Value.absent(),
                Value<String?> srcPronunciationEn = const Value.absent(),
                Value<String?> srcMeaningTr = const Value.absent(),
                Value<String?> srcMeaningEn = const Value.absent(),
                Value<String?> expectedAudioFile = const Value.absent(),
                Value<bool> readyToPublish = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String?> importDiff = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> titleArType = const Value.absent(),
                Value<String?> sourceType = const Value.absent(),
                Value<String?> hadithTr = const Value.absent(),
                Value<String?> hadithEn = const Value.absent(),
                Value<String?> hadithGrade = const Value.absent(),
                Value<String?> storyTr = const Value.absent(),
                Value<String?> storyEn = const Value.absent(),
                Value<int?> recitationCount = const Value.absent(),
                Value<String?> recitationTimeTr = const Value.absent(),
                Value<String?> recitationTimeEn = const Value.absent(),
                Value<bool> standaloneVisible = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DuasCompanion(
                id: id,
                titleTr: titleTr,
                titleEn: titleEn,
                titleAr: titleAr,
                variantOf: variantOf,
                variantKey: variantKey,
                quranReference: quranReference,
                editorialStatus: editorialStatus,
                editorialNote: editorialNote,
                sourceJson: sourceJson,
                srcPronunciationTr: srcPronunciationTr,
                srcPronunciationEn: srcPronunciationEn,
                srcMeaningTr: srcMeaningTr,
                srcMeaningEn: srcMeaningEn,
                expectedAudioFile: expectedAudioFile,
                readyToPublish: readyToPublish,
                version: version,
                importDiff: importDiff,
                sortOrder: sortOrder,
                titleArType: titleArType,
                sourceType: sourceType,
                hadithTr: hadithTr,
                hadithEn: hadithEn,
                hadithGrade: hadithGrade,
                storyTr: storyTr,
                storyEn: storyEn,
                recitationCount: recitationCount,
                recitationTimeTr: recitationTimeTr,
                recitationTimeEn: recitationTimeEn,
                standaloneVisible: standaloneVisible,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String titleTr,
                Value<String?> titleEn = const Value.absent(),
                Value<String?> titleAr = const Value.absent(),
                Value<String?> variantOf = const Value.absent(),
                Value<String?> variantKey = const Value.absent(),
                Value<String?> quranReference = const Value.absent(),
                Value<String?> editorialStatus = const Value.absent(),
                Value<String?> editorialNote = const Value.absent(),
                Value<String?> sourceJson = const Value.absent(),
                Value<String?> srcPronunciationTr = const Value.absent(),
                Value<String?> srcPronunciationEn = const Value.absent(),
                Value<String?> srcMeaningTr = const Value.absent(),
                Value<String?> srcMeaningEn = const Value.absent(),
                Value<String?> expectedAudioFile = const Value.absent(),
                Value<bool> readyToPublish = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String?> importDiff = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> titleArType = const Value.absent(),
                Value<String?> sourceType = const Value.absent(),
                Value<String?> hadithTr = const Value.absent(),
                Value<String?> hadithEn = const Value.absent(),
                Value<String?> hadithGrade = const Value.absent(),
                Value<String?> storyTr = const Value.absent(),
                Value<String?> storyEn = const Value.absent(),
                Value<int?> recitationCount = const Value.absent(),
                Value<String?> recitationTimeTr = const Value.absent(),
                Value<String?> recitationTimeEn = const Value.absent(),
                Value<bool> standaloneVisible = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DuasCompanion.insert(
                id: id,
                titleTr: titleTr,
                titleEn: titleEn,
                titleAr: titleAr,
                variantOf: variantOf,
                variantKey: variantKey,
                quranReference: quranReference,
                editorialStatus: editorialStatus,
                editorialNote: editorialNote,
                sourceJson: sourceJson,
                srcPronunciationTr: srcPronunciationTr,
                srcPronunciationEn: srcPronunciationEn,
                srcMeaningTr: srcMeaningTr,
                srcMeaningEn: srcMeaningEn,
                expectedAudioFile: expectedAudioFile,
                readyToPublish: readyToPublish,
                version: version,
                importDiff: importDiff,
                sortOrder: sortOrder,
                titleArType: titleArType,
                sourceType: sourceType,
                hadithTr: hadithTr,
                hadithEn: hadithEn,
                hadithGrade: hadithGrade,
                storyTr: storyTr,
                storyEn: storyEn,
                recitationCount: recitationCount,
                recitationTimeTr: recitationTimeTr,
                recitationTimeEn: recitationTimeEn,
                standaloneVisible: standaloneVisible,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DuasTable, Dua>(table),
                  $$DuasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                variantOf = false,
                duaCategoriesRefs = false,
                groupItemsRefs = false,
                segmentsRefs = false,
                tracksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (duaCategoriesRefs) db.duaCategories,
                    if (groupItemsRefs) db.groupItems,
                    if (segmentsRefs) db.segments,
                    if (tracksRefs) db.tracks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (variantOf) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.variantOf,
                            referencedTable: $$DuasTableReferences
                                ._variantOfTable(db),
                            referencedColumn: $$DuasTableReferences
                                ._variantOfTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (duaCategoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          Dua,
                          $DuasTable,
                          DuaCategory,
                          $DuaCategoriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$DuasTableReferences
                              ._duaCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) => $$DuasTableReferences(
                            db,
                            table,
                            p0,
                          ).duaCategoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'dua_id',
                          typedResults: items,
                        ),
                      if (groupItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          Dua,
                          $DuasTable,
                          GroupItem,
                          $GroupItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$DuasTableReferences
                              ._groupItemsRefsTable(db),
                          managerFromTypedResult: (p0) => $$DuasTableReferences(
                            db,
                            table,
                            p0,
                          ).groupItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'dua_id',
                          typedResults: items,
                        ),
                      if (segmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Dua,
                          $DuasTable,
                          Segment,
                          $SegmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$DuasTableReferences
                              ._segmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DuasTableReferences(db, table, p0).segmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'dua_id',
                          typedResults: items,
                        ),
                      if (tracksRefs)
                        await $_getPrefetchedDataByColumns<
                          Dua,
                          $DuasTable,
                          Track,
                          $TracksTable
                        >(
                          currentTable: table,
                          referencedTable: $$DuasTableReferences
                              ._tracksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DuasTableReferences(db, table, p0).tracksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'dua_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DuasTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $DuasTable,
      Dua,
      $$DuasTableFilterComposer,
      $$DuasTableOrderingComposer,
      $$DuasTableAnnotationComposer,
      $$DuasTableCreateCompanionBuilder,
      $$DuasTableUpdateCompanionBuilder,
      (Dua, $$DuasTableReferences),
      Dua,
      PrefetchHooks Function({
        bool variantOf,
        bool duaCategoriesRefs,
        bool groupItemsRefs,
        bool segmentsRefs,
        bool tracksRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String?> code,
  required String nameTr,
  Value<String?> nameEn,
  Value<int> sortOrder,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String?> code,
  Value<String> nameTr,
  Value<String?> nameEn,
  Value<int> sortOrder,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$ContentDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DuaCategoriesTable, List<DuaCategory>>
  _duaCategoriesRefsTable(_$ContentDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.duaCategories,
        aliasName: 'categories__id__dua_categories__category_id',
      );

  $$DuaCategoriesTableProcessedTableManager get duaCategoriesRefs {
    final manager = $$DuaCategoriesTableTableManager(
      $_db,
      $_db.duaCategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_duaCategoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupCategoriesTable, List<GroupCategory>>
  _groupCategoriesRefsTable(_$ContentDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.groupCategories,
        aliasName: 'categories__id__group_categories__category_id',
      );

  $$GroupCategoriesTableProcessedTableManager get groupCategoriesRefs {
    final manager = $$GroupCategoriesTableTableManager(
      $_db,
      $_db.groupCategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$ContentDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTr => $composableBuilder(
    column: $table.nameTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> duaCategoriesRefs(
    Expression<bool> Function($$DuaCategoriesTableFilterComposer f) f,
  ) {
    final $$DuaCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.duaCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupCategoriesRefs(
    Expression<bool> Function($$GroupCategoriesTableFilterComposer f) f,
  ) {
    final $$GroupCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.groupCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$ContentDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTr => $composableBuilder(
    column: $table.nameTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$ContentDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameTr =>
      $composableBuilder(column: $table.nameTr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> duaCategoriesRefs<T extends Object>(
    Expression<T> Function($$DuaCategoriesTableAnnotationComposer a) f,
  ) {
    final $$DuaCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.duaCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuaCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.duaCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupCategoriesRefs<T extends Object>(
    Expression<T> Function($$GroupCategoriesTableAnnotationComposer a) f,
  ) {
    final $$GroupCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.groupCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool duaCategoriesRefs,
            bool groupCategoriesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$ContentDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String> nameTr = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                code: code,
                nameTr: nameTr,
                nameEn: nameEn,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> code = const Value.absent(),
                required String nameTr,
                Value<String?> nameEn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                code: code,
                nameTr: nameTr,
                nameEn: nameEn,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({duaCategoriesRefs = false, groupCategoriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (duaCategoriesRefs) db.duaCategories,
                    if (groupCategoriesRefs) db.groupCategories,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (duaCategoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          DuaCategory,
                          $DuaCategoriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._duaCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).duaCategoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (groupCategoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          Category,
                          $CategoriesTable,
                          GroupCategory,
                          $GroupCategoriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._groupCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).groupCategoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool duaCategoriesRefs, bool groupCategoriesRefs})
    >;
typedef $$DuaCategoriesTableCreateCompanionBuilder =
    DuaCategoriesCompanion Function({
      required String duaId,
      required int categoryId,
      Value<int> rowid,
    });
typedef $$DuaCategoriesTableUpdateCompanionBuilder =
    DuaCategoriesCompanion Function({
      Value<String> duaId,
      Value<int> categoryId,
      Value<int> rowid,
    });

final class $$DuaCategoriesTableReferences
    extends
        BaseReferences<_$ContentDatabase, $DuaCategoriesTable, DuaCategory> {
  $$DuaCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DuasTable _duaIdTable(_$ContentDatabase db) =>
      db.duas.createAlias('dua_categories__dua_id__duas__id');

  $$DuasTableProcessedTableManager get duaId {
    final $_column = $_itemColumn<String>('dua_id')!;

    final manager = $$DuasTableTableManager(
      $_db,
      $_db.duas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_duaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$ContentDatabase db) =>
      db.categories.createAlias('dua_categories__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DuaCategoriesTableFilterComposer
    extends Composer<_$ContentDatabase, $DuaCategoriesTable> {
  $$DuaCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DuasTableFilterComposer get duaId {
    final $$DuasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableFilterComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuaCategoriesTableOrderingComposer
    extends Composer<_$ContentDatabase, $DuaCategoriesTable> {
  $$DuaCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DuasTableOrderingComposer get duaId {
    final $$DuasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableOrderingComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuaCategoriesTableAnnotationComposer
    extends Composer<_$ContentDatabase, $DuaCategoriesTable> {
  $$DuaCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$DuasTableAnnotationComposer get duaId {
    final $$DuasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableAnnotationComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DuaCategoriesTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $DuaCategoriesTable,
          DuaCategory,
          $$DuaCategoriesTableFilterComposer,
          $$DuaCategoriesTableOrderingComposer,
          $$DuaCategoriesTableAnnotationComposer,
          $$DuaCategoriesTableCreateCompanionBuilder,
          $$DuaCategoriesTableUpdateCompanionBuilder,
          (DuaCategory, $$DuaCategoriesTableReferences),
          DuaCategory,
          PrefetchHooks Function({bool duaId, bool categoryId})
        > {
  $$DuaCategoriesTableTableManager(
    _$ContentDatabase db,
    $DuaCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuaCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuaCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DuaCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> duaId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DuaCategoriesCompanion(
                duaId: duaId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String duaId,
                required int categoryId,
                Value<int> rowid = const Value.absent(),
              }) => DuaCategoriesCompanion.insert(
                duaId: duaId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DuaCategoriesTable, DuaCategory>(table),
                  $$DuaCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({duaId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (duaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.duaId,
                        referencedTable: $$DuaCategoriesTableReferences
                            ._duaIdTable(db),
                        referencedColumn: $$DuaCategoriesTableReferences
                            ._duaIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$DuaCategoriesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$DuaCategoriesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DuaCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $DuaCategoriesTable,
      DuaCategory,
      $$DuaCategoriesTableFilterComposer,
      $$DuaCategoriesTableOrderingComposer,
      $$DuaCategoriesTableAnnotationComposer,
      $$DuaCategoriesTableCreateCompanionBuilder,
      $$DuaCategoriesTableUpdateCompanionBuilder,
      (DuaCategory, $$DuaCategoriesTableReferences),
      DuaCategory,
      PrefetchHooks Function({bool duaId, bool categoryId})
    >;
typedef $$GroupsTableCreateCompanionBuilder = GroupsCompanion Function({
  required String id,
  required String titleTr,
  Value<String?> titleEn,
  Value<String?> titleAr,
  Value<String?> description,
  Value<String?> editorialStatus,
  Value<String?> infoJson,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$GroupsTableUpdateCompanionBuilder = GroupsCompanion Function({
  Value<String> id,
  Value<String> titleTr,
  Value<String?> titleEn,
  Value<String?> titleAr,
  Value<String?> description,
  Value<String?> editorialStatus,
  Value<String?> infoJson,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$GroupsTableReferences
    extends BaseReferences<_$ContentDatabase, $GroupsTable, DuaGroup> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupCategoriesTable, List<GroupCategory>>
  _groupCategoriesRefsTable(_$ContentDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.groupCategories,
        aliasName: 'groups__id__group_categories__group_id',
      );

  $$GroupCategoriesTableProcessedTableManager get groupCategoriesRefs {
    final manager = $$GroupCategoriesTableTableManager(
      $_db,
      $_db.groupCategories,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupItemsTable, List<GroupItem>>
  _groupItemsRefsTable(_$ContentDatabase db) => MultiTypedResultKey.fromTable(
    db.groupItems,
    aliasName: 'groups__id__group_items__group_id',
  );

  $$GroupItemsTableProcessedTableManager get groupItemsRefs {
    final manager = $$GroupItemsTableTableManager(
      $_db,
      $_db.groupItems,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TracksTable, List<Track>> _tracksRefsTable(
    _$ContentDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tracks,
    aliasName: 'groups__id__tracks__group_id',
  );

  $$TracksTableProcessedTableManager get tracksRefs {
    final manager = $$TracksTableTableManager(
      $_db,
      $_db.tracks,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tracksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$ContentDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleTr => $composableBuilder(
    column: $table.titleTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editorialStatus => $composableBuilder(
    column: $table.editorialStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get infoJson => $composableBuilder(
    column: $table.infoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupCategoriesRefs(
    Expression<bool> Function($$GroupCategoriesTableFilterComposer f) f,
  ) {
    final $$GroupCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupCategories,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.groupCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupItemsRefs(
    Expression<bool> Function($$GroupItemsTableFilterComposer f) f,
  ) {
    final $$GroupItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupItems,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupItemsTableFilterComposer(
            $db: $db,
            $table: $db.groupItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tracksRefs(
    Expression<bool> Function($$TracksTableFilterComposer f) f,
  ) {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$ContentDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleTr => $composableBuilder(
    column: $table.titleTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editorialStatus => $composableBuilder(
    column: $table.editorialStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get infoJson => $composableBuilder(
    column: $table.infoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleTr =>
      $composableBuilder(column: $table.titleTr, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editorialStatus => $composableBuilder(
    column: $table.editorialStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get infoJson =>
      $composableBuilder(column: $table.infoJson, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> groupCategoriesRefs<T extends Object>(
    Expression<T> Function($$GroupCategoriesTableAnnotationComposer a) f,
  ) {
    final $$GroupCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupCategories,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.groupCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupItemsRefs<T extends Object>(
    Expression<T> Function($$GroupItemsTableAnnotationComposer a) f,
  ) {
    final $$GroupItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupItems,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tracksRefs<T extends Object>(
    Expression<T> Function($$TracksTableAnnotationComposer a) f,
  ) {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $GroupsTable,
          DuaGroup,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (DuaGroup, $$GroupsTableReferences),
          DuaGroup,
          PrefetchHooks Function({
            bool groupCategoriesRefs,
            bool groupItemsRefs,
            bool tracksRefs,
          })
        > {
  $$GroupsTableTableManager(_$ContentDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> titleTr = const Value.absent(),
                Value<String?> titleEn = const Value.absent(),
                Value<String?> titleAr = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> editorialStatus = const Value.absent(),
                Value<String?> infoJson = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                titleTr: titleTr,
                titleEn: titleEn,
                titleAr: titleAr,
                description: description,
                editorialStatus: editorialStatus,
                infoJson: infoJson,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String titleTr,
                Value<String?> titleEn = const Value.absent(),
                Value<String?> titleAr = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> editorialStatus = const Value.absent(),
                Value<String?> infoJson = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                titleTr: titleTr,
                titleEn: titleEn,
                titleAr: titleAr,
                description: description,
                editorialStatus: editorialStatus,
                infoJson: infoJson,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupsTable, DuaGroup>(table),
                  $$GroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupCategoriesRefs = false,
                groupItemsRefs = false,
                tracksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (groupCategoriesRefs) db.groupCategories,
                    if (groupItemsRefs) db.groupItems,
                    if (tracksRefs) db.tracks,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (groupCategoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          DuaGroup,
                          $GroupsTable,
                          GroupCategory,
                          $GroupCategoriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._groupCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupCategoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'group_id',
                          typedResults: items,
                        ),
                      if (groupItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          DuaGroup,
                          $GroupsTable,
                          GroupItem,
                          $GroupItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._groupItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'group_id',
                          typedResults: items,
                        ),
                      if (tracksRefs)
                        await $_getPrefetchedDataByColumns<
                          DuaGroup,
                          $GroupsTable,
                          Track,
                          $TracksTable
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._tracksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(db, table, p0).tracksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'group_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $GroupsTable,
      DuaGroup,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (DuaGroup, $$GroupsTableReferences),
      DuaGroup,
      PrefetchHooks Function({
        bool groupCategoriesRefs,
        bool groupItemsRefs,
        bool tracksRefs,
      })
    >;
typedef $$GroupCategoriesTableCreateCompanionBuilder =
    GroupCategoriesCompanion Function({
      required String groupId,
      required int categoryId,
      Value<int> rowid,
    });
typedef $$GroupCategoriesTableUpdateCompanionBuilder =
    GroupCategoriesCompanion Function({
      Value<String> groupId,
      Value<int> categoryId,
      Value<int> rowid,
    });

final class $$GroupCategoriesTableReferences
    extends
        BaseReferences<
          _$ContentDatabase,
          $GroupCategoriesTable,
          GroupCategory
        > {
  $$GroupCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTable _groupIdTable(_$ContentDatabase db) =>
      db.groups.createAlias('group_categories__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$ContentDatabase db) => db
      .categories
      .createAlias('group_categories__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupCategoriesTableFilterComposer
    extends Composer<_$ContentDatabase, $GroupCategoriesTable> {
  $$GroupCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupCategoriesTableOrderingComposer
    extends Composer<_$ContentDatabase, $GroupCategoriesTable> {
  $$GroupCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupCategoriesTableAnnotationComposer
    extends Composer<_$ContentDatabase, $GroupCategoriesTable> {
  $$GroupCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupCategoriesTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $GroupCategoriesTable,
          GroupCategory,
          $$GroupCategoriesTableFilterComposer,
          $$GroupCategoriesTableOrderingComposer,
          $$GroupCategoriesTableAnnotationComposer,
          $$GroupCategoriesTableCreateCompanionBuilder,
          $$GroupCategoriesTableUpdateCompanionBuilder,
          (GroupCategory, $$GroupCategoriesTableReferences),
          GroupCategory,
          PrefetchHooks Function({bool groupId, bool categoryId})
        > {
  $$GroupCategoriesTableTableManager(
    _$ContentDatabase db,
    $GroupCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupCategoriesCompanion(
                groupId: groupId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required int categoryId,
                Value<int> rowid = const Value.absent(),
              }) => GroupCategoriesCompanion.insert(
                groupId: groupId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupCategoriesTable, GroupCategory>(table),
                  $$GroupCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$GroupCategoriesTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$GroupCategoriesTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$GroupCategoriesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$GroupCategoriesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $GroupCategoriesTable,
      GroupCategory,
      $$GroupCategoriesTableFilterComposer,
      $$GroupCategoriesTableOrderingComposer,
      $$GroupCategoriesTableAnnotationComposer,
      $$GroupCategoriesTableCreateCompanionBuilder,
      $$GroupCategoriesTableUpdateCompanionBuilder,
      (GroupCategory, $$GroupCategoriesTableReferences),
      GroupCategory,
      PrefetchHooks Function({bool groupId, bool categoryId})
    >;
typedef $$GroupItemsTableCreateCompanionBuilder = GroupItemsCompanion Function({
  Value<int> id,
  required String groupId,
  required String duaId,
  Value<int?> position,
  Value<int> repeatCount,
});
typedef $$GroupItemsTableUpdateCompanionBuilder = GroupItemsCompanion Function({
  Value<int> id,
  Value<String> groupId,
  Value<String> duaId,
  Value<int?> position,
  Value<int> repeatCount,
});

final class $$GroupItemsTableReferences
    extends BaseReferences<_$ContentDatabase, $GroupItemsTable, GroupItem> {
  $$GroupItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$ContentDatabase db) =>
      db.groups.createAlias('group_items__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DuasTable _duaIdTable(_$ContentDatabase db) =>
      db.duas.createAlias('group_items__dua_id__duas__id');

  $$DuasTableProcessedTableManager get duaId {
    final $_column = $_itemColumn<String>('dua_id')!;

    final manager = $$DuasTableTableManager(
      $_db,
      $_db.duas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_duaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupItemsTableFilterComposer
    extends Composer<_$ContentDatabase, $GroupItemsTable> {
  $$GroupItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatCount => $composableBuilder(
    column: $table.repeatCount,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DuasTableFilterComposer get duaId {
    final $$DuasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableFilterComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupItemsTableOrderingComposer
    extends Composer<_$ContentDatabase, $GroupItemsTable> {
  $$GroupItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatCount => $composableBuilder(
    column: $table.repeatCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DuasTableOrderingComposer get duaId {
    final $$DuasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableOrderingComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupItemsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $GroupItemsTable> {
  $$GroupItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get repeatCount => $composableBuilder(
    column: $table.repeatCount,
    builder: (column) => column,
  );

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DuasTableAnnotationComposer get duaId {
    final $$DuasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableAnnotationComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupItemsTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $GroupItemsTable,
          GroupItem,
          $$GroupItemsTableFilterComposer,
          $$GroupItemsTableOrderingComposer,
          $$GroupItemsTableAnnotationComposer,
          $$GroupItemsTableCreateCompanionBuilder,
          $$GroupItemsTableUpdateCompanionBuilder,
          (GroupItem, $$GroupItemsTableReferences),
          GroupItem,
          PrefetchHooks Function({bool groupId, bool duaId})
        > {
  $$GroupItemsTableTableManager(_$ContentDatabase db, $GroupItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> duaId = const Value.absent(),
                Value<int?> position = const Value.absent(),
                Value<int> repeatCount = const Value.absent(),
              }) => GroupItemsCompanion(
                id: id,
                groupId: groupId,
                duaId: duaId,
                position: position,
                repeatCount: repeatCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String groupId,
                required String duaId,
                Value<int?> position = const Value.absent(),
                Value<int> repeatCount = const Value.absent(),
              }) => GroupItemsCompanion.insert(
                id: id,
                groupId: groupId,
                duaId: duaId,
                position: position,
                repeatCount: repeatCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupItemsTable, GroupItem>(table),
                  $$GroupItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, duaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$GroupItemsTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$GroupItemsTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (duaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.duaId,
                        referencedTable: $$GroupItemsTableReferences
                            ._duaIdTable(db),
                        referencedColumn: $$GroupItemsTableReferences
                            ._duaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $GroupItemsTable,
      GroupItem,
      $$GroupItemsTableFilterComposer,
      $$GroupItemsTableOrderingComposer,
      $$GroupItemsTableAnnotationComposer,
      $$GroupItemsTableCreateCompanionBuilder,
      $$GroupItemsTableUpdateCompanionBuilder,
      (GroupItem, $$GroupItemsTableReferences),
      GroupItem,
      PrefetchHooks Function({bool groupId, bool duaId})
    >;
typedef $$SegmentsTableCreateCompanionBuilder = SegmentsCompanion Function({
  Value<int> id,
  required String duaId,
  required int position,
  required String textAr,
  Value<String?> pronunciationTr,
  Value<String?> pronunciationEn,
  Value<String?> meaningTr,
  Value<String?> meaningEn,
  Value<FieldSource?> pronunciationTrSource,
  Value<FieldSource?> pronunciationEnSource,
  Value<FieldSource?> meaningTrSource,
  Value<FieldSource?> meaningEnSource,
  Value<ReviewStatus> review,
});
typedef $$SegmentsTableUpdateCompanionBuilder = SegmentsCompanion Function({
  Value<int> id,
  Value<String> duaId,
  Value<int> position,
  Value<String> textAr,
  Value<String?> pronunciationTr,
  Value<String?> pronunciationEn,
  Value<String?> meaningTr,
  Value<String?> meaningEn,
  Value<FieldSource?> pronunciationTrSource,
  Value<FieldSource?> pronunciationEnSource,
  Value<FieldSource?> meaningTrSource,
  Value<FieldSource?> meaningEnSource,
  Value<ReviewStatus> review,
});

final class $$SegmentsTableReferences
    extends BaseReferences<_$ContentDatabase, $SegmentsTable, Segment> {
  $$SegmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DuasTable _duaIdTable(_$ContentDatabase db) =>
      db.duas.createAlias('segments__dua_id__duas__id');

  $$DuasTableProcessedTableManager get duaId {
    final $_column = $_itemColumn<String>('dua_id')!;

    final manager = $$DuasTableTableManager(
      $_db,
      $_db.duas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_duaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CuesTable, List<Cue>> _cuesRefsTable(
    _$ContentDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cues,
    aliasName: 'segments__id__cues__segment_id',
  );

  $$CuesTableProcessedTableManager get cuesRefs {
    final manager = $$CuesTableTableManager(
      $_db,
      $_db.cues,
    ).filter((f) => f.segmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cuesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SegmentsTableFilterComposer
    extends Composer<_$ContentDatabase, $SegmentsTable> {
  $$SegmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textAr => $composableBuilder(
    column: $table.textAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pronunciationTr => $composableBuilder(
    column: $table.pronunciationTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pronunciationEn => $composableBuilder(
    column: $table.pronunciationEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningTr => $composableBuilder(
    column: $table.meaningTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningEn => $composableBuilder(
    column: $table.meaningEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FieldSource?, FieldSource, String>
  get pronunciationTrSource => $composableBuilder(
    column: $table.pronunciationTrSource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<FieldSource?, FieldSource, String>
  get pronunciationEnSource => $composableBuilder(
    column: $table.pronunciationEnSource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<FieldSource?, FieldSource, String>
  get meaningTrSource => $composableBuilder(
    column: $table.meaningTrSource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<FieldSource?, FieldSource, String>
  get meaningEnSource => $composableBuilder(
    column: $table.meaningEnSource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ReviewStatus, ReviewStatus, String>
  get review => $composableBuilder(
    column: $table.review,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$DuasTableFilterComposer get duaId {
    final $$DuasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableFilterComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cuesRefs(
    Expression<bool> Function($$CuesTableFilterComposer f) f,
  ) {
    final $$CuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cues,
      getReferencedColumn: (t) => t.segmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuesTableFilterComposer(
            $db: $db,
            $table: $db.cues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SegmentsTableOrderingComposer
    extends Composer<_$ContentDatabase, $SegmentsTable> {
  $$SegmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textAr => $composableBuilder(
    column: $table.textAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronunciationTr => $composableBuilder(
    column: $table.pronunciationTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronunciationEn => $composableBuilder(
    column: $table.pronunciationEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningTr => $composableBuilder(
    column: $table.meaningTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningEn => $composableBuilder(
    column: $table.meaningEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronunciationTrSource => $composableBuilder(
    column: $table.pronunciationTrSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronunciationEnSource => $composableBuilder(
    column: $table.pronunciationEnSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningTrSource => $composableBuilder(
    column: $table.meaningTrSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningEnSource => $composableBuilder(
    column: $table.meaningEnSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get review => $composableBuilder(
    column: $table.review,
    builder: (column) => ColumnOrderings(column),
  );

  $$DuasTableOrderingComposer get duaId {
    final $$DuasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableOrderingComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SegmentsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $SegmentsTable> {
  $$SegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get textAr =>
      $composableBuilder(column: $table.textAr, builder: (column) => column);

  GeneratedColumn<String> get pronunciationTr => $composableBuilder(
    column: $table.pronunciationTr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pronunciationEn => $composableBuilder(
    column: $table.pronunciationEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meaningTr =>
      $composableBuilder(column: $table.meaningTr, builder: (column) => column);

  GeneratedColumn<String> get meaningEn =>
      $composableBuilder(column: $table.meaningEn, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FieldSource?, String>
  get pronunciationTrSource => $composableBuilder(
    column: $table.pronunciationTrSource,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FieldSource?, String>
  get pronunciationEnSource => $composableBuilder(
    column: $table.pronunciationEnSource,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FieldSource?, String> get meaningTrSource =>
      $composableBuilder(
        column: $table.meaningTrSource,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<FieldSource?, String> get meaningEnSource =>
      $composableBuilder(
        column: $table.meaningEnSource,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<ReviewStatus, String> get review =>
      $composableBuilder(column: $table.review, builder: (column) => column);

  $$DuasTableAnnotationComposer get duaId {
    final $$DuasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableAnnotationComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cuesRefs<T extends Object>(
    Expression<T> Function($$CuesTableAnnotationComposer a) f,
  ) {
    final $$CuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cues,
      getReferencedColumn: (t) => t.segmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuesTableAnnotationComposer(
            $db: $db,
            $table: $db.cues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SegmentsTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $SegmentsTable,
          Segment,
          $$SegmentsTableFilterComposer,
          $$SegmentsTableOrderingComposer,
          $$SegmentsTableAnnotationComposer,
          $$SegmentsTableCreateCompanionBuilder,
          $$SegmentsTableUpdateCompanionBuilder,
          (Segment, $$SegmentsTableReferences),
          Segment,
          PrefetchHooks Function({bool duaId, bool cuesRefs})
        > {
  $$SegmentsTableTableManager(_$ContentDatabase db, $SegmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SegmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> duaId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> textAr = const Value.absent(),
                Value<String?> pronunciationTr = const Value.absent(),
                Value<String?> pronunciationEn = const Value.absent(),
                Value<String?> meaningTr = const Value.absent(),
                Value<String?> meaningEn = const Value.absent(),
                Value<FieldSource?> pronunciationTrSource =
                    const Value.absent(),
                Value<FieldSource?> pronunciationEnSource =
                    const Value.absent(),
                Value<FieldSource?> meaningTrSource = const Value.absent(),
                Value<FieldSource?> meaningEnSource = const Value.absent(),
                Value<ReviewStatus> review = const Value.absent(),
              }) => SegmentsCompanion(
                id: id,
                duaId: duaId,
                position: position,
                textAr: textAr,
                pronunciationTr: pronunciationTr,
                pronunciationEn: pronunciationEn,
                meaningTr: meaningTr,
                meaningEn: meaningEn,
                pronunciationTrSource: pronunciationTrSource,
                pronunciationEnSource: pronunciationEnSource,
                meaningTrSource: meaningTrSource,
                meaningEnSource: meaningEnSource,
                review: review,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String duaId,
                required int position,
                required String textAr,
                Value<String?> pronunciationTr = const Value.absent(),
                Value<String?> pronunciationEn = const Value.absent(),
                Value<String?> meaningTr = const Value.absent(),
                Value<String?> meaningEn = const Value.absent(),
                Value<FieldSource?> pronunciationTrSource =
                    const Value.absent(),
                Value<FieldSource?> pronunciationEnSource =
                    const Value.absent(),
                Value<FieldSource?> meaningTrSource = const Value.absent(),
                Value<FieldSource?> meaningEnSource = const Value.absent(),
                Value<ReviewStatus> review = const Value.absent(),
              }) => SegmentsCompanion.insert(
                id: id,
                duaId: duaId,
                position: position,
                textAr: textAr,
                pronunciationTr: pronunciationTr,
                pronunciationEn: pronunciationEn,
                meaningTr: meaningTr,
                meaningEn: meaningEn,
                pronunciationTrSource: pronunciationTrSource,
                pronunciationEnSource: pronunciationEnSource,
                meaningTrSource: meaningTrSource,
                meaningEnSource: meaningEnSource,
                review: review,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SegmentsTable, Segment>(table),
                  $$SegmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({duaId = false, cuesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cuesRefs) db.cues],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (duaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.duaId,
                        referencedTable: $$SegmentsTableReferences._duaIdTable(
                          db,
                        ),
                        referencedColumn: $$SegmentsTableReferences
                            ._duaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cuesRefs)
                    await $_getPrefetchedDataByColumns<
                      Segment,
                      $SegmentsTable,
                      Cue,
                      $CuesTable
                    >(
                      currentTable: table,
                      referencedTable: $$SegmentsTableReferences._cuesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$SegmentsTableReferences(db, table, p0).cuesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'segment_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SegmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $SegmentsTable,
      Segment,
      $$SegmentsTableFilterComposer,
      $$SegmentsTableOrderingComposer,
      $$SegmentsTableAnnotationComposer,
      $$SegmentsTableCreateCompanionBuilder,
      $$SegmentsTableUpdateCompanionBuilder,
      (Segment, $$SegmentsTableReferences),
      Segment,
      PrefetchHooks Function({bool duaId, bool cuesRefs})
    >;
typedef $$TracksTableCreateCompanionBuilder = TracksCompanion Function({
  Value<int> id,
  required TrackOwnerKind ownerKind,
  Value<String?> duaId,
  Value<String?> groupId,
  required String relPath,
  required String label,
  Value<int?> durationMs,
});
typedef $$TracksTableUpdateCompanionBuilder = TracksCompanion Function({
  Value<int> id,
  Value<TrackOwnerKind> ownerKind,
  Value<String?> duaId,
  Value<String?> groupId,
  Value<String> relPath,
  Value<String> label,
  Value<int?> durationMs,
});

final class $$TracksTableReferences
    extends BaseReferences<_$ContentDatabase, $TracksTable, Track> {
  $$TracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DuasTable _duaIdTable(_$ContentDatabase db) =>
      db.duas.createAlias('tracks__dua_id__duas__id');

  $$DuasTableProcessedTableManager? get duaId {
    final $_column = $_itemColumn<String>('dua_id');
    if ($_column == null) return null;
    final manager = $$DuasTableTableManager(
      $_db,
      $_db.duas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_duaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GroupsTable _groupIdTable(_$ContentDatabase db) =>
      db.groups.createAlias('tracks__group_id__groups__id');

  $$GroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<String>('group_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CuesTable, List<Cue>> _cuesRefsTable(
    _$ContentDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cues,
    aliasName: 'tracks__id__cues__track_id',
  );

  $$CuesTableProcessedTableManager get cuesRefs {
    final manager = $$CuesTableTableManager(
      $_db,
      $_db.cues,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cuesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TracksTableFilterComposer
    extends Composer<_$ContentDatabase, $TracksTable> {
  $$TracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TrackOwnerKind, TrackOwnerKind, String>
  get ownerKind => $composableBuilder(
    column: $table.ownerKind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get relPath => $composableBuilder(
    column: $table.relPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  $$DuasTableFilterComposer get duaId {
    final $$DuasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableFilterComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cuesRefs(
    Expression<bool> Function($$CuesTableFilterComposer f) f,
  ) {
    final $$CuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cues,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuesTableFilterComposer(
            $db: $db,
            $table: $db.cues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TracksTableOrderingComposer
    extends Composer<_$ContentDatabase, $TracksTable> {
  $$TracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerKind => $composableBuilder(
    column: $table.ownerKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relPath => $composableBuilder(
    column: $table.relPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$DuasTableOrderingComposer get duaId {
    final $$DuasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableOrderingComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TracksTableAnnotationComposer
    extends Composer<_$ContentDatabase, $TracksTable> {
  $$TracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TrackOwnerKind, String> get ownerKind =>
      $composableBuilder(column: $table.ownerKind, builder: (column) => column);

  GeneratedColumn<String> get relPath =>
      $composableBuilder(column: $table.relPath, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  $$DuasTableAnnotationComposer get duaId {
    final $$DuasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duaId,
      referencedTable: $db.duas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DuasTableAnnotationComposer(
            $db: $db,
            $table: $db.duas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cuesRefs<T extends Object>(
    Expression<T> Function($$CuesTableAnnotationComposer a) f,
  ) {
    final $$CuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cues,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuesTableAnnotationComposer(
            $db: $db,
            $table: $db.cues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TracksTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $TracksTable,
          Track,
          $$TracksTableFilterComposer,
          $$TracksTableOrderingComposer,
          $$TracksTableAnnotationComposer,
          $$TracksTableCreateCompanionBuilder,
          $$TracksTableUpdateCompanionBuilder,
          (Track, $$TracksTableReferences),
          Track,
          PrefetchHooks Function({bool duaId, bool groupId, bool cuesRefs})
        > {
  $$TracksTableTableManager(_$ContentDatabase db, $TracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TrackOwnerKind> ownerKind = const Value.absent(),
                Value<String?> duaId = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String> relPath = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
              }) => TracksCompanion(
                id: id,
                ownerKind: ownerKind,
                duaId: duaId,
                groupId: groupId,
                relPath: relPath,
                label: label,
                durationMs: durationMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TrackOwnerKind ownerKind,
                Value<String?> duaId = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                required String relPath,
                required String label,
                Value<int?> durationMs = const Value.absent(),
              }) => TracksCompanion.insert(
                id: id,
                ownerKind: ownerKind,
                duaId: duaId,
                groupId: groupId,
                relPath: relPath,
                label: label,
                durationMs: durationMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TracksTable, Track>(table),
                  $$TracksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({duaId = false, groupId = false, cuesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (cuesRefs) db.cues],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (duaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.duaId,
                            referencedTable: $$TracksTableReferences
                                ._duaIdTable(db),
                            referencedColumn: $$TracksTableReferences
                                ._duaIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (groupId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.groupId,
                            referencedTable: $$TracksTableReferences
                                ._groupIdTable(db),
                            referencedColumn: $$TracksTableReferences
                                ._groupIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cuesRefs)
                        await $_getPrefetchedDataByColumns<
                          Track,
                          $TracksTable,
                          Cue,
                          $CuesTable
                        >(
                          currentTable: table,
                          referencedTable: $$TracksTableReferences
                              ._cuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TracksTableReferences(db, table, p0).cuesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'track_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TracksTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $TracksTable,
      Track,
      $$TracksTableFilterComposer,
      $$TracksTableOrderingComposer,
      $$TracksTableAnnotationComposer,
      $$TracksTableCreateCompanionBuilder,
      $$TracksTableUpdateCompanionBuilder,
      (Track, $$TracksTableReferences),
      Track,
      PrefetchHooks Function({bool duaId, bool groupId, bool cuesRefs})
    >;
typedef $$CuesTableCreateCompanionBuilder = CuesCompanion Function({
  Value<int> id,
  required int trackId,
  required int startMs,
  Value<int?> segmentId,
});
typedef $$CuesTableUpdateCompanionBuilder = CuesCompanion Function({
  Value<int> id,
  Value<int> trackId,
  Value<int> startMs,
  Value<int?> segmentId,
});

final class $$CuesTableReferences
    extends BaseReferences<_$ContentDatabase, $CuesTable, Cue> {
  $$CuesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TracksTable _trackIdTable(_$ContentDatabase db) =>
      db.tracks.createAlias('cues__track_id__tracks__id');

  $$TracksTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<int>('track_id')!;

    final manager = $$TracksTableTableManager(
      $_db,
      $_db.tracks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SegmentsTable _segmentIdTable(_$ContentDatabase db) =>
      db.segments.createAlias('cues__segment_id__segments__id');

  $$SegmentsTableProcessedTableManager? get segmentId {
    final $_column = $_itemColumn<int>('segment_id');
    if ($_column == null) return null;
    final manager = $$SegmentsTableTableManager(
      $_db,
      $_db.segments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_segmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CuesTableFilterComposer
    extends Composer<_$ContentDatabase, $CuesTable> {
  $$CuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnFilters(column),
  );

  $$TracksTableFilterComposer get trackId {
    final $$TracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableFilterComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SegmentsTableFilterComposer get segmentId {
    final $$SegmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.segmentId,
      referencedTable: $db.segments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SegmentsTableFilterComposer(
            $db: $db,
            $table: $db.segments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CuesTableOrderingComposer
    extends Composer<_$ContentDatabase, $CuesTable> {
  $$CuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$TracksTableOrderingComposer get trackId {
    final $$TracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableOrderingComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SegmentsTableOrderingComposer get segmentId {
    final $$SegmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.segmentId,
      referencedTable: $db.segments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SegmentsTableOrderingComposer(
            $db: $db,
            $table: $db.segments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CuesTableAnnotationComposer
    extends Composer<_$ContentDatabase, $CuesTable> {
  $$CuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startMs =>
      $composableBuilder(column: $table.startMs, builder: (column) => column);

  $$TracksTableAnnotationComposer get trackId {
    final $$TracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SegmentsTableAnnotationComposer get segmentId {
    final $$SegmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.segmentId,
      referencedTable: $db.segments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SegmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.segments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CuesTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $CuesTable,
          Cue,
          $$CuesTableFilterComposer,
          $$CuesTableOrderingComposer,
          $$CuesTableAnnotationComposer,
          $$CuesTableCreateCompanionBuilder,
          $$CuesTableUpdateCompanionBuilder,
          (Cue, $$CuesTableReferences),
          Cue,
          PrefetchHooks Function({bool trackId, bool segmentId})
        > {
  $$CuesTableTableManager(_$ContentDatabase db, $CuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> trackId = const Value.absent(),
                Value<int> startMs = const Value.absent(),
                Value<int?> segmentId = const Value.absent(),
              }) => CuesCompanion(
                id: id,
                trackId: trackId,
                startMs: startMs,
                segmentId: segmentId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int trackId,
                required int startMs,
                Value<int?> segmentId = const Value.absent(),
              }) => CuesCompanion.insert(
                id: id,
                trackId: trackId,
                startMs: startMs,
                segmentId: segmentId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CuesTable, Cue>(table),
                  $$CuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackId = false, segmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trackId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.trackId,
                        referencedTable: $$CuesTableReferences._trackIdTable(
                          db,
                        ),
                        referencedColumn: $$CuesTableReferences
                            ._trackIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (segmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.segmentId,
                        referencedTable: $$CuesTableReferences._segmentIdTable(
                          db,
                        ),
                        referencedColumn: $$CuesTableReferences
                            ._segmentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CuesTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $CuesTable,
      Cue,
      $$CuesTableFilterComposer,
      $$CuesTableOrderingComposer,
      $$CuesTableAnnotationComposer,
      $$CuesTableCreateCompanionBuilder,
      $$CuesTableUpdateCompanionBuilder,
      (Cue, $$CuesTableReferences),
      Cue,
      PrefetchHooks Function({bool trackId, bool segmentId})
    >;
typedef $$ImportLogsTableCreateCompanionBuilder = ImportLogsCompanion Function({
  Value<int> id,
  required DateTime importedAt,
  required String fileName,
  required String reportJson,
});
typedef $$ImportLogsTableUpdateCompanionBuilder = ImportLogsCompanion Function({
  Value<int> id,
  Value<DateTime> importedAt,
  Value<String> fileName,
  Value<String> reportJson,
});

class $$ImportLogsTableFilterComposer
    extends Composer<_$ContentDatabase, $ImportLogsTable> {
  $$ImportLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImportLogsTableOrderingComposer
    extends Composer<_$ContentDatabase, $ImportLogsTable> {
  $$ImportLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportLogsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $ImportLogsTable> {
  $$ImportLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => column,
  );
}

class $$ImportLogsTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $ImportLogsTable,
          ImportLog,
          $$ImportLogsTableFilterComposer,
          $$ImportLogsTableOrderingComposer,
          $$ImportLogsTableAnnotationComposer,
          $$ImportLogsTableCreateCompanionBuilder,
          $$ImportLogsTableUpdateCompanionBuilder,
          (
            ImportLog,
            BaseReferences<_$ContentDatabase, $ImportLogsTable, ImportLog>,
          ),
          ImportLog,
          PrefetchHooks Function()
        > {
  $$ImportLogsTableTableManager(_$ContentDatabase db, $ImportLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> reportJson = const Value.absent(),
              }) => ImportLogsCompanion(
                id: id,
                importedAt: importedAt,
                fileName: fileName,
                reportJson: reportJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime importedAt,
                required String fileName,
                required String reportJson,
              }) => ImportLogsCompanion.insert(
                id: id,
                importedAt: importedAt,
                fileName: fileName,
                reportJson: reportJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportLogsTable, ImportLog>(table),
                  BaseReferences<
                    _$ContentDatabase,
                    $ImportLogsTable,
                    ImportLog
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImportLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $ImportLogsTable,
      ImportLog,
      $$ImportLogsTableFilterComposer,
      $$ImportLogsTableOrderingComposer,
      $$ImportLogsTableAnnotationComposer,
      $$ImportLogsTableCreateCompanionBuilder,
      $$ImportLogsTableUpdateCompanionBuilder,
      (
        ImportLog,
        BaseReferences<_$ContentDatabase, $ImportLogsTable, ImportLog>,
      ),
      ImportLog,
      PrefetchHooks Function()
    >;

class $ContentDatabaseManager {
  final _$ContentDatabase _db;
  $ContentDatabaseManager(this._db);
  $$DuasTableTableManager get duas => $$DuasTableTableManager(_db, _db.duas);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$DuaCategoriesTableTableManager get duaCategories =>
      $$DuaCategoriesTableTableManager(_db, _db.duaCategories);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$GroupCategoriesTableTableManager get groupCategories =>
      $$GroupCategoriesTableTableManager(_db, _db.groupCategories);
  $$GroupItemsTableTableManager get groupItems =>
      $$GroupItemsTableTableManager(_db, _db.groupItems);
  $$SegmentsTableTableManager get segments =>
      $$SegmentsTableTableManager(_db, _db.segments);
  $$TracksTableTableManager get tracks =>
      $$TracksTableTableManager(_db, _db.tracks);
  $$CuesTableTableManager get cues => $$CuesTableTableManager(_db, _db.cues);
  $$ImportLogsTableTableManager get importLogs =>
      $$ImportLogsTableTableManager(_db, _db.importLogs);
}
