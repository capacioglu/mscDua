import 'package:dua_core/dua_core.dart';
import 'package:flutter/widgets.dart';

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
  );

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
  );

  final ContentQueries queries;
  final UserDatabase user;
  final PlayerService player;

  ReadingPrefs _prefs;
  double _fontScale;
  int _gapMs;

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
