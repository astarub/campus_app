import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
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
import 'package:campus_app/pages/home/onboarding.dart';
import 'package:campus_app/pages/feed/rubnews/news_entity.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/calendar/entities/category_entity.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/entities/organizer_entity.dart';
import 'package:campus_app/pages/calendar/entities/venue_entity.dart';
import 'package:campus_app/pages/home/widgets/firebase_popup.dart';
import 'package:campus_app/utils/pages/main_utils.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keeps the native splash screen onscreen until all loading is done
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Disable all logs in production mode
  if (!kDebugMode) debugPrint = (String? message, {int? wrapWidth}) => '';

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
      // Initializes the provider that handles the app-theme, authentication and other things
      ChangeNotifierProvider<SettingsHandler>(create: (_) => SettingsHandler()),
      ChangeNotifierProvider<ThemesNotifier>(create: (_) => ThemesNotifier()),
      ChangeNotifierProvider<AuthenticationHandler>(create: (_) => AuthenticationHandler()),
    ],
    child: const CampusApp(),
  ));
}

final GlobalKey<HomePageState> homeKey = GlobalKey();

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
              loadedSettings = loadedSettings!.copyWith(newsExplore: true); // Default Feed on every start

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

              checkFirebasePermission();
            }
          });
        } else {
          // Create settings file for the first time, if it doesnt exist
          debugPrint('Settings-file created.');
          settingsJsonFile.create();
          final Settings initialSettings = Settings(feedFilter: ['RUB', 'AStA'], mensaPreferences: [], mensaAllergenes: []);
          settingsJsonFile.writeAsString(json.encode(initialSettings.toJson()));

          // Apply the inital settings
          Provider.of<SettingsHandler>(context, listen: false).setLoadedSettings(initialSettings);

          // Set theme (defaults to current system brightness)
          setTheme(contextForThemeProvider: context);

          loadingTimer.stop();
          debugPrint('-- loading time: ${loadingTimer.elapsedMilliseconds} ms');

          // Start the app and show the onboarding experience
          FlutterNativeSplash.remove();
          Navigator.of(mainNavigatorKey.currentState!.context).push(MaterialPageRoute(
              builder: (context) => OnboardingPage(homePageKey: homeKey, mainNavigatorKey: mainNavigatorKey)));
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

  /// This function checks if the firebase permission is `FirebaseStatus.unconfigured`.
  /// If so, it shows a popup to ask wether or not the user wants to use Firebase.
  ///
  /// If the _useFirebase_ setting is already set to `permitted`,
  /// the function [initializeFirebase] is called.
  void checkFirebasePermission() {
    if (Provider.of<SettingsHandler>(context, listen: false).currentSettings.useFirebase ==
        FirebaseStatus.uncofigured) {
      Timer(
          const Duration(seconds: 2),
          () => mainNavigatorKey.currentState?.push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, _, __) => FirebasePopup(onClose: (permissionGranted) {
                    final Settings newSettings;

                    if (permissionGranted) {
                      // User accepted to use Google services
                      newSettings = Provider.of<SettingsHandler>(context, listen: false)
                          .currentSettings
                          .copyWith(useFirebase: FirebaseStatus.permitted);

                      initializeFirebase();
                    } else {
                      // User denied to use Google services
                      newSettings = Provider.of<SettingsHandler>(context, listen: false)
                          .currentSettings
                          .copyWith(useFirebase: FirebaseStatus.forbidden);
                    }

                    debugPrint('Set Firebase permission: ${newSettings.useFirebase}');
                    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
                  }),
                ),
              ));
    } else if (Provider.of<SettingsHandler>(context, listen: false).currentSettings.useFirebase ==
        FirebaseStatus.permitted) {
      initializeFirebase();
    }
  }

  @override
  void initState() {
    super.initState();

    if (!Platform.isIOS) {
      FlutterDisplayMode.setHighRefreshRate();
    }

    // Add observer in order to listen to `didChangeAppLifecycleState`
    WidgetsBinding.instance.addObserver(this);

    //_debugDeleteSettings();

    // load saved settings
    loadingTimer.start();
    loadSettings();

    // Handle deep links
    handleIncomingLink();
    handleInitialUri();
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
      builder: Provider.of<SettingsHandler>(context).currentSettings.useSystemTextScaling
          ? null
          : (context, child) {
              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1), child: child!);
            },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return PageTransition(
            child: HomePage(key: homeKey, mainNavigatorKey: mainNavigatorKey),
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
