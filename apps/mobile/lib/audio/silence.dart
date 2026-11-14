import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

/// [ms] süreli sessiz WAV (8 kHz, mono, 16 bit). Her platformda çalınır;
/// dualar arası boşluk ve sesi olmayan dua için kullanılır. Aynı süre önbellekten döner.
Future<File> silenceWav(Directory dir, int ms) async {
  final f = File(p.join(dir.path, 'silence_$ms.wav'));
  if (f.existsSync()) return f;
  const rate = 8000;
  final dataLen = ms * rate ~/ 1000 * 2;
  final b = ByteData(44 + dataLen);
  void str(int o, String s) {
    for (var i = 0; i < s.length; i++) {
      b.setUint8(o + i, s.codeUnitAt(i));
    }
  }

  str(0, 'RIFF');
  b.setUint32(4, 36 + dataLen, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  b.setUint32(16, 16, Endian.little);
  b.setUint16(20, 1, Endian.little); // PCM
  b.setUint16(22, 1, Endian.little); // mono
  b.setUint32(24, rate, Endian.little);
  b.setUint32(28, rate * 2, Endian.little);
  b.setUint16(32, 2, Endian.little);
  b.setUint16(34, 16, Endian.little);
  str(36, 'data');
  b.setUint32(40, dataLen, Endian.little);
  await dir.create(recursive: true);
  await f.writeAsBytes(b.buffer.asUint8List(), flush: true);
  return f;
}
