import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/themes.dart';

import 'package:campus_app/pages/home/widgets/bottom_nav_bar.dart';

/// Defines the different pages that can be displayed
enum PageItem { feed, events, coupons, mensa, guide, more }

/// The [HomePage] displays all general UI elements like the bottom nav-menu and
/// handles the switching between the different pages.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Creates a [GlobalKey] for each page that should be accessable within the bottom nav-menu
  Map<PageItem, GlobalKey<NavigatorState>> navigatorKeys = {
    PageItem.feed: GlobalKey<NavigatorState>(),
    PageItem.events: GlobalKey<NavigatorState>(),
  };

  /// Holds the currently active page.
  PageItem currentPage = PageItem.feed;

  /// Switches to another page when selected in the nav-menu
  void _selectedPage(PageItem selectedPageItem) {
    setState(() => currentPage = selectedPageItem);
  }

  /// Wraps the [NavBarNavigator] that holds the displayed page in an [Offstage] widget
  /// in order to stack them and show only the active page.
  Widget _buildOffstateNavigator(PageItem tabItem) {
    return Offstage(
      offstage: currentPage != tabItem,
      child: NavBarNavigator(
        navigatorKey: navigatorKeys[tabItem]!,
        pageItem: tabItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[currentPage]!.currentState!.maybePop(),
      child: Scaffold(
        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
        bottomNavigationBar: BottomNavBar(
          currentPage: currentPage,
          onSelectedPage: _selectedPage,
        ),
        body: Stack(
          // Holds all the pages that sould be accessable within the bottom nav-menu
          children: [
            _buildOffstateNavigator(PageItem.feed),
            _buildOffstateNavigator(PageItem.events),
          ],
        ),
      ),
    );
  }
}
