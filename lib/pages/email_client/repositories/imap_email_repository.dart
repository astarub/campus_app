//2. IMAP IMPLEMENTATION OF EMAIL REPOSITORY
// ============================================================================

import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/repositories/email_repository.dart';
import 'package:campus_app/pages/email_client/services/imap_email_service.dart';

class ImapEmailRepository implements EmailRepository {
  final ImapEmailService _imapService;

  ImapEmailRepository(this._imapService);

  @override
  Future<bool> connect(String username, String password) {
    return _imapService.connect(username, password);
  }

  @override
  Future<void> disconnect() {
    return _imapService.disconnect();
  }

  @override
  Future<List<Email>> fetchEmails({required String mailboxName, int count = 50}) {
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
    return _imapService.markAsRead(uid);
  }

  @override
  Future<bool> markAsUnread(int uid) {
    return _imapService.markAsUnread(uid);
  }

  @override
  Future<bool> deleteEmail(int uid, {String mailboxName = 'INBOX'}) {
    return _imapService.deleteEmail(uid, mailboxName: mailboxName);
  }

  @override
  Future<bool> moveEmail(int uid, String targetMailbox) {
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
    return _imapService.searchEmails(
      query: query,
      from: from,
      subject: subject,
      unreadOnly: unreadOnly,
      mailboxName: mailboxName,
    );
  }

  @override
  bool get isConnected => _imapService.isConnected;
}
