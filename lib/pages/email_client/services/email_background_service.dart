import 'package:background_fetch/background_fetch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:campus_app/pages/email_client/services/imap_email_service.dart';

// store the keys for the SharedPreferences
class EmailNotificationsPrefs {
  static const enabled = 'email_notifications_enabled';
  static const showDetails = 'email_notifications_show_details';
}

@pragma('vm:entry-point')
class EmailBackgroundService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<Map<String, String>?> _loadCredentials() async {
    const storage = FlutterSecureStorage();

    final username = await storage.read(key: 'email_loginId');
    final password = await storage.read(key: 'email_password');
    final isAuth = await storage.read(key: 'email_is_authenticated');

    if (isAuth != 'true') {
      debugPrint('Email BG: not authenticated');
      return null;
    }

    if (username != null && password != null && isAuth == 'true') {
      return {
        'username': username,
        'password': password,
      };
    }

    return null;
  }

  /// Call this once at app start (main)
  static Future<void> init() async {
    await _initNotifications();
    await _initBackgroundFetch();
  }

  static Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings: settings);
  }

  static Future<void> _initBackgroundFetch() async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15, // minutes (Android best-effort)
        stopOnTerminate: false,
        enableHeadless: true,
        startOnBoot: true,
        requiredNetworkType: NetworkType.ANY,
      ),
      _onBackgroundFetch,
      _onBackgroundTimeout,
    );

    // Optional: run once immediately for testing
    await BackgroundFetch.start();
  }

  static void _onBackgroundTimeout(String taskId) {
    BackgroundFetch.finish(taskId);
  }

  /// Runs while app is in background (not killed)
  static Future<void> _onBackgroundFetch(String taskId) async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await fetchEmailsAndNotify(taskId);
    } catch (e) {
      debugPrint('Background fetch error: $e');
    } finally {
      await BackgroundFetch.finish(taskId);
    }
  }

  /// Runs when app is terminated (Android headless)
  @pragma('vm:entry-point')
  static Future<void> headlessTask(HeadlessTask task) async {
    WidgetsFlutterBinding.ensureInitialized();

    final taskId = task.taskId;

    // if our operation times out, notify os to finish the task, so as to not use unnecessary resources
    if (task.timeout) {
      debugPrint('Email BG: task timed out');
      await BackgroundFetch.finish(taskId);
      return;
    }

    await fetchEmailsAndNotify(taskId);
  }

  // fetch newest inbox mails + notify if new
  static Future<void> fetchEmailsAndNotify(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final enabled =
        prefs.getBool(EmailNotificationsPrefs.enabled) ?? false; // default to disabled when prefs is not set
    final showDetails = prefs.getBool(EmailNotificationsPrefs.showDetails) ?? false; // default to private

    await _initNotifications();

    // check preference settings
    if (!enabled) {
      debugPrint('Email BG: notifications disabled');
      return;
    }

    // call and store User credentials
    final credentials = await _loadCredentials();
    if (credentials == null) {
      debugPrint('Email BG: no credentials loaded');
      await BackgroundFetch.finish(taskId);
      return;
    }

    final imapService = ImapEmailService();

    try {
      // establish connection to the server
      final ok = await imapService.connect(
        credentials['username']!,
        credentials['password']!,
      );
      if (!ok) {
        debugPrint('Email BG: connection to server failed');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final lastSeenUid = prefs.getInt('last_seen_inbox_uid') ?? 0;

      // fetch the 50 most recent emails from the inbox
      final emails = await imapService.fetchEmails();
      if (emails.isEmpty) {
        debugPrint('Email BG: no emails fetched');
        return;
      }

      final highestUid = emails.map((e) => e.uid).reduce((a, b) => a > b ? a : b);
      await prefs.setInt('last_seen_inbox_uid', highestUid);

      // filter out already read emails (+ in future (TODO) filter here with notification preferences (ex. customize which senders should trigger notifications))
      final newEmails = emails.where((e) => e.uid > lastSeenUid && e.isUnread).toList();

      debugPrint('Email BG: ${newEmails.length} new unread emails');

      if (newEmails.isEmpty) return;

      final count = newEmails.length;
      final tooMany = count >= 10;

      // private notification mode
      if (!showDetails) {
        await _showNotification(
          id: 0,
          title: 'RUB Mail',
          body: count == 1 ? '1 neue Email' : '$count neue Emails',
          showDetails: false,
        );
        return;
      }

      // display notifications depending on how many there are
      if (tooMany) {
        await _showNotification(
          id: 0,
          title: 'RUB Mail',
          body: 'Du hast 10+ neue Emails',
        );
      } else if (count > 3) {
        await _showNotification(
          id: 0,
          title: 'RUB Mail: Du hast $count neue Emails ',
          body: newEmails.map((e) => e.sender).take(3).join(', '),
        );
      } else {
        for (int i = 0; i < newEmails.length; i++) {
          final email = newEmails[i];
          await _showNotification(
            id: i + 1,
            title: email.sender.isNotEmpty ? 'RUB Mail: ${email.sender}' : 'RUB Mail: Neue Email',
            body: email.subject.isNotEmpty ? email.subject : 'Kein Betreff',
          );
        }
      }
    } catch (e) {
      debugPrint('Email BG: error in fetchEmailsAndNotifiy: $e');
    } finally {
      // always disconnect
      await imapService.disconnect();
    }
  }

  static Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    bool showDetails = true,
  }) async {
    final android = AndroidNotificationDetails(
      'email_channel',
      'Email Updates',
      channelDescription: 'Notifications for new incoming emails',
      importance: Importance.high,
      priority: Priority.high,
      visibility: showDetails ? NotificationVisibility.private : NotificationVisibility.public,
    );

    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(android: android),
    );
  }
}
