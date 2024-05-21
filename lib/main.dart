import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:campus_app/core/backend/analytics/aptabase.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:campus_app/l10n/l10n.dart';

import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:campus_app/core/injection.dart' as ic; // injection container
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/pages/home/onboarding.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/calendar/entities/category_entity.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/entities/organizer_entity.dart';
import 'package:campus_app/pages/calendar/entities/venue_entity.dart';
import 'package:campus_app/utils/pages/main_utils.dart';
import 'package:campus_app/utils/pages/mensa_utils.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Initialize Aptabase for analytics with our app key
  await Aptabase.init('A-SH-3787488994', const InitOptions(host: 'https://analytics.app.asta-bochum.de'));

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

  // Checks if the app is in release mode and initializes sentry
  // REMOVE THIS CHECK IF YOU WISH TO RUN THE APP IN RELEASE MODE OTHERWISE THE APP WILL NOT RUN
  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 0.3;
      },
      appRunner: () => runApp(
        MultiProvider(
          providers: [
            // Initializes the provider that handles the app-theme, authentication and other things
            ChangeNotifierProvider<SettingsHandler>(create: (_) => SettingsHandler()),
            ChangeNotifierProvider<ThemesNotifier>(create: (_) => ThemesNotifier()),
          ],
          child: CampusApp(
            key: campusAppKey,
          ),
        ),
      ),
    );
  } else {
    runApp(
      MultiProvider(
        providers: [
          // Initializes the provider that handles the app-theme, authentication and other things
          ChangeNotifierProvider<SettingsHandler>(create: (_) => SettingsHandler()),
          ChangeNotifierProvider<ThemesNotifier>(create: (_) => ThemesNotifier()),
        ],
        child: CampusApp(
          key: campusAppKey,
        ),
      ),
    );
  }
}

final GlobalKey<CampusAppState> campusAppKey = GlobalKey();
final GlobalKey<HomePageState> homeKey = GlobalKey();

class CampusApp extends StatefulWidget {
  const CampusApp({Key? key}) : super(key: key);

  @override
  State<CampusApp> createState() => CampusAppState();
}

