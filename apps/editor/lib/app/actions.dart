import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show BooleanExpressionOperators;
import 'package:dua_core/dua_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../widgets/elevenlabs_settings.dart';
import 'app_state.dart';

Future<void> showReport(
  BuildContext context,
  String title,
  List<String> lines,
) => showDialog(
  context: context,
  builder: (c) => AlertDialog(
    title: Text(title),
    content: SizedBox(
      width: 640,
      child: SingleChildScrollView(
        child: SelectableText(lines.isEmpty ? 'Tamam.' : lines.join('\n')),
      ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(c), child: const Text('Kapat')),
    ],
  ),
);

Future<void> _guard(
  BuildContext context,
  String title,
  Future<List<String>> Function() body,
) async {
  try {
    final lines = await body();
    if (context.mounted) await showReport(context, title, lines);
  } catch (e) {
    if (context.mounted) await showReport(context, '$title — hata', ['$e']);
  }
}

Future<void> importArchiveAction(BuildContext context, AppState s) async {
  final picked = await FilePicker.pickFiles(
    dialogTitle: 'Dua arşivi (JSON) seç',
    type: FileType.custom,
    allowedExtensions: ['json'],
    initialDirectory: p.join(s.contentDir.path, 'import'),
  );
  final path = picked.isEmpty ? null : picked.first.path;
  if (path == null || !context.mounted) return;
  await _guard(context, 'JSON içe aktarma', () async {
    final json =
        jsonDecode(await File(path).readAsString()) as Map<String, dynamic>;
    final r = await ArchiveImporter(s.db)
        .importJson(json, fileName: p.basename(path));
    s.changed();
    return [
      'Yeni dua: ${r.duasCreated}, güncellenen: ${r.duasUpdated}, yeni grup: ${r.groupsCreated}, yeni satır: ${r.segmentsCreated}',
      if (r.changedDuaIds.isNotEmpty)
        'JSON\'da değişiklik olan dualar: ${r.changedDuaIds.join(', ')}',
      ...r.warnings.map((w) => '⚠ $w'),
    ];
  });
}

Future<void> matchAudioAction(BuildContext context, AppState s) async {
  final dir = await FilePicker.getDirectoryPath(
    dialogTitle: 'Ses dosyalarının klasörü',
  );
  if (dir == null || !context.mounted) return;
  await _guard(context, 'Sesleri eşleştir', () async {
    final r = await matchAudioFolder(s.db, Directory(dir), s.contentDir);
    s.changed();
    return [
      'Eşleşen: ${r.matched.length}',
      ...r.matched.map((m) => '  ${m.$1} ← ${m.$2}'),
      if (r.unmatchedFiles.isNotEmpty)
        'Eşleşmeyen dosyalar: ${r.unmatchedFiles.join(', ')}',
      if (r.duasWithoutFile.isNotEmpty)
        'Sesi olmayan dualar (${r.duasWithoutFile.length}): ${r.duasWithoutFile.join(', ')}',
    ];
  });
}

Future<void> sendToTranslationAction(BuildContext context, AppState s) =>
    _guard(context, 'Çeviriye gönder', () async {
      final pending = await buildPending(s.db);
      final f = s.translationFile('pending.json');
      await f.writeAsString(
        const JsonEncoder.withIndent('  ').convert(pending),
      );
      final n = (pending['duas'] as List).length;
      return [
        '$n dua ${f.path} dosyasına yazıldı.',
        if (n > 0)
          'Claude\'a "çevirileri yap" deyin; bitince "Çevirileri içe aktar".',
      ];
    });

Future<void> importTranslationsAction(BuildContext context, AppState s) =>
    _guard(context, 'Çevirileri içe aktar', () async {
      final f = s.translationFile('done.json');
      if (!f.existsSync()) return ['${f.path} bulunamadı.'];
      final r = await applyDone(
        s.db,
        jsonDecode(await f.readAsString()) as Map<String, dynamic>,
      );
      s.changed();
      return [
        'Uygulanan satır: ${r.applied}',
        if (r.staleSegmentIds.isNotEmpty)
          'Arapçası değişmiş (uygulanmadı): ${r.staleSegmentIds.join(', ')}',
        if (r.skippedApprovedIds.isNotEmpty)
          'Onaylı olduğu için atlanan: ${r.skippedApprovedIds.join(', ')}',
        ...r.errors.map((e) => '⚠ $e'),
      ];
    });

Future<void> publishAction(
  BuildContext context,
  AppState s,
) => _guard(context, 'Mobil için yayınla', () async {
  // Telefona 64 kbps mono kopyalar gider; content/audio'daki orijinaller değişmez.
  final ff = s.ffmpeg;
  final r = await publish(
    s.db,
    contentDir: s.contentDir,
    outDir: s.publishDir,
    transcode: ff == null
        ? null
        : cachedTranscoder(
            Directory(p.join(s.contentDir.path, '.yayin-64k')),
            (src, dst) => ff.transcodeSpeech(src, dst),
          ),
  );
  s.changed();
  return [
    'İçerik sürümü: ${r.contentVersion} → ${s.publishDir.path}',
    ff == null
        ? '⚠ ffmpeg bulunamadı: sesler dönüştürülmeden (orijinal boyutta) kopyalandı.'
        : 'Sesler telefona 64 kbps olarak gitti (orijinaller content/audio\'da).',
    'Yayınlanan dua: ${r.publishedDuaIds.length}, grup: ${r.publishedGroupIds.length}',
    if (r.skipped.isNotEmpty) 'Yayınlanmayan (${r.skipped.length}):',
    ...r.skipped.entries.map((e) => '  ${e.key}: ${e.value.join('; ')}'),
    if (r.groupMissing.isNotEmpty) 'Gruplarda eksik kalan üyeler:',
    ...r.groupMissing.entries.map((e) => '  ${e.key}: ${e.value.join(', ')}'),
  ];
});

