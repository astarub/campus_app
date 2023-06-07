import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/home/widgets/bottom_nav_bar.dart';
import 'package:campus_app/pages/home/widgets/side_nav_bar.dart';
import 'package:campus_app/pages/feed/feed_page.dart';

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
  final SystemUiOverlayStyle lightTabletSystemUiStyle = const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light, // iOS
    statusBarColor: Color.fromRGBO(245, 246, 250, 1), // Android
    statusBarIconBrightness: Brightness.dark, // Android
    systemNavigationBarColor: Color.fromRGBO(245, 246, 250, 1), // Android
    systemNavigationBarIconBrightness: Brightness.dark, // Android
  );
  final SystemUiOverlayStyle darkTabletSystemUiStyle = const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark, // iOS
    statusBarColor: Color.fromRGBO(17, 25, 38, 1), // Android
    statusBarIconBrightness: Brightness.light, // Android
    systemNavigationBarColor: Color.fromRGBO(17, 25, 38, 1), // Android
    systemNavigationBarIconBrightness: Brightness.light, // Android
  );

  /// Holds the currently active page.
  PageItem currentPage = PageItem.feed;

  GlobalKey<FeedPageState> feedKey = GlobalKey();

  final PageController _pageController = PageController();

  double pagePosition = 0;

  /// Switches to another page when selected in the nav-menu on phones
  Future<bool> selectedPage(PageItem selectedPageItem) async {
    if (selectedPageItem == currentPage) return true;

    // Phone Layout
    if (MediaQuery.of(context).size.shortestSide < 600) {
      // Get all pages as list and find the corresponding element
      final List<PageItem> pages = navigatorKeys.keys.toList();
      final int indexNewPage = pages.indexWhere((element) => element == selectedPageItem);

      // Switch to the selected page
      await _pageController.animateToPage(
        indexNewPage,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );

      // Tablet Layout
    } else {
      // Reset the exit animation of the new page to make the content visible again
      exitAnimationKeys[selectedPageItem]?.currentState?.resetExitAnimation();
      // Start the exit animation of the old page
      await exitAnimationKeys[currentPage]?.currentState?.startExitAnimation();
      // Switch to the new page
      setState(() => currentPage = selectedPageItem);
      // Start the entry animation of the new page
      await entryAnimationKeys[selectedPageItem]?.currentState?.startEntryAnimation();
    }

    return true;
  }

  /// Returns the [NavBarNavigator] for the specified PageItem on phones
  Widget _buildNavigator(PageItem tabItem) {
    return NavBarNavigator(
      mainNavigatorKey: widget.mainNavigatorKey,
      navigatorKey: navigatorKeys[tabItem]!,
      pageItem: tabItem,
      pageEntryAnimationKey: entryAnimationKeys[tabItem]!,
      pageExitAnimationKey: exitAnimationKeys[tabItem]!,
    );
  }

  /// Wraps the [NavBarNavigator] that holds the displayed page in an [Offstage] widget
  /// in order to stack them and show only the active page.
  /// Only used for tablets.
  Widget _buildOffstateNavigator(PageItem tabItem) {
    return Offstage(
      offstage: currentPage != tabItem,
      child: NavBarNavigator(
        mainNavigatorKey: widget.mainNavigatorKey,
        navigatorKey: navigatorKeys[tabItem]!,
        pageItem: tabItem,
        pageEntryAnimationKey: entryAnimationKeys[tabItem]!,
        pageExitAnimationKey: exitAnimationKeys[tabItem]!,
      ),
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
      value: MediaQuery.of(context).size.shortestSide < 600
          ? Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? lightSystemUiStyle
              : darkSystemUiStyle
          : Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? lightTabletSystemUiStyle
              : darkTabletSystemUiStyle,
      child: WillPopScope(
        onWillPop: () async => !await navigatorKeys[currentPage]!.currentState!.maybePop(),
        child: Scaffold(
          backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
          body: MediaQuery.of(context).size.shortestSide < 600
              // Phone layout
              ? SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 60),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: navigatorKeys.length,
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
                        ),
                      ),
                      // BottomNavigationBar
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomNavBar(
                          currentPage: currentPage,
                          onSelectedPage: selectedPage,
                        ),
                      ),
                    ],
                  ),
                )
              // Tablet layout
              : SafeArea(
                  child: Container(
                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? const Color.fromRGBO(245, 246, 250, 1)
                        : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 20,
                          color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                              ? const Color.fromRGBO(245, 246, 250, 1)
                              : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              SideNavBar(
                                currentPage: currentPage,
                                onSelectedPage: selectedPage,
                              ),
                              // Pages
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 550,
                                      child: Stack(
                                        children: [
                                          _buildOffstateNavigator(PageItem.feed),
                                          _buildOffstateNavigator(PageItem.events),
                                          _buildOffstateNavigator(PageItem.mensa),
                                          _buildOffstateNavigator(PageItem.guide),
                                          _buildOffstateNavigator(PageItem.more),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Detail space
                              Container(
                                width: 20,
                                color:
                                    Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                                        ? const Color.fromRGBO(245, 246, 250, 1)
                                        : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                              ? const Color.fromRGBO(245, 246, 250, 1)
                              : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
