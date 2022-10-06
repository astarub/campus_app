import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/home_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/splash';
  final GlobalKey<NavigatorState> mainNavigatorKey;

  const SplashPage({Key? key, required this.mainNavigatorKey}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Stopwatch loadingTimer = Stopwatch();
  Stopwatch idleTimer = Stopwatch();
  String _directoryPath = '';

  Settings? loadedSettings;

  void startApp(BuildContext context) {
    if (loadedSettings != null) {
      // Normal app start
      debugPrint('Initiate normal app start.');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage(mainNavigatorKey: widget.mainNavigatorKey)),
      );
    } else {
      // Onboarding
      debugPrint('Start onboarding.');
    }
  }

  /// Load the saved settings and parse it
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
            }
          });
        } else {
          // Create settings file for the first time, if it doesnt exist
          debugPrint('Settings-file created.');
          settingsJsonFile.create();
          final Map<String, dynamic> initialSettings = {'useSystemDarkmode': true, 'useDarkmode': false};
          settingsJsonFile.writeAsString(json.encode(initialSettings));
        }

        // Timer for statistics
        loadingTimer.stop();
        debugPrint('-- loading time: ${loadingTimer.elapsedMilliseconds} ms');
        idleTimer.start();
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

  // ? DEBUG ONLY
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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.white.withOpacity(0.2),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    FlutterDisplayMode.setHighRefreshRate();

    //_debugDeleteSettings();
    // load saved settings
    loadingTimer.start();
    loadSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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

  @override
  Widget build(BuildContext context) {
    // Timer before the app moves on to the home page to give the loading some time
    final Timer startingTimer = Timer(const Duration(seconds: 1), () {
      idleTimer.stop();
      debugPrint('-- idle time: ${idleTimer.elapsedMilliseconds} ms');
      startApp(context);
    });

    // The [AnnotatedRegion] widget allows to style system components like the status- or navigation-bar
    return Container(
      color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      child: Center(
        child: Image.asset(
          'assets/img/asta_logo.png',
          color: Colors.black,
          height: 100,
        ),
      ),
    );
  }
}
