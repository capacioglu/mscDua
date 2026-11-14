import 'dart:io';

import 'package:media_kit/media_kit.dart';

/// Oynatıcı soyutlaması (testte sahte oynatıcı kullanılır).
abstract class PlaybackController {
  Stream<Duration> get positionStream;
  Duration get position;
  Duration get duration;
  bool get playing;
  Future<void> open(File file);
  Future<void> playOrPause();
  Future<void> pause();
  Future<void> seek(Duration d);

  /// Çalma hızı; perde korunur (mpv audio-pitch-correction).
  Future<void> setRate(double rate);
  Future<void> dispose();
}

class MediaKitPlayback implements PlaybackController {
  final Player _p = Player();

  @override
  Stream<Duration> get positionStream => _p.stream.position;
  @override
  Duration get position => _p.state.position;
  @override
  Duration get duration => _p.state.duration;
  @override
  bool get playing => _p.state.playing;
  @override
  Future<void> open(File file) => _p.open(Media(file.path), play: false);
  @override
  Future<void> playOrPause() => _p.playOrPause();
  @override
  Future<void> pause() => _p.pause();
  @override
  Future<void> seek(Duration d) => _p.seek(d);
  @override
  Future<void> setRate(double rate) => _p.setRate(rate);
  @override
  Future<void> dispose() => _p.dispose();
}
