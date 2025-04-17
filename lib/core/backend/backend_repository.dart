import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:campus_app/core/backend/entities/account_entity.dart';
import 'package:campus_app/core/backend/entities/publisher_entity.dart';
import 'package:campus_app/core/backend/entities/study_course_entity.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:campus_app/utils/onboarding_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slugid/slugid.dart';

// TODO: BackendRepository Refactoring
//    1.) It's implementation is too long: 500+ lines of code
//    2.) It mix-ups multiple features and/or clean-architecture-layers:
//        - e.g. the function `loadMensaRestaurantConfig` mensa feature
//        - e.g. the `addSavedEvent` is a usecase of the calendar / feed
//        - "Backend" is in general a vague term, so a better approach would be
//          writing e.g. a user / authentication feature for the auth handling
class BackendRepository {
  final Client client;
  bool authenticated = false;

  BackendRepository({
    required this.client,
  });

  Future<void> addSavedEvent(SettingsHandler settingsHandler, Event event) async {
    final Databases databaseService = Databases(client);

    if (settingsHandler.currentSettings.useFirebase == FirebaseStatus.forbidden ||
        settingsHandler.currentSettings.useFirebase == FirebaseStatus.uncofigured ||
        !settingsHandler.currentSettings.savedEventsNotifications) {
      return;
    }

    final String eventUrlHost = Uri.parse(event.url).host;

    try {
      final document = await databaseService.createDocument(
        databaseId: 'push_notifications',
        collectionId: 'saved_events',
        documentId: ID.unique(),
        data: {
          'fcmToken': settingsHandler.currentSettings.backendAccount.fcmToken,
          'eventId': event.id,
          'startDate': DateFormat('yyyy-MM-dd HH:mm:ss Z', 'de_DE').format(event.startDate),
          'host': eventUrlHost,
        },
        permissions: [
          Permission.read(
            Role.user(settingsHandler.currentSettings.backendAccount.id),
          ),
          Permission.write(
            Role.user(settingsHandler.currentSettings.backendAccount.id),
          ),
        ],
      );

      List<Map<String, dynamic>> savedEvents = settingsHandler.currentSettings.backendAccount.savedEvents;

      if (savedEvents.isEmpty) savedEvents = [];

      savedEvents.add({
        'eventId': event.id,
        'documentId': document.$id,
        'host': eventUrlHost,
        'startDate': DateFormat('yyyy-MM-dd HH:mm:ss Z', 'de_DE').format(event.startDate),
      });

      settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
        backendAccount: settingsHandler.currentSettings.backendAccount.copyWith(savedEvents: savedEvents),
      );

      await FirebaseMessaging.instance.subscribeToTopic('${eventUrlHost}_${event.id}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> createAccount(SettingsHandler settingsHandler) async {
    final Functions functionService = Functions(client);

    final String userId = Slugid.nice().toString();
    final String password = Slugid.v4().toString();

    try {
      final result = await functionService.createExecution(
        functionId: 'create_user',
        body: jsonEncode(
          {
            'api_key': appwriteCreateUserKey,
            'userId': userId,
            'email': '$userId@app.asta-bochum.de',
            'password': password,
          },
        ),
      );

      if (result.responseStatusCode != 200 ||
          result.responseBody == '"Incorrect api key. Please provide a valid api key."') {
        debugPrint(
          'Error while creating an account at the backend. Error: ${result.responseBody}',
        );
        throw AuthenticationException();
      }

      debugPrint('Successfully created an account at the backend.');

      settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
        backendAccount: settingsHandler.currentSettings.backendAccount.copyWith(
          id: userId,
          password: password,
        ),
      );
    } on AppwriteException catch (e) {
      debugPrint(e.message);

      throw ServerException();
    }
  }

  Future<void> createLastLoginDocument(SettingsHandler settingsHandler) async {
    final Databases databaseService = Databases(client);

    try {
      final document = await databaseService.createDocument(
        databaseId: 'accounts',
        collectionId: 'last_login',
        documentId: ID.unique(),
        data: {
          'userId': settingsHandler.currentSettings.backendAccount.id,
          'date': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(
            Role.user(settingsHandler.currentSettings.backendAccount.id),
          ),
          Permission.write(
            Role.user(settingsHandler.currentSettings.backendAccount.id),
          ),
        ],
      );

      settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
        backendAccount: settingsHandler.currentSettings.backendAccount.copyWith(lastLoginDocumentId: document.$id),
      );

      debugPrint('Created last login document on the server side.');
    } on AppwriteException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<List<Map<String, dynamic>>> getSavedEvents(SettingsHandler settingsHandler) async {
    final Databases databaseService = Databases(client);

    models.DocumentList? list;

    List<Map<String, dynamic>> events = [];

    try {
      list = await databaseService.listDocuments(
        databaseId: 'push_notifications',
        collectionId: 'saved_events',
        queries: [Query.equal('fcmToken', settingsHandler.currentSettings.backendAccount.fcmToken)],
      );
    } on AppwriteException catch (e) {
      debugPrint(
        'Could not fetch saved events. Exception: ${e.message}',
      );
    }

    if (list != null) {
      events = list.documents.map((e) => e.data).toList();
    }

    return events;
  }

