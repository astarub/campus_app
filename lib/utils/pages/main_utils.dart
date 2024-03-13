import 'dart:async';
import 'dart:convert';

import 'package:campus_app/pages/home/widgets/study_course_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:campus_app/main.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:campus_app/core/backend/entities/publisher_entity.dart';
import 'package:campus_app/core/backend/entities/study_course_entity.dart';
import 'package:campus_app/firebase_options.dart';
import 'package:campus_app/pages/home/widgets/firebase_popup.dart';
import 'package:campus_app/pages/calendar/calendar_detail_page.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/more/in_app_web_view_page.dart';

enum FGBGType { foreground, background }

/// This stream listener gives the possibility to listen to if the app is
/// currently in the foreground or in the background.
///
/// Flutter has WidgetsBindingObserver to get notified when app changes its state
/// from active to inactive states and back. But it actually includes the state
/// changes of the embedding Activity/ViewController as well.
///
/// This stream however, reports the events only at app level.
///
/// Usage example:
/// ```
/// subscription = FGBGEvents.stream.listen((event) {
///   print(event); // FGBGType.foreground or FGBGType.background
/// });
/// ```
class FGBGEvents {
  static const _channel = EventChannel('events');
  static Stream<FGBGType>? _stream;

  static Stream<FGBGType> get stream {
    return _stream ??= _channel
        .receiveBroadcastStream()
        .map((event) => event == 'foreground' ? FGBGType.foreground : FGBGType.background);
  }
}

class MainUtils {
  // Deep link handling
  bool initialUriHandled = false;
  // ignore: cancel_subscriptions
  StreamSubscription? subscription;

  final CalendarUsecases calendarUsecases = sl<CalendarUsecases>();

  final BackendRepository backendRepository = sl<BackendRepository>();

  Map<String, AndroidNotificationChannel> androidChannels = {
    'notifications': const AndroidNotificationChannel(
      'notifications',
      'Notification Channel',
      description: 'This channel is used to display general notifications.',
      importance: Importance.max,
    ),
    'savedEvents': const AndroidNotificationChannel(
      'savedEvents',
      'Saved Event Reminders',
      description: 'This channel is used to send reminders about upcoming saved events.',
      importance: Importance.high,
    ),
  };

  /// Handle app/universal links when the app is terminated
  Future<void> handleInitialUri() async {
    if (initialUriHandled) return;
    initialUriHandled = true;

    try {
      final uri = await getInitialUri();

      if (uri == null) return;
      // Distinguish between news and potentially other categories
      switch (uri.pathSegments[0]) {
        case 'termine':
          {
            if (homeKey.currentState == null) return;
            // Navigate to the calendar page
            await homeKey.currentState!.selectedPage(PageItem.events);
            break;
          }
        case 'termin':
          {
            // Fetch all events from the AStA event calendar
            final eventData = await calendarUsecases.updateEventsAndFailures();
            final events = eventData['events']! as List<Event>;

            if (homeKey.currentState == null) return;
            // Navigate to the calendar page
            await homeKey.currentState!.selectedPage(PageItem.events);

            final url = 'https://${uri.host}${uri.path}';

            // Get the event object by the specified url if a specific event is passed as an argument. Otherwise only the events page will be displayed.
            Event event;
            try {
              event = events.firstWhere((element) => element.url == url);
            } catch (e) {
              return;
            }

            // Push the CalendarDetailPage onto the navigator of the current page
            await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!
                .push(MaterialPageRoute(builder: (_) => CalendarDetailPage(event: event)));

            break;
          }
        default:
          return;
      }
    } catch (e) {
      debugPrint('Cannot get initial uri.');
    }
  }

  /// Handle incoming app/universal link
  void handleIncomingLink() {
    // Subscribe to the link stream
    subscription = uriLinkStream.listen(
      (Uri? uri) async {
        if (uri == null) return;
        // Distinguish between news and potentially other categories
        switch (uri.pathSegments[0]) {
          case 'termine':
            {
              if (homeKey.currentState == null) return;
              // Navigate to the calendar page
              await homeKey.currentState!.selectedPage(PageItem.events);
              break;
            }
          case 'termin':
            {
              // Fetch all events from the AStA event calendar
              final eventData = await calendarUsecases.updateEventsAndFailures();
              final events = eventData['events']! as List<Event>;

              final url = 'https://${uri.host}${uri.path}';

              // Get the event object by the specified url if a specific event is passed as an argument. Otherwise only the events page will be displayed.
              Event event;
              try {
                event = events.firstWhere((element) => element.url == url);
              } catch (e) {
                return;
              }

              if (homeKey.currentState == null) return;
              // Navigate to the calendar page
              await homeKey.currentState!.selectedPage(PageItem.events);

              // Push the CalendarDetailPage onto the navigator of the current page
              await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!
                  .push(MaterialPageRoute(builder: (_) => CalendarDetailPage(event: event)));

              break;
            }
          default:
            return;
        }
      },
      onError: (err) {
        debugPrint(err);
      },
    );
  }

