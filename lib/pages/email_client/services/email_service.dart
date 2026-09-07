import 'package:flutter/foundation.dart';

import 'dart:math';

import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/repositories/email_repository.dart';
import 'package:campus_app/core/injection.dart';

class EmailService extends ChangeNotifier {
  final List<Email> _allEmails = [];

  final List<UserEmailFolder> _userFolders = [];

  final EmailSelectionController _selectionController = EmailSelectionController();

  final EmailAuthService _authService = sl<EmailAuthService>();
  final EmailRepository _emailRepository;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<Email> get allEmails => List.unmodifiable(_allEmails);
  List<UserEmailFolder> get userFolders => List.unmodifiable(_userFolders);
  EmailSelectionController get selectionController => _selectionController;

  EmailService(this._emailRepository) {
    _selectionController.addListener(notifyListeners);
  }

  // Called once when the email client starts.
  // Connects to the server, loads folder list, resolves system folders, then loads emails.
  Future<void> initialize() async {
    try {
      final credentials = await _authService.getCredentials();
      if (credentials == null) {
        throw Exception('No credentials found');
      }

      await _connectToEmailServer(
        credentials['username']!,
        credentials['password']!,
      );

      _isInitialized = true;
      notifyListeners();

      //  Load folders dynamically
      await loadUserFolders();

      //  Load emails for resolved system folders
      await refreshEmails();
    } catch (e) {
      _isInitialized = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _connectToEmailServer(String username, String password) async {
    final success = await _emailRepository.connect(username, password);
    if (!success) {
      throw Exception('Failed to connect to email server');
    }
  }

  void clear() {
    _allEmails.clear();
    _userFolders.clear();
    _isInitialized = false;
    _emailRepository.disconnect();
    notifyListeners();
  }

  @override
  void dispose() {
    _selectionController.dispose();
    _emailRepository.disconnect();
    super.dispose();
  }

  // Loads all mailbox names from the server.
  // We keep them for the drawer/UI and also try to detect system folders.
  Future<void> loadUserFolders() async {
    if (!_isInitialized) {
      throw Exception('Email service not initialized');
    }

    try {
      final mailboxes = await _emailRepository.listMailboxes();

      final systemFolders = [
        UserEmailFolder.inbox,
        UserEmailFolder.sent,
        UserEmailFolder.drafts,
        UserEmailFolder.trash,
        UserEmailFolder.spam,
      ];

      // Store all mailboxes for UI (including nested ones)
      _userFolders
        ..clear()
        ..addAll(
          mailboxes.where((mb) => mb.trim().isNotEmpty).map((mb) {
            final systemMatch = systemFolders
                .where(
                  (f) => f.mailboxName.toLowerCase() == mb.toLowerCase(),
                )
                .firstOrNull;

            return systemMatch ??
                UserEmailFolder(
                  mailboxName: mb,
                  displayName: mb,
                );
          }),
        );

      notifyListeners();
    } catch (e) {
      // Folder loading should not crash the app. Worst case is  drawer stays minimal.
      debugPrint('Failed to load folders: $e');
    }
  }

  // Reloads emails from the server for all system folders that were actually resolved.
  Future<void> refreshEmails() async {
    if (!_isInitialized) {
      throw Exception('Email service not initialized');
    }

    try {
      await _fetchEmailsFromServer();
      notifyListeners();
    } catch (e) {
      // If auth dies, force logout so the UI can ask for login again.
      if (e.toString().toLowerCase().contains('authentication')) {
        await _authService.logout();
        _isInitialized = false;
        await _emailRepository.disconnect();
        notifyListeners();
      }
      rethrow;
    }
  }

  // Loads emails for each resolved system folder.
  // If a folder could not be resolved on this server, we simply skip it.
  Future<void> _fetchEmailsFromServer() async {
    _allEmails.clear();

    for (final folder in _userFolders) {
      await _fetchEmailsForMailbox(folder);
    }
  }

  // Fetches emails from a single mailbox and merges them into the local cache.
  Future<void> _fetchEmailsForMailbox(UserEmailFolder folder) async {
    try {
      final count = folder == UserEmailFolder.inbox ? 50 : 30;
      final emails = await _emailRepository.fetchEmails(
        mailboxName: folder.mailboxName,
        count: count,
      );

      for (final email in emails) {
        _allEmails.add(
          email.copyWith(
            folder: folder,
            mailboxName: folder.mailboxName,
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to fetch ${folder.displayName}: $e');
    }
  }

  Future<void> markAsRead(Email email) async {
    if (!_isInitialized || email.uid == 0) return;
    final success = await _emailRepository.markAsRead(email.uid);
    if (success) updateEmail(email.copyWith(isRead: true));
  }

  Future<void> markAsUnread(Email email) async {
    if (!_isInitialized || email.uid == 0) return;
    final success = await _emailRepository.markAsUnread(email.uid);
    if (success) updateEmail(email.copyWith(isRead: false));
  }

  // Moves an email to trash if possible.
  // If Trash is not resolved on this server, we fall back to a local-only move.
  Future<void> deleteEmail(Email email) async {
    if (!_isInitialized || email.uid == 0) return;

    final trashMailbox = UserEmailFolder.trash.mailboxName;

    // If the email is already in trash, try to delete permanently from that mailbox.
    if (email.folder == UserEmailFolder.trash) {
      final mailbox = email.mailboxName ?? trashMailbox;
      final success = await _emailRepository.deleteEmail(
        email.uid,
        mailboxName: mailbox,
      );
      if (success) {
        _allEmails.removeWhere((e) => e.id == email.id);
        notifyListeners();
      }
      return;
    }

    // Otherwise move it to trash.
    final moved = await _emailRepository.moveEmail(email.uid, trashMailbox,
        sourceMailbox: email.mailboxName ?? UserEmailFolder.inbox.mailboxName);
    if (moved != null) updateEmail(email.copyWith(folder: UserEmailFolder.trash));
  }

  // wrapper for easier access to move Operation with folder names
  Future<void> moveEmailsToFolder(
    List<Email> emails,
    UserEmailFolder folder,
  ) async {
    await moveEmailsToMailbox(emails, folder.mailboxName);
  }

  // wrapper function for moving mutliple emails
  Future<void> moveEmailsToMailbox(List<Email> emails, String targetMailboxName) async {
    for (final email in emails) {
      await moveEmailToMailbox(email, targetMailboxName);
    }
  }

  // move Email to a Mailbox
  Future<Email?> moveEmailToMailbox(Email email, String targetMailboxName) async {
    if (!_isInitialized || email.uid == 0) return null;

    final sourceMailbox = email.mailboxName ?? 'INBOX';

    final newUID = await _emailRepository.moveEmail(
      email.uid,
      targetMailboxName,
      sourceMailbox: sourceMailbox,
    );

    if (newUID != null) {
      final targetFolder = _userFolders.firstWhere(
        (f) => f.mailboxName == targetMailboxName,
        orElse: () => UserEmailFolder(
          mailboxName: targetMailboxName,
          displayName: targetMailboxName,
        ),
      );

      final updated = email.copyWith(
        uid: newUID,
        folder: targetFolder,
        mailboxName: targetMailboxName,
      );
      updateEmail(updated);
      return updated;
    }
    return null;
  }

  /// Sends a new email and refreshes Sent if the server has it.
  Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
    required String senderEmail,
    String? cc,
    String? bcc,
  }) async {
    if (!_isInitialized) throw Exception('Email service not initialized');

    final displayName = await _authService.getDisplayName() ?? '';

    final success = await _emailRepository.sendEmail(
      to: to,
      subject: subject,
      body: body,
      senderEmail: senderEmail,
      senderName: displayName,
      cc: cc?.split(',').map((e) => e.trim()).toList(),
      bcc: bcc?.split(',').map((e) => e.trim()).toList(),
    );

    if (!success) throw Exception('Failed to send email');

    // Refresh Sent only if we know the mailbox name
    _allEmails.removeWhere((e) => e.folder == UserEmailFolder.sent);
    await _fetchEmailsForMailbox(UserEmailFolder.sent);
    notifyListeners();
  }

  List<int> _searchUIDs = [];
  int _searchSession = 0;
  static const int _searchBatchSize = 30; // for now see how 30 emails at a time impacts performance
  bool _hasMoreSearchResults = false;

  // Searches emails in a folder (only works if that folder has a resolved mailbox).
  Future<List<Email>> searchEmails({
    String? query,
    String? from,
    String? subject,
    UserEmailFolder? folder,
    bool unreadOnly = false,
  }) async {
    if (!_isInitialized) return [];

    final targetFolder = folder ?? UserEmailFolder.inbox;
    final mailboxName = targetFolder.mailboxName;

    _searchUIDs = await _emailRepository.searchEmailUIDs(
      query: query,
      from: from,
      subject: subject,
      unreadOnly: unreadOnly,
      mailboxName: mailboxName,
    );

    _searchSession = 0;
    _hasMoreSearchResults = _searchUIDs.length > _searchBatchSize;

    return _fetchSearchBatch(targetFolder);
  }

  // returns a batch of emails
  Future<List<Email>> _fetchSearchBatch(
    UserEmailFolder folder,
  ) async {
    final start = _searchSession * _searchBatchSize;
    final end = min(start + _searchBatchSize, _searchUIDs.length);

    if (start >= _searchUIDs.length) {
      _hasMoreSearchResults = false;
      return [];
    }

    _hasMoreSearchResults = end < _searchUIDs.length;

    final batchUIDs = _searchUIDs.sublist(start, end);
    final emails = await _emailRepository.fetchEmailsbyUIDs(batchUIDs, mailboxName: folder.mailboxName);

    return emails.map((email) => email.copyWith(folder: folder, mailboxName: folder.mailboxName)).toList();
  }

  bool get hasMoreSearchResults => _hasMoreSearchResults;

  // initiate loading the next session of matching Emails to a search
  Future<List<Email>> loadMoreSearchResults({UserEmailFolder? folder}) async {
    if (!_isInitialized || !_hasMoreSearchResults) return [];

    final targetFolder = folder ?? UserEmailFolder.inbox;

    _searchSession++;
    return _fetchSearchBatch(targetFolder);
  }

  // Saves or updates a draft locally and on the server .
  Future<void> saveOrUpdateDraft(Email draft) async {
    //  Local update first (fast UI feedback)
    if (_isDraftEmpty(draft)) {
      _allEmails.removeWhere((e) => e.id == draft.id);
      notifyListeners();
      return;
    }

    final mailboxName = UserEmailFolder.drafts.mailboxName;
    final updatedDraft = draft.copyWith(folder: UserEmailFolder.drafts, mailboxName: mailboxName);
    final index = _allEmails.indexWhere((e) => e.id == draft.id);

    if (index != -1) {
      _allEmails[index] = updatedDraft;
    } else {
      _allEmails.add(updatedDraft);
    }
    notifyListeners();

    try {
      final newUID = await _emailRepository.saveDraft(updatedDraft);
      if (newUID != null) {
        final index = _allEmails.indexWhere((e) => e.id == updatedDraft.id);
        if (index != -1) {
          _allEmails[index] = _allEmails[index].copyWith(uid: newUID);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Failed to save draft on server: $e');
    }
  }

  void removeDraft(String draftId) {
    final draft = _allEmails.firstWhere(
      (e) => e.id == draftId && e.folder == UserEmailFolder.drafts,
      orElse: () => Email(
        id: '',
        sender: '',
        senderEmail: '',
        recipients: [],
        subject: '',
        body: '',
        date: DateTime.now(),
      ),
    );

    final draftsMailbox = UserEmailFolder.drafts.mailboxName;
    if (_isInitialized && draft.uid != 0 && draft.id.isNotEmpty) {
      _emailRepository.deleteEmail(draft.uid, mailboxName: draftsMailbox).catchError((_) {});
    }

    _allEmails.removeWhere((e) => e.id == draftId && e.folder == UserEmailFolder.drafts);
    notifyListeners();
  }

  bool _isDraftEmpty(Email draft) {
    return draft.subject.trim().isEmpty && draft.body.trim().isEmpty && draft.recipients.isEmpty;
  }

  List<Email> filterEmails(String query, UserEmailFolder folder) {
    final filtered = _allEmails.where((e) => e.folder == folder).toList();
    if (query.isEmpty) return filtered;

    final q = query.toLowerCase();
    return filtered.where((email) {
      return email.sender.toLowerCase().contains(q) || email.subject.toLowerCase().contains(q);
    }).toList();
  }

  List<Email> getEmailsForMailbox(String mailboxName) {
    final target = mailboxName.trim().toLowerCase();

    return _allEmails.where((email) {
      return (email.mailboxName ?? '').trim().toLowerCase() == target;
    }).toList();
  }

  void updateEmail(Email updatedEmail) {
    final index = _allEmails.indexWhere((e) => e.id == updatedEmail.id);
    if (index != -1) {
      _allEmails[index] = updatedEmail;
      notifyListeners();
    }
  }

  // access to fetching Emails by their UID + mailbox
  Future<Email?> fetchFullEmail(Email email) async {
    if (!_isInitialized || email.uid == 0) return null;

    final mailboxName = email.mailboxName ?? UserEmailFolder.inbox.mailboxName; // Inbox fallback

    try {
      final full = await _emailRepository.fetchEmailbyUID(email.uid, mailboxName: mailboxName);
      if (full != null) {
        final index = _allEmails.indexWhere((e) => e.uid == email.uid && e.mailboxName == mailboxName);
        if (index != -1) {
          _allEmails[index] = _allEmails[index].copyWith(
            body: full.body,
            htmlBody: full.htmlBody,
            id: full.id,
          );
          return _allEmails[index];
        }
        return full.copyWith(
          folder: email.folder,
          mailboxName: mailboxName,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Email Service: error fetching full Email: $e');
      return null;
    }
  }

  // unredCount dynamic
  int get unreadCount => _allEmails.where((e) => e.folder == UserEmailFolder.inbox && !e.isRead).length;
}
