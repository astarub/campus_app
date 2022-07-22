// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../../pages/calendar/calendar_page.dart' as _i2;
import '../../pages/home/home_page.dart' as _i5;
import '../../pages/moodle/moodle_page.dart' as _i4;
import '../../pages/rubnews/rubnews_page.dart' as _i6;
import '../../pages/rubsignin/rubsignin_page.dart' as _i3;
import '../../pages/splash/splash_page.dart' as _i1;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    SplashPageRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashPage());
    },
    CalendarPageRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.CalendarPage());
    },
    RUBSignInPageRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.RUBSignInPage());
    },
    MoodlePageRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.MoodlePage());
    },
    HomePageRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.HomePage());
    },
    RubnewsPageRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.RubnewsPage());
    }
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(SplashPageRoute.name, path: '/'),
        _i7.RouteConfig(CalendarPageRoute.name, path: '/calendar-page'),
        _i7.RouteConfig(RUBSignInPageRoute.name, path: '/r-ub-sign-in-page'),
        _i7.RouteConfig(MoodlePageRoute.name, path: '/moodle-page'),
        _i7.RouteConfig(HomePageRoute.name, path: '/home-page'),
        _i7.RouteConfig(RubnewsPageRoute.name, path: '/rubnews-page')
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashPageRoute extends _i7.PageRouteInfo<void> {
  const SplashPageRoute() : super(SplashPageRoute.name, path: '/');

  static const String name = 'SplashPageRoute';
}

/// generated route for
/// [_i2.CalendarPage]
class CalendarPageRoute extends _i7.PageRouteInfo<void> {
  const CalendarPageRoute()
      : super(CalendarPageRoute.name, path: '/calendar-page');

  static const String name = 'CalendarPageRoute';
}

/// generated route for
/// [_i3.RUBSignInPage]
class RUBSignInPageRoute extends _i7.PageRouteInfo<void> {
  const RUBSignInPageRoute()
      : super(RUBSignInPageRoute.name, path: '/r-ub-sign-in-page');

  static const String name = 'RUBSignInPageRoute';
}

/// generated route for
/// [_i4.MoodlePage]
class MoodlePageRoute extends _i7.PageRouteInfo<void> {
  const MoodlePageRoute() : super(MoodlePageRoute.name, path: '/moodle-page');

  static const String name = 'MoodlePageRoute';
}

/// generated route for
/// [_i5.HomePage]
class HomePageRoute extends _i7.PageRouteInfo<void> {
  const HomePageRoute() : super(HomePageRoute.name, path: '/home-page');

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i6.RubnewsPage]
class RubnewsPageRoute extends _i7.PageRouteInfo<void> {
  const RubnewsPageRoute()
      : super(RubnewsPageRoute.name, path: '/rubnews-page');

  static const String name = 'RubnewsPageRoute';
}