  Future<FlutterLocalNotificationsPlugin> initializeLocalNotifications() async {
    // Local notifications on Android
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    const DarwinInitializationSettings initializationSettingsIos = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'notifications',
          options: <DarwinNotificationCategoryOption>{DarwinNotificationCategoryOption.hiddenPreviewShowTitle},
        ),
        DarwinNotificationCategory(
          'savedEvents',
          options: <DarwinNotificationCategoryOption>{DarwinNotificationCategoryOption.hiddenPreviewShowTitle},
        ),
      ],
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload == null) return;
        if (homeKey.currentState == null) return;

        final String payload = response.payload!;

        Map<String, dynamic> data = {};
        Map<String, dynamic> interaction = {};

        // Decode JSON payload from the message data
        try {
          data = jsonDecode(payload);

          if (data['interaction'] == null) return;

          interaction = jsonDecode(data['interaction']);
        } catch (e) {
          throw JsonException();
        }
        if (interaction['destination'] == null) return;

        // Deal with different actions specified in the message data
        switch (interaction['destination']) {
          case 'calendar':
            {
              if (interaction['data'] == null) return;

              final List<dynamic> interactionData = interaction['data'];

              // Retrieves all events from the calendar
              final Map<String, List<dynamic>> eventsAndFailures = await calendarUsecases.updateEventsAndFailures();
              final List<Event> events = eventsAndFailures['events']! as List<Event>;

              if (interactionData[0] == null || List<Map<String, dynamic>>.from(interactionData)[0]['event'] == null) {
                return;
              }

              final Map<String, dynamic> eventJson = List<Map<String, dynamic>>.from(interactionData)[0]['event'];

              // Get the event according to the id in the message payload
              Event event;
              try {
                event = events.firstWhere((element) => element.url == eventJson['url']);
              } catch (e) {
                return;
              }

              // Change page
              await homeKey.currentState!.selectedPage(PageItem.events);
              // Push the CalendarDetailPage onto the navigator of the current page
              await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!.push(
                MaterialPageRoute(
                  builder: (_) => CalendarDetailPage(event: event),
                ),
              );

              break;
            }
          case 'mensa':
            {
              await homeKey.currentState!.selectedPage(PageItem.mensa);

              break;
            }
          case 'wallet':
            {
              await homeKey.currentState!.selectedPage(PageItem.wallet);

              break;
            }
          case 'more':
            {
              await homeKey.currentState!.selectedPage(PageItem.more);

              break;
            }
          case 'link':
            {
              // Checks if a notification payload is present
              if (interaction['data'] == null) return;

              final List<dynamic> interactionData = interaction['data'];

              if (interactionData[0] == null) return;

              final String url = interactionData[0];

              // Decides whether the link should be opened in the app or in an external browser
              // ignore: use_build_context_synchronously
              if (Provider.of<SettingsHandler>(homeKey.currentState!.context, listen: false)
                      .currentSettings
                      .useExternalBrowser ||
                  url.contains('instagram') ||
                  url.contains('facebook') ||
                  url.contains('twitch') ||
                  url.contains('mailto:') ||
                  url.contains('tel:')) {
                // Open in external browser
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                // Open in InAppView
                await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!
                    .push(MaterialPageRoute(builder: (context) => InAppWebViewPage(url: url)));
              }
            }
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannels['notifications']!);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannels['savedEvents']!);

    return flutterLocalNotificationsPlugin;
  }

  /// This function checks if the firebase permission is `FirebaseStatus.unconfigured`.
  /// If so, it shows a popup to ask wether or not the user wants to use Firebase.
  ///
  /// If the _useFirebase_ setting is already set to `permitted`,
  /// the function [initializeFirebase] is called.
  Future<void> checkFirebasePermission(BuildContext context, GlobalKey<NavigatorState> mainKey) async {
    final SettingsHandler settingsHandler = Provider.of<SettingsHandler>(context, listen: false);
    if (settingsHandler.currentSettings.useFirebase == FirebaseStatus.uncofigured) {
      Timer(
        const Duration(seconds: 2),
        () => mainKey.currentState?.push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) => FirebasePopup(
              onClose: ({bool permissionGranted = false}) {
                final Settings newSettings;

                if (permissionGranted) {
                  // User accepted to use Google services
                  newSettings = settingsHandler.currentSettings.copyWith(useFirebase: FirebaseStatus.permitted);

                  initializeFirebase(context);
                } else {
                  // User denied to use Google services
                  newSettings = settingsHandler.currentSettings.copyWith(useFirebase: FirebaseStatus.forbidden);
                }

                debugPrint('Set Firebase permission: ${newSettings.useFirebase}');
                settingsHandler.currentSettings = newSettings;

                // Check whether the user already chose their study courses
                if (!settingsHandler.currentSettings.studyCoursePopup) {
                  Timer(
                    const Duration(seconds: 2),
                    () => mainKey.currentState?.push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, _, __) => const StudyCoursePopup(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    } else if (settingsHandler.currentSettings.useFirebase == FirebaseStatus.permitted) {
      await initializeFirebase(context);

      // Check whether the user already chose their study courses
      if (!settingsHandler.currentSettings.studyCoursePopup) {
        Timer(
          const Duration(seconds: 2),
          () => mainKey.currentState?.push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, _, __) => const StudyCoursePopup(),
            ),
          ),
        );
      }
    } else if (settingsHandler.currentSettings.useFirebase == FirebaseStatus.forbidden) {
      try {
        await backendRepository.removeAllSavedEvents(
          settingsHandler,
        );
      } catch (e) {
        debugPrint(
          'Could not remove all events from the database while trying to remove the device from Firebase. Retrying next restart.',
        );
      }

      try {
        await FirebaseMessaging.instance.deleteToken();
      } catch (e) {
        debugPrint(
          'Error while trying to remove the device from Firebase. Please check your connection.',
        );
      }

      // Check whether the user already chose their study courses
      if (!settingsHandler.currentSettings.studyCoursePopup) {
        Timer(
          const Duration(seconds: 2),
          () => mainKey.currentState?.push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, _, __) => const StudyCoursePopup(),
            ),
          ),
        );
      }
    }
  }

  /// This function initializes the Google Firebase services and FCM
  Future<void> initializeFirebase(BuildContext context) async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Request notifications permissions on iOS
    await FirebaseMessaging.instance.requestPermission();

    String fcmToken = '';
    try {
      // Get the FCM Token
      fcmToken = (await FirebaseMessaging.instance.getToken())!;

      debugPrint(fcmToken);
    } catch (e) {
      return;
    }

    // Enable foreground notifications on iOs
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    if (context.mounted) {
      final SettingsHandler settings = Provider.of<SettingsHandler>(context, listen: false);

      settings.currentSettings = settings.currentSettings.copyWith(
        backendAccount: settings.currentSettings.backendAccount.copyWith(fcmToken: fcmToken),
      );
    }

    // Initialize the notification interaction handler
    await setupFirebaseInteraction();

    // Subscribes the app to the default notifications topic in order to send notifications via the FCM API
    await FirebaseMessaging.instance.subscribeToTopic('defaultNotifications');

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = await initializeLocalNotifications();

    // Display foreground notifications on Android
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;

      if (notification != null && message.notification?.android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              notification.android!.channelId != null
                  ? androidChannels[notification.android!.channelId!]!.id
                  : androidChannels['notifications']!.id,
              notification.android!.channelId != null
                  ? androidChannels[notification.android!.channelId!]!.name
                  : androidChannels['notifications']!.name,
              channelDescription: notification.android!.channelId != null
                  ? androidChannels[notification.android!.channelId!]!.description
                  : androidChannels['notifications']!.description,
              icon: '@drawable/ic_notification',
              color: const Color.fromRGBO(0, 202, 245, 1),
            ),
            iOS: DarwinNotificationDetails(
              categoryIdentifier: message.category != null ? message.category! : 'notifications',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    debugPrint('Firebase initialised.');
    return;
  }

  /// This function registers the event handler for notification interactions (user clicking on a notification)
  Future<void> setupFirebaseInteraction() async {
    // Get the message that caused the app to start
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // Checks whether the notification caused the app to start and then processes that notification
    if (initialMessage != null) {
      await _handleFirebaseInteraction(initialMessage);
    }

    // Registers the event listener in case a notification is received while the app is running
    FirebaseMessaging.onMessageOpenedApp.listen(_handleFirebaseInteraction);

    return;
  }

  /// Handles notification interactions
  Future<void> _handleFirebaseInteraction(RemoteMessage message) async {
    if (homeKey.currentState == null) return;

    Map<String, dynamic> interaction = {};

    // Decode JSON payload from the message data
    try {
      interaction = jsonDecode(message.data['interaction']);
    } catch (e) {
      throw JsonException();
    }

    if (interaction['destination'] == null) return;

    // Deal with different actions specified in the message data
    switch (interaction['destination']) {
      case 'calendar':
        {
          if (interaction['data'] == null) return;

          final List<dynamic> interactionData = interaction['data'];

          // Retrieves all events from the calendar
          final calendarUsecase = sl<CalendarUsecases>();
          final Map<String, List<dynamic>> eventsAndFailures = await calendarUsecase.updateEventsAndFailures();
          final List<Event> events = eventsAndFailures['events']! as List<Event>;

          if (interactionData[0] == null || List<Map<String, dynamic>>.from(interactionData)[0]['event'] == null) {
            return;
          }

          final Map<String, dynamic> eventJson = List<Map<String, dynamic>>.from(interactionData)[0]['event'];

          // Get the event according to the id in the message payload
          Event event;
          try {
            event = events.firstWhere((element) => element.url == eventJson['url']);
          } catch (e) {
            return;
          }

          // Change page
          await homeKey.currentState!.selectedPage(PageItem.events);
          // Push the CalendarDetailPage onto the navigator of the current page
          await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (_) => CalendarDetailPage(event: event),
            ),
          );

          break;
        }
      case 'mensa':
        {
          await homeKey.currentState!.selectedPage(PageItem.mensa);

          break;
        }
      case 'wallet':
        {
          await homeKey.currentState!.selectedPage(PageItem.wallet);

          break;
        }
      case 'more':
        {
          await homeKey.currentState!.selectedPage(PageItem.more);

          break;
        }
      case 'link':
        {
          if (interaction['data'] == null) return;

          final List<dynamic> interactionData = interaction['data'];

          if (interactionData[0] == null) return;

          final String url = interactionData[0];

          // ignore: use_build_context_synchronously
          if (Provider.of<SettingsHandler>(homeKey.currentState!.context, listen: false)
                  .currentSettings
                  .useExternalBrowser ||
              url.contains('instagram') ||
              url.contains('facebook') ||
              url.contains('twitch') ||
              url.contains('mailto:') ||
              url.contains('tel:')) {
            // Open in external browser
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          } else {
            // Open in InAppView
            await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!.push(
              MaterialPageRoute(
                builder: (context) => InAppWebViewPage(url: url),
              ),
            );
          }
        }
    }
  }

  /// Sets the initial publishers if the app is freshly installed or updated.
  Future<void> setInitialPublishers(SettingsHandler settingsHandler) async {
    // Loads all publishers from the backend
    try {
      await backendRepository.loadPublishers(settingsHandler);
    } catch (e) {
      debugPrint('Could not load publishers while loading the initial publishers. Exception: $e');

      // Feed filters
      settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
        feedFilter: [Publisher(id: 0, name: 'RUB'), Publisher(id: 0, name: 'AStA')],
      );

      // Calendar filters
      settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
        eventsFilter: [Publisher(id: 0, name: 'AStA')],
      );
      return;
    }
    final List<Publisher> publishers = settingsHandler.currentSettings.publishers;

    // Gets all publishers that should be displayed after newly installing the app
    final List<Publisher> initialPublishers = publishers.where((element) => element.initiallyDisplayed).toList();

    // Feed filters
    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
      feedFilter: [Publisher(id: 0, name: 'RUB'), Publisher(id: 0, name: 'AStA')] + initialPublishers,
    );

    // Calendar filters
    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
      eventsFilter: [Publisher(id: 0, name: 'AStA')] + initialPublishers,
    );
  }

  Future<void> setIntialStudyCoursePublishers(
    SettingsHandler settingsHandler,
    List<StudyCourse> selectedStudyCourses,
  ) async {
    final List<Publisher> publishers = settingsHandler.currentSettings.publishers;

    final List<Publisher> initialPublishers = [];

    for (final StudyCourse course in selectedStudyCourses) {
      try {
        final Publisher publisher = publishers.firstWhere((element) => element.id == course.pId);
        initialPublishers.add(publisher);
        // ignore: empty_catches
      } catch (e) {}
    }

    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
      feedFilter: settingsHandler.currentSettings.feedFilter + initialPublishers,
      eventsFilter: settingsHandler.currentSettings.eventsFilter + initialPublishers,
    );
  }
}
