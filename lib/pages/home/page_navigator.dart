import 'package:flutter/material.dart';
import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/pages/feed/feed_page.dart';
import 'package:campus_app/pages/calendar/calendar_page.dart';
import 'package:campus_app/pages/mensa/mensa_page.dart';
import 'package:campus_app/pages/guide/guide_page.dart';
import 'package:campus_app/pages/more/more_page.dart';

class PageNavigatorRoutes {
  /// The root-page is shown initially when this navbar-tab is the active one.
  static const String root = '/';

  /// The detail-page is pushed onto the navigator-stack of this specific tab when,
  /// for example, a news-article is opened.
  static const String detail = '/detail';
}

/// Wraps the displayed page into a seperate [Navigator] in order to push new detail-pages
/// (like opening a news-article) to a specific navigator-stack instead of the app-wide navigator-stack.
///
/// This also allows to constantly show the [BottomNavBar] across multiple pages, even during transitions.
class NavBarNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;

  final GlobalKey<NavigatorState> navigatorKey;

  /// Determines the type of the page in order to set the navigator correctly.
  final PageItem pageItem;


  NavBarNavigator({
    required this.mainNavigatorKey,
    required this.navigatorKey,
    required this.pageItem,
  });

  /// Creates a map of the root and detail page of the specific page.
  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    Widget rootPage;
    switch (pageItem) {
      case PageItem.feed:
        rootPage = FeedPage(
          mainNavigatorKey: mainNavigatorKey,
        );
        break;
      case PageItem.events:
        rootPage = CalendarPage(
          mainNavigatorKey: mainNavigatorKey,
        );
        break;
      case PageItem.coupons:
        rootPage = Scaffold(); // Has to be replaced!
        break;
      case PageItem.mensa:
        rootPage = MensaPage(
          mainNavigatorKey: mainNavigatorKey,
        );
        break;
      case PageItem.guide:
        rootPage = GuidePage();
        break;
      case PageItem.more:
        rootPage = MorePage(
          mainNavigatorKey: mainNavigatorKey,
        );
        break;
    }
    return {
      PageNavigatorRoutes.root: (context) => rootPage,
      //TabNavigatorRoutes.detail: (context) => ,
    };
  }

  /// Pushes the detail page onto the navigation-stack of the specific page
  ///
  /// HAS TO BE IMPLEMENTED!
  void _push(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetBuilder> routeBuilders = _routeBuilders(context);

    return Navigator(
      key: navigatorKey,
      initialRoute: PageNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name]!(context),
        );
      },
    );
  }
}
