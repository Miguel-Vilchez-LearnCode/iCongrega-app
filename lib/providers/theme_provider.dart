import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  bool get isLightMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.light;
    }
    return _themeMode == ThemeMode.light;
  }

  bool get isSystemMode => _themeMode == ThemeMode.system;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 1;
      _themeMode = ThemeMode.values[themeIndex];
      notifyListeners();
    } catch (e) {
      // Si hay error, usar tema del sistema por defecto
      _themeMode = ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);
    } catch (e) {
      // Error guardando preferencias, pero el tema ya cambió
      debugPrint('Error guardando preferencia de tema: $e');
    }
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.system);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
}
