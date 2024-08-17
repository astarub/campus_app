import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

/// This widget displays an animated illustration for
/// making the theme selection visually more appealing.
class ThemeSelection extends StatefulWidget {
  const ThemeSelection({super.key});

  @override
  State<ThemeSelection> createState() => ThemeSelectionState();
}

class ThemeSelectionState extends State<ThemeSelection> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  void changeTheme(int selectedThemeMode) {
    // Control animation
    final Brightness currentBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (selectedThemeMode == 0 &&
        Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.dark &&
        currentBrightness == Brightness.light) {
      _animationController.reverse(from: 1);
    } else if (selectedThemeMode == 0 &&
        Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light &&
        currentBrightness == Brightness.dark) {
      _animationController.forward(from: 0);
    } else if (selectedThemeMode == 1 &&
        Provider.of<ThemesNotifier>(context, listen: false).currentTheme != AppThemes.light) {
      _animationController.reverse(from: 1);
    } else if (selectedThemeMode == 2 &&
        Provider.of<ThemesNotifier>(context, listen: false).currentTheme != AppThemes.dark) {
      _animationController.forward(from: 0);
    }

    // Switch theme
    switch (selectedThemeMode) {
      case 0:
        Provider.of<ThemesNotifier>(context, listen: false).currentThemeMode = ThemeMode.system;
        break;
      case 1:
        Provider.of<ThemesNotifier>(context, listen: false).currentTheme = AppThemes.light;
        break;
      case 2:
        Provider.of<ThemesNotifier>(context, listen: false).currentTheme = AppThemes.dark;
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? [const Color(0xDDFF0080), const Color(0xDDFF8C00)]
                    : [const Color(0xFF8983F7), const Color(0xFFA3DAFB)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(40, 0),
            child: ScaleTransition(
              scale: _animationController.drive(
                Tween<double>(begin: 0, end: 1).chain(
                  CurveTween(curve: Curves.decelerate),
                ),
              ),
              alignment: Alignment.topRight,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
