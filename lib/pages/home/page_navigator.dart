import 'package:campus_app/pages/feed/feed_page.dart';
import 'package:flutter/material.dart';

import 'package:campus_app/pages/home/widgets/bottom_nav_bar.dart';
import 'package:campus_app/pages/calendar/calendar_page.dart';
import 'package:campus_app/pages/mensa/mensa_page.dart';
import 'package:campus_app/pages/wallet/wallet_page.dart';
import 'package:campus_app/pages/more/more_page.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/planner/planner_page.dart';

enum PageItem { feed, events, mensa, wallet, more }

class PageNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class NavBarNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<NavigatorState> navigatorKey;

  final PageItem pageItem;

  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const NavBarNavigator({
    super.key,
    required this.mainNavigatorKey,
    required this.navigatorKey,
    required this.pageItem,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  });

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    Widget rootPage;

    switch (pageItem) {
      case PageItem.feed:
        rootPage = FeedPage(
          mainNavigatorKey: mainNavigatorKey,
          pageEntryAnimationKey: pageEntryAnimationKey,
          pageExitAnimationKey: pageExitAnimationKey,
        );
        break;

      case PageItem.events:
        rootPage = PlannerPage(
          mainNavigatorKey: mainNavigatorKey,
        );
        break;

      case PageItem.mensa:
        rootPage = MensaPage(
          mainNavigatorKey: mainNavigatorKey,
          pageEntryAnimationKey: pageEntryAnimationKey,
          pageExitAnimationKey: pageExitAnimationKey,
        );
        break;

      case PageItem.wallet:
        rootPage = WalletPage(
          pageEntryAnimationKey: pageEntryAnimationKey,
          pageExitAnimationKey: pageExitAnimationKey,
        );
        break;

      case PageItem.more:
        rootPage = MorePage(
          mainNavigatorKey: mainNavigatorKey,
          pageEntryAnimationKey: pageEntryAnimationKey,
          pageExitAnimationKey: pageExitAnimationKey,
        );
        break;
    }

    return {
      PageNavigatorRoutes.root: (context) => rootPage,
    };
  }

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
