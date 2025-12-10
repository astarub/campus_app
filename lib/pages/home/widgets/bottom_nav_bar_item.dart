import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

class BottomNavBarItem extends StatefulWidget {
  final String imagePathActive;
  final String imagePathInactive;

  final String title;

  final double iconPaddingLeft;
  final double iconPaddingRight;

  final VoidCallback onTap;
  final bool isActive;

  const BottomNavBarItem({
    super.key,
    required this.imagePathActive,
    required this.imagePathInactive,
    required this.title,
    required this.onTap,
    this.isActive = false,
    this.iconPaddingLeft = 12,
    this.iconPaddingRight = 12,
  });

  @override
  State<BottomNavBarItem> createState() => _BottomNavBarItemState();
}

class _BottomNavBarItemState extends State<BottomNavBarItem> {
  // FINAL ICON SIZE FOR PERFECT LOOK
  static const double iconSize = 30;

  static const Curve animationCurve = Curves.easeOutExpo;
  static const Duration animationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemesNotifier>(context);

    return Padding(
      padding: EdgeInsets.only(
        left: widget.iconPaddingLeft,
        right: widget.iconPaddingRight,
      ),
      child: AnimatedPadding(
        duration: animationDuration,
        curve: animationCurve,
        padding: widget.isActive
            ? const EdgeInsets.only(top: 0)
            : const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              tapHandler: widget.onTap,
              child: Image.asset(
                widget.isActive
                    ? widget.imagePathActive
                    : widget.imagePathInactive,

                /// ⭐ FIX & FINAL SIZE ⭐
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,

                color: widget.isActive
                    ? theme.currentThemeData.colorScheme.secondary
                    : theme.currentTheme == AppThemes.light
                        ? Colors.black
                        : const Color.fromRGBO(184, 186, 191, 1),
                filterQuality: FilterQuality.high,
              ),
            ),

            AnimatedPadding(
              duration: animationDuration,
              curve: animationCurve,
              padding: widget.isActive
                  ? const EdgeInsets.only(top: 4)
                  : const EdgeInsets.only(top: 12),
              child: AnimatedOpacity(
                duration: animationDuration,
                opacity: widget.isActive ? 1 : 0,
                child: Text(
                  widget.title,
                  style: theme.currentThemeData.textTheme.labelSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