/// Seçili duaların [lang] dilindeki sesini ElevenLabs ile üretir:
/// özet (dua, karakter, kalan kota) → onay → ilerleme + iptal → rapor.
/// Her dua bağımsızdır; biri hata verirse diğerleri sürer.
Future<void> generateTtsAction(
  BuildContext context,
  AppState s,
  List<String> duaIds,
  String lang,
) async {
  final name = ttsLangNames[lang]!;
  final title = '$name ses üretimi';
  final el = s.settings.elevenLabs;
  final voice = el.voices[lang];
  final client = s.elevenLabs();
  if (client == null || voice == null) {
    await showReport(context, title, [
      if (client == null)
        'Önce Ayarlar → ElevenLabs sekmesinden API anahtarını gir.',
      if (voice == null) 'Ayarlar → ElevenLabs: $name için ses seçilmemiş.',
    ]);
    return;
  }
  try {
    final gen = s.ttsGenerator(client);
    final eligible = <String>[];
    final skipped = <String>[];
    var chars = 0;
    var existing = 0;
    for (final id in duaIds) {
      if (!await gen.canGenerate(id, lang)) {
        skipped.add(id);
        continue;
      }
      eligible.add(id);
      chars += await gen.estimateChars(id, lang);
      final has = await (s.db.select(
        s.db.tracks,
      )..where((t) => t.duaId.equals(id) & t.language.equals(lang))).get();
      if (has.isNotEmpty) existing++;
    }
    if (!context.mounted) return;
    if (eligible.isEmpty) {
      await showReport(context, title, [
        'Seçili dualarda $name ses üretilecek metin yok (satırların $name metni eksik ya da dua bu dilde okunmuyor).',
        if (skipped.isNotEmpty) 'Atlanan: ${skipped.join(', ')}',
      ]);
      return;
    }
    String quota;
    var low = false;
    try {
      final q = await client.quota();
      quota = 'Kalan kota: ${q.remaining} / ${q.limit} karakter';
      low = chars > q.remaining;
    } catch (e) {
      quota = 'Kalan kota okunamadı: $e';
    }
    if (!context.mounted) return;
    final summary = [
      '${eligible.length} dua · $chars karakter · ses: ${voice.name}',
      quota,
      if (low) '⚠ Kota bu iş için yetmeyebilir.',
      if (existing > 0)
        '$existing duada zaten $name kaydı var: ElevenLabs kaydı yenilenir, elle eklenen kayıt silinmez (telefonda yenisi çalar).',
      if (skipped.isNotEmpty)
        'Metni eksik olduğu için atlanacak (${skipped.length}): ${skipped.join(', ')}',
    ].join('\n');
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 560,
          child: Text(summary, key: const ValueKey('tts-summary')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            key: const ValueKey('tts-confirm'),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Üret'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final lines = await showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _TtsProgressDialog(
        title: title,
        ids: eligible,
        run: (id) => gen
            .generate(
              id,
              lang,
              voiceId: voice.id,
              voiceName: voice.name,
              modelId: el.modelId,
            )
            .then((r) => r.chars),
      ),
    );
    s.changed();
    if (context.mounted) await showReport(context, title, lines ?? const []);
  } finally {
    client.close();
  }
}

class _TtsProgressDialog extends StatefulWidget {
  const _TtsProgressDialog({
    required this.title,
    required this.ids,
    required this.run,
  });
  final String title;
  final List<String> ids;
  final Future<int> Function(String duaId) run;

  @override
  State<_TtsProgressDialog> createState() => _TtsProgressDialogState();
}

class _TtsProgressDialogState extends State<_TtsProgressDialog> {
  int _done = 0;
  bool _cancel = false;
  String? _current;

  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    final ok = <String>[];
    final failed = <String>[];
    var chars = 0;
    for (final id in widget.ids) {
      if (_cancel) break;
      setState(() => _current = id);
      try {
        final n = await widget.run(id);
        chars += n;
        ok.add('  $id ✓ ($n karakter)');
      } catch (e) {
        failed.add('  ⚠ $id: ${e is StateError ? e.message : e}');
      }
      if (!mounted) return;
      setState(() => _done++);
    }
    final rest = widget.ids.length - _done;
    if (mounted) {
      Navigator.pop(context, [
        'Üretilen: ${ok.length} dua, $chars karakter',
        ...ok,
        if (failed.isNotEmpty) 'Hata (${failed.length}):',
        ...failed,
        if (rest > 0)
          'İptal edildi; üretilmeyen: ${widget.ids.skip(_done).join(', ')}',
      ]);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 480,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: widget.ids.isEmpty ? null : _done / widget.ids.length,
          ),
          const SizedBox(height: 8),
          Text(
            '$_done / ${widget.ids.length}${_current == null ? '' : ' · $_current'}',
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: _cancel ? null : () => setState(() => _cancel = true),
        child: Text(_cancel ? 'Bu dua bitince duracak…' : 'İptal'),
      ),
    ],
  );
}
