import 'package:dua_core/dua_core.dart';
import 'package:flutter/material.dart';

import 'audio/player_service.dart';

/// Uygulama genelindeki servisler ve kalıcı tercihler.
class AppServices extends ChangeNotifier {
  AppServices._(
    this.queries,
    this.user,
    this.player,
    this._prefs,
    this._fontScale,
    this._gapMs,
    this._themeMode,
    this._meaningPerLine,
    this._listenLanguage,
  ) {
    player.listenLanguage = _listenLanguage;
  }

  static Future<AppServices> create({
    required ContentQueries queries,
    required UserDatabase user,
    required PlayerService player,
  }) async => AppServices._(
    queries,
    user,
    player,
    await user.readingPrefs(),
    await user.fontScale(),
    await user.gapMs(),
    _parseTheme(await user.themeMode()),
    await user.meaningPerLine(),
    await user.listenLanguage(),
  );

  static ThemeMode _parseTheme(String s) => ThemeMode.values.firstWhere(
    (m) => m.name == s,
    orElse: () => ThemeMode.system,
  );

  final ContentQueries queries;
  final UserDatabase user;
  final PlayerService player;

  ReadingPrefs _prefs;
  double _fontScale;
  int _gapMs;
  ThemeMode _themeMode;
  bool _meaningPerLine;
  String _listenLanguage;

  /// Dinleme dili: 'ar' | 'tr' | 'en'. O dilde kaydı olmayan dua Arapça kaydıyla çalar.
  String get listenLanguage => _listenLanguage;

  Future<void> setListenLanguage(String lang) async {
    _listenLanguage = lang;
    player.listenLanguage = lang;
    notifyListeners();
    await user.setListenLanguage(lang);
  }

  ThemeMode get themeMode => _themeMode;

  /// Anlam her Arapça satırın altında (true) ya da duanın sonunda (false).
  bool get meaningPerLine => _meaningPerLine;

  Future<void> setThemeMode(ThemeMode m) async {
    _themeMode = m;
    notifyListeners();
    await user.setThemeMode(m.name);
  }

  Future<void> setMeaningPerLine(bool v) async {
    _meaningPerLine = v;
    notifyListeners();
    await user.setMeaningPerLine(v);
  }

  ReadingPrefs get prefs => _prefs;
  double get fontScale => _fontScale;
  int get gapMs => _gapMs;

  Future<void> toggle(ReadingOption o) async {
    _prefs = _prefs.toggle(o);
    notifyListeners();
    await user.saveReadingPrefs(_prefs);
  }

  Future<void> setFontScale(double v) async {
    _fontScale = v;
    notifyListeners();
    await user.setFontScale(v);
  }

  Future<void> setGapMs(int ms) async {
    _gapMs = ms;
    notifyListeners();
    await user.setGapMs(ms);
  }
}

/// Servisleri ağaca taşır; tercih değişince dinleyenleri yeniden çizer.
class AppScope extends InheritedNotifier<AppServices> {
  const AppScope({
    super.key,
    required AppServices services,
    required super.child,
  }) : super(notifier: services);

  static AppServices of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
