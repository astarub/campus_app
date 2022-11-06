import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:campus_app/core/authentication/authentication_handler.dart';
import 'package:campus_app/core/injection.dart' as ic; // injection container
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/pages/feed/rubnews/news_entity.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/calendar/entities/category_entity.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/entities/organizer_entity.dart';
import 'package:campus_app/pages/calendar/entities/venue_entity.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keeps the native splash screen onscreen until all loading is done
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //Disable all logs in production mode
  const bool production = bool.fromEnvironment('dart.vm.product');
  if(production) debugPrint = (String? message, {int? wrapWidth}) => '';

  // Initializes Hive and all used adapter for caching entities
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(VenueAdapter());
  Hive.registerAdapter(OrganizerAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(NewsEntityAdapter());
  Hive.registerAdapter(DishEntityAdapter());

  // Initialize injection container
  await ic.init();

  runApp(MultiProvider(
    providers: [
      // Initializes the provider that handles the app-theme, authentification and other things
      ChangeNotifierProvider<SettingsHandler>(create: (_) => SettingsHandler()),
      ChangeNotifierProvider<ThemesNotifier>(create: (_) => ThemesNotifier()),
      ChangeNotifierProvider<AuthenticationHandler>(create: (_) => AuthenticationHandler()),
    ],
    child: const CampusApp(),
  ));
}

class CampusApp extends StatefulWidget {
  const CampusApp({Key? key}) : super(key: key);

  @override
  State<CampusApp> createState() => _CampusAppState();
}

class _CampusAppState extends State<CampusApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey();

  String _directoryPath = '';
  Settings? loadedSettings;

  Stopwatch loadingTimer = Stopwatch();

  /// Starts the app if a settings file already exists.
  /// If not, the user starts the app for the first time, which initiates onboarding.
  void startApp(BuildContext context) {
    if (loadedSettings != null) {
      // Normal app start
      debugPrint('Initiate normal app start.');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage(mainNavigatorKey: mainNavigatorKey)),
      );
    } else {
      // Onboarding
      debugPrint('Initiate onboarding.  -- TEMPORARY REPLACED WITH NORMAL APP START');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage(mainNavigatorKey: mainNavigatorKey)),
      );
    }
  }

  /// Load the saved settings and parse them to the [SettingsHandler]
  void loadSettings() {
    debugPrint('LoadSettings initalized.');
    getApplicationDocumentsDirectory().then((Directory directory) {
      _directoryPath = directory.path;
      debugPrint('Save location: $_directoryPath');

      // Load settings async
      final File settingsJsonFile = File('$_directoryPath/settings.json');

      // Check if settings file already exists
      settingsJsonFile.exists().then((bool existing) {
        if (existing) {
          debugPrint('Settings-file already exists. Initialize loading of settings.');
          // Load settings and parse it
          settingsJsonFile.readAsString().then((String rawFileContent) {
            if (rawFileContent != '') {
              final dynamic rawData = json.decode(rawFileContent);
              loadedSettings = Settings.fromJson(rawData);

              debugPrint('Settings loaded.');
              Provider.of<SettingsHandler>(context, listen: false).setLoadedSettings(loadedSettings!);

              // Set theme
              setTheme(
                contextForThemeProvider: context,
                useSystemDarkmode: loadedSettings!.useSystemDarkmode,
                useDarkmode: loadedSettings!.useDarkmode,
              );

              loadingTimer.stop();
              debugPrint('-- loading time: ${loadingTimer.elapsedMilliseconds} ms');

              // Start the app
              FlutterNativeSplash.remove();
            }
          });
        } else {
          // Create settings file for the first time, if it doesnt exist
          debugPrint('Settings-file created.');
          settingsJsonFile.create();
          final Map<String, dynamic> initialSettings = {'useSystemDarkmode': true, 'useDarkmode': false};
          settingsJsonFile.writeAsString(json.encode(initialSettings));

          loadingTimer.stop();
          debugPrint('-- loading time: ${loadingTimer.elapsedMilliseconds} ms');

          // Set theme (defaults to current system brightness)
          setTheme(contextForThemeProvider: context);

          // Start the app
          FlutterNativeSplash.remove();
        }
      });
    });
  }

  /// Given the loaded settings, listen to the system brightness mode and apply the theme
  void setTheme({
    required BuildContext contextForThemeProvider,
    bool useSystemDarkmode = true,
    bool useDarkmode = false,
  }) {
    if (useSystemDarkmode) {
      Provider.of<ThemesNotifier>(context, listen: false).currentThemeMode = ThemeMode.system;
    } else {
      if (useDarkmode) {
        Provider.of<ThemesNotifier>(context, listen: false).currentThemeMode = ThemeMode.dark;
      } else {
        Provider.of<ThemesNotifier>(context, listen: false).currentThemeMode = ThemeMode.light;
      }
    }
  }

  void precacheAssets(BuildContext context) {
    // Precache images to prevent a visual glitch when they're loaded the first time
    precacheImage(Image.asset('assets/img/icons/home-outlined.png').image, context);
    precacheImage(Image.asset('assets/img/icons/home-filled.png').image, context);
    precacheImage(Image.asset('assets/img/icons/calendar-outlined.png').image, context);
    precacheImage(Image.asset('assets/img/icons/calendar-filled.png').image, context);
    precacheImage(Image.asset('assets/img/icons/mensa-outlined.png').image, context);
    precacheImage(Image.asset('assets/img/icons/mensa-filled.png').image, context);
    precacheImage(Image.asset('assets/img/icons/help-outlined.png').image, context);
    precacheImage(Image.asset('assets/img/icons/help-filled.png').image, context);
    precacheImage(Image.asset('assets/img/icons/more.png').image, context);
  }

  /// DEBUG ONLY - Deletes the existing settings!
  void _debugDeleteSettings() {
    getApplicationDocumentsDirectory().then((Directory directory) {
      final String tempDirectoryPath = directory.path;
      final File jsonFile = File('$tempDirectoryPath/settings.json');
      jsonFile.delete().then((_) => debugPrint('DEBUG: Settings-Datei gelöscht.'));
    });
  }

  @override
  void initState() {
    super.initState();

    FlutterDisplayMode.setHighRefreshRate();

    // Add observer in order to listen to `didChangeAppLifecycleState`
    WidgetsBinding.instance.addObserver(this);

    //_debugDeleteSettings();

    // load saved settings
    loadingTimer.start();
    loadSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheAssets(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    precacheAssets(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: Provider.of<ThemesNotifier>(context, listen: false).currentThemeData,
      darkTheme: Provider.of<ThemesNotifier>(context, listen: false).darkThemeData,
      themeMode: Provider.of<ThemesNotifier>(context, listen: false).currentThemeMode,
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return PageTransition(
            child: HomePage(mainNavigatorKey: mainNavigatorKey),
            type: PageTransitionType.scale,
            alignment: Alignment.center,
          );
        }
      },
      navigatorKey: mainNavigatorKey,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
    );
  }
}
