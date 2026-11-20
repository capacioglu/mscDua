import 'package:drift/drift.dart';

import '../db/database.dart';

/// Kaydı, aynı dua (veya grup) ve dildeki kayıtlar arasında telefonda çalacak
/// birincil kayıt yapar; diğerlerinin birincilliği düşer.
Future<void> setPrimaryTrack(ContentDatabase db, int trackId) => db.transaction(() async {
      final t = await (db.select(db.tracks)..where((x) => x.id.equals(trackId))).getSingle();
      final same = db.update(db.tracks)
        ..where((x) =>
            x.language.equals(t.language) &
            (t.duaId != null ? x.duaId.equals(t.duaId!) : x.groupId.equalsNullable(t.groupId)));
      await same.write(const TracksCompanion(isPrimary: Value(false)));
      await (db.update(db.tracks)..where((x) => x.id.equals(trackId)))
          .write(const TracksCompanion(isPrimary: Value(true)));
    });
