import 'package:auto_route/auto_route.dart';
import 'package:campus_app/pages/splash/splash_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true),
  ],
)
class $AppRouter {}
