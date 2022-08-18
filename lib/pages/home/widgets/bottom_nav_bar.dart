import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

/// Creates the bottom navigation bar that lets the user switch between different pages.
class BottomNavBar extends StatefulWidget {
  /// Needs the currently active page in order to highlight it
  PageItem currentPage;

  /// Calls this function when an item of the navigation bar is selected.
  final Function onSelectedPage;

  BottomNavBar({
    required this.currentPage,
    required this.onSelectedPage,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // Adjust this value in order to change the icon height of each navbar-element
  static const double iconHeight = 26;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -1))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // News Feed
          CustomButton(
            tapHandler: () => widget.onSelectedPage(PageItem.feed),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Image.asset(
                widget.currentPage == PageItem.feed
                    ? 'assets/img/icons/home-filled.png'
                    : 'assets/img/icons/home-outlined.png',
                height: iconHeight,
                color: Colors.black,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          // Calendar
          CustomButton(
            tapHandler: () => widget.onSelectedPage(PageItem.events),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Image.asset(
                widget.currentPage == PageItem.events
                    ? 'assets/img/icons/calendar-filled.png'
                    : 'assets/img/icons/calendar-outlined.png',
                height: iconHeight,
                color: Colors.black,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          // Mensa
          CustomButton(
            tapHandler: () => widget.onSelectedPage(PageItem.mensa),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Image.asset(
                widget.currentPage == PageItem.mensa
                    ? 'assets/img/icons/mensa-filled.png'
                    : 'assets/img/icons/mensa-outlined.png',
                height: iconHeight,
                color: Colors.black,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          // Guide
          CustomButton(
            tapHandler: () => widget.onSelectedPage(PageItem.guide),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Image.asset(
                widget.currentPage == PageItem.guide
                    ? 'assets/img/icons/help-filled.png'
                    : 'assets/img/icons/help-outlined.png',
                height: iconHeight,
                color: Colors.black,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          // More
          CustomButton(
            tapHandler: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Image.asset(
                widget.currentPage == PageItem.feed ? 'assets/img/icons/more.png' : 'assets/img/icons/more.png',
                height: iconHeight,
                color: Colors.black,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
