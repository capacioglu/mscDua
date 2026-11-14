import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'app/app_state.dart';
import 'screens/dua_edit_screen.dart';
import 'screens/dua_list_screen.dart';
import 'screens/group_screen.dart';
import 'services/settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const EditorApp());
}

class EditorApp extends StatefulWidget {
  const EditorApp({super.key});

  @override
  State<EditorApp> createState() => _EditorAppState();
}

class _EditorAppState extends State<EditorApp> {
  final _settings = Settings.load();
  final _nav = GlobalKey<NavigatorState>();
  AppState? _state;
  String? _error;

  @override
  void initState() {
    super.initState();
    final last = _settings.lastContentDir;
    if (last != null && Directory(last).existsSync()) _open(Directory(last));
  }

  Future<void> _open(Directory dir) async {
    try {
      final st = await AppState.open(dir, _settings);
      setState(() {
        _state = st;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = '$e');
    }
  }

  Future<void> _pickFolder() async {
    final dir = await FilePicker.getDirectoryPath(
      dialogTitle: 'İçerik klasörünü seç (content)',
    );
    if (dir != null) await _open(Directory(dir));
  }

  void _openDua(String id) => _nav.currentState!.push(
    MaterialPageRoute(
      builder: (_) =>
          DuaEditScreen(state: _state!, duaId: id, onOpenDua: _openDua),
    ),
  );

  void _openGroup(String id) => _nav.currentState!.push(
    MaterialPageRoute(
      builder: (_) =>
          GroupScreen(state: _state!, groupId: id, onOpenDua: _openDua),
    ),
  );

  Future<void> _settingsDialog() async {
    final ffCtl = TextEditingController(text: _settings.ffmpegPath ?? '');
    final pubCtl = TextEditingController(text: _settings.publishDir ?? '');
    final found = _state?.ffmpeg?.ffmpegPath;
    await showDialog(
      context: _nav.currentContext!,
      builder: (c) => AlertDialog(
        title: const Text('Ayarlar'),
        content: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('İçerik klasörü: ${_state?.contentDir.path ?? '-'}'),
              const SizedBox(height: 8),
              TextField(
                controller: ffCtl,
                decoration: const InputDecoration(
                  labelText: 'ffmpeg.exe yolu (boş = otomatik)',
                ),
              ),
              Text(
                found == null ? 'ffmpeg bulunamadı' : 'Kullanılan: $found',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: pubCtl,
                decoration: const InputDecoration(
                  labelText: 'Yayın klasörü (boş = apps/mobile/assets/content)',
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(c);
                  _pickFolder();
                },
                icon: const Icon(Icons.folder_open),
                label: const Text('Başka içerik klasörü aç'),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              _settings.ffmpegPath = ffCtl.text.trim().isEmpty
                  ? null
                  : ffCtl.text.trim();
              _settings.publishDir = pubCtl.text.trim().isEmpty
                  ? null
                  : pubCtl.text.trim();
              await _settings.save();
              if (c.mounted) Navigator.pop(c);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final st = _state;
    return MaterialApp(
      title: 'Dualarım Editörü',
      navigatorKey: _nav,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: st == null
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Dualarım içerik klasörünü seçin (ör. proje içindeki "content").',
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _pickFolder,
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Klasör seç'),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : DuaListScreen(
              state: st,
              onOpenDua: _openDua,
              onOpenGroup: _openGroup,
              onSettings: _settingsDialog,
            ),
    );
  }
}
