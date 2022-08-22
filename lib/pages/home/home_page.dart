import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/themes.dart';

import 'package:campus_app/pages/home/widgets/bottom_nav_bar.dart';
import 'package:campus_app/pages/rubnews/rubnews_page.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';

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

  /// Creates two [GlobalKey] for each page in order to control the exit- and
  /// entry-animation from outside the page
  Map<PageItem, GlobalKey<AnimatedExitState>> exitAnimationKeys = {
    PageItem.feed: GlobalKey<AnimatedExitState>(),
    PageItem.events: GlobalKey<AnimatedExitState>(),
  };
  Map<PageItem, GlobalKey<AnimatedEntryState>> entryAnimationKeys = {
    PageItem.feed: GlobalKey<AnimatedEntryState>(),
    PageItem.events: GlobalKey<AnimatedEntryState>(),
  };

  /// Holds the currently active page.
  PageItem currentPage = PageItem.feed;

  GlobalKey<RubnewsPageState> feedKey = GlobalKey();

  /// Switches to another page when selected in the nav-menu
  Future<bool> _selectedPage(PageItem selectedPageItem) async {
    // Reset the exit animation of the new page to make the content visible again
    exitAnimationKeys[selectedPageItem]?.currentState?.resetExitAnimation();
    // Start the exit animation of the old page
    await exitAnimationKeys[currentPage]?.currentState?.startExitAnimation();
    // Switch to the new page
    setState(() => currentPage = selectedPageItem);
    // Start the entry animation of the new page
    await entryAnimationKeys[selectedPageItem]?.currentState?.startEntryAnimation();

    return true;
  }

  /// Wraps the [NavBarNavigator] that holds the displayed page in an [Offstage] widget
  /// in order to stack them and show only the active page.
  Widget _buildOffstateNavigator(PageItem tabItem) {
    return Offstage(
      offstage: currentPage != tabItem,
      child: NavBarNavigator(
        navigatorKey: navigatorKeys[tabItem]!,
        pageItem: tabItem,
        pageEntryAnimationKey: entryAnimationKeys[tabItem]!,
        pageExitAnimationKey: exitAnimationKeys[tabItem]!,
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
