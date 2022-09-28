import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/injection.dart' as ic; // injection container
import 'package:campus_app/core/injection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/authentication/authentication_handler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:campus_app/pages/splash/splash_page.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  runApp(MultiProvider(
    providers: [
      // Initializes the provider that handles the app-theme, authentification and other things
      ChangeNotifierProvider<ThemesNotifier>(create: (_) => ThemesNotifier()),
      ChangeNotifierProvider<AuthenticationHandler>(create: (_) => AuthenticationHandler()),
      ChangeNotifierProvider<SettingsHandler>(create: (_) => SettingsHandler()),
    ],
    child: const CampusApp(),
  ));
}

class CampusApp extends StatelessWidget {
  const CampusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey();

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: Provider.of<ThemesNotifier>(context).currentThemeData,
      darkTheme: Provider.of<ThemesNotifier>(context).darkThemeData,
      themeMode: Provider.of<ThemesNotifier>(context).currentThemeMode,
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return PageTransition(
            child: SplashPage(mainNavigatorKey: mainNavigatorKey), // Exchange page to your needs during development
            type: PageTransitionType.scale,
            alignment: Alignment.center,
          );
        }
      },
      navigatorKey:
          mainNavigatorKey, // comment this out during development, otherwhise the whole app restarts on hot-reload
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
    );
  }
}
