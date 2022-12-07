import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:campus_app/pages/home/widgets/bottom_nav_bar.dart';
import 'package:campus_app/pages/feed/feed_page.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';

/// Defines the different pages that can be displayed
enum PageItem { feed, events, coupons, mensa, guide, more }

/// The [HomePage] displays all general UI elements like the bottom nav-menu and
/// handles the switching between the different pages.
class HomePage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;

  const HomePage({Key? key, required this.mainNavigatorKey}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// Creates a [GlobalKey] for each page that should be accessable within the bottom nav-menu
  Map<PageItem, GlobalKey<NavigatorState>> navigatorKeys = {
    PageItem.feed: GlobalKey<NavigatorState>(),
    PageItem.events: GlobalKey<NavigatorState>(),
    PageItem.mensa: GlobalKey<NavigatorState>(),
    PageItem.guide: GlobalKey<NavigatorState>(),
    PageItem.more: GlobalKey<NavigatorState>(),
  };

  /// Creates two [GlobalKey] for each page in order to control the exit- and
  /// entry-animation from outside the page
  Map<PageItem, GlobalKey<AnimatedExitState>> exitAnimationKeys = {
    PageItem.feed: GlobalKey<AnimatedExitState>(),
    PageItem.events: GlobalKey<AnimatedExitState>(),
    PageItem.mensa: GlobalKey<AnimatedExitState>(),
    PageItem.guide: GlobalKey<AnimatedExitState>(),
    PageItem.more: GlobalKey<AnimatedExitState>(),
  };
  Map<PageItem, GlobalKey<AnimatedEntryState>> entryAnimationKeys = {
    PageItem.feed: GlobalKey<AnimatedEntryState>(),
    PageItem.events: GlobalKey<AnimatedEntryState>(),
    PageItem.mensa: GlobalKey<AnimatedEntryState>(),
    PageItem.guide: GlobalKey<AnimatedEntryState>(),
    PageItem.more: GlobalKey<AnimatedEntryState>(),
  };

  final SystemUiOverlayStyle lightSystemUiStyle = const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light, // iOS
    statusBarColor: Colors.white, // Android
    statusBarIconBrightness: Brightness.dark, // Android
    systemNavigationBarColor: Colors.white, // Android
    systemNavigationBarIconBrightness: Brightness.dark, // Android
  );
  final SystemUiOverlayStyle darkSystemUiStyle = const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark, // iOS
    statusBarColor: Color.fromRGBO(14, 20, 32, 1), // Android
    statusBarIconBrightness: Brightness.light, // Android
    systemNavigationBarColor: Color.fromRGBO(17, 25, 38, 1), // Android
    systemNavigationBarIconBrightness: Brightness.light, // Android
  );

  /// Holds the currently active page.
  PageItem currentPage = PageItem.feed;

  GlobalKey<FeedPageState> feedKey = GlobalKey();

  final PageController _pageController = PageController();

  /// Switches to another page when selected in the nav-menu
  Future<bool> selectedPage(PageItem selectedPageItem) async {
    if (selectedPageItem != currentPage) {
      final List<PageItem> pages = navigatorKeys.keys.toList();
      final int indexNewPage = pages.indexWhere((element) => element == selectedPageItem);

      _pageController.jumpToPage(indexNewPage);
      currentPage = selectedPageItem;
    }

    return true;
  }

  /// Wraps the [NavBarNavigator] that holds the displayed page in an [Offstage] widget
  /// in order to stack them and show only the active page.
  Widget _buildPage(PageItem tabItem) {
    return NavBarNavigator(
      mainNavigatorKey: widget.mainNavigatorKey,
      navigatorKey: navigatorKeys[tabItem]!,
      pageItem: tabItem,
      pageEntryAnimationKey: entryAnimationKeys[tabItem]!,
      pageExitAnimationKey: exitAnimationKeys[tabItem]!,
    );
  }

  @override
  void initState() {
    super.initState();

    // Theme von System auslesen & Callback erstellen
    var window = WidgetsBinding.instance.window;

    window.onPlatformBrightnessChanged = () {
      final brightness = window.platformBrightness;

      // Callback wird ausgeführt, sofern System-Darkmode verwendet werden soll
      if (Provider.of<SettingsHandler>(context, listen: false).currentSettings.useSystemDarkmode) {
        if (brightness == Brightness.light) {
          debugPrint('System ändert zu LightMode.');
          if (Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.dark) {
            Provider.of<ThemesNotifier>(context, listen: false).currentTheme = AppThemes.light;
          }
        } else if (brightness == Brightness.dark) {
          debugPrint('System ändert zu DarkMode.');
          if (Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light) {
            Provider.of<ThemesNotifier>(context, listen: false).currentTheme = AppThemes.dark;
          }
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
          ? lightSystemUiStyle
          : darkSystemUiStyle,
      child: WillPopScope(
        onWillPop: () async => !await navigatorKeys[currentPage]!.currentState!.maybePop(),
        child: Scaffold(
          backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
          bottomNavigationBar: BottomNavBar(
            currentPage: currentPage,
            onSelectedPage: selectedPage,
          ),
          body: SafeArea(
            bottom: false,
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                final List<PageItem> pages = navigatorKeys.keys.toList();
                PageItem newPage;
                try{
                  newPage = pages.firstWhere((element) => element.index == page);
                } catch(e) {
                  return;
                }

                setState(() {
                  currentPage = newPage;
                });
              },
              children: [
                _buildPage(PageItem.feed),
                _buildPage(PageItem.events),
                _buildPage(PageItem.mensa),
                _buildPage(PageItem.guide),
                _buildPage(PageItem.more),
              ],
            ),
          ),
        ),
      ),
    );
  }
}