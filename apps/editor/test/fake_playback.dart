import 'dart:async';
import 'dart:io';

import 'package:dualarim_editor/services/playback.dart';

/// Testte kullanılan sahte oynatıcı: konum elle ayarlanır.
class FakePlayback implements PlaybackController {
  final _pos = StreamController<Duration>.broadcast();
  @override
  Duration position = Duration.zero;
  @override
  Duration duration = const Duration(seconds: 10);
  @override
  bool playing = false;
  double rate = 1;
  File? opened;

  void setPosition(int ms) {
    position = Duration(milliseconds: ms);
    _pos.add(position);
  }

  @override
  Stream<Duration> get positionStream => _pos.stream;
  @override
  Future<void> open(File file) async => opened = file;
  @override
  Future<void> playOrPause() async => playing = !playing;
  @override
  Future<void> pause() async => playing = false;
  @override
  Future<void> seek(Duration d) async => setPosition(d.inMilliseconds);
  @override
  Future<void> setRate(double r) async => rate = r;
  @override
  Future<void> dispose() async => _pos.close();
}
