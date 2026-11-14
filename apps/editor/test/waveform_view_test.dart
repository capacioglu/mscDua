import 'dart:typed_data';

import 'package:dua_core/dua_core.dart';
import 'package:dualarim_editor/widgets/waveform_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ortaya tıklama sürenin yarısına atlar', (tester) async {
    int? seeked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            height: 120,
            child: WaveformView(
              peaks: Float32List.fromList(
                List.generate(200, (i) => (i % 10) / 10),
              ),
              durationMs: 10000,
              positionMs: 0,
              cues: [
                CueEntry(startMs: 2000, segmentId: 1),
                CueEntry(startMs: 6000),
              ],
              cueLabel: (c) => c.segmentId == null ? '…' : '1',
              onSeek: (ms) => seeked = ms,
            ),
          ),
        ),
      ),
    );
    await tester.tapAt(tester.getCenter(find.byType(WaveformView)));
    expect(seeked, inInclusiveRange(4950, 5050));
  });
}
