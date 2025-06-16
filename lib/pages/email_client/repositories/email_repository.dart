// 1. ABSTRACT EMAIL REPOSITORY (Define the contract)
// ============================================================================

import 'package:campus_app/pages/email_client/models/email.dart';

abstract class EmailRepository {
  Future<bool> connect(String username, String password);
  Future<void> disconnect();
  Future<List<Email>> fetchEmails({required String mailboxName, int count = 50});
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    List<String>? cc,
    List<String>? bcc,
  });
  Future<bool> markAsRead(int uid);
  Future<bool> markAsUnread(int uid);
  Future<bool> deleteEmail(int uid, {String mailboxName});
  Future<bool> moveEmail(int uid, String targetMailbox);
  Future<List<Email>> searchEmails({
    String? query,
    String? from,
    String? subject,
    bool unreadOnly = false,
    String mailboxName = 'INBOX',
  });
  bool get isConnected;
}



// ============================================================================
// USAGE EXAMPLE
/*

class EmailController {
  final EmailService _emailService = sl<EmailService>();
  
  Future<void> initializeEmail() async {
    try {
      await _emailService.initialize();
    } catch (e) {
      // Handle initialization error
      print('Failed to initialize email: $e');
    }
  }
  
  Future<void> sendTestEmail() async {
    try {
      await _emailService.sendEmail(
        to: 'test@example.com',
        subject: 'Test Email',
        body: 'This is a test email',
      );
    } catch (e) {
      // Handle send error
      print('Failed to send email: $e');
    }
  }
}

*/