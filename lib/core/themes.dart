import 'package:flutter/material.dart';

enum AppThemes { light, dark }

class ThemesNotifier with ChangeNotifier {
  // List of themes
  static final List<ThemeData> themeData = [
    // Light
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.black,
      cardColor: Colors.white,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Colors.black,
        secondary: Color.fromRGBO(21, 0, 62, 1),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.black,
        background: Colors.white,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      fontFamily: 'SF-Pro',
      textTheme: const TextTheme(
        displayMedium: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          color: Color.fromARGB(255, 129, 129, 129),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        labelSmall: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        // Button
        labelMedium: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
        // Mensa Card
        labelLarge: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    // Dark
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      cardColor: const Color.fromRGBO(17, 25, 38, 1),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.white,
        secondary: Color.fromRGBO(49, 113, 236, 1),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.black,
        background: Color.fromRGBO(14, 20, 32, 1),
        onBackground: Colors.white,
        surface: Color.fromRGBO(17, 25, 38, 1),
        onSurface: Colors.white,
      ),
      fontFamily: 'SF-Pro',
      textTheme: const TextTheme(
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 1,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          color: Color.fromRGBO(184, 186, 191, 1),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        labelSmall: TextStyle(
          //color: Color.fromRGBO(184, 186, 191, 1),
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        // Button
        labelMedium: TextStyle(
          color: Color.fromRGBO(184, 186, 191, 1),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
        // Mensa Card
        labelLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    )
  ];

  AppThemes _currentTheme = AppThemes.light;
  ThemeData _currentThemeData = themeData[0];
  ThemeMode _currentThemeMode = ThemeMode.system;

  /// Switches the app-theme to the non-active
  void switchTheme() {
    if (currentTheme == AppThemes.light) {
      currentTheme = AppThemes.dark;
    } else {
      currentTheme = AppThemes.light;
    }
  }

  set currentTheme(AppThemes theme) {
    _currentTheme = theme;

    if (_currentTheme == AppThemes.light) {
      _currentThemeData = themeData[0];
      if (_currentThemeMode != ThemeMode.system) {
        _currentThemeMode = ThemeMode.light;
        debugPrint('ThemeMode Änderung zu: $_currentTheme');
      }
    } else {
      _currentThemeData = themeData[1];
      if (_currentThemeMode != ThemeMode.system) {
        _currentThemeMode = ThemeMode.dark;
        debugPrint('ThemeMode Änderung zu: $_currentTheme');
      }
    }

    /* mySystemTheme= SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.red);
      SystemChrome.setSystemUiOverlayStyle(mySystemTheme); */

    debugPrint('Theme Änderung zu: $theme');

    notifyListeners();
  }

  set currentThemeMode(ThemeMode mode) {
    _currentThemeMode = mode;

    if (mode == ThemeMode.system) {
      final Brightness deviceMode = WidgetsBinding.instance.window.platformBrightness;
      if (deviceMode == Brightness.light) {
        debugPrint('System-Theme ist: LightMode');
        if (currentTheme == AppThemes.dark) currentTheme = AppThemes.light;
      } else if (deviceMode == Brightness.dark) {
        debugPrint('System-Theme ist: DarkMode');
        if (currentTheme == AppThemes.light) currentTheme = AppThemes.dark;
      }
    } else if (mode == ThemeMode.light) {
      _currentTheme = AppThemes.light;
      _currentThemeData = themeData[0];
      notifyListeners();
    } else if (mode == ThemeMode.dark) {
      _currentTheme = AppThemes.dark;
      _currentThemeData = themeData[1];
      notifyListeners();
    }

    debugPrint('ThemeMode Änderung zu: $mode');
  }

  AppThemes get currentTheme => _currentTheme;
  ThemeData get currentThemeData => _currentThemeData;
  ThemeMode get currentThemeMode => _currentThemeMode;
  ThemeData get darkThemeData => themeData[1];
}
