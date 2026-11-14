/// Editördeki bir zamanlama işareti (DB'ye yazılmadan önce/sonra).
class CueEntry {
  CueEntry({this.id, required this.startMs, this.segmentId});
  int? id;
  int startMs;

  /// null = metinsiz bölüm.
  int? segmentId;
}

/// Bir ses kaydının zamanlama mantığı (saf; DB'siz). Grup kaydında
/// [segmentOrder] gruptaki duaların satırlarının art arda sırasıdır.
class CueTimeline {
  CueTimeline(this.segmentOrder, List<CueEntry> cues) : _cues = [...cues] {
    _sort();
    final lastTimed = _cues.lastWhere((c) => c.segmentId != null, orElse: () => CueEntry(startMs: -1));
    _cursor = lastTimed.segmentId == null ? 0 : segmentOrder.indexOf(lastTimed.segmentId!) + 1;
  }

  final List<int> segmentOrder;
  final List<CueEntry> _cues;
  int _cursor = 0;

  void _sort() => _cues.sort((a, b) => a.startMs.compareTo(b.startMs));

  List<CueEntry> get sorted => List.unmodifiable(_cues);

  /// Bir sonraki Enter'da işaretlenecek satır; tüm satırlar geçildiyse null.
  int? get nextSegmentId => _cursor < segmentOrder.length ? segmentOrder[_cursor] : null;

  void selectNext(int segmentId) {
    final i = segmentOrder.indexOf(segmentId);
    if (i < 0) throw ArgumentError('Satır bu kayda ait değil: $segmentId');
    _cursor = i;
  }

  /// Aynı ms'de başka işaret varsa bir sonraki boş ms (sıralama kararlı kalsın).
  int _free(int ms) {
    final used = _cues.map((c) => c.startMs).toSet();
    var m = ms < 0 ? 0 : ms;
    while (used.contains(m)) {
      m++;
    }
    return m;
  }

  CueEntry markNext(int atMs) {
    final seg = nextSegmentId;
    if (seg == null) throw StateError('İşaretlenecek satır kalmadı');
    final c = CueEntry(startMs: _free(atMs), segmentId: seg);
    _cues.add(c);
    _sort();
    _cursor++;
    return c;
  }

  CueEntry markGap(int atMs) {
    final c = CueEntry(startMs: _free(atMs));
    _cues.add(c);
    _sort();
    return c;
  }

  /// [c]'yi komşu cue'ların arasına sıkıştırarak taşır (en az 1 ms ara, en az 0).
  void move(CueEntry c, int toMs) {
    final i = _cues.indexOf(c);
    final lo = i > 0 ? _cues[i - 1].startMs + 1 : 0;
    final hi = i < _cues.length - 1 ? _cues[i + 1].startMs - 1 : 1 << 31;
    c.startMs = lo > hi ? c.startMs : toMs.clamp(lo, hi);
  }

  void nudge(CueEntry c, int deltaMs) => move(c, c.startMs + deltaMs);

  void remove(CueEntry c) => _cues.remove(c);

  /// [ms] anında geçerli olan cue (startMs ≤ ms olan son cue).
  CueEntry? activeAt(int ms) {
    CueEntry? found;
    for (final c in _cues) {
      if (c.startMs > ms) break;
      found = c;
    }
    return found;
  }

  Set<int> get untimedSegments =>
      segmentOrder.toSet().difference(_cues.map((c) => c.segmentId).whereType<int>().toSet());
}
