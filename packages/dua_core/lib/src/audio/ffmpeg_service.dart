import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

/// ffmpeg komut satırı aracı üzerinden ses işlemleri (yalnızca editör/masaüstü).
class FfmpegService {
  FfmpegService(this.ffmpegPath);
  final String ffmpegPath;

  /// ffmpeg'i önce [preferred], sonra PATH, sonra WinGet paket klasöründe arar.
  static FfmpegService? locate({String? preferred}) {
    if (preferred != null && preferred.isNotEmpty && File(preferred).existsSync()) return FfmpegService(preferred);
    final exe = Platform.isWindows ? 'ffmpeg.exe' : 'ffmpeg';
    final sep = Platform.isWindows ? ';' : ':';
    for (final dir in (Platform.environment['PATH'] ?? '').split(sep)) {
      final f = File(p.join(dir, exe));
      if (dir.isNotEmpty && f.existsSync()) return FfmpegService(f.path);
    }
    final local = Platform.environment['LOCALAPPDATA'];
    if (local != null) {
      final pkgs = Directory(p.join(local, 'Microsoft', 'WinGet', 'Packages'));
      if (pkgs.existsSync()) {
        for (final pkg in pkgs.listSync().whereType<Directory>()) {
          if (!p.basename(pkg.path).toLowerCase().contains('ffmpeg')) continue;
          for (final e in pkg.listSync(recursive: true).whereType<File>()) {
            if (p.basename(e.path).toLowerCase() == exe) return FfmpegService(e.path);
          }
        }
      }
    }
    return null;
  }

  Future<bool> isAvailable() async {
    try {
      return (await Process.run(ffmpegPath, ['-version'])).exitCode == 0;
    } on ProcessException {
      return false;
    }
  }

  /// Video (veya herhangi bir medya) dosyasının sesini AAC/m4a olarak çıkarır.
  Future<File> extractAudio(File input, File outM4a) async {
    final r = await Process.run(
        ffmpegPath, ['-y', '-i', input.path, '-vn', '-c:a', 'aac', '-b:a', '128k', outM4a.path]);
    if (r.exitCode != 0) throw ProcessException(ffmpegPath, const [], 'Ses çıkarılamadı: ${r.stderr}', r.exitCode);
    return outM4a;
  }

  /// Konuşma sesini mono [kbps] (varsayılan 64) olarak yeniden kodlar.
  /// mp3 → mp3 (LAME), m4a/aac → AAC; uzantı korunur.
  Future<File> transcodeSpeech(File input, File out, {int kbps = 64}) async {
    final ext = p.extension(input.path).toLowerCase();
    final codec = ext == '.m4a' || ext == '.aac' ? 'aac' : 'libmp3lame';
    final format = ext == '.m4a' ? 'ipod' : (ext == '.aac' ? 'adts' : 'mp3');
    final r = await Process.run(ffmpegPath, [
      '-y', '-v', 'error', '-i', input.path, '-vn', '-ac', '1',
      '-c:a', codec, '-b:a', '${kbps}k', '-f', format, out.path,
    ]);
    if (r.exitCode != 0) throw ProcessException(ffmpegPath, const [], 'Dönüştürülemedi: ${r.stderr}', r.exitCode);
    return out;
  }

  /// Sesi mono 16-bit PCM olarak çözer (dalga formu için).
  Future<Int16List> decodePcm(File audio, {int sampleRate = 8000}) async {
    final proc = await Process.start(
        ffmpegPath, ['-v', 'error', '-i', audio.path, '-f', 's16le', '-ac', '1', '-ar', '$sampleRate', 'pipe:1']);
    final bytes = BytesBuilder(copy: false);
    final err = StringBuffer();
    proc.stderr.listen((d) => err.write(String.fromCharCodes(d)));
    await for (final chunk in proc.stdout) {
      bytes.add(chunk);
    }
    final code = await proc.exitCode;
    if (code != 0) throw ProcessException(ffmpegPath, const [], 'Ses çözülemedi: $err', code);
    final data = bytes.takeBytes();
    return data.buffer.asInt16List(data.offsetInBytes, data.lengthInBytes ~/ 2);
  }

  /// Süreyi ffmpeg çıktısındaki "Duration: hh:mm:ss.cc" satırından okur.
  Future<int> durationMs(File audio) async {
    final r = await Process.run(ffmpegPath, ['-hide_banner', '-i', audio.path]);
    final m = RegExp(r'Duration: (\d+):(\d+):(\d+)\.(\d+)').firstMatch(r.stderr.toString());
    if (m == null) throw ProcessException(ffmpegPath, const [], 'Süre okunamadı', r.exitCode);
    final frac = m.group(4)!;
    return (int.parse(m.group(1)!) * 3600 + int.parse(m.group(2)!) * 60 + int.parse(m.group(3)!)) * 1000 +
        (int.parse(frac) * 1000 ~/ _pow10(frac.length));
  }

  /// MP3 dosyalarını sırayla birleştirir (yeniden kodlamadan).
  Future<File> concat(List<File> inputs, File out) async {
    final list = File('${out.path}.list.txt');
    String quote(File f) => f.absolute.path.replaceAll(r'\', '/').replaceAll("'", r"'\''");
    await list.writeAsString(inputs.map((f) => "file '${quote(f)}'").join('\n'));
    try {
      final r = await Process.run(ffmpegPath, ['-y', '-f', 'concat', '-safe', '0', '-i', list.path, '-c', 'copy', out.path]);
      if (r.exitCode != 0) throw ProcessException(ffmpegPath, const [], 'Birleştirilemedi: ${r.stderr}', r.exitCode);
      return out;
    } finally {
      if (list.existsSync()) await list.delete();
    }
  }

  static int _pow10(int n) => n <= 0 ? 1 : 10 * _pow10(n - 1);
}
