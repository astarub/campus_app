import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsHandler with ChangeNotifier {
  /// The save location for the settings
  String _directoryPath = '';

  /// Holds the currently used settings
  Settings _currentSettings = Settings();

  /// Is used for appyling the loaded settings
  void setLoadedSettings(Settings loadedSettings) {
    _currentSettings = loadedSettings;
    notifyListeners();
  }

  set currentSettings(Settings newSettings) {
    _currentSettings = newSettings;
    notifyListeners();

    // Save new settings
    if (_directoryPath == '') {
      getApplicationDocumentsDirectory().then((Directory directory) {
        _directoryPath = directory.path;
        final File settingsJsonFile = File('$_directoryPath/settings.json');
        settingsJsonFile.writeAsString(json.encode(newSettings.toJson()));
      });
    } else {
      final File settingsJsonFile = File('$_directoryPath/settings.json');
      settingsJsonFile.writeAsString(json.encode(newSettings.toJson()));
    }
  }

  Settings get currentSettings => _currentSettings;
}

class Settings {
  final bool useSystemDarkmode;
  final bool useDarkmode;
  final List<String> mensaPreferences;
  final List<String> mensaAllergenes;

  Settings({
    this.useSystemDarkmode = true,
    this.useDarkmode = false,
    this.mensaPreferences = const [],
    this.mensaAllergenes = const [],
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      useSystemDarkmode: json['useSystemDarkmode'] ?? true,
      useDarkmode: json['useDarkmode'] ?? false,
      mensaPreferences:
          json['mensaPreferences'] != null ? List<String>.from(json['mensaPreferences']) : [] as List<String>,
      mensaAllergenes:
          json['mensaAllergenes'] != null ? List<String>.from(json['mensaAllergenes']) : [] as List<String>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'useSystemDarkmode': useSystemDarkmode,
      'useDarkmode': useDarkmode,
      'mensaPreferences': mensaPreferences,
      'mensaAllergenes': mensaAllergenes,
    };
  }
}
