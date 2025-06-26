// Imports the Email model used throughout the email operations
import 'package:campus_app/pages/email_client/models/email.dart';

// Abstract repository defining the interface for any email backend (e.g., IMAP)
abstract class EmailRepository {
  // Establish connection to the email server
  Future<bool> connect(String username, String password);

  // Disconnect from the email server
  Future<void> disconnect();

  // Fetch a list of emails from a specified mailbox (e.g., INBOX)
  Future<List<Email>> fetchEmails({required String mailboxName, int count = 50});

  // Send a new email with optional cc/bcc fields
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    List<String>? cc,
    List<String>? bcc,
  });

  // Mark a specific email as read using its UID
  Future<bool> markAsRead(int uid);

  // Mark a specific email as unread
  Future<bool> markAsUnread(int uid);

  // Delete a specific email from a mailbox (defaults to INBOX)
  Future<bool> deleteEmail(int uid, {String mailboxName});

  // Move an email to a different mailbox (e.g., Archive, Trash)
  Future<bool> moveEmail(int uid, String targetMailbox);

  // Search emails based on query params in a specific mailbox
  Future<List<Email>> searchEmails({
    String? query,
    String? from,
    String? subject,
    bool unreadOnly = false,
    String mailboxName = 'INBOX',
  });

  // Check if a connection to the server is active
  bool get isConnected;

  // Save or update a draft email on the server
  Future<bool> saveDraft(Email draft);

  // Fetch drafts from the "Drafts" mailbox
  Future<List<Email>> fetchDrafts({int count = 50});
}
