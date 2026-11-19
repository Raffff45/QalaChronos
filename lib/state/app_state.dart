import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Язык, избранное, изученное и флаг пройденного онбординга.
class AppState extends ChangeNotifier {
  AppState(this._prefs) {
    lang = _prefs.getInt('lang') ?? 0;
    // containsKey: чтобы у тех, кто уже выбирал язык раньше, экран выбора не повторялся
  langChosen = _prefs.getBool('langChosen') ?? false;
    introDone = _prefs.getBool('intro') ?? false;
    _fav.addAll(_prefs.getStringList('fav') ?? const []);
    _seen.addAll(_prefs.getStringList('seen') ?? const []);
  }

  final SharedPreferences _prefs;
  final Set<String> _fav = {};
  final Set<String> _seen = {};

  /// 0 = русский, 1 = қазақша, 2 = English
  int lang = 0;
  bool langChosen = false;
  bool introDone = false;

  String t(String ru, String kk, String en) => [ru, kk, en][lang];

  bool isFav(String id) => _fav.contains(id);
  bool isSeen(String id) => _seen.contains(id);

  void setLang(int value) {
    lang = value;
    langChosen = true;
    _prefs.setInt('lang', value);
    _prefs.setBool('langChosen', true);
    notifyListeners();
  }

  void toggleFav(String id) {
    if (!_fav.remove(id)) _fav.add(id);
    _prefs.setStringList('fav', _fav.toList());
    notifyListeners();
  }

  void markSeen(String id) {
    _seen.add(id);
    _prefs.setStringList('seen', _seen.toList());
    notifyListeners();
  }

  void finishIntro() {
    introDone = true;
    _prefs.setBool('intro', true);
    notifyListeners();
  }
}