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

  /// Padding above and below the icon
  final double iconVerticalPadding;
  final double iconPaddingLeft;
  final double iconPaddingRight;

  /// Title of the page that this menu item refers to
  final String title;

  /// Callback that should be called whenever the button is tapped
  final VoidCallback onTap;

  /// Whether the referred page is the currently displayed one
  final bool isActive;

  const BottomNavBarItem({
    super.key,
    required this.imagePathActive,
    required this.imagePathInactive,
    required this.title,
    this.iconVerticalPadding = 8,
    this.iconPaddingLeft = 0,
    this.iconPaddingRight = 0,
    required this.onTap,
    this.isActive = false,
  });

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
    return Padding(
      padding: EdgeInsets.only(left: widget.iconPaddingLeft, right: widget.iconPaddingRight),
      child: AnimatedPadding(
        padding: widget.isActive ? const EdgeInsets.only(top: 2) : const EdgeInsets.only(top: 6),
        duration: animationDuration,
        curve: animationCurve,
        child: Column(
          children: [
            // Icon-button wrapped so it can flex if parent is constrained
            Flexible(
              child: CustomButton(
                tapHandler: () => widget.onTap(),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: widget.iconVerticalPadding,
                    bottom: widget.iconVerticalPadding,
                  ),
                  child: Image.asset(
                    widget.isActive ? widget.imagePathActive : widget.imagePathInactive,
                    height: iconHeight,
                    color: widget.isActive
                        ? Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.secondary
                        : Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                            ? Colors.black
                            : const Color.fromRGBO(184, 186, 191, 1),
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),

            // Text: keep single line and avoid reserving vertical space when
            // inactive. Use maxLines:1 to guarantee no wrapping.
            AnimatedSwitcher(
              duration: animationDuration,
              switchInCurve: animationCurve,
              switchOutCurve: animationCurve,
              child: widget.isActive
                  ? Text(
                      widget.title,
                      key: ValueKey('title-${widget.title}'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                    )
                  : const SizedBox.shrink(key: ValueKey('title-empty')),
            ),
          ],
        ),
      ),
    );
  }
}
