import 'package:flutter/material.dart';

import 'package:campus_app/pages/home/home_page.dart';

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
  TextStyle activeStyle = TextStyle(fontWeight: FontWeight.bold);
  TextStyle nonActiveStyle = TextStyle(fontWeight: FontWeight.normal);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          TextButton(
            child: Text(
              'Page1',
              style: widget.currentPage == PageItem.feed ? activeStyle : nonActiveStyle,
            ),
            onPressed: () => widget.onSelectedPage(PageItem.feed),
          ),
          TextButton(
            child: Text(
              'Page2',
              style: widget.currentPage == PageItem.events ? activeStyle : nonActiveStyle,
            ),
            onPressed: () => widget.onSelectedPage(PageItem.events),
          ),
        ],
      ),
    );
  }
}
