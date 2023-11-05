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

  /// Title of the page that this menu item refers to
  final String title;

  /// Callback that should be called whenever the button is tapped
  final VoidCallback onTap;

  /// Wether the refered page is the currently displayed one
  final bool isActive;

  const SideNavBarItem({
    Key? key,
    required this.imagePathActive,
    required this.imagePathInactive,
    required this.title,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  State<SideNavBarItem> createState() => _SideNavBarItemState();
}

class _SideNavBarItemState extends State<SideNavBarItem> {
  // Adjust this value in order to change the icon height of each navbar-element
  static const double iconHeight = 26;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child:
          // Icon-button
          CustomButton(
        tapHandler: () => widget.onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 5),
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
