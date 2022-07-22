import 'package:flutter/material.dart';


// TODO: Each theme in seperate file
class AppTheme {
  // CAMPUS NOW Colors
  static const Color _campusNowScaffoldColor = Color(0xffe5efff);
  static const Color _campusNowPrimaryVariantColor = Color(0xff7bb0ff);
  static const Color _campusNowPrimaryColor = Color(0xff4c73ae);
  static const Color _campusNowSecondaryColor = Color(0xffff7425);
  static const Color _campusNowTertiaryColor = Color(0xffffef87);

  // different Colors to test ThemeProvider
  static const Color _testScaffoldColor = Color(0x00e5efff);
  static const Color _testPrimaryVariantColor = Color(0xea77b0ff);
  static const Color _testPrimaryColor = Color(0xfa4c77ae);
  static const Color _testSecondaryColor = Color(0xaa0f7425);
  static const Color _testTertiaryColor = Color(0xaaf0ef87);
  static const Color _testTextColorPrimary = Colors.white;

  static const Color _iconColor = Colors.white;

  static const TextStyle _lightHeadingText = TextStyle(
    color: _campusNowSecondaryColor,
    fontFamily: 'Rubik',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _lightBodyText = TextStyle(
    color: _campusNowSecondaryColor,
    fontFamily: 'Rubik',
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static final TextStyle _testThemeHeadingTextStyle =
      _lightHeadingText.copyWith(color: _testTextColorPrimary);

  static final TextStyle _testThemeBodyeTextStyle =
      _lightBodyText.copyWith(color: _testTextColorPrimary);

  static final TextTheme _testTextTheme = TextTheme(
    headline1: _testThemeHeadingTextStyle,
    bodyText1: _testThemeBodyeTextStyle,
  );

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: Colors.black45),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black45),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black87),
    ),
  );

  static final campusNowTheme = ThemeData(
    scaffoldBackgroundColor: _campusNowScaffoldColor,
    appBarTheme: const AppBarTheme(
      color: _campusNowSecondaryColor,
      iconTheme: IconThemeData(color: _iconColor),
    ),
    bottomAppBarColor: _campusNowSecondaryColor,
    colorScheme: const ColorScheme.light(
      primary: _campusNowPrimaryColor,
      primaryContainer: _campusNowPrimaryVariantColor,
      secondary: _campusNowTertiaryColor,
    ),
    inputDecorationTheme: _inputDecorationTheme,
  );

  static final testTheme = ThemeData(
    scaffoldBackgroundColor: _testScaffoldColor,
    appBarTheme: const AppBarTheme(
      color: _testSecondaryColor,
      iconTheme: IconThemeData(color: _iconColor),
    ),
    bottomAppBarColor: _testSecondaryColor,
    colorScheme: const ColorScheme.light(
      primary: _testPrimaryColor,
      primaryContainer: _testPrimaryVariantColor,
      secondary: _testTertiaryColor,
    ),
    textTheme: _testTextTheme,
    inputDecorationTheme: _inputDecorationTheme,
  );

  AppTheme._();
}
