import 'dart:async';
import 'dart:math' as math;
import 'package:enough_mail/enough_mail.dart';
import 'package:intl/intl.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'dart:convert';

class ImapEmailService {
  ImapClient? _imapClient;
  SmtpClient? _smtpClient;
  String? _username;
  String? _password;

  // IMAP/SMTP server configuration
  static const String _imapHost = 'mail.ruhr-uni-bochum.de';
  static const int _imapPort = 993;
  static const String _smtpHost = 'mail.ruhr-uni-bochum.de';
  static const int _smtpPort = 587;

  bool get isConnected => _imapClient?.isConnected ?? false;

  // Connects to the IMAP server and logs in.
  Future<bool> connect(String username, String password) async {
    _imapClient = ImapClient(isLogEnabled: true);
    try {
      _username = username;
      _password = password;
      await _imapClient!.connectToServer(_imapHost, _imapPort, isSecure: true);
      await _imapClient!.login(_username!, _password!);
      print('IMAP: Connected as $_username');
      return true;
    } catch (e) {
      print('IMAP: Connection/login failed: $e');
      return false;
    }
  }

  // Disconnects both IMAP and SMTP clients cleanly.
  Future<void> disconnect() async {
    try {
      await _imapClient?.disconnect();
      await _smtpClient?.disconnect();
    } catch (e) {
      print('Disconnect error: $e');
    } finally {
      _imapClient = null;
      _smtpClient = null;
      _username = null;
      _password = null;
    }
  }

