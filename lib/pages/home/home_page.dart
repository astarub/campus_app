import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:campus_app/pages/home/widgets/bottom_nav_bar.dart';
import 'package:campus_app/pages/feed/feed_page.dart';

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

  double pagePosition = 0;

  /// Switches to another page when selected in the nav-menu
  Future<bool> selectedPage(PageItem selectedPageItem) async {
    if (selectedPageItem != currentPage) {
      // Get all pages as list and find the corresponding element
      final List<PageItem> pages = navigatorKeys.keys.toList();
      final int indexNewPage = pages.indexWhere((element) => element == selectedPageItem);

      // Switch to the clicked page
      _pageController.jumpToPage(indexNewPage);
      await _pageController.animateToPage(
        indexNewPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    return true;
  }

  /// Returns the [NavBarNavigator] for the specified PageItem
  Widget _buildNavigator(PageItem tabItem) {
    return NavBarNavigator(
      mainNavigatorKey: widget.mainNavigatorKey,
      navigatorKey: navigatorKeys[tabItem]!,
      pageItem: tabItem,
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

    _pageController.addListener(() {
      setState(() => pagePosition = _pageController.page ?? 0);
    });
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
            child: PageView.builder(
              controller: _pageController,
              itemCount: navigatorKeys.length,
              //scrollBehavior: CupertinoScrollBehavior(),
              onPageChanged: (page) {
                final List<PageItem> pages = navigatorKeys.keys.toList();

                // Find new PageItem and assign newPage the old value in case no element is found
                final PageItem newPage = pages[page];

                // Set newPage as the currentPage
                if (newPage != currentPage) {
                  setState(() => currentPage = newPage);
                }
              },
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: pagePosition - index < 0
                      // Navigate left -> blend out the right page
                      ? pagePosition - index + 1 >= 0.9
                          ? 1
                          : pagePosition - index + 1 <= 0.1
                              ? 0
                              : pagePosition - index + 1
                      // Navigate right -> blend out the left page
                      : (1 - (pagePosition - index)) >= 0.9
                          ? 1
                          : 1 - (pagePosition - index) <= 0.1
                              ? 0
                              : 1 - (pagePosition - index),
                  duration: const Duration(milliseconds: 100),
                  child: _buildNavigator(navigatorKeys.keys.toList()[index]),
                );
              },
              /* children: [
                _buildNavigator(PageItem.feed),
                _buildNavigator(PageItem.events),
                _buildNavigator(PageItem.mensa),
                _buildNavigator(PageItem.guide),
                _buildNavigator(PageItem.more),
              ], */
            ),
          ),
        ),
      ),
    );
  }
}
