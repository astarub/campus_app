import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:campus_app/pages/home/widgets/bottom_nav_bar_item.dart';
import 'package:campus_app/pages/home/widgets/side_nav_bar_item.dart';

class SideNavBar extends StatefulWidget {
  /// Needs the currently active page in order to highlight it
  PageItem currentPage;

  /// Calls this function when an item of the navigation bar is selected.
  final Function onSelectedPage;

  SideNavBar({
    required this.currentPage,
    required this.onSelectedPage,
  });

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  // Adjust this value in order to change the icon height of each navbar-element
  static const double iconHeight = 26;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.only(top: 40, bottom: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
            ? const Color.fromRGBO(245, 246, 250, 1)
            : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
      ),
      child: Column(
        children: [
          // News Feed
          SideNavBarItem(
            title: 'Feed',
            imagePathActive: 'assets/img/icons/home-filled.png',
            imagePathInactive: 'assets/img/icons/home-outlined.png',
            onTap: () => widget.onSelectedPage(PageItem.feed),
            isActive: widget.currentPage == PageItem.feed,
          ),
          // Calendar
          SideNavBarItem(
            title: 'Events',
            imagePathActive: 'assets/img/icons/calendar-filled.png',
            imagePathInactive: 'assets/img/icons/calendar-outlined.png',
            onTap: () => widget.onSelectedPage(PageItem.events),
            isActive: widget.currentPage == PageItem.events,
          ),
          // Mensa
          SideNavBarItem(
            title: 'Mensa',
            imagePathActive: 'assets/img/icons/mensa-filled.png',
            imagePathInactive: 'assets/img/icons/mensa-outlined.png',
            onTap: () => widget.onSelectedPage(PageItem.mensa),
            isActive: widget.currentPage == PageItem.mensa,
          ),
          // Guide
          SideNavBarItem(
            title: 'Guide',
            imagePathActive: 'assets/img/icons/help-filled.png',
            imagePathInactive: 'assets/img/icons/help-outlined.png',
            onTap: () => widget.onSelectedPage(PageItem.guide),
            isActive: widget.currentPage == PageItem.guide,
          ),
          const Expanded(child: SizedBox()),
          // More
          SideNavBarItem(
            title: 'Mehr',
            imagePathActive: 'assets/img/icons/more.png',
            imagePathInactive: 'assets/img/icons/more.png',
            onTap: () => widget.onSelectedPage(PageItem.more),
            isActive: widget.currentPage == PageItem.more,
          ),
        ],
      ),
    );
  }
}
