import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:campus_app/pages/home/widgets/side_nav_bar_item.dart';

class SideNavBar extends StatefulWidget {
  /// Needs the currently active page in order to highlight it
  final PageItem currentPage;

  final List<PageItem> orderedPages;

  /// Calls this function when an item of the navigation bar is selected.
  final Function(PageItem) onSelectedPage;

  const SideNavBar({
    super.key,
    required this.currentPage,
    required this.orderedPages,
    required this.onSelectedPage,
  });

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.only(top: 40, bottom: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context, listen: false)
                    .currentTheme ==
                AppThemes.light
            ? const Color.fromRGBO(245, 246, 250, 1)
            : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
      ),
      child: Column(
        children: [
          for (final page in widget.orderedPages)
            SideNavBarItem(
              title: page.title,
              imagePathActive: page.activeIconPath,
              imagePathInactive: page.inactiveIconPath,
              onTap: () => widget.onSelectedPage(page),
              isActive: widget.currentPage == page,
            ),
        ],
      ),
    );
  }
}
