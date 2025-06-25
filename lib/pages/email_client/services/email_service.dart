import 'package:flutter/foundation.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/repositories/email_repository.dart';
import 'package:campus_app/core/injection.dart';

class EmailService extends ChangeNotifier {
  final List<Email> _allEmails = []; // Local email cache
  final EmailSelectionController _selectionController = EmailSelectionController();
  final EmailAuthService _authService = sl<EmailAuthService>();
  final EmailRepository _emailRepository;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  EmailService(this._emailRepository) {
    _selectionController.addListener(notifyListeners);
  }

  List<Email> get allEmails => List.unmodifiable(_allEmails);
  EmailSelectionController get selectionController => _selectionController;

  /// Initialize connection and pull all folders (including drafts).
  Future<void> initialize() async {
    try {
      final credentials = await _authService.getCredentials();
      if (credentials == null) throw Exception('No valid credentials found');
      await _connectToEmailServer(credentials['username']!, credentials['password']!);
      _isInitialized = true;
      notifyListeners();

      // Immediately load all folders, including drafts on the server
      await refreshEmails();
    } catch (e) {
      _isInitialized = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _connectToEmailServer(String username, String password) async {
    final success = await _emailRepository.connect(username, password);
    if (!success) throw Exception('Failed to connect to email server');
  }

  /// Refreshes all mailbox folders, including server drafts.
  Future<void> refreshEmails() async {
    if (!_isInitialized) throw Exception('Email service not initialized');
    try {
      await _fetchEmailsFromServer();
      notifyListeners();
    } catch (e) {
      if (e.toString().contains('authentication')) {
        await _authService.logout();
        _isInitialized = false;
        await _emailRepository.disconnect();
        notifyListeners();
      }
      rethrow;
    }
  }

  /// Fetches inbox, sent, drafts (server-side), trash, spam.
  Future<void> _fetchEmailsFromServer() async {
    _allEmails.clear();

    final folderMappings = {
      EmailFolder.inbox: ['INBOX'],
      EmailFolder.sent: ['Sent'],
      EmailFolder.drafts: ['Drafts'], // ← We’ll fetch server drafts separately below
      EmailFolder.trash: ['Trash'],
      EmailFolder.spam: ['UCE-TMP'],
    };

    // 1) Fetch standard folders
    for (final entry in folderMappings.entries) {
      final folder = entry.key;
      final folderNames = entry.value;
      await _fetchEmailsForFolder(folder, folderNames);
    }

    // 2) Fetch server-side drafts and merge
    try {
      final serverDrafts = await _emailRepository.fetchDrafts(count: 50);
      for (final draft in serverDrafts) {
        _allEmails.add(draft.copyWith(folder: EmailFolder.drafts));
      }
    } catch (e) {
      print('Could not fetch server drafts: $e');
    }
  }

  /// Helper to try all mailbox name aliases for a given folder.
  Future<void> _fetchEmailsForFolder(EmailFolder folder, List<String> folderNames) async {
    for (final folderName in folderNames) {
      try {
        final count = folder == EmailFolder.inbox ? 50 : 30;
        final emails = await _emailRepository.fetchEmails(mailboxName: folderName, count: count);
        for (final email in emails) {
          _allEmails.add(email.copyWith(folder: folder));
        }
        return;
      } catch (_) {
        // try next alias
      }
    }

    if (folder != EmailFolder.inbox) {
      print('Could not fetch ${folder.name} emails from: ${folderNames.join(', ')}');
    }
  }

  void clear() {
    _allEmails.clear();
    _isInitialized = false;
    _emailRepository.disconnect();
    notifyListeners();
  }

  /// Sends a new email over SMTP and refreshes the Sent folder.
  Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
    String? cc,
    String? bcc,
  }) async {
    if (!_isInitialized) throw Exception('Email service not initialized');

    final success = await _emailRepository.sendEmail(
      to: to,
      subject: subject,
      body: body,
      cc: cc?.split(',').map((e) => e.trim()).toList(),
      bcc: bcc?.split(',').map((e) => e.trim()).toList(),
    );
    if (!success) throw Exception('Failed to send email');

    await _refreshSentEmails();
    notifyListeners();
  }

