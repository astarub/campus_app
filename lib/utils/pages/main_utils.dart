import 'dart:async';
import 'dart:convert';

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
import 'package:campus_app/firebase_options.dart';
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

// Deep link handling
bool initialUriHandled = false;
StreamSubscription? subscription;

final CalendarUsecases calendarUsecases = sl<CalendarUsecases>();

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

          // Get the event object by the specified url if a specific event is passed as an argument. Otherwise only the events page will be displayed.
          Event event;
          try {
            event =
                events.firstWhere((element) => element.url == 'https://asta-bochum.de/termin/${uri.pathSegments[1]}/');
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

            // Get the event object by the specified url if a specific event is passed as an argument. Otherwise only the events page will be displayed.
            Event event;
            try {
              event = events
                  .firstWhere((element) => element.url == 'https://asta-bochum.de/termin/${uri.pathSegments[1]}/');
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

/// This function initializes the Google Firebase services and FCM
Future<void> initializeFirebase() async {
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Get the FCM Token
  final fcmToken = await FirebaseMessaging.instance.getToken();

  debugPrint(fcmToken);

  // Request notifications permissions on iOs
  await FirebaseMessaging.instance.requestPermission();

  // Enable foreground notifications on iOs
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  // Initialize the notification interaction handler
  await setupFirebaseInteraction();

  // Subscribes the app to the default notifications topic in order to send notifications via the FCM API
  await FirebaseMessaging.instance.subscribeToTopic('defaultNotifications');

  // Local notifications on Android
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_notification');
  const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
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
            final List<Event> events = eventsAndFailures['events'] as List<Event>;

            if (interactionData[0] == null || interactionData[0]['event'] == null) return;

            final Map<String, dynamic> eventJson = interactionData[0]['event'];

            // Get the event according to the id in the message payload
            Event event;
            try {
              event = events.firstWhere((element) => element.id == eventJson['id']);
            } catch (e) {
              return;
            }

            // Change page
            await homeKey.currentState!.selectedPage(PageItem.events);
            // Push the CalendarDetailPage onto the navigator of the current page
            await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!
                .push(MaterialPageRoute(builder: (_) => CalendarDetailPage(event: event)));

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

  // Create another notifications channel on Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'notifications',
    'Notification Channel',
    description: 'This channel is used to display notifications.',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

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
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/ic_notification',
            color: const Color.fromRGBO(0, 202, 245, 1),
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  });
  debugPrint('Firebase initialised.');
}

/// This function registers the event handler for notification interactions (user clicking on a notification)
Future<void> setupFirebaseInteraction() async {
  // Get the message that caused the app to start
  final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  // Checks whether the notification caused the app to start and then processes that notification
  if (initialMessage != null) {
    _handleFirebaseInteraction(initialMessage);
  }

  // Registers the event listener in case a notification is received while the app is running
  FirebaseMessaging.onMessageOpenedApp.listen(_handleFirebaseInteraction);
}

/// Handles notification interactions
void _handleFirebaseInteraction(RemoteMessage message) async {
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
        final List<Event> events = eventsAndFailures['events'] as List<Event>;

        if (interactionData[0] == null || interactionData[0]['event'] == null) return;

        final Map<String, dynamic> eventJson = interactionData[0]['event'];

        // Get the event according to the id in the message payload
        Event event;
        try {
          event = events.firstWhere((element) => element.id == eventJson['id']);
        } catch (e) {
          return;
        }

        // Change page
        await homeKey.currentState!.selectedPage(PageItem.events);
        // Push the CalendarDetailPage onto the navigator of the current page
        await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!
            .pushReplacement(MaterialPageRoute(builder: (_) => CalendarDetailPage(event: event)));

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
}
