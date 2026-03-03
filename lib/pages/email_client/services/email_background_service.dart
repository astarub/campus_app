import 'package:flutter/foundation.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:campus_app/pages/email_client/repositories/email_repository.dart';
import 'package:campus_app/pages/email_client/repositories/imap_email_repository.dart';
import 'package:campus_app/pages/email_client/services/imap_email_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EmailBackgroundService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

      static Future<Map<String, String>?> _loadCredentials() async {
  const storage = FlutterSecureStorage();

  final username = await storage.read(key: 'email_loginId');
  final password = await storage.read(key: 'email_password');
  final isAuth = await storage.read(key: 'email_is_authenticated');

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

    await _notifications.initialize(settings);
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
    try {
      await fetchEmailsAndNotify();
    } catch (e) {
      debugPrint('Background fetch error: $e');
    } finally {
      BackgroundFetch.finish(taskId);
    }
  }

  /// Runs when app is terminated (Android headless)
  static Future<void> headlessTask(HeadlessTask task) async {
    final taskId = task.taskId;
    try {
      await fetchEmailsAndNotify();
    } catch (e) {
      debugPrint('Headless fetch error: $e');
    } finally {
      BackgroundFetch.finish(taskId);
    }
  }

  // fetch newest inbox mails + notify if new
  static Future<void> fetchEmailsAndNotify() async {
  final credentials = await _loadCredentials();
  if (credentials == null) return;

  final username = credentials['username']!;
  final password = credentials['password']!;

  final EmailRepository repo = ImapEmailRepository(ImapEmailService());

  final ok = await repo.connect(username, password);
  if (!ok) return;

  final emails = await repo.fetchEmails(mailboxName: 'INBOX', count: 10);

  await repo.disconnect();

  if (emails.isEmpty) return;

final prefs = await SharedPreferences.getInstance();


final sorted = List.from(emails)
  ..sort((a, b) => b.uid.compareTo(a.uid));

final newest = sorted.first;
final newestUid = newest.uid;

final lastSeenUid = prefs.getInt('last_seen_inbox_uid') ?? 0;

if (newestUid > lastSeenUid) {
  await prefs.setInt('last_seen_inbox_uid', newestUid);

  await _showNotification(
    title: newest.subject.isNotEmpty ? newest.subject : 'New Email',
    body: newest.sender.isNotEmpty
        ? 'From: ${newest.sender}'
        : 'You received a new email.',
  );
}
}

  static Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    const android = AndroidNotificationDetails(
      'email_channel',
      'Email Updates',
      channelDescription: 'Notifications for new incoming emails',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: android);

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}