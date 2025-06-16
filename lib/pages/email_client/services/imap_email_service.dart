import 'dart:async';
import 'dart:math' as math;
import 'package:enough_mail/enough_mail.dart';
import 'package:intl/intl.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class ImapEmailService {
  ImapClient? _imapClient;
  SmtpClient? _smtpClient;
  String? _username;
  String? _password;

  static const String _imapHost = 'mail.ruhr-uni-bochum.de';
  static const int _imapPort = 993;
  static const String _smtpHost = 'mail.ruhr-uni-bochum.de';
  static const int _smtpPort = 587;

  bool get isConnected => _imapClient?.isConnected ?? false;

  Future<bool> connect(String username, String password) async {
    _imapClient = ImapClient(isLogEnabled: true);
    try {
      _username = username;
      _password = password;
      await _imapClient!.connectToServer(_imapHost, _imapPort, isSecure: true);
      await _imapClient!.login(_username!, _password!);
      print('Successfully connected to RUB email server');

      final boxes = await _imapClient!.listMailboxes();
      print('Available mailboxes: ${boxes.map((m) => m.name).toList()}');
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
    } catch (e) {
      print('Error disconnecting: $e');
    } finally {
      _imapClient = null;
      _smtpClient = null;
      _username = null;
      _password = null;
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

    // 1. select mailbox
    final mailbox = await _imapClient!.selectMailboxByPath(mailboxName);

    // 2. how many messages there?
    final total = mailbox.messagesExists;
    print('DEBUG: $mailboxName has $total messages');

    // 3. bail out only if truly empty
    if (total == 0) return [];

    // 4. clamp page-range into [1..total]
    final start = math.max(1, total - (page * count) + 1);
    final end = math.min(total, total - ((page - 1) * count));

    // 5. fetch with parentheses around the item list
    final fetchResult = await _imapClient!.fetchMessages(
      MessageSequence.fromRange(start, end),
      '(BODY.PEEK[HEADER] BODY.PEEK[TEXT])',
    );
    print('DEBUG: fetched ${fetchResult.messages.length} '
        'messages from $mailboxName');

    // 6. map & reverse (newest-first)
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
      if (_smtpClient == null) {
        _smtpClient = SmtpClient('RUB-Flutter-Client', isLogEnabled: false);
        await _smtpClient!.connectToServer(_smtpHost, _smtpPort, isSecure: false);
        await _smtpClient!.ehlo();
        await _smtpClient!.startTls();
        await _smtpClient!.authenticate(_username!, _password!, AuthMechanism.login);
      }

      final builder = MessageBuilder.prepareMultipartAlternativeMessage(plainText: body)
        ..from = [MailAddress('', _username!)]
        ..to = [MailAddress('', to)]
        ..subject = subject;

      if (cc?.isNotEmpty ?? false) {
        builder.cc = cc!.map((e) => MailAddress('', e)).toList();
      }
      if (bcc?.isNotEmpty ?? false) {
        builder.bcc = bcc!.map((e) => MailAddress('', e)).toList();
      }

      // TODO: attachments if needed

      final message = builder.buildMimeMessage();
      await _smtpClient!.sendMessage(message);
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  Future<bool> markAsRead(int uid, {String mailboxName = 'INBOX'}) =>
      _updateEmailFlags(uid, [MessageFlags.seen], mailboxName: mailboxName);

  Future<bool> markAsUnread(int uid, {String mailboxName = 'INBOX'}) => _updateEmailFlags(
        uid,
        [MessageFlags.seen],
        remove: true,
        mailboxName: mailboxName,
      );

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
    String mailboxName = 'INBOX',
    String? query,
    String? from,
    String? subject,
    DateTime? since,
    bool unreadOnly = false,
  }) async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to email server');
    }

    final criteria = <String>[];
    if (query?.isNotEmpty ?? false) criteria.add('TEXT "$query"');
    if (from?.isNotEmpty ?? false) criteria.add('FROM "$from"');
    if (subject?.isNotEmpty ?? false) criteria.add('SUBJECT "$subject"');
    if (since != null) {
      final formatted = DateFormat('dd-MMM-yyyy').format(since).toUpperCase();
      criteria.add('SINCE $formatted');
    }
    if (unreadOnly) criteria.add('UNSEEN');
    if (criteria.isEmpty) criteria.add('ALL');

    final mailbox = await _imapClient!.selectMailboxByPath(mailboxName);
    final total = mailbox.messagesExists;

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
      attachments: <String>[], // implement if needed
      uid: msg.uid ?? 0,
    );
  }
}
