import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final double opacity;
  final Widget? bottom;
  final VoidCallback? onProfileTap;

  const AppHeader({
    super.key,
    required this.title,
    this.opacity = 1,
    this.bottom,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;

    return Container(
      padding: EdgeInsets.only(
        // Adds extra top padding on Android to avoid overlapping the status bar.
        top: Platform.isAndroid ? 10 : 0,
        bottom: 20,
      ),

      // Makes the header background transparent when the page scrolls down.
      color: opacity == 1 ? theme.colorScheme.surface : Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main header row with centered title and profile icon on the right.
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 20,
            ),
            child: SizedBox(
              width: double.infinity,

              // Keeps the title centered while placing the profile button on the right.
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.displayMedium,
                  ),

                  // Profile button on the right side of the header.
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.person_outline,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: onProfileTap,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Optional page-specific content below the title.
          // For example: search bar, filter buttons, or segmented controls.
          if (bottom != null)
            AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: bottom,
            ),
        ],
      ),
    );
  }
}