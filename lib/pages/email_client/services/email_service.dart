// REFACTORED EMAIL SERVICE (Business Logic Only)
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/repositories/email_repository.dart';
import 'package:campus_app/core/injection.dart';

class EmailService extends ChangeNotifier {
  final List<Email> _allEmails = [];
  final EmailSelectionController _selectionController = EmailSelectionController();
  final EmailAuthService _authService = sl<EmailAuthService>();
  final EmailRepository _emailRepository;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  EmailService(this._emailRepository) {
    _selectionController.addListener(notifyListeners);
  }

  // Public API
  List<Email> get allEmails => List.unmodifiable(_allEmails);
  EmailSelectionController get selectionController => _selectionController;

  /// Initialize the email service with authenticated credentials
  Future<void> initialize() async {
    try {
      final credentials = await _authService.getCredentials();
      if (credentials == null) {
        throw Exception('No valid credentials found');
      }

      await _connectToEmailServer(credentials['username']!, credentials['password']!);

      _isInitialized = true;
      notifyListeners();
      await refreshEmails();
    } catch (e) {
      _isInitialized = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Connect to the email server
  Future<void> _connectToEmailServer(String username, String password) async {
    final success = await _emailRepository.connect(username, password);
    if (!success) {
      throw Exception('Failed to connect to email server');
    }
  }

  /// Refresh emails from server
  Future<void> refreshEmails() async {
    if (!_isInitialized) {
      throw Exception('Email service not initialized');
    }

    try {
      await _fetchEmailsFromServer();
      notifyListeners();
    } catch (e) {
      if (e.toString().contains('authentication') || e.toString().contains('credentials')) {
        await _authService.logout();
        _isInitialized = false;
        await _emailRepository.disconnect();
        notifyListeners();
      }
      rethrow;
    }
  }

  /// Fetch emails from the server
  Future<void> _fetchEmailsFromServer() async {
    _allEmails.clear();

    // Define folder mappings with fallbacks
    final folderMappings = {
      EmailFolder.inbox: ['INBOX'],
      EmailFolder.sent: ['Sent'],
      EmailFolder.drafts: ['Drafts'],
      EmailFolder.trash: ['Trash'],
    };

    for (final entry in folderMappings.entries) {
      final folder = entry.key;
      final folderNames = entry.value;

      await _fetchEmailsForFolder(folder, folderNames);
    }
  }

  Future<void> _fetchEmailsForFolder(EmailFolder folder, List<String> folderNames) async {
    for (final folderName in folderNames) {
      try {
        final count = folder == EmailFolder.inbox ? 50 : 30;
        final emails = await _emailRepository.fetchEmails(mailboxName: folderName, count: count);

        for (final email in emails) {
          _allEmails.add(email.copyWith(folder: folder));
        }
        return; // Success, no need to try other folder names
      } catch (e) {
        continue; // Try next folder name
      }
    }

    if (folder != EmailFolder.inbox) {
      print('Could not fetch ${folder.name} emails from any of: ${folderNames.join(', ')}');
    }
  }

  /// Clear all email data
  void clear() {
    _allEmails.clear();
    _isInitialized = false;
    _emailRepository.disconnect();
    notifyListeners();
  }

  /// Send email
  Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
    String? cc,
    String? bcc,
  }) async {
    if (!_isInitialized) {
      throw Exception('Email service not initialized');
    }

    final success = await _emailRepository.sendEmail(
      to: to,
      subject: subject,
      body: body,
      cc: cc?.split(',').map((e) => e.trim()).toList(),
      bcc: bcc?.split(',').map((e) => e.trim()).toList(),
    );

    if (!success) {
      throw Exception('Failed to send email');
    }

    await _refreshSentEmails();
    notifyListeners();
  }

  /// Refresh sent emails only
  Future<void> _refreshSentEmails() async {
    _allEmails.removeWhere((e) => e.folder == EmailFolder.sent);
    await _fetchEmailsForFolder(EmailFolder.sent, ['Sent', 'INBOX.Sent', 'INBOX/Sent']);
  }

  /// Mark email as read
  Future<void> markAsRead(Email email) async {
    if (!_isInitialized || email.uid == 0) return;

    final success = await _emailRepository.markAsRead(email.uid);
    if (success) {
      updateEmail(email.copyWith(isRead: true));
    }
  }

  /// Mark email as unread
  Future<void> markAsUnread(Email email) async {
    if (!_isInitialized || email.uid == 0) return;

    final success = await _emailRepository.markAsUnread(email.uid);
    if (success) {
      updateEmail(email.copyWith(isRead: false));
    }
  }

  /// Delete email (move to trash or permanently delete)
  Future<void> deleteEmail(Email email) async {
    if (!_isInitialized || email.uid == 0) return;

    if (email.folder == EmailFolder.trash) {
      final success = await _emailRepository.deleteEmail(email.uid, mailboxName: 'Trash');
      if (success) {
        _allEmails.removeWhere((e) => e.id == email.id);
        notifyListeners();
      }
    } else {
      final success = await _emailRepository.moveEmail(email.uid, 'Trash');
      if (success) {
        updateEmail(email.copyWith(folder: EmailFolder.trash));
      }
    }
  }

