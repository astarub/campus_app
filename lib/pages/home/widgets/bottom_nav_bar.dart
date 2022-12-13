import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/bottom_nav_bar_item.dart';

/// Creates the bottom navigation bar that lets the user switch between different pages.
class BottomNavBar extends StatefulWidget {
  /// Needs the currently active page in order to highlight it
  PageItem currentPage;

  /// Calls this function when an item of the navigation bar is selected.
  final Function onSelectedPage;

  BottomNavBar({
    Key? key,
    required this.currentPage,
    required this.onSelectedPage,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // Adjust this value in order to change the icon height of each navbar-element
  static const double iconHeight = 26;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isIOS ? 88 : 68,
      padding: Platform.isIOS ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -1))],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Feed
            BottomNavBarItem(
              title: 'Feed',
              imagePathActive: 'assets/img/icons/home-filled.png',
              imagePathInactive: 'assets/img/icons/home-outlined.png',
              onTap: () => widget.onSelectedPage(PageItem.feed),
              isActive: widget.currentPage == PageItem.feed,
            ),
            // Calendar
            BottomNavBarItem(
              title: 'Events',
              imagePathActive: 'assets/img/icons/calendar-filled.png',
              imagePathInactive: 'assets/img/icons/calendar-outlined.png',
              onTap: () => widget.onSelectedPage(PageItem.events),
              isActive: widget.currentPage == PageItem.events,
            ),
            // Mensa
            BottomNavBarItem(
              title: 'Mensa',
              imagePathActive: 'assets/img/icons/mensa-filled.png',
              imagePathInactive: 'assets/img/icons/mensa-outlined.png',
              onTap: () => widget.onSelectedPage(PageItem.mensa),
              isActive: widget.currentPage == PageItem.mensa,
            ),
            // Guide
            BottomNavBarItem(
              title: 'Guide',
              imagePathActive: 'assets/img/icons/help-filled.png',
              imagePathInactive: 'assets/img/icons/help-outlined.png',
              onTap: () => widget.onSelectedPage(PageItem.guide),
              isActive: widget.currentPage == PageItem.guide,
            ),
            // More
            BottomNavBarItem(
              title: 'Mehr',
              imagePathActive: 'assets/img/icons/more.png',
              imagePathInactive: 'assets/img/icons/more.png',
              onTap: () => widget.onSelectedPage(PageItem.more),
              isActive: widget.currentPage == PageItem.more,
            ),
          ],
        ),
      ),
    );
  }
}
