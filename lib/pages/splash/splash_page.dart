import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/home_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/splash';

  const SplashPage({Key? key}) : super(key: key);

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
      print('Initiate normal app start.');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      // Onboarding
      print('Start onboarding.');
    }
  }

  /// Load the saved settings and parse it
  void loadSettings() {
    print('LoadSettings initalized.');
    getApplicationDocumentsDirectory().then((Directory directory) {
      _directoryPath = directory.path;
      print('Save location: ' + _directoryPath.toString());

      // Load settings async
      File settingsJsonFile = File(_directoryPath + '/settings.json');

      // Check if settings file already exists
      settingsJsonFile.exists().then((bool existing) {
        if (existing) {
          print('Settings-file already exists. Initialize loading of settings.');
          // Load settings and parse it
          settingsJsonFile.readAsString().then((String rawFileContent) {
            if (rawFileContent != '') {
              dynamic rawData = json.decode(rawFileContent);
              loadedSettings = Settings.fromJson(rawData);

              print('Settings loaded.');

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
          print('Settings-file created.');
          settingsJsonFile.create();
          Map<String, dynamic> initialSettings = {'useSystemDarkmode': true, 'useDarkmode': false};
          settingsJsonFile.writeAsString(json.encode(initialSettings));
        }

        // Timer for statistics
        loadingTimer.stop();
        print('-- loading time: ' + loadingTimer.elapsedMilliseconds.toString() + ' ms');
        idleTimer.start();
      });
    });
  }

  /// Given the loaded settings, listen to the system brightness mode and apply the theme
  void setTheme({
    required BuildContext contextForThemeProvider,
    bool useSystemDarkmode = true,
    bool useDarkmode = false,
  }) {}

  // ? DEBUG ONLY
  void _debugDeleteSettings() async {
    File jsonFile = File(_directoryPath + '/settings.json');
    jsonFile.delete().then((_) => print('DEBUG: Settings-Datei gelöscht.'));
  }

  @override
  void initState() {
    super.initState();

    // load saved settings
    loadingTimer.start();
    loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    // Timer before the app moves on to the home page to give the loading some time
    final Timer startingTimer = Timer(const Duration(seconds: 1), () {
      idleTimer.stop();
      print('-- idle time: ' + idleTimer.elapsedMilliseconds.toString() + ' ms');
      startApp(context);
    });

    return Container(
      color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      child: const Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
