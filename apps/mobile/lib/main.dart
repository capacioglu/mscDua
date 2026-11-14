import 'dart:io';

import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_scope.dart';
import 'audio/player_service.dart';
import 'data/content_installer.dart';
import 'screens/home_screen.dart';

bool get _isMobile => Platform.isAndroid || Platform.isIOS;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (_isMobile) {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.dualarim.app.audio',
      androidNotificationChannelName: 'Dua çalma',
      androidNotificationOngoing: true,
    );
  }
  if (Platform.isWindows) {
    JustAudioMediaKit.ensureInitialized(windows: true);
  }
  final support = await getApplicationSupportDirectory();
  final installer = ContentInstaller(
    supportDir: support,
    loadAsset: rootBundle.load,
    listAssets: () async =>
        (await AssetManifest.loadFromAssetBundle(rootBundle)).listAssets(),
  );
  final contentDb = ContentDatabase.open(await installer.ensureInstalled());
  final queries = ContentQueries(contentDb);
  final user = UserDatabase.open(File(p.join(support.path, 'user.db')));
  final services = await AppServices.create(
    queries: queries,
    user: user,
    player: PlayerService(
      JustAudioBackend(
        background: _isMobile,
        cacheDir: Directory(p.join(support.path, 'silence')),
      ),
      queries,
      fileOf: (t) =>
          File(p.joinAll([installer.contentDir.path, ...t.relPath.split('/')])),
      store: SessionStore(load: user.lastSession, save: user.saveLastSession),
    ),
  );
  await services.player.loadSession();
  runApp(DualarimApp(services: services));
}

class DualarimApp extends StatelessWidget {
  const DualarimApp({super.key, required this.services});
  final AppServices services;

  @override
  Widget build(BuildContext context) => AppScope(
    services: services,
    child: ListenableBuilder(
      listenable: services,
      builder: (context, _) => MaterialApp(
        themeMode: services.themeMode,
        title: 'Dualarım',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF0C4250),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: const Color(0xFF0C4250),
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    ),
  );
}
