import 'package:campus_app/core/injection.dart' as ic; // injection container
import 'package:campus_app/core/routes/router.gr.dart' as router;
import 'package:campus_app/core/themes/theme.dart';
import 'package:campus_app/core/themes/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:provider/provider.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  runApp(AStA());
}

class AStA extends StatelessWidget {
  final _appRouter = router.AppRouter();

  AStA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp.router(
            routeInformationParser: _appRouter.defaultRouteParser(),
            routerDelegate: _appRouter.delegate(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.campusNowTheme,
            darkTheme: AppTheme.testTheme,
            themeMode: themeService.isCampusNowThemeOn
                ? ThemeMode.light
                : ThemeMode.dark,
          );
        },
      ),
    );
  }
}
