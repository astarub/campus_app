import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/injection.dart' as ic; // injection container
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/routes/router.gr.dart' as router;
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/authentication/authentification_handler.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  runApp(MultiProvider(
    providers: [
      // Initializes the provider that handles the app-theme, authentification and other things
      ChangeNotifierProvider<ThemesNotifier>(create: (_) => ThemesNotifier()),
      ChangeNotifierProvider<AuthentificationHandler>(create: (_) => AuthentificationHandler()),
    ],
    child: CampusApp(),
  ));
}

class CampusApp extends StatelessWidget {
  final _appRouter = router.AppRouter();

  CampusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: Provider.of<ThemesNotifier>(context).currentThemeData,
      darkTheme: Provider.of<ThemesNotifier>(context).darkThemeData,
      themeMode: Provider.of<ThemesNotifier>(context).currentThemeMode,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
    );
  }
}
