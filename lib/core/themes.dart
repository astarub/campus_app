import 'package:flutter/material.dart';

enum AppThemes { light, dark }

class ThemesNotifier with ChangeNotifier {
  // List of themes
  static final List<ThemeData> themeData = [
    // Light
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      primaryColor: Colors.black,
      fontFamily: 'SF-Pro',
      textTheme: const TextTheme(
        displayMedium: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.w600,
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
      ),
    ),
    // Dark
    ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      backgroundColor: Colors.white,
      primaryColor: Colors.black,
      textTheme: TextTheme(),
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
    if (theme != null) {
      _currentTheme = theme;

      if (_currentTheme == AppThemes.light) {
        _currentThemeData = themeData[0];
        if (_currentThemeMode != ThemeMode.system) {
          _currentThemeMode = ThemeMode.light;
          debugPrint('ThemeMode Änderung zu: ' + _currentTheme.toString());
        }
      } else {
        _currentThemeData = themeData[1];
        if (_currentThemeMode != ThemeMode.system) {
          _currentThemeMode = ThemeMode.dark;
          debugPrint('ThemeMode Änderung zu: ' + _currentTheme.toString());
        }
      }

      /* mySystemTheme= SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.red);
      SystemChrome.setSystemUiOverlayStyle(mySystemTheme); */

      debugPrint('Theme Änderung zu: ' + theme.toString());

      notifyListeners();
    }
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

    debugPrint('ThemeMode Änderung zu: ' + mode.toString());
  }

  AppThemes get currentTheme => _currentTheme;
  ThemeData get currentThemeData => _currentThemeData;
  ThemeMode get currentThemeMode => _currentThemeMode;
  ThemeData get darkThemeData => themeData[1];
}