  Future<void> loadMensaRestaurantConfig(SettingsHandler settingsHandler) async {
    final Databases databaseService = Databases(client);

    models.Document doc;

    try {
      doc = await databaseService.getDocument(
        databaseId: 'data',
        collectionId: 'config',
        documentId: 'mensa_restaurant_config',
      );
    } on AppwriteException catch (e) {
      debugPrint('Exception while fetching the Mensa restaurant config : ${e.message}');

      return;
    }

    final List<Map<String, dynamic>> temp = [];

    for (final String v in doc.data['value']) {
      try {
        temp.add(Map<String, dynamic>.from(jsonDecode(v)));
      } catch (e) {
        debugPrint('Could not parse the JSON Mensa restaurant config.');
      }
    }

    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(mensaRestaurantConfig: temp);

    debugPrint('Loaded mensa restaurant config.');
  }

  Future<void> loadPublishers(SettingsHandler settingsHandler) async {
    final Databases databaseService = Databases(client);

    models.DocumentList list;

    try {
      list = await databaseService.listDocuments(
        databaseId: 'data',
        collectionId: 'publishers',
        queries: [Query.limit(150)],
      );
    } on AppwriteException catch (e) {
      debugPrint('Exception while fetching the publishers: ${e.message}');

      return;
    }

    final List<Publisher> publishers = list.documents.map((d) => Publisher.fromJson(json: d.data)).toList();
    final List<String> publisherNames = publishers.map((e) => e.name).toList();

    final List<Publisher> clearedFeedFilters = [];
    final List<Publisher> clearedEventFilters = [];

    // Adds new publishers that are marked as initially displayed to the filters
    final List<String> oldPublisherNames = settingsHandler.currentSettings.publishers.map((e) => e.name).toList();
    final List<int> oldPublisherIds = settingsHandler.currentSettings.publishers.map((e) => e.id).toList();

    final List<Publisher> initiallyDisplayed = publishers
        .where(
          (publisher) =>
              !oldPublisherNames.contains(publisher.name) &&
              !oldPublisherIds.contains(publisher.id) &&
              publisher.initiallyDisplayed,
        )
        .toList();

    clearedFeedFilters.addAll(initiallyDisplayed);
    clearedEventFilters.addAll(initiallyDisplayed);

    // Removes all feed filters that are no longer on the backend
    if (settingsHandler.currentSettings.feedFilter.isNotEmpty) {
      for (final f in settingsHandler.currentSettings.feedFilter) {
        if (publisherNames.contains(f.name) || f.name == 'RUB' || f.name == 'AStA') {
          clearedFeedFilters.add(f);
        }
      }
    }

    // Removes all event filters that are no longer on the backend
    if (settingsHandler.currentSettings.eventsFilter.isNotEmpty) {
      for (final f in settingsHandler.currentSettings.eventsFilter) {
        if (publisherNames.contains(f.name) || f.name == 'AStA') {
          clearedEventFilters.add(f);
        }
      }
    }

    publishers.sort((a, b) => a.name.compareTo(b.name));

    settingsHandler.currentSettings = settingsHandler.currentSettings
        .copyWith(feedFilter: clearedFeedFilters, eventsFilter: clearedEventFilters, publishers: publishers);

    debugPrint('Loaded publishers.');
  }

  Future<void> loadStudyCourses(SettingsHandler settingsHandler) async {
    final Databases databaseService = Databases(client);

    models.DocumentList? list;

    List<StudyCourse> courses = [];

    try {
      list = await databaseService.listDocuments(
        databaseId: 'data',
        collectionId: 'study_courses',
        queries: [Query.limit(150)],
      );
    } on AppwriteException catch (e) {
      debugPrint(
        'Could not fetch remote study courses on time. Falling back to static study courses. Exception: ${e.message}',
      );

      for (final course in staticStudyCourses) {
        courses.add(StudyCourse.empty(name: course));
      }
    }

    if (list != null) {
      courses = list.documents.map((d) => StudyCourse.fromJson(json: d.data)).toList();
    }

    courses.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(studyCourses: courses);

    debugPrint('Loaded study courses.');
  }

  Future<void> login(SettingsHandler settingsHandler) async {
    final Account accountService = Account(client);

    if (settingsHandler.currentSettings.backendAccount.id == '') {
      try {
        await createAccount(settingsHandler);
      } catch (e) {
        return;
      }
    }

    try {
      await accountService.createEmailPasswordSession(
        email: '${settingsHandler.currentSettings.backendAccount.id}@app.asta-bochum.de',
        password: settingsHandler.currentSettings.backendAccount.password,
      );

      debugPrint('Successfully logged in to the backend.');
    } on AppwriteException catch (e) {
      if (e.message!.contains('Invalid credentials')) {
        debugPrint(
          'Account seems to be deleted on the server side. Creating new account...',
        );
        settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
          backendAccount: const BackendAccount.empty(),
        );

        //await login(settingsHandler);
      } else {
        debugPrint(e.message);
      }
    }

