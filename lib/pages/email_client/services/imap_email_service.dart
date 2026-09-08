import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:convert';

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/pages/email_client/models/email.dart';

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

  // -------------------------------------------------------- IMAP Server Connection Functions  ----------------------------------------------------------------- //

  // we use this timer to periodically send a NOOP to the IMAP Server to prevent having to reconnect every time the connection drops (~every 10-20 mins)
  // a NOOP command inexpensive and pretty much won't affect our performance at all
  Timer? _imapkeepAliveTimer;

  void _startKeepAliveIMAP() {
    _imapkeepAliveTimer?.cancel();
    _imapkeepAliveTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      if (_imapClient != null && _imapClient!.isConnected) {
        try {
          await _imapClient!.noop();
          debugPrint('IMAP: NOOP for keep alive sent.');
        } catch (e) {
          debugPrint('IMAP: keep alive failed: $e');
          _imapClient = null;
        }
      }
    });
  }

  void _stopKeepAliveIMAP() {
    _imapkeepAliveTimer?.cancel();
    _imapkeepAliveTimer = null;
  }

  // Connects to the IMAP server and logs in.
  Future<bool> connect(String username, String password) async {
    _imapClient = ImapClient(isLogEnabled: true);
    try {
      _username = username;
      _password = password;
      await _imapClient!.connectToServer(_imapHost, _imapPort, isSecure: true);
      await _imapClient!.login(_username!, _password!);
      debugPrint('IMAP: Connected as $_username');
      _startKeepAliveIMAP();
      return true;
    } catch (e) {
      debugPrint('IMAP: Connection/login failed: $e');
      return false;
    }
  }

  // Disconnects both IMAP and SMTP clients cleanly.
  Future<void> disconnect() async {
    try {
      await _imapClient?.disconnect();
      await _smtpClient?.disconnect();
    } catch (e) {
      debugPrint('Disconnect error: $e');
    } finally {
      _imapClient = null;
      _smtpClient = null;
      _username = null;
      _password = null;
      _stopKeepAliveIMAP();
    }
  }

  // run a connection check and reconnect if the connection is lost
  Future<void> _checkConnection() async {
    // first check if we are connected
    if (_imapClient != null && _imapClient!.isConnected) {
      return;
    }

    // we aren't connected, re-establish connection
    if (_username == null || _password == null) {
      throw Exception('Could not find credentials for reconnect.');
    }

    debugPrint('IMAP: Attempting Reconnect...');
    _imapClient = ImapClient(isLogEnabled: true);
    await _imapClient!.connectToServer(_imapHost, _imapPort);
    await _imapClient!.login(_username!, _password!);
    debugPrint('IMAP: Reconnect successful.');
    _startKeepAliveIMAP();
  }

  // To work around the asynchronous gap with the SocketException and enough_mail's internal handling, we timeout the IMAP Operation to catch
  // Connection drops we didn't detect
  Future<T> _addTimeout<T>(Future<T> future, {Duration? timeout}) async {
    return future.timeout(
      timeout ?? const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('IMAP: OP has timed out');
      },
    );
  }

  // Wrapper Function for Imap Client actions to ensure connection isn't lost, if it is we run a retry
  Future<T> _ensureConnection<T>(Future<T> Function() action, {Duration? timeout}) async {
    try {
      await _checkConnection();
      return await _addTimeout(action(), timeout: timeout);
    } catch (e) {
      debugPrint('IMAP Connection error caught: ${e.runtimeType} - $e');
      // the on SocketException catch isn't enough so we catch all errors and differentiate
      final isConnectionError = e is SocketException ||
          e.toString().toLowerCase().contains('socket') ||
          e.toString().toLowerCase().contains('connection') ||
          e.toString().toLowerCase().contains('reset by peer') ||
          e.toString().toLowerCase().contains('not connected') ||
          e.toString().toLowerCase().contains('connection closed') ||
          e is TimeoutException;

      if (isConnectionError) {
        debugPrint('Lost IMAP connection...reconnecting: $e');
        try {
          await _imapClient?.disconnect();
        } catch (_) {}
        _imapClient = null;
        await _checkConnection();
        return _addTimeout(action(), timeout: timeout);
      }
      rethrow;
    }
  }

  // ---------------------------------------------------------- IMAP Email Operations/Functions ----------------------------------------------------------------------------- //

  // Fetches [count] messages from [mailboxName], newest-first paging.
  Future<List<Email>> fetchEmails({
    String mailboxName = 'INBOX',
    int count = 50,
    int page = 1,
  }) async {
    return _ensureConnection(() async {
      // 1) Select mailbox
      final mailbox = await _imapClient!.selectMailboxByPath(mailboxName);
      final total = mailbox.messagesExists;
      if (total == 0) return [];

      // 2) Determine sequence range
      final start = math.max(1, total - (page * count) + 1);
      final end = math.min(total, total - ((page - 1) * count));

      // 3) Fetch headers
      final result = await _imapClient!.fetchMessages(
        MessageSequence.fromRange(start, end),
        '(UID FLAGS BODY.PEEK[HEADER.FIELDS (FROM TO SUBJECT DATE MESSAGE-ID)])', // only fetch the headers and additional display info
      );

      // 4) Convert and reverse for newest-first order
      final emails = await Future.wait(
        result.messages.map(_convertMimeMessageToEmail),
      );
      return emails.reversed.toList();
    });
  }

  // Fetches a single email by its UID.
  Future<Email?> fetchEmailByUid(int uid, {String mailboxName = 'INBOX'}) async {
    final results = await fetchEmailsbyUIDs([uid], mailboxName: mailboxName, withBody: true);
    return results.isEmpty ? null : results.first;
  }

  // Fetch Emails by their UID, with or without their body
  Future<List<Email>> fetchEmailsbyUIDs(
    List<int> uids, {
    String mailboxName = 'INBOX',
    bool withBody = false,
  }) {
    return _ensureConnection(() async {
      if (uids.isEmpty) return [];

      await _imapClient!.selectMailboxByPath(mailboxName);

      final sequence = MessageSequence.fromIds(uids, isUid: true);
      final fetchCriteria =
          withBody ? '(FLAGS BODY[])' : '(UID FLAGS BODY.PEEK[HEADER.FIELDS (FROM TO SUBJECT DATE MESSAGE-ID)])';
      final result = await _imapClient!.uidFetchMessages(sequence, fetchCriteria);

      final emails = await Future.wait(result.messages.map(_convertMimeMessageToEmail));
      return emails;
    });
  }

  // Sends an email via SMTP, then appends it into the IMAP “Sent” folder.
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    required String senderEmail,
    String senderName = '',
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

      // build message explicitly (works more reliably as seen in drafts)
      final builder = MessageBuilder();
      builder.from = [MailAddress(senderName, senderEmail)];
      builder.to = [MailAddress('', to)];
      builder.subject = subject;
      builder.addTextPlain(body);

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
      debugPrint('SMTP: Message sent');

      // ─── 4) Append to IMAP “Sent” folder ──────────────────────────────────
      return _ensureConnection(() async {
        try {
          await _imapClient!.selectMailboxByPath('Sent');
          await _imapClient!.appendMessage(
            mimeMessage,
            flags: [MessageFlags.seen], // mark as read in Sent
          );
          debugPrint('IMAP: Appended message to Sent');
        } catch (e) {
          debugPrint('IMAP: Failed to append to Sent: $e');
        }

        return true;
      });
    } catch (e) {
      debugPrint('sendEmail error: $e');
      return false;
    }
  }

  // Appends (or updates) a draft in the IMAP “Drafts” folder.
  Future<int?> appendDraft(Email draft) async {
    return _ensureConnection(() async {
      // Select the Drafts mailbox
      await _imapClient!.selectMailboxByPath('Drafts');

      // try to delete the outdated draft server side
      if (draft.uid != 0) {
        try {
          await _imapClient!.uidStore(
            MessageSequence.fromId(draft.uid),
            [MessageFlags.deleted],
          );
          await _imapClient!.expunge();
          debugPrint('DRAFTS: deleted old draft: UID: ${draft.uid}');
        } catch (e) {
          debugPrint('DRAFTS: failed to delete old draft: UID: ${draft.uid}');
        }
      }

      // Build draft MIME
      final builder = MessageBuilder();

      builder.from = [MailAddress(draft.sender, draft.senderEmail)];
      builder.to = draft.recipients.map((r) => MailAddress('', r)).toList();
      builder.subject = draft.subject;
      builder.addTextPlain(draft.body);
      builder.setHeader('X-Local-Draft-ID', draft.id); // Header to keep track of our Drafts

      final mime = builder.buildMimeMessage();

      try {
        final appendResult = await _imapClient!.appendMessage(
          mime,
          flags: [MessageFlags.draft, MessageFlags.seen],
        );
        // get the UID of the newly appended Email and pass it along so we can keep track of the current UID
        final newUID = appendResult.responseCodeAppendUid;
        final uid = newUID?.targetSequence.toList().first;
        return uid;
      } catch (e) {
        debugPrint('appendDraft error: $e');
        return null;
      }
    });
  }

  /// Lists all mailbox names on the server.
  Future<List<String>> getMailboxes() async {
    return _ensureConnection(() async {
      final boxes = await _imapClient!.listMailboxes();
      return boxes.map((m) => m.name).toList();
    });
  }

  /// Searches emails in [mailboxName] matching optional criteria.
  Future<List<int>> searchEmailUIDs({
    String mailboxName = 'INBOX',
    String? query,
    String? from,
    String? subject,
    DateTime? since,
    bool unreadOnly = false,
  }) async {
    return _ensureConnection(
      () async {
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

        await _imapClient!.selectMailboxByPath(mailboxName);

        final searchResult = await _imapClient!.uidSearchMessages(
          searchCriteria: criteria.join(' '),
        );

        if (searchResult.matchingSequence == null || searchResult.matchingSequence!.isEmpty) {
          return [];
        }

        // return only the uids of matching emails
        final uids = searchResult.matchingSequence!.toList();
        return uids.reversed.toList();
      },
      timeout: const Duration(seconds: 90),
    );
  }

  // Internal helper to add/remove flags (e.g., Seen).
  Future<bool> _updateEmailFlags(
    int uid,
    List<String> flags, {
    bool remove = false,
    String mailboxName = 'INBOX',
  }) async {
    return _ensureConnection(() async {
      try {
        await _imapClient!.selectMailboxByPath(mailboxName);
        await _imapClient!.uidStore(
          MessageSequence.fromId(uid),
          flags,
          action: remove ? StoreAction.remove : StoreAction.add,
        );
        return true;
      } catch (e) {
        debugPrint('Error updating email flags: $e');
        return false;
      }
    });
  }

  Future<bool> markAsRead(int uid, {String mailboxName = 'INBOX'}) =>
      _updateEmailFlags(uid, [MessageFlags.seen], mailboxName: mailboxName);

  Future<bool> markAsUnread(int uid, {String mailboxName = 'INBOX'}) =>
      _updateEmailFlags(uid, [MessageFlags.seen], remove: true, mailboxName: mailboxName);

  // Deletes a message (marks \Deleted + EXPUNGE).
  Future<bool> deleteEmail(int uid, {String mailboxName = 'INBOX'}) async {
    return _ensureConnection(() async {
      try {
        await _imapClient!.selectMailboxByPath(mailboxName);
        await _imapClient!.uidStore(
          MessageSequence.fromId(uid),
          [MessageFlags.deleted],
          action: StoreAction.add,
        );
        await _imapClient!.expunge();
        return true;
      } catch (e) {
        debugPrint('Error deleting email: $e');
        return false;
      }
    });
  }

  // Moves an email and returns it's new UID
  Future<int?> moveEmail(
    int uid,
    String targetMailbox, {
    String sourceMailbox = 'INBOX',
  }) async {
    return _ensureConnection(() async {
      try {
        // select the source Mailbox and pass the target directly to the move function
        await _imapClient!.selectMailboxByPath(sourceMailbox);
        final result = await _imapClient!.uidMove(MessageSequence.fromId(uid), targetMailboxPath: targetMailbox);
        final copyUid = result.responseCodeCopyUid;

        // parse to int to keep track of the new assigned UID
        if (copyUid != null) {
          return int.tryParse(copyUid.targetSequence.toString());
        }

        return uid;
      } catch (e) {
        debugPrint('Error moving email: $e');
        return null;
      }
    });
  }

  // ------------------------------------------------------------------------------------ MIME Helper Functions -------------------------------------------------------------------------------- //

  // extracting the plain text body by MIME tree
  String _extractPlainBody(MimeMessage msg) {
    // try to decode a message to Plain text directly
    final simpleMsg = msg.decodeTextPlainPart();
    if (simpleMsg != null && simpleMsg.trim().isNotEmpty) return simpleMsg;

    for (final MimePart part in msg.parts ?? []) {
      final text = part.decodeTextPlainPart();
      if (text != null && text.trim().isNotEmpty) return text;

      for (final MimePart subPart in part.parts ?? []) {
        final subText = subPart.decodeTextPlainPart();
        if (subText != null && subText.trim().isNotEmpty) return subText;
      }
    }
    return '';
  }

  // same procedure for html bodies
  String? _extractHtmlBody(MimeMessage msg) {
    final simpleHTMLMsg = msg.decodeTextHtmlPart();
    if (simpleHTMLMsg != null && simpleHTMLMsg.trim().isNotEmpty) return simpleHTMLMsg;

    for (final MimePart part in msg.parts ?? []) {
      final html = part.decodeTextHtmlPart();
      if (html != null && html.trim().isNotEmpty) return html;
      for (final MimePart subPart in part.parts ?? []) {
        final subHTML = subPart.decodeTextHtmlPart();
        if (subHTML != null && subHTML.trim().isNotEmpty) return subHTML;
      }
    }
    return null;
  }

  // extract Inline attachments and replace their cid identifier with data so the webview can render the image
  String _resolveCIDImages(String html, MimeMessage msg) {
    final cidIdentifier = RegExp(r'cid:([^">\s]+)');

    return html.replaceAllMapped(cidIdentifier, (match) {
      final contentId = match.group(1)!;

      // search message parts for cid beginning
      for (final part in msg.allPartsFlat) {
        final partContentId = part.getHeaderValue('content-id')?.replaceAll('<', '').replaceAll('>', '').trim();

        if (partContentId == contentId) {
          final bytes = part.decodeContentBinary();
          if (bytes != null) {
            final base64Data = base64Encode(bytes);
            final mimeType = part.mediaType.text;
            return 'data:$mimeType;base64,$base64Data';
          }
        }
      }
      return '';
    });
  }

  // Converts a raw [MimeMessage] into your app’s [Email] model.
  Future<Email> _convertMimeMessageToEmail(MimeMessage msg) async {
    final plain = _extractPlainBody(msg);
    String? html = _extractHtmlBody(msg);

    // if we're dealing with a draft, try to use the saved header id
    final localDraftID = msg.getHeaderValue('X-Local-Draft-ID');
    final id = localDraftID?.isNotEmpty == true
        ? localDraftID!
        : msg.uid?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();

    // if email contains inline attached images, try to resolve them before building the email
    if (html != null && html.contains('cid')) {
      html = _resolveCIDImages(html, msg);
    }

    return Email(
      id: id,
      subject: msg.decodeSubject() ?? 'No Subject',
      body: plain.isNotEmpty ? plain : (html ?? ''),
      htmlBody: html,
      sender: msg.from?.isNotEmpty == true
          ? (msg.from!.first.personalName?.isNotEmpty == true
              ? msg.from!.first.personalName!
              : msg.from!.first.encode() ?? 'Unknown')
          : 'Unknown',
      senderEmail: msg.from?.isNotEmpty == true ? (msg.from?.first.email ?? '') : '',
      recipients: msg.to?.where((a) => a.email.isNotEmpty).map((a) => a.email).toList() ?? [],
      date: msg.decodeDate() ?? DateTime.now(),
      isUnread: !msg.isSeen,
      isStarred: msg.isFlagged,
      attachments: <String>[],
      uid: msg.uid ?? 0,
    );
  }
}