class CampusAppState extends State<CampusApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey();

  String _directoryPath = '';
  Settings? loadedSettings;

  Stopwatch loadingTimer = Stopwatch();

  DateTime _appStartTime = DateTime.now();

  final BackendRepository backendRepository = ic.sl<BackendRepository>();
  final MainUtils mainUtils = ic.sl<MainUtils>();
  final MensaUtils mensaUtils = ic.sl<MensaUtils>();

  /// Load the saved settings and parse them to the [SettingsHandler]
  void loadSettings() {
    debugPrint('LoadSettings initalized.');
    getApplicationDocumentsDirectory().then((Directory directory) {
      _directoryPath = directory.path;
      debugPrint('Save location: $_directoryPath');

      // Load settings async
      final File settingsJsonFile = File('$_directoryPath/settings.json');

      final bool existing = settingsJsonFile.existsSync();

      // Check if settings file already exists
      if (existing) {
        debugPrint('Settings-file already exists. Initialize loading of settings.');
        // Load settings and parse it
        settingsJsonFile.readAsString().then((String rawFileContent) {
          if (rawFileContent != '') {
            try {
              final dynamic rawData = json.decode(rawFileContent);
              loadedSettings = Settings.fromJson(rawData);
            } catch (e) {
              debugPrint('Settings file corrupted. Creating a new settings file.');

              settingsJsonFile.deleteSync();
              settingsJsonFile.create();

              loadedSettings = Settings(
                mensaRestaurantConfig: mensaUtils.restaurantConfig,
                mensaPreferences: [],
                mensaAllergenes: [],
              );

              settingsJsonFile.writeAsString(json.encode(loadedSettings!.toJson()));
            }

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

            // Check whether the user agreed to use Firebase
            mainUtils.checkFirebasePermission(
              context,
              mainNavigatorKey,
            );

            // Initialize the backend connection
            initializeBackendConnection();
          }
        });
      } else {
        // Create settings file for the first time, if it doesnt exist
        debugPrint('Settings-file created.');
        settingsJsonFile.create();
        final Settings initialSettings = Settings(
          mensaAllergenes: [],
          mensaPreferences: [],
          mensaRestaurantConfig: mensaUtils.restaurantConfig,
        );
        settingsJsonFile.writeAsString(json.encode(initialSettings.toJson()));

        // Apply the inital settings
        Provider.of<SettingsHandler>(context, listen: false).setLoadedSettings(initialSettings);

        // Set theme (defaults to current system brightness)
        setTheme(contextForThemeProvider: context);

        // Initialize the backend connection
        initializeBackendConnection();

        loadingTimer.stop();
        debugPrint('-- loading time: ${loadingTimer.elapsedMilliseconds} ms');

        // Start the app and show the onboarding experience
        FlutterNativeSplash.remove();
        Navigator.of(mainNavigatorKey.currentState!.context).push(
          MaterialPageRoute(
            builder: (context) => OnboardingPage(homePageKey: homeKey, mainNavigatorKey: mainNavigatorKey),
          ),
        );
      }
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
    precacheImage(Image.asset('assets/img/icons/map-outlined.png').image, context);
    precacheImage(Image.asset('assets/img/icons/map-filled.png').image, context);
    precacheImage(Image.asset('assets/img/icons/mensa-outlined.png').image, context);
    precacheImage(Image.asset('assets/img/icons/mensa-filled.png').image, context);
    precacheImage(Image.asset('assets/img/icons/wallet-outlined.png').image, context);
    precacheImage(Image.asset('assets/img/icons/wallet-filled.png').image, context);
    precacheImage(Image.asset('assets/img/icons/more.png').image, context);
  }

  Future<void> initializeBackendConnection() async {
    final SettingsHandler settingsHandler = Provider.of<SettingsHandler>(context, listen: false);

    // Set the initial publishers for users who weren't connected to the backend in the past
    if (settingsHandler.currentSettings.latestVersion == '') {
      await mainUtils.setInitialPublishers(Provider.of<SettingsHandler>(context, listen: false));
    }

    try {
      await backendRepository.login(
        settingsHandler,
      );
    } catch (e) {
      debugPrint('Could not connect to the backend. Retrying next restart.');
    }

    if (settingsHandler.currentSettings.savedEventsNotifications == false) {
      try {
        await backendRepository.removeAllSavedEvents(
          settingsHandler,
        );
        await backendRepository.unsubscribeFromAllSavedEvents(
          settingsHandler,
        );
      } catch (e) {
        debugPrint(
          'Could not remove all saved events from the backend. Retrying next restart.',
        );
      }
    }

    try {
      if (await backendRepository.updateAvailable(settingsHandler)) {}

      await backendRepository.loadStudyCourses(settingsHandler);
      await backendRepository.loadMensaRestaurantConfig(settingsHandler);
    } catch (e) {
      debugPrint('Could not lead filters. Exception $e');
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

    // load saved settings
    loadingTimer.start();
    loadSettings();

    // Handle deep links
    mainUtils.handleIncomingLink();
    mainUtils.handleInitialUri();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheAssets(context);
  }

  void _sendTimeInAppToAptabase() {
    final Duration usageTime = DateTime.now().difference(_appStartTime);
    Aptabase.instance.trackEvent('usage_time', {'seconds': usageTime.inSeconds.toString()});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // start new time measurement of time in app (resumed, called everytime when
    // entering the app) or send spent time to Aptabase (inactive, called everytime,
    // when exiting the app)
    switch(state) {
      case AppLifecycleState.inactive: _sendTimeInAppToAptabase(); break;
      case AppLifecycleState.resumed: _appStartTime = DateTime.now(); break;
      default: break;
    }
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
    );
  }
}
