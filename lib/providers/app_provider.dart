import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Original
// class AppProvider extends ChangeNotifier {
//   final SharedPreferences _prefs;
//   ThemeMode _themeMode;
//   Locale _locale = const Locale('en');

//   AppProvider(this._prefs)
//       : _themeMode = _prefs.getBool('isDark') == true
//             ? ThemeMode.dark
//             : ThemeMode.light;

//   ThemeMode get themeMode => _themeMode;
//   Locale get locale => _locale;

//   void toggleTheme(bool isDark) {
//     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
//     _prefs.setBool('isDark', isDark);
//     notifyListeners();
//   }

//   void setLocale(Locale locale) {
//     _locale = locale;
//     notifyListeners();
//   }
// }

// Modified

class AppProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  static const _themeKey = 'themeMode';

  ThemeMode _themeMode;
  Locale _locale = const Locale('en');

  AppProvider(this._prefs)
      : _themeMode = _loadThemeMode(_prefs);

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  // --- Theme handling ---

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final value = prefs.getString(_themeKey);

    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
      default:
        return ThemeMode.system; // 👈 default + fallback
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs.setString(_themeKey, mode.name);
    notifyListeners();
  }

  // Optional: backward compatibility with old isDark
  void migrateFromBoolIfNeeded() {
    if (_prefs.containsKey('isDark')) {
      final isDark = _prefs.getBool('isDark') ?? false;
      setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
      _prefs.remove('isDark');
    }
  }
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _prefs.setBool('isDark', isDark);
    notifyListeners();
  }


  // --- Locale handling ---

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

