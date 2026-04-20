import 'package:flutter/material.dart';

import 'package:campus_app/pages/feed/feed_page.dart';
import 'package:campus_app/pages/calendar/calendar_page.dart';
import 'package:campus_app/pages/mensa/mensa_page.dart';
import 'package:campus_app/pages/wallet/wallet_page.dart';
import 'package:campus_app/pages/more/more_page.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/navigation/outdoor_navigation_page.dart';

enum PageItem { feed, events, coupons, navigation, mensa, wallet, more }

const List<PageItem> customizablePageItems = [
  PageItem.feed,
  PageItem.events,
  PageItem.mensa,
  PageItem.navigation,
  PageItem.wallet,
  PageItem.more,
];

extension PageItemConfig on PageItem {
  String get storageId {
    switch (this) {
      case PageItem.feed:
        return 'feed';
      case PageItem.events:
        return 'events';
      case PageItem.coupons:
        return 'coupons';
      case PageItem.navigation:
        return 'navigation';
      case PageItem.mensa:
        return 'mensa';
      case PageItem.wallet:
        return 'wallet';
      case PageItem.more:
        return 'more';
    }
  }

  String get title {
    switch (this) {
      case PageItem.feed:
        return 'Feed';
      case PageItem.events:
        return 'Events';
      case PageItem.coupons:
        return 'Coupons';
      case PageItem.navigation:
        return 'Navigation';
      case PageItem.mensa:
        return 'Mensa';
      case PageItem.wallet:
        return 'Wallet';
      case PageItem.more:
        return 'Mehr';
    }
  }

  String get activeIconPath {
    switch (this) {
      case PageItem.feed:
        return 'assets/img/icons/home-filled.png';
      case PageItem.events:
        return 'assets/img/icons/calendar-filled.png';
      case PageItem.coupons:
        return 'assets/img/icons/home-filled.png';
      case PageItem.navigation:
        return 'assets/img/icons/map-filled.png';
      case PageItem.mensa:
        return 'assets/img/icons/mensa-filled.png';
      case PageItem.wallet:
        return 'assets/img/icons/wallet-filled.png';
      case PageItem.more:
        return 'assets/img/icons/more.png';
    }
  }

  String get inactiveIconPath {
    switch (this) {
      case PageItem.feed:
        return 'assets/img/icons/home-outlined.png';
      case PageItem.events:
        return 'assets/img/icons/calendar-outlined.png';
      case PageItem.coupons:
        return 'assets/img/icons/home-outlined.png';
      case PageItem.navigation:
        return 'assets/img/icons/map-outlined.png';
      case PageItem.mensa:
        return 'assets/img/icons/mensa-outlined.png';
      case PageItem.wallet:
        return 'assets/img/icons/wallet-outlined.png';
      case PageItem.more:
        return 'assets/img/icons/more.png';
    }
  }
}

PageItem? pageItemFromStorageId(String id) {
  for (final item in PageItem.values) {
    if (item.storageId == id) {
      return item;
    }
  }

  return null;
}

List<PageItem> sanitizeCustomizablePageOrder(List<String> pageIds) {
  final List<PageItem> orderedPages = [];

  for (final pageId in pageIds) {
    final pageItem = pageItemFromStorageId(pageId);
    if (pageItem != null &&
        customizablePageItems.contains(pageItem) &&
        !orderedPages.contains(pageItem)) {
      orderedPages.add(pageItem);
    }
  }

  for (final pageItem in customizablePageItems) {
    if (!orderedPages.contains(pageItem)) {
      orderedPages.add(pageItem);
    }
  }

  return orderedPages;
}

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
/// This also allows the app navigation chrome to stay visible across multiple pages, even during transitions.
class NavBarNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;

  final GlobalKey<NavigatorState> navigatorKey;

  /// Determines the type of the page in order to set the navigator correctly.
  final PageItem pageItem;

  /// Passes the animation key for the entry animation to the referenced page
  /// to control the animation from outside the page.
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;

  /// Passes the animation key for the exit animation to the referenced page
  /// to control the animation from outside the page.
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const NavBarNavigator({
    super.key,
    required this.mainNavigatorKey,
    required this.navigatorKey,
    required this.pageItem,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  });

  /// Creates a map of the root and detail page of the specific page.
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
        rootPage = CalendarPage(
          mainNavigatorKey: mainNavigatorKey,
          pageEntryAnimationKey: pageEntryAnimationKey,
          pageExitAnimationKey: pageExitAnimationKey,
        );
        break;
      case PageItem.coupons:
        rootPage = const Scaffold(); // Has to be replaced!
        break;
      case PageItem.mensa:
        rootPage = MensaPage(
          mainNavigatorKey: mainNavigatorKey,
          pageEntryAnimationKey: pageEntryAnimationKey,
          pageExitAnimationKey: pageExitAnimationKey,
        );
        break;
      case PageItem.navigation:
        rootPage = NavigationPage(
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
      //TabNavigatorRoutes.detail: (context) => ,
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
