import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

class SideNavBarItem extends StatefulWidget {
  /// Path to the image asset that should be shown when the menu item is active.
  ///
  /// ATTENTION: Only use .png-files
  final String imagePathActive;

  /// Path to the image asset that should be shown when the menu item is inactive.
  ///
  /// ATTENTION: Only use .png-files
  final String imagePathInactive;

  /// Set the icon height
  final double iconHeight;

  // Set the padding below the icon
  final double bottomIconPadding;

  // Set the padding at the top and bottom of the whole item
  final double verticalPadding;

  /// Title of the page that this menu item refers to
  final String title;

  /// Callback that should be called whenever the button is tapped
  final VoidCallback onTap;

  /// Wether the refered page is the currently displayed one
  final bool isActive;

  const SideNavBarItem({
    super.key,
    required this.imagePathActive,
    required this.imagePathInactive,
    this.iconHeight = 26,
    this.bottomIconPadding = 5,
    this.verticalPadding = 10,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<SideNavBarItem> createState() => _SideNavBarItemState();
}

class _SideNavBarItemState extends State<SideNavBarItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child:
          // Icon-button
          CustomButton(
        tapHandler: () => widget.onTap(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 14, right: 14, bottom: widget.bottomIconPadding),
                child: Image.asset(
                  widget.isActive ? widget.imagePathActive : widget.imagePathInactive,
                  height: widget.iconHeight,
                  color: widget.isActive
                      ? Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.secondary
                      : Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? Colors.black
                          : const Color.fromRGBO(184, 186, 191, 1),
                  filterQuality: FilterQuality.high,
                ),
              ),
              // Text
              Text(
                widget.title,
                style: widget.isActive
                    ? Provider.of<ThemesNotifier>(context)
                        .currentThemeData
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontWeight: FontWeight.w700)
                    : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
