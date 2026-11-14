/// Bir satırın çeviri/onay durumu.
enum ReviewStatus { none, review, approved }

/// Bir çeviri alanının nereden geldiği.
enum FieldSource { imported, claude, user }

/// Ses kaydının sahibi: tek bir dua mı, bir grup mu.
enum TrackOwnerKind { dua, group }

/// Satırların çeviri alanları.
enum SegmentField { pronunciationTr, pronunciationEn, meaningTr, meaningEn }
