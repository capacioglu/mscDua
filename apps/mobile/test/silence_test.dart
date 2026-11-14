import 'dart:io';

import 'package:dualarim_mobile/audio/silence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'verilen sürede geçerli sessiz WAV üretir ve önbellekten döner',
    () async {
      final dir = await Directory.systemTemp.createTemp('dualarim_sil');
      try {
        final f = await silenceWav(dir, 1500);
        final b = f.readAsBytesSync();
        expect(String.fromCharCodes(b.sublist(0, 4)), 'RIFF');
        expect(String.fromCharCodes(b.sublist(8, 12)), 'WAVE');
        expect(b.length, 44 + 1500 * 8000 ~/ 1000 * 2);
        expect(b.sublist(44).every((x) => x == 0), isTrue);
        final again = await silenceWav(dir, 1500);
        expect(again.path, f.path);
      } finally {
        await dir.delete(recursive: true);
      }
    },
  );
}
