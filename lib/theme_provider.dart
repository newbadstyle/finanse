import 'package:flutter/material.dart';

class ThemeProvider {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;

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
    ),
  );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
  }

  static of(BuildContext context) {}
}
