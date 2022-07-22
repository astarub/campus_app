import 'package:auto_route/auto_route.dart';
import 'package:campus_app/pages/calendar/calendar_page.dart';
import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/pages/moodle/moodle_page.dart';
import 'package:campus_app/pages/rubnews/rubnews_page.dart';
import 'package:campus_app/pages/rubsignin/rubsignin_page.dart';
import 'package:campus_app/pages/splash/splash_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: CalendarPage),
    AutoRoute(page: RUBSignInPage),
    AutoRoute(page: MoodlePage),
    AutoRoute(page: HomePage),
    AutoRoute(page: RubnewsPage),
  ],
)
class $AppRouter {}