    if (settingsHandler.currentSettings.backendAccount.lastLoginDocumentId == '') {
      await createLastLoginDocument(settingsHandler);
      return;
    }

    await updateLastLoginDocument(settingsHandler);
  }

  Future<void> removeAllSavedEvents(SettingsHandler settingsHandler) async {
    final Databases databaseService = Databases(client);

    if (settingsHandler.currentSettings.backendAccount.fcmToken == '') return;

    final List<Map<String, dynamic>> savedEvents = List.from(
      settingsHandler.currentSettings.backendAccount.savedEvents,
    );

    final List<Map<String, dynamic>> toRemove = [];

    for (final Map<String, dynamic> savedEvent in savedEvents) {
      try {
        await databaseService.deleteDocument(
          databaseId: 'push_notifications',
          collectionId: 'saved_events',
          documentId: savedEvent['documentId'],
        );
      } on AppwriteException catch (e) {
        if (e.message!.contains('lookup')) {
          throw NoConnectionException();
        }
        continue;
      }
      toRemove.add(savedEvent);
    }

    savedEvents.removeWhere(toRemove.contains);

    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
      backendAccount: settingsHandler.currentSettings.backendAccount.copyWith(savedEvents: savedEvents),
    );

    if (toRemove.isNotEmpty) {
      debugPrint('Successfully removed all saved events from the database.');
    }
    return;
  }

  Future<void> removeSavedEvent(SettingsHandler settingsHandler, int eventId, String eventUrlHost) async {
    final Databases databaseService = Databases(client);

    if (settingsHandler.currentSettings.useFirebase == FirebaseStatus.forbidden ||
        settingsHandler.currentSettings.useFirebase == FirebaseStatus.uncofigured ||
        !settingsHandler.currentSettings.savedEventsNotifications) {
      return;
    }

    String documentId = '';
    try {
      final Map<String, dynamic> savedEvent = settingsHandler.currentSettings.backendAccount.savedEvents
          .firstWhere((element) => element['eventId'] == eventId && element['host'] == eventUrlHost);

      documentId = savedEvent['documentId'];
    } catch (e) {
      return;
    }

    try {
      await databaseService.deleteDocument(
        databaseId: 'push_notifications',
        collectionId: 'saved_events',
        documentId: documentId,
      );
    } on AppwriteException catch (e) {
      debugPrint(e.message);

      return;
    }

    final List<Map<String, dynamic>> savedEvents = settingsHandler.currentSettings.backendAccount.savedEvents;

    try {
      savedEvents.removeWhere((element) => element['documentId'] == documentId);
    } catch (e) {
      return;
    }

    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
      backendAccount: settingsHandler.currentSettings.backendAccount.copyWith(savedEvents: savedEvents),
    );

    await FirebaseMessaging.instance.unsubscribeFromTopic('${eventUrlHost}_$eventId');
  }

  Future<void> unsubscribeFromAllSavedEvents(SettingsHandler settingsHandler) async {
    final List<Map<String, dynamic>> savedEvents = List.from(
      settingsHandler.currentSettings.backendAccount.savedEvents,
    );

    for (final Map<String, dynamic> savedEvent in savedEvents) {
      try {
        await FirebaseMessaging.instance.unsubscribeFromTopic("${savedEvent['host']}_${savedEvent['eventId']}");
      } catch (e) {
        debugPrint(e.toString());
        continue;
      }
    }
  }

  Future<bool> updateAvailable(SettingsHandler settingsHandler) async {
    final Databases databaseService = Databases(client);

    models.Document document;
    try {
      document = await databaseService.getDocument(
        databaseId: 'data',
        collectionId: 'config',
        documentId: 'latestVersion',
      );
    } on AppwriteException catch (e) {
      debugPrint(e.toString());

      return false;
    }

    if (document.data['value'] == null || List.from(document.data['value'])[0] == null) {
      return false;
    }

    final String latestVersion = List.from(document.data['value'])[0] as String;

    bool available = false;

    if (settingsHandler.currentSettings.latestVersion != '' &&
        settingsHandler.currentSettings.latestVersion != latestVersion) {
      debugPrint('There is an update available!');

      available = true;
    }

    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
      latestVersion: latestVersion,
    );
    return available;
  }

  Future<void> updateLastLoginDocument(SettingsHandler settingsHandler) async {
    final Databases databaseService = Databases(client);

    try {
      await databaseService.updateDocument(
        databaseId: 'accounts',
        collectionId: 'last_login',
        documentId: settingsHandler.currentSettings.backendAccount.lastLoginDocumentId,
        data: {'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().add(const Duration(hours: 2)))},
      );

      debugPrint('Updated last login date.');
    } on AppwriteException catch (e) {
      debugPrint(e.message);

      if (e.message!.contains('Document with the requested ID could not be found.')) {
        debugPrint('Last login document seems to be gone. Creating new one...');

        await createLastLoginDocument(settingsHandler);
      }
    }
  }
}