  // Fetches [count] messages from [mailboxName], newest-first paging.
  Future<List<Email>> fetchEmails({
    String mailboxName = 'INBOX',
    int count = 50,
    int page = 1,
  }) async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to IMAP server');
    }
    // 1) Select mailbox
    final mailbox = await _imapClient!.selectMailboxByPath(mailboxName);
    final total = mailbox.messagesExists;
    if (total == 0) return [];

    // 2) Determine sequence range
    final start = math.max(1, total - (page * count) + 1);
    final end = math.min(total, total - ((page - 1) * count));

    // 3) Fetch headers and body peek
    final result = await _imapClient!.fetchMessages(
      MessageSequence.fromRange(start, end),
      '(BODY.PEEK[HEADER] BODY.PEEK[TEXT])',
    );

    // 4) Convert and reverse for newest-first order
    final emails = await Future.wait(
      result.messages.map(_convertMimeMessageToEmail),
    );
    return emails.reversed.toList();
  }

  // Fetches a single email by its UID.
  Future<Email?> fetchEmailByUid(int uid, {String mailboxName = 'INBOX'}) async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to IMAP server');
    }
    await _imapClient!.selectMailboxByPath(mailboxName);
    final result = await _imapClient!.uidFetchMessage(uid, 'BODY[]');
    if (result.messages.isEmpty) return null;
    return await _convertMimeMessageToEmail(result.messages.first);
  }

  // Sends an email via SMTP, then appends it into the IMAP “Sent” folder.
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    List<String>? cc,
    List<String>? bcc,
    List<String>? attachments,
  }) async {
    try {
      // ─── 1) Ensure SMTP connection + full STARTTLS handshake ─────────────
      if (_smtpClient == null || !_smtpClient!.isConnected) {
        _smtpClient = SmtpClient('RUB-Flutter-Client', isLogEnabled: true);

        // Connect without TLS
        await _smtpClient!.connectToServer(_smtpHost, _smtpPort, isSecure: false);
        // Advertise capabilities
        await _smtpClient!.ehlo();
        // Upgrade to TLS
        await _smtpClient!.startTls();
        // Re-advertise capabilities after TLS
        await _smtpClient!.ehlo();
        // Authenticate
        await _smtpClient!.authenticate(_username!, _password!, AuthMechanism.login);
      }

      // ─── 2) Build the MIME message ────────────────────────────────────────
      final builder = MessageBuilder.prepareMultipartAlternativeMessage(plainText: body)
        ..from = [
          MailAddress(
            '',
            _username!.contains('@') ? _username! : '$_username@ruhr-uni-bochum.de',
          )
        ]
        ..to = [MailAddress('', to)]
        ..subject = subject;

      if (cc?.isNotEmpty ?? false) {
        builder.cc = cc!.map((addr) => MailAddress('', addr)).toList();
      }
      if (bcc?.isNotEmpty ?? false) {
        builder.bcc = bcc!.map((addr) => MailAddress('', addr)).toList();
      }

      // TODO: handle attachments if needed

      final mimeMessage = builder.buildMimeMessage();

      // ─── 3) Send the message ───────────────────────────────────────────────
      await _smtpClient!.sendMessage(mimeMessage);
      print('SMTP: Message sent');

      // ─── 4) Append to IMAP “Sent” folder ──────────────────────────────────
      if (_imapClient != null && _imapClient!.isConnected) {
        try {
          await _imapClient!.selectMailboxByPath('Sent');
          await _imapClient!.appendMessage(
            mimeMessage,
            flags: [MessageFlags.seen], // mark as read in Sent
          );
          print('IMAP: Appended message to Sent');
        } catch (e) {
          print('IMAP: Failed to append to Sent: $e');
        }
      }

      return true;
    } catch (e) {
      print('sendEmail error: $e');
      return false;
    }
  }

  // Appends (or updates) a draft in the IMAP “Drafts” folder.
  Future<bool> appendDraft(Email draft) async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to IMAP server');
    }
    // Select the Drafts mailbox
    await _imapClient!.selectMailboxByPath('Drafts');
    // Build draft MIME
    final builder = MessageBuilder.prepareMultipartAlternativeMessage(plainText: draft.body)
      ..from = [MailAddress('', _username!)]
      ..to = draft.recipients.map((r) => MailAddress('', r)).toList()
      ..subject = draft.subject;
    final mime = builder.buildMimeMessage();

    try {
      await _imapClient!.appendMessage(
        mime,
        flags: [MessageFlags.draft],
      );
      return true;
    } catch (e) {
      print('appendDraft error: $e');
      return false;
    }
  }

  /// Lists all mailbox names on the server.
  Future<List<String>> getMailboxes() async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to IMAP server');
    }
    final boxes = await _imapClient!.listMailboxes();
    return boxes.map((m) => m.name).toList();
  }

  /// Searches emails in [mailboxName] matching optional criteria.
  Future<List<Email>> searchEmails({
    String mailboxName = 'INBOX',
    String? query,
    String? from,
    String? subject,
    DateTime? since,
    bool unreadOnly = false,
  }) async {
    if (_imapClient == null || !_imapClient!.isConnected) {
      throw Exception('Not connected to IMAP server');
    }

    // Build IMAP search criteria
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

    // Execute search
    final mailbox = await _imapClient!.selectMailboxByPath(mailboxName);
    final total = mailbox.messagesExists;
    final result = await _imapClient!.fetchRecentMessages(
      messageCount: total,
      criteria: criteria.join(' '),
    );

    return Future.wait(result.messages.map(_convertMimeMessageToEmail));
  }

  // Internal helper to add/remove flags (e.g., Seen).
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

  Future<bool> markAsRead(int uid, {String mailboxName = 'INBOX'}) =>
      _updateEmailFlags(uid, [MessageFlags.seen], mailboxName: mailboxName);

  Future<bool> markAsUnread(int uid, {String mailboxName = 'INBOX'}) =>
      _updateEmailFlags(uid, [MessageFlags.seen], remove: true, mailboxName: mailboxName);

  // Deletes a message (marks \Deleted + EXPUNGE).
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

  // Moves a message to [targetMailbox].
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

  // Converts a raw [MimeMessage] into your app’s [Email] model.
  Future<Email> _convertMimeMessageToEmail(MimeMessage msg) async {
    final plain = msg.decodeTextPlainPart();
    final html = msg.decodeTextHtmlPart();

    return Email(
      id: msg.uid?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      subject: msg.decodeSubject() ?? 'No Subject',
      body: plain ?? html ?? '',
      htmlBody: html,
      sender: msg.from?.first.personalName ?? msg.from?.first.email ?? 'Unknown',
      senderEmail: msg.from?.first.email ?? '',
      recipients: msg.to?.map((a) => a.email).toList() ?? [],
      date: msg.decodeDate() ?? DateTime.now(),
      isUnread: !msg.isSeen,
      isStarred: msg.isFlagged,
      attachments: <String>[],
      uid: msg.uid ?? 0,
    );
  }
}