  Future<void> _refreshSentEmails() async {
    _allEmails.removeWhere((e) => e.folder == EmailFolder.sent);
    await _fetchEmailsForFolder(EmailFolder.sent, ['Sent', 'INBOX.Sent', 'INBOX/Sent']);
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
      if (success) updateEmail(email.copyWith(folder: EmailFolder.trash));
    }
  }

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

    return results.map((e) => e.copyWith(folder: folder ?? EmailFolder.inbox)).toList();
  }

  String _getMailboxNameForFolder(EmailFolder folder) {
    switch (folder) {
      case EmailFolder.sent:
        return 'Sent';
      case EmailFolder.drafts:
        return 'Drafts';
      case EmailFolder.trash:
        return 'Trash';
      case EmailFolder.spam:
        return 'UCE-TMP';
      default:
        return 'INBOX';
    }
  }

  Future<bool> needsReAuthentication() async {
    if (!_isInitialized) return true;
    if (!_emailRepository.isConnected) return true;
    return !(await _authService.validateCurrentCredentials());
  }

  // === Local Data Helpers ===

  List<Email> filterEmails(String query, EmailFolder folder) {
    final filtered = _allEmails.where((e) => e.folder == folder).toList();
    if (query.isEmpty) return filtered;
    return filtered.where((email) {
      return email.sender.toLowerCase().contains(query.toLowerCase()) ||
          email.subject.toLowerCase().contains(query.toLowerCase());
    }).toList();
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
        _emailRepository.moveEmail(email.uid, targetMailbox).catchError(print);
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
        _emailRepository.deleteEmail(email.uid).catchError(print);
      }
    }
    _allEmails.removeWhere((e) => emails.any((d) => d.id == e.id));
    _selectionController.clearSelection();
    notifyListeners();
  }

  /// Save or update a draft both locally and on the IMAP server
  Future<void> saveOrUpdateDraft(Email draft) async {
    // 1) Local cache update
    if (_isDraftEmpty(draft)) {
      _allEmails.removeWhere((e) => e.id == draft.id);
      notifyListeners();
    } else {
      final updatedDraft = draft.copyWith(folder: EmailFolder.drafts);
      final index = _allEmails.indexWhere((e) => e.id == draft.id);
      if (index != -1) {
        _allEmails[index] = updatedDraft;
      } else {
        _allEmails.add(updatedDraft);
      }
      notifyListeners();
    }

    // 2) Push to server
    try {
      final success = await _emailRepository.saveDraft(draft);
      if (!success) {
        print('Failed to save draft on server');
        // Optionally, show a user-facing error here
      }
    } catch (e) {
      print('Error while saving draft: $e');
      // Optionally, rollback local change
    }
  }

  void removeDraft(String draftId) {
    final draft = _allEmails.firstWhere(
      (e) => e.id == draftId && e.folder == EmailFolder.drafts,
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

    if (_isInitialized && draft.uid != 0 && draft.id.isNotEmpty) {
      _emailRepository.deleteEmail(draft.uid, mailboxName: 'Drafts').catchError(print);
    }

    _allEmails.removeWhere((e) => e.id == draftId && e.folder == EmailFolder.drafts);
    notifyListeners();
  }

  void cleanEmptyDrafts() {
    final emptyDrafts = _allEmails.where((e) => e.folder == EmailFolder.drafts && _isDraftEmpty(e)).toList();
    if (emptyDrafts.isNotEmpty) deleteEmailsPermanently(emptyDrafts);
  }

  bool _isDraftEmpty(Email draft) {
    return draft.subject.trim().isEmpty && draft.body.trim().isEmpty && draft.recipients.isEmpty;
  }

  int get emptyDraftsCount => _allEmails.where((e) => e.folder == EmailFolder.drafts && _isDraftEmpty(e)).length;

  int get unreadCount => _allEmails.where((e) => e.folder == EmailFolder.inbox && !e.isRead).length;

  @override
  void dispose() {
    _selectionController.dispose();
    _emailRepository.disconnect();
    super.dispose();
  }
}
