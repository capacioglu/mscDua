import 'dart:typed_data';

/// PCM16 örneklerini [buckets] kovaya böler; her kova için mutlak tepe / 32768.
Float32List peaksFromPcm16(Int16List samples, int buckets) {
  final out = Float32List(buckets);
  if (samples.isEmpty || buckets <= 0) return out;
  for (var b = 0; b < buckets; b++) {
    final start = samples.length * b ~/ buckets;
    final end = samples.length * (b + 1) ~/ buckets;
    var peak = 0;
    for (var i = start; i < end; i++) {
      final v = samples[i].abs();
      if (v > peak) peak = v;
    }
    out[b] = peak / 32768;
  }
  return out;
}
