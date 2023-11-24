import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

/// A widget that displays an item in the bottom navigation menu which allows the user
/// to switch between different pages. When active, the whole item is moved up and the title
/// text fades in while also moving up. The item also changes its icon-color when it's the
/// active navigation menu item.
class BottomNavBarItem extends StatefulWidget {
  /// Path to the image asset that should be shown when the menu item is active.
  ///
  /// ATTENTION: Only use .png-files
  final String imagePathActive;

  /// Path to the image asset that should be shown when the menu item is inactive.
  ///
  /// ATTENTION: Only use .png-files
  final String imagePathInactive;

  /// Icon height
  final double iconHeight;

  /// Padding above and below the icon
  final double iconVerticalPadding;

  /// Title of the page that this menu item refers to
  final String title;

  /// Callback that should be called whenever the button is tapped
  final VoidCallback onTap;

  /// Wether the refered page is the currently displayed one
  bool isActive;

  BottomNavBarItem({
    Key? key,
    required this.imagePathActive,
    required this.imagePathInactive,
    required this.title,
    this.iconHeight = 26,
    this.iconVerticalPadding = 10,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  State<BottomNavBarItem> createState() => _BottomNavBarItemState();
}

class _BottomNavBarItemState extends State<BottomNavBarItem> {
  // Adjust this value in order to change the icon height of each navbar-element
  static const double iconHeight = 26;
  // Adjust this value in order to change the animation curve that is used for the
  // vertical translation-animation
  static const Curve animationCurve = Curves.easeOutExpo;
  // Adjust this value in order to change the animation speed that is used for
  // all animations
  static const Duration animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: widget.isActive ? const EdgeInsets.only(top: 2) : const EdgeInsets.only(top: 11),
      duration: animationDuration,
      curve: animationCurve,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon-button
          CustomButton(
            tapHandler: () => widget.onTap(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: widget.iconVerticalPadding),
              child: Image.asset(
                widget.isActive ? widget.imagePathActive : widget.imagePathInactive,
                height: widget.iconHeight,
                color: widget.isActive
                    ? Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.secondary
                    : Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? Colors.black
                        : const Color.fromRGBO(184, 186, 191, 1),
                /* Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? widget.isActive
                        ? Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.secondary
                        : Colors.black
                    : widget.isActive
                        ? const Color.fromRGBO(255, 107, 1, 1)
                        : const Color.fromRGBO(184, 186, 191, 1), */
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          // Text
          AnimatedPadding(
            padding: widget.isActive ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
            duration: animationDuration,
            curve: animationCurve,
            child: AnimatedOpacity(
              opacity: widget.isActive ? 1 : 0,
              duration: animationDuration,
              child:
                  Text(widget.title, style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall),
            ),
          ),
        ],
      ),
    );
  }
}