  /// Search emails
  Future<List<Email>> searchEmails({
    String? query,
    String? from,
    String? subject,
    EmailFolder? folder,
    bool unreadOnly = false,
  }) async {
    if (!_isInitialized) return [];

    final mailboxName = _getMailboxNameForFolder(folder ?? EmailFolder.inbox);
    final results = await _emailRepository.searchEmails(
      query: query,
      from: from,
      subject: subject,
      unreadOnly: unreadOnly,
      mailboxName: mailboxName,
    );

    return results.map((email) => email.copyWith(folder: folder ?? EmailFolder.inbox)).toList();
  }

  String _getMailboxNameForFolder(EmailFolder folder) {
    switch (folder) {
      case EmailFolder.sent:
        return 'Sent';
      case EmailFolder.drafts:
        return 'Drafts';
      case EmailFolder.trash:
        return 'Trash';
      default:
        return 'INBOX';
    }
  }

  /// Check if service needs re-authentication
  Future<bool> needsReAuthentication() async {
    if (!_isInitialized) return true;
    if (!_emailRepository.isConnected) return true;
    return !(await _authService.validateCurrentCredentials());
  }

  // ========================================================================
  // LOCAL DATA MANAGEMENT METHODS
  // ========================================================================

  List<Email> filterEmails(String query, EmailFolder folder) {
    final filtered = _allEmails.where((e) => e.folder == folder).toList();
    if (query.isEmpty) return filtered;

    return filtered
        .where((email) =>
            email.sender.toLowerCase().contains(query.toLowerCase()) ||
            email.subject.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void updateEmail(Email updatedEmail) {
    final index = _allEmails.indexWhere((e) => e.id == updatedEmail.id);
    if (index != -1) {
      _allEmails[index] = updatedEmail;
      notifyListeners();
    }
  }

  void moveEmailsToFolder(Iterable<Email> emails, EmailFolder folder) {
    for (final email in emails) {
      if (_isInitialized && email.uid != 0) {
        final targetMailbox = _getMailboxNameForFolder(folder);
        _emailRepository.moveEmail(email.uid, targetMailbox).catchError((e) {
          print('Error moving email on server: $e');
        });
      }

      final index = _allEmails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        _allEmails[index] = email.copyWith(folder: folder);
      }
    }
    notifyListeners();
  }

  void deleteEmailsPermanently(Iterable<Email> emails) {
    for (final email in emails) {
      if (_isInitialized && email.uid != 0) {
        _emailRepository.deleteEmail(email.uid).catchError((e) {
          print('Error deleting email permanently: $e');
        });
      }
    }

    _allEmails.removeWhere((e) => emails.any((email) => email.id == e.id));
    _selectionController.clearSelection();
    notifyListeners();
  }

  void saveOrUpdateDraft(Email draft) {
    if (_isDraftEmpty(draft)) {
      final existingIndex = _allEmails.indexWhere((e) => e.id == draft.id);
      if (existingIndex != -1) {
        _allEmails.removeAt(existingIndex);
        notifyListeners();
      }
      return;
    }

    final index = _allEmails.indexWhere((e) => e.id == draft.id);
    final updatedDraft = draft.copyWith(folder: EmailFolder.drafts);

    if (index != -1) {
      _allEmails[index] = updatedDraft;
    } else {
      _allEmails.add(updatedDraft);
    }

    notifyListeners();
  }

  void removeDraft(String draftId) {
    Email? draft;
    try {
      draft = _allEmails.firstWhere(
        (e) => e.id == draftId && e.folder == EmailFolder.drafts,
      );
    } catch (e) {
      draft = null; // Email not found
    }

    if (draft != null && _isInitialized && draft.uid != 0) {
      _emailRepository.deleteEmail(draft.uid, mailboxName: 'Drafts').catchError((e) {
        print('Error removing draft from server: $e');
      });
    }

    _allEmails.removeWhere((e) => e.id == draftId && e.folder == EmailFolder.drafts);
    notifyListeners();
  }

  void cleanEmptyDrafts() {
    final emptyDrafts = _allEmails.where((e) => e.folder == EmailFolder.drafts && _isDraftEmpty(e)).toList();

    if (emptyDrafts.isNotEmpty) {
      deleteEmailsPermanently(emptyDrafts);
    }
  }

  bool _isDraftEmpty(Email draft) {
    return draft.subject.trim().isEmpty && draft.body.trim().isEmpty && draft.recipients.isEmpty;
  }

  int get emptyDraftsCount {
    return _allEmails.where((e) => e.folder == EmailFolder.drafts && _isDraftEmpty(e)).length;
  }

  int get unreadCount {
    return _allEmails.where((e) => e.folder == EmailFolder.inbox && !e.isRead).length;
  }

  @override
  void dispose() {
    _selectionController.dispose();
    _emailRepository.disconnect();
    super.dispose();
  }
}
