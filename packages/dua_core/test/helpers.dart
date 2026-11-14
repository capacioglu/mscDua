import 'package:drift/drift.dart';
import 'package:dua_core/dua_core.dart';

/// Test duası ekler; satırları verilen Arapça metinlerle oluşturur ve id'lerini döner.
Future<List<int>> seedDua(ContentDatabase db, String duaId, List<String> texts,
    {bool translated = false, bool approved = false, bool ready = false}) async {
  await db.into(db.duas).insert(DuasCompanion.insert(id: duaId, titleTr: duaId, readyToPublish: Value(ready)));
  final ids = <int>[];
  for (var i = 0; i < texts.length; i++) {
    ids.add(await db.into(db.segments).insert(SegmentsCompanion.insert(
          duaId: duaId,
          position: i,
          textAr: texts[i],
          pronunciationTr: Value(translated || approved ? 'okunuş $i' : null),
          meaningTr: Value(translated || approved ? 'anlam $i' : null),
          meaningEn: Value(translated || approved ? 'meaning $i' : null),
          review: Value(approved ? ReviewStatus.approved : (translated ? ReviewStatus.review : ReviewStatus.none)),
        )));
  }
  return ids;
}

Future<int> addDuaTrack(ContentDatabase db, String duaId, {String path = 'audio/a.mp3'}) =>
    db.into(db.tracks).insert(TracksCompanion.insert(
        ownerKind: TrackOwnerKind.dua, duaId: Value(duaId), relPath: path, label: 'test'));

Future<int> addGroupTrack(ContentDatabase db, String groupId, {String path = 'audio/g.mp3'}) =>
    db.into(db.tracks).insert(TracksCompanion.insert(
        ownerKind: TrackOwnerKind.group, groupId: Value(groupId), relPath: path, label: 'test'));

Future<int> addCue(ContentDatabase db, int trackId, int startMs, int? segmentId) =>
    db.into(db.cues).insert(CuesCompanion.insert(trackId: trackId, startMs: startMs, segmentId: Value(segmentId)));

Future<List<Cue>> cuesOf(ContentDatabase db, int trackId) =>
    (db.select(db.cues)..where((t) => t.trackId.equals(trackId))).get();
