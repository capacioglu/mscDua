import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:dua_core/dua_core.dart';
import 'package:dualarim_mobile/app_scope.dart';
import 'package:dualarim_mobile/audio/player_service.dart';

/// Sahte ses motoru: kuyruk ve konum elle sürülür.
class FakeBackend implements AudioBackend {
  List<QueueEntry> queue = [];
  bool playing = false;
  (int, int)? lastSeek;
  final _progress = StreamController<(int, int)>.broadcast();
  final _playing = StreamController<bool>.broadcast();

  void emit(int index, int ms) => _progress.add((index, ms));

  @override
  Future<void> setQueue(List<QueueEntry> q, File Function(Track) fileOf, String Function(String duaId) titleOf) async =>
      queue = q;
  @override
  Future<void> play() async => _playing.add(playing = true);
  @override
  Future<void> pause() async => _playing.add(playing = false);
  @override
  Future<void> seekTo(int index, int ms) async {
    lastSeek = (index, ms);
    emit(index, ms);
  }

  @override
  Stream<(int, int)> get progress => _progress.stream;
  @override
  Stream<bool> get playingStream => _playing.stream;
  @override
  Future<void> dispose() async {}
}

/// Mini arşiv + DUA-0006 ve DUA-0013 için kayıt ve işaretler.
Future<ContentDatabase> seededContent() async {
  final db = ContentDatabase.memory();
  await ArchiveImporter(db).importJson(
      jsonDecode(File('../../packages/dua_core/test/fixtures/dua_archive.mini.json').readAsStringSync())
          as Map<String, dynamic>,
      fileName: 'mini.json');
  for (final id in ['DUA-0006', 'DUA-0013']) {
    final t = await db.into(db.tracks).insert(TracksCompanion.insert(
        ownerKind: TrackOwnerKind.dua, duaId: Value(id), relPath: 'audio/$id.mp3', label: 'x'));
    final segs = await db.segmentsOf(id);
    for (var i = 0; i < segs.length; i++) {
      await db.into(db.cues).insert(CuesCompanion.insert(trackId: t, startMs: i * 1000, segmentId: Value(segs[i].id)));
    }
  }
  return db;
}

/// Testler için tam uygulama servisleri (bellek içi veritabanları + sahte ses motoru).
Future<(AppServices, FakeBackend, ContentDatabase)> testServices() async {
  final db = await seededContent();
  final backend = FakeBackend();
  final services = await AppServices.create(
    queries: ContentQueries(db),
    user: UserDatabase.memory(),
    player: PlayerService(backend, ContentQueries(db), fileOf: (t) => File(t.relPath)),
  );
  return (services, backend, db);
}
