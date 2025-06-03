import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

  ThemeProvider() {
    _loadTheme();
  }

  static final _lightTheme = ThemeData(
    primaryColor: const Color(0xFF2A6F5B),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2A6F5B),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF2A6F5B)),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.all(const Color(0xFF2A6F5B)),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2A6F5B),
      secondary: Color(0xFFB0F1D4),
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
    ),
  );

  static final _darkTheme = ThemeData(
    primaryColor: const Color(0xFF2A6F5B),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2A6F5B),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFB0F1D4)),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.all(const Color(0xFFB0F1D4)),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2A6F5B),
      secondary: Color(0xFFB0F1D4),
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
    ),
  );

  Future _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
