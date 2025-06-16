import 'dart:async';
import 'dart:math' as math;
import 'package:enough_mail/enough_mail.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class ImapEmailService {
  ImapClient? _imapClient;
  SmtpClient? _smtpClient;
  String? _username;
  String? _password;

  // RUB email server configuration
  static const String _imapHost = 'mail.ruhr-uni-bochum.de';
  static const int _imapPort = 993;
  static const String _smtpHost = 'mail.ruhr-uni-bochum.de';
  static const int _smtpPort = 587;

  bool get isConnected => _imapClient?.isConnected ?? false;

  Future<bool> connect(String username, String password) async {
    try {
      _username = username;
      _password = password;
      _imapClient = ImapClient(isLogEnabled: false);
      await _imapClient!.connectToServer(_imapHost, _imapPort, isSecure: true);
      await _imapClient!.login(_username!, _password!);
      print('Successfully connected to RUB email server');
      return true;
    } catch (e) {
      print('Failed to connect to email server: $e');
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      await _imapClient?.disconnect();
      await _smtpClient?.disconnect();
      _imapClient = null;
      _smtpClient = null;
    } catch (e) {
      print('Error disconnecting: $e');
    }
  }

  Future<List<Email>> fetchEmails({
    String mailboxName = 'INBOX',
    int count = 50,
    int page = 1,
  }) async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to email server');
    }

    final mailbox = await _imapClient!.selectMailboxByPath(mailboxName);
    final total = mailbox.messagesExists;
    final start = total - (page * count) + 1;
    final end = total - ((page - 1) * count);
    if (start <= 0) return [];

    final fetchResult = await _imapClient!.fetchMessages(
      MessageSequence.fromRange(math.max(1, start), math.min(total, end)),
      'BODY.PEEK[HEADER] BODY.PEEK[TEXT]',
    );

    return fetchResult.messages.map(_convertMimeMessageToEmail).toList().reversed.toList();
  }

  Future<Email?> fetchEmailByUid(int uid, {String mailboxName = 'INBOX'}) async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to email server');
    }

    await _imapClient!.selectMailboxByPath(mailboxName);
    final result = await _imapClient!.uidFetchMessage(uid, 'BODY[]');
    if (result.messages.isNotEmpty) {
      return _convertMimeMessageToEmail(result.messages.first);
    }
    return null;
  }

  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    List<String>? cc,
    List<String>? bcc,
    List<String>? attachments,
  }) async {
    try {
      // Initialize SMTP client
      if (_smtpClient == null) {
        _smtpClient = SmtpClient('RUB-Flutter-Client', isLogEnabled: false);
        await _smtpClient!.connectToServer(_smtpHost, _smtpPort, isSecure: false);
        await _smtpClient!.ehlo();
        await _smtpClient!.startTls();
        await _smtpClient!.authenticate(_username!, _password!, AuthMechanism.login);
      }

      // Use the builder API instead of buildSimpleTextMessage:
      final builder = MessageBuilder.prepareMultipartAlternativeMessage(
        plainText: body,
      )
        ..from = [MailAddress('', _username!)]
        ..to = [MailAddress('', to)]
        ..subject = subject;

      if (cc != null && cc.isNotEmpty) {
        builder.cc = cc.map((e) => MailAddress('', e)).toList();
      }
      if (bcc != null && bcc.isNotEmpty) {
        builder.bcc = bcc.map((e) => MailAddress('', e)).toList();
      }

      // (You can re-add attachments here once you've inspected the new attachment API.)

      final message = builder.buildMimeMessage();
      await _smtpClient!.sendMessage(message);
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  Future<bool> markAsRead(int uid, {String mailboxName = 'INBOX'}) {
    return _updateEmailFlags(uid, [MessageFlags.seen], mailboxName: mailboxName);
  }

  Future<bool> markAsUnread(int uid, {String mailboxName = 'INBOX'}) {
    return _updateEmailFlags(
      uid,
      [MessageFlags.seen],
      remove: true,
      mailboxName: mailboxName,
    );
  }

  Future<bool> deleteEmail(int uid, {String mailboxName = 'INBOX'}) async {
    try {
      await _imapClient!.selectMailboxByPath(mailboxName);
      await _imapClient!.uidStore(MessageSequence.fromId(uid), [MessageFlags.deleted]);
      await _imapClient!.expunge();
      return true;
    } catch (e) {
      print('Error deleting email: $e');
      return false;
    }
  }

  Future<bool> moveEmail(
    int uid,
    String targetMailbox, {
    String sourceMailbox = 'INBOX',
  }) async {
    try {
      await _imapClient!.selectMailboxByPath(sourceMailbox);
      await _imapClient!.selectMailboxByPath(targetMailbox);
      await _imapClient!.uidMove(MessageSequence.fromId(uid));
      return true;
    } catch (e) {
      print('Error moving email: $e');
      return false;
    }
  }

  Future<List<String>> getMailboxes() async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to email server');
    }
    final boxes = await _imapClient!.listMailboxes();
    return boxes.map((m) => m.name).toList();
  }

  Future<List<Email>> searchEmails({
    String? query,
    String? from,
    String? subject,
    DateTime? since,
    bool unreadOnly = false,
    String mailboxName = 'INBOX',
  }) async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to email server');
    }

    // build IMAP SEARCH criteria
    final criteria = <String>[];
    if (query?.isNotEmpty ?? false) criteria.add('TEXT "$query"');
    if (from?.isNotEmpty ?? false) criteria.add('FROM "$from"');
    if (subject?.isNotEmpty ?? false) criteria.add('SUBJECT "$subject"');
    if (since != null) {
      criteria.add('SINCE ${DateCodec.encodeSearchDate(since)}');
    }
    if (unreadOnly) criteria.add('UNSEEN');

    final mailbox = await _imapClient!.selectMailboxByPath(mailboxName);
    final total = mailbox.messagesExists;

    // fetchRecentMessages accepts a named `criteria` string
    final fetchResult = await _imapClient!.fetchRecentMessages(
      messageCount: total,
      criteria: criteria.join(' '),
    );

    return fetchResult.messages.map(_convertMimeMessageToEmail).toList();
  }

  Future<bool> _updateEmailFlags(
    int uid,
    List<String> flags, {
    bool remove = false,
    String mailboxName = 'INBOX',
  }) async {
    try {
      await _imapClient!.selectMailboxByPath(mailboxName);
      await _imapClient!.uidStore(
        MessageSequence.fromId(uid),
        flags,
        action: remove ? StoreAction.remove : StoreAction.add,
      );
      return true;
    } catch (e) {
      print('Error updating email flags: $e');
      return false;
    }
  }

  Email _convertMimeMessageToEmail(MimeMessage msg) {
    return Email(
      id: msg.uid?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      subject: msg.decodeSubject() ?? 'No Subject',
      body: msg.decodeTextPlainPart() ?? msg.decodeTextHtmlPart() ?? '',
      sender: msg.from?.first.personalName ?? msg.from?.first.email ?? 'Unknown',
      senderEmail: msg.from?.first.email ?? 'unknown@example.com',
      recipients: msg.to?.map((addr) => addr.email).toList() ?? [],
      date: msg.decodeDate() ?? DateTime.now(),
      isUnread: !msg.isSeen,
      isStarred: msg.isFlagged,
      // stubbed; re-add once you’ve inspected MimePart’s new API:
      attachments: <String>[],
      uid: msg.uid ?? 0,
    );
  }
}
