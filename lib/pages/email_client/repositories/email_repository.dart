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

  /// Save or update a draft on the server
  Future<bool> saveDraft(Email draft);

  /// Fetch drafts from the server-side “Drafts” folder
  Future<List<Email>> fetchDrafts({int count = 50});
}
