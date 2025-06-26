// Imports required Email model, interface, and IMAP service implementation
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/repositories/email_repository.dart';
import 'package:campus_app/pages/email_client/services/imap_email_service.dart';

// Concrete implementation of EmailRepository using IMAP protocol
class ImapEmailRepository implements EmailRepository {
  final ImapEmailService _imapService;

  // Constructor injection of the IMAP email service
  ImapEmailRepository(this._imapService);

  @override
  Future<bool> connect(String username, String password) {
    // Connect to the email server using credentials
    return _imapService.connect(username, password);
  }

  @override
  Future<void> disconnect() {
    // Disconnect from the email server
    return _imapService.disconnect();
  }

  @override
  Future<List<Email>> fetchEmails({required String mailboxName, int count = 50}) {
    // Fetch emails from a specific mailbox
    return _imapService.fetchEmails(mailboxName: mailboxName, count: count);
  }

  @override
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    List<String>? cc,
    List<String>? bcc,
  }) {
    // Send an email with optional cc/bcc
    return _imapService.sendEmail(
      to: to,
      subject: subject,
      body: body,
      cc: cc,
      bcc: bcc,
    );
  }

  @override
  Future<bool> markAsRead(int uid) {
    // Mark an email as read
    return _imapService.markAsRead(uid);
  }

  @override
  Future<bool> markAsUnread(int uid) {
    // Mark an email as unread
    return _imapService.markAsUnread(uid);
  }

  @override
  Future<bool> deleteEmail(int uid, {String mailboxName = 'INBOX'}) {
    // Delete email from specified mailbox
    return _imapService.deleteEmail(uid, mailboxName: mailboxName);
  }

  @override
  Future<bool> moveEmail(int uid, String targetMailbox) {
    // Move email to another mailbox
    return _imapService.moveEmail(uid, targetMailbox);
  }

  @override
  Future<List<Email>> searchEmails({
    String? query,
    String? from,
    String? subject,
    bool unreadOnly = false,
    String mailboxName = 'INBOX',
  }) {
    // Search emails based on filters
    return _imapService.searchEmails(
      query: query,
      from: from,
      subject: subject,
      unreadOnly: unreadOnly,
      mailboxName: mailboxName,
    );
  }

  @override
  bool get isConnected => _imapService.isConnected; // Proxy for connection state

  @override
  Future<bool> saveDraft(Email draft) => _imapService.appendDraft(draft); // Save draft email

  @override
  Future<List<Email>> fetchDrafts({int count = 50}) =>
      _imapService.fetchEmails(mailboxName: 'Drafts', count: count); // Fetch emails from "Drafts" folder
}
