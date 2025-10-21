import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:campus_app/core/backend/entities/account_entity.dart';
import 'package:campus_app/core/backend/entities/publisher_entity.dart';
import 'package:campus_app/core/backend/entities/study_course_entity.dart';

enum FirebaseStatus { uncofigured, forbidden, permitted }

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

  /// Notifies the listeners whenever the settings are changed and saves
  /// the new settings.
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
  final List<Publisher> feedFilter;
  final bool newsExplore;
  final List<Publisher> eventsFilter;
  final List<String> mensaPreferences;
  final List<String> mensaAllergenes;
  final bool useExternalBrowser;
  final bool useSystemTextScaling;
  final FirebaseStatus useFirebase;
  final bool studyCoursePopup;
  final List<StudyCourse> selectedStudyCourses;
  final List<StudyCourse> studyCourses;
  final List<Publisher> publishers;
  final bool savedEventsNotifications;
  final BackendAccount backendAccount;
  final String latestVersion;
  final bool displayFullscreenTicket;
  final double? lastMensaBalance;
  final double? lastMensaTransaction;
  final List<Map<String, dynamic>>? mensaRestaurantConfig;
  final bool firstTimePathfinder;

  Settings({
    this.useSystemDarkmode = true,
    this.useDarkmode = false,
    this.feedFilter = const [],
    this.newsExplore = false,
    this.eventsFilter = const [],
    this.mensaPreferences = const [],
    this.mensaAllergenes = const [],
    this.mensaRestaurantConfig = const [],
    this.useExternalBrowser = false,
    this.useSystemTextScaling = false,
    this.useFirebase = FirebaseStatus.uncofigured,
    this.studyCoursePopup = false,
    this.selectedStudyCourses = const [],
    this.studyCourses = const [],
    this.publishers = const [],
    this.savedEventsNotifications = true,
    this.backendAccount = const BackendAccount.empty(),
    this.latestVersion = '',
    this.displayFullscreenTicket = false,
    this.lastMensaBalance,
    this.lastMensaTransaction,
    this.firstTimePathfinder = true,
  });

  Settings copyWith({
    bool? useSystemDarkmode,
    bool? useDarkmode,
    List<Publisher>? feedFilter,
    bool? newsExplore,
    List<Publisher>? eventsFilter,
    List<String>? mensaPreferences,
    List<String>? mensaAllergenes,
    List<Map<String, dynamic>>? mensaRestaurantConfig,
    bool? useExternalBrowser,
    bool? useSystemTextScaling,
    FirebaseStatus? useFirebase,
    bool? studyCoursePopup,
    List<StudyCourse>? selectedStudyCourses,
    List<StudyCourse>? studyCourses,
    List<Publisher>? publishers,
    bool? savedEventsNotifications,
    BackendAccount? backendAccount,
    String? latestVersion,
    bool? displayFullscreenTicket,
    double? lastMensaBalance,
    double? lastMensaTransaction,
    bool? firstTimePathfinder,
  }) =>
      Settings(
        useSystemDarkmode: useSystemDarkmode ?? this.useSystemDarkmode,
        useDarkmode: useDarkmode ?? this.useDarkmode,
        feedFilter: feedFilter ?? this.feedFilter,
        newsExplore: newsExplore ?? this.newsExplore,
        eventsFilter: eventsFilter ?? this.eventsFilter,
        mensaPreferences: mensaPreferences ?? this.mensaPreferences,
        mensaAllergenes: mensaAllergenes ?? this.mensaAllergenes,
        useExternalBrowser: useExternalBrowser ?? this.useExternalBrowser,
        useSystemTextScaling: useSystemTextScaling ?? this.useSystemTextScaling,
        useFirebase: useFirebase ?? this.useFirebase,
        studyCoursePopup: studyCoursePopup ?? this.studyCoursePopup,
        selectedStudyCourses: selectedStudyCourses ?? this.selectedStudyCourses,
        studyCourses: studyCourses ?? this.studyCourses,
        publishers: publishers ?? this.publishers,
        savedEventsNotifications: savedEventsNotifications ?? this.savedEventsNotifications,
        backendAccount: backendAccount ?? this.backendAccount,
        latestVersion: latestVersion ?? this.latestVersion,
        displayFullscreenTicket: displayFullscreenTicket ?? this.displayFullscreenTicket,
        lastMensaBalance: lastMensaBalance ?? this.lastMensaBalance,
        lastMensaTransaction: lastMensaTransaction ?? this.lastMensaTransaction,
        mensaRestaurantConfig: mensaRestaurantConfig ?? this.mensaRestaurantConfig,
        firstTimePathfinder: firstTimePathfinder ?? this.firstTimePathfinder,
      );

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      useSystemDarkmode: json['useSystemDarkmode'] ?? true,
      useDarkmode: json['useDarkmode'] ?? false,
      feedFilter: json['newFeedFilter'] != null
          ? List<Map<String, dynamic>>.from(json['newFeedFilter']).map((c) => Publisher.fromJson(json: c)).toList()
          : List<Publisher>.from([]),
      newsExplore: json['newsExplore'] ?? false,
      eventsFilter: json['eventsFilter'] != null
          ? List<Map<String, dynamic>>.from(json['eventsFilter']).map((c) => Publisher.fromJson(json: c)).toList()
          : List<Publisher>.from([]),
      mensaPreferences:
          json['mensaPreferences'] != null ? List<String>.from(json['mensaPreferences']) : List<String>.from([]),
      mensaAllergenes:
          json['mensaAllergenes'] != null ? List<String>.from(json['mensaAllergenes']) : List<String>.from([]),
      mensaRestaurantConfig: json['mensaRestaurantConfig'] != null
          ? List<Map<String, dynamic>>.from(json['mensaRestaurantConfig'])
          : List<Map<String, dynamic>>.from([]),
      useExternalBrowser: json['useExternalBrowser'] ?? false,
      useSystemTextScaling: json['useSystemTextScaling'] ?? false,
      useFirebase: json['useFirebase'] == 2
          ? FirebaseStatus.permitted
          : json['useFirebase'] == 1
              ? FirebaseStatus.forbidden
              : FirebaseStatus.uncofigured,
      studyCoursePopup: json['studyCoursePopup'] ?? false,
      selectedStudyCourses: json['selectedStudyCourses'] != null
          ? List<Map<String, dynamic>>.from(json['selectedStudyCourses'])
              .map((c) => StudyCourse.fromJson(json: c))
              .toList()
          : List<StudyCourse>.from([]),
      // Renamed to newStudyCourses as older settings file might provide wrong data
      studyCourses: json['newStudyCourses'] != null
          ? List<Map<String, dynamic>>.from(json['newStudyCourses']).map((c) => StudyCourse.fromJson(json: c)).toList()
          : List<StudyCourse>.from([]),
      publishers: json['publishers'] != null
          ? List<Map<String, dynamic>>.from(json['publishers']).map((c) => Publisher.fromJson(json: c)).toList()
          : List<Publisher>.from([]),
      savedEventsNotifications: json['savedEventsNotifications'] ?? true,
      backendAccount: json['backendAccount'] != null
          ? BackendAccount.fromJson(json: Map<String, dynamic>.from(json['backendAccount']))
          : const BackendAccount.empty(),
      latestVersion: json['latestVersion'] ?? '',
      displayFullscreenTicket: json['displayFullscreenTicket'] ?? false,
      lastMensaBalance: json['lastMensaBalance'],
      lastMensaTransaction: json['lastMensaTransaction'],
      firstTimePathfinder: json['firstTimePathfinder'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'useSystemDarkmode': useSystemDarkmode,
      'useDarkmode': useDarkmode,
      'newFeedFilter': feedFilter.map((p) => p.toInternalJson()).toList(),
      'newsExplore': newsExplore,
      'eventsFilter': eventsFilter.map((p) => p.toInternalJson()).toList(),
      'mensaPreferences': mensaPreferences,
      'mensaAllergenes': mensaAllergenes,
      'mensaRestaurantConfig': mensaRestaurantConfig,
      'useExternalBrowser': useExternalBrowser,
      'useSystemTextScaling': useSystemTextScaling,
      'useFirebase': useFirebase == FirebaseStatus.permitted
          ? 2
          : useFirebase == FirebaseStatus.forbidden
              ? 1
              : 0,
      'studyCoursePopup': studyCoursePopup,
      'selectedStudyCourses': selectedStudyCourses.map((p) => p.toInternalJson()).toList(),
      'newStudyCourses': studyCourses.map((c) => c.toInternalJson()).toList(),
      'publishers': publishers.map((p) => p.toInternalJson()).toList(),
      'savedEventsNotifications': savedEventsNotifications,
      'backendAccount': backendAccount.toInternalJson(),
      'latestVersion': latestVersion,
      'displayFullscreenTicket': displayFullscreenTicket,
      'lastMensaBalance': lastMensaBalance,
      'lastMensaTransaction': lastMensaTransaction,
      'firstTimePathfinder': firstTimePathfinder,
    };
  }
}
