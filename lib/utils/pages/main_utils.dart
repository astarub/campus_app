import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:campus_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/firebase_options.dart';
import 'package:campus_app/pages/calendar/calendar_detail_page.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';

class MainUtils {}

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

/// This function initializes the Google Firebase services and FCM
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Get the FCM Token
  final fcmToken = await FirebaseMessaging.instance.getToken();

  debugPrint(fcmToken);

  // Request notifications permissions on iOs
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  // Enable foreground notifications on iOs
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  // Initialize the notification interaction handler
  await setupFirebaseInteraction();

  // Local notifications on Android
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/ic_notification');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        final String payload = response.payload!;
        Map<String, dynamic> data = {};
        Map<String, dynamic> interaction = {};

        // Decode JSON payload from the message data
        try {
          data = jsonDecode(payload);
          interaction = jsonDecode(data['interaction']);
        } catch(e) {
          throw JsonException();
        }

        //Deal with different actions specified in the message data
        switch (interaction['destination']) {
          case 'calendar': {
            if (interaction['data'] == null) {
              return;
            }

            final List<dynamic> interactionData = interaction['data'];

            // Retrieves all events from the calendar
            final calendarUsecase = sl<CalendarUsecases>();
            final Map<String, List<dynamic>> eventsAndFailures = await calendarUsecase.updateEventsAndFailures();
            final List<Event> events = eventsAndFailures['events'] as List<Event>;

            if (interactionData[0] == null || interactionData[0]['event'] == null){
              return;
            }

            final Map<String, dynamic> eventJson = interactionData[0]['event'] ;

            // Get the event according to the id in the message payload
            Event event;
            try {
              event = events.firstWhere((element) => element.id == eventJson['id']);
            } catch(e){
              return;
            }

            // Push the CalendarDetailPage onto the navigator of the current page
            if (homeKey.currentState != null) {
              await homeKey.currentState!.selectedPage(PageItem.events);
              await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!.push(MaterialPageRoute(builder: (_) => CalendarDetailPage(event: event)));
            }
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
}

/// This function registers the event handler for notification interactions (user clicking on a notification)
Future<void> setupFirebaseInteraction() async {
  // Get the message that caused the app to start
  final RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();

  // Checks whether the notification caused the app to start and then processes that notification
  if (initialMessage != null) {
    _handleFirebaseInteraction(initialMessage);
  }

  // Registers the event listener in case a notification is received while the app is running
  FirebaseMessaging.onMessageOpenedApp.listen(_handleFirebaseInteraction);
}

/// Handles notification interactions
void _handleFirebaseInteraction(RemoteMessage message) async {
  Map<String, dynamic> interaction = {};

  //Decode JSON payload from the message data
  try {
    interaction = jsonDecode(message.data['interaction']);
  } catch(e) {
    throw JsonException();
  }

  // Deal with different actions specified in the message data
  switch (interaction['destination']) {
    case 'calendar': {
      if (interaction['data'] == null) {
        return;
      }

      final List<dynamic> interactionData = interaction['data'];

      // Retrieve all events in the calendar
      final calendarUsecase = sl<CalendarUsecases>();
      final Map<String, List<dynamic>> eventsAndFailures = await calendarUsecase.updateEventsAndFailures();
      final List<Event> events = eventsAndFailures['events'] as List<Event>;

      if (interactionData[0] == null || interactionData[0]['event'] == null) {
        return;
      }

      final Map<String, dynamic> eventJson = interactionData[0]['event'] ;

      // Get the event according to the id in the message payload
      Event event;
      try {
        event = events.firstWhere((element) => element.id == eventJson['id']);
      } catch(e){
        return;
      }

      // Push the CalendarDetailPage onto the navigator of the current page
      if (homeKey.currentState != null) {
        await homeKey.currentState!.selectedPage(PageItem.events);
        await homeKey.currentState!.navigatorKeys[homeKey.currentState!.currentPage]?.currentState!.push(MaterialPageRoute(builder: (_) => CalendarDetailPage(event: event)));
      }
    }
  }
}
