import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../db/database.dart';
import '../model/enums.dart';

class AudioMatchResult {
  final List<(String duaId, String fileName)> matched = [];
  final List<String> unmatchedFiles = [];
  final List<String> duasWithoutFile = [];
}

const _audioExt = {'.mp3', '.m4a', '.wav', '.aac', '.ogg'};

/// Kaynak klasördeki ses dosyalarını duaların `expectedAudioFile` adlarıyla
/// (büyük/küçük harf duyarsız) eşler, `content/audio/` altına kopyalar ve
/// dua kaydı ekler. Aynı göreli yol zaten kayıtlıysa tekrar eklemez.
Future<AudioMatchResult> matchAudioFolder(ContentDatabase db, Directory source, Directory contentDir,
    {String label = 'ElevenLabs'}) async {
  final result = AudioMatchResult();
  final duas = await (db.select(db.duas)..where((t) => t.expectedAudioFile.isNotNull())).get();
  final byName = {for (final d in duas) d.expectedAudioFile!.toLowerCase(): d};
  final found = <String>{};
  final audioDir = Directory(p.join(contentDir.path, 'audio'));
  await audioDir.create(recursive: true);

  final files = source.listSync().whereType<File>().where((f) => _audioExt.contains(p.extension(f.path).toLowerCase())).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  for (final f in files) {
    final name = p.basename(f.path);
    final dua = byName[name.toLowerCase()];
    if (dua == null) {
      result.unmatchedFiles.add(name);
      continue;
    }
    final target = dua.expectedAudioFile!;
    final relPath = 'audio/$target';
    await f.copy(p.join(audioDir.path, target));
    final exists = await (db.select(db.tracks)..where((t) => t.relPath.equals(relPath))).getSingleOrNull();
    if (exists == null) {
      await db.into(db.tracks).insert(TracksCompanion.insert(
          ownerKind: TrackOwnerKind.dua, duaId: Value(dua.id), relPath: relPath, label: label));
    }
    found.add(dua.id);
    result.matched.add((dua.id, name));
  }
  result.duasWithoutFile.addAll(duas.map((d) => d.id).where((id) => !found.contains(id)).toList()..sort());
  return result;
}
