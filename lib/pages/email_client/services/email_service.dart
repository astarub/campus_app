import 'package:flutter/foundation.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/repositories/email_repository.dart';
import 'package:campus_app/core/injection.dart';

// Represents a mailbox/folder returned by the mail server.


class UserEmailFolder {
  final String mailboxName; // Real server mailbox name (IMAP path)
  final String displayName; // Friendly name shown in the UI

  UserEmailFolder({
    required this.mailboxName,
    required this.displayName,
  });
}

class EmailService extends ChangeNotifier {
  
  final List<Email> _allEmails = [];

  final List<UserEmailFolder> _userFolders = [];
   // Stores resolved mailbox names for system folders.
  //  This starts empty and is only filled if a matching mailbox exists on the server.
  final Map<EmailFolder, String> _folderMailboxNames = {};

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
    _folderMailboxNames.clear();
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

      // Try to resolve which mailbox is Inbox/Sent/Drafts/Trash/Spam/Archive on THIS server.
      _resolveSystemMailboxes(mailboxes);

      // Store all mailboxes for UI (including nested ones)
      _userFolders
        ..clear()
        ..addAll(
          mailboxes
              .where((mb) => mb.trim().isNotEmpty)
              .map(
                (mb) => UserEmailFolder(
                  mailboxName: mb,
                  displayName: _extractDisplayName(mb),
                ),
              ),
        );

      notifyListeners();
    } catch (e) {
      // Folder loading should not crash the app. Worst case is  drawer stays minimal.
      debugPrint('Failed to load folders: $e');
    }
  }

  // Extracts a friendly display name from a mailbox path.
 
  String _extractDisplayName(String mailboxName) {
    final normalized = mailboxName.replaceAll('\\', '/');
    final parts = normalized.split(RegExp(r'[/.]'));
    return parts.isNotEmpty ? parts.last : mailboxName;
  }

  // Returns the resolved mailbox name for a system folder, or null if not found.
  String? _getMailboxNameForFolder(EmailFolder folder) => _folderMailboxNames[folder];

  // Helper to find a mailbox by common aliases.
  // We match either exact name or "endsWith" (because servers often return paths like "INBOX/Sent").
  void _resolveSystemMailboxes(List<String> mailboxes) {
    String? findMatch(List<String> candidates) {
      for (final mb in mailboxes) {
        final lower = mb.toLowerCase();
        for (final c in candidates) {
          final cl = c.toLowerCase();
          if (lower == cl || lower.endsWith(cl)) {
            return mb;
          }
        }
      }
      return null;
    }

    // Inbox is special: almost every server has it.
    final inbox = findMatch(['inbox']);
    if (inbox != null) _folderMailboxNames[EmailFolder.inbox] = inbox;

    final sent = findMatch([
      'sent',
      'sent messages',
      'gesendet',
      'inbox.sent',
      'inbox/sent',
    ]);
    if (sent != null) _folderMailboxNames[EmailFolder.sent] = sent;

    final drafts = findMatch([
      'drafts',
      'entwürfe',
      'inbox.drafts',
      'inbox/drafts',
    ]);
    if (drafts != null) _folderMailboxNames[EmailFolder.drafts] = drafts;

    final trash = findMatch([
      'trash',
      'deleted',
      'papierkorb',
      'inbox.trash',
      'inbox/trash',
    ]);
    if (trash != null) _folderMailboxNames[EmailFolder.trash] = trash;

    final spam = findMatch([
      'spam',
      'junk',
      'uce-tmp',
      'inbox.spam',
      'inbox/spam',
    ]);
    if (spam != null) _folderMailboxNames[EmailFolder.spam] = spam;

    final archives = findMatch([
      'archive',
      'archives',
      'archiv',
      'inbox.archive',
      'inbox/archive',
    ]);
    if (archives != null) _folderMailboxNames[EmailFolder.archives] = archives;
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

    final foldersToLoad = <EmailFolder>[
      EmailFolder.inbox,
      EmailFolder.sent,
      EmailFolder.drafts,
      EmailFolder.trash,
      EmailFolder.spam,
      EmailFolder.archives,
    ];

    for (final folder in foldersToLoad) {
      final mailbox = _getMailboxNameForFolder(folder);
      if (mailbox == null) {
        // Not found on server → don't crash just skip.
        continue;
      }
      await _fetchEmailsForMailbox (folder, mailbox);
    }
  }

  // Fetches emails from a single mailbox and merges them into the local cache.
  Future<void> _fetchEmailsForMailbox(EmailFolder folder, String mailboxName) async {
    try {
      final count = folder == EmailFolder.inbox ? 50 : 30;
      final emails = await _emailRepository.fetchEmails(
        mailboxName: mailboxName,
        count: count,
      );

      for (final email in emails) {
         _allEmails.add(
        email.copyWith(
          folder: folder,
          mailboxName: mailboxName,
        ),
      );
      }
    } catch (e) {
      debugPrint('Failed to fetch ${folder.name} from "$mailboxName": $e');
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

    final trashMailbox = _getMailboxNameForFolder(EmailFolder.trash);
    if (trashMailbox == null) {
      // Server doesn't expose Trash → local fallback
      updateEmail(email.copyWith(folder: EmailFolder.trash));
      return;
    }

    // If the email is already in trash, try to delete permanently from that mailbox.
    if (email.folder == EmailFolder.trash) {
      final success = await _emailRepository.deleteEmail(email.uid, mailboxName: trashMailbox);
      if (success) {
        _allEmails.removeWhere((e) => e.id == email.id);
        notifyListeners();
      }
      return;
    }

    // Otherwise move it to trash.
    final moved = await _emailRepository.moveEmail(email.uid, trashMailbox);
    if (moved) updateEmail(email.copyWith(folder: EmailFolder.trash));
  }

  // Moves multiple emails to a target folder .
  // If the server mailbox for that folder isn't resolved, we do a local-only move.
  void moveEmailsToFolder(Iterable<Email> emails, EmailFolder folder) {
    final targetMailbox = _getMailboxNameForFolder(folder);

    for (final email in emails) {
      if (_isInitialized && email.uid != 0 && targetMailbox != null) {
        _emailRepository.moveEmail(email.uid, targetMailbox).catchError((_) {});
      }

      final index = _allEmails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        _allEmails[index] = email.copyWith(folder: folder, mailboxName: targetMailbox ?? email.mailboxName,);
      }
    }

    notifyListeners();
  }

  /// Sends a new email and refreshes Sent if the server has it.
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

    // Refresh Sent only if we know the mailbox name
    final sentMailbox = _getMailboxNameForFolder(EmailFolder.sent);
    if (sentMailbox != null) {
      _allEmails.removeWhere((e) => e.folder == EmailFolder.sent);
      await _fetchEmailsForMailbox(EmailFolder.sent, sentMailbox);
      notifyListeners();
    }
  }

  // Searches emails in a folder (only works if that folder has a resolved mailbox).
  Future<List<Email>> searchEmails({
    String? query,
    String? from,
    String? subject,
    EmailFolder? folder,
    bool unreadOnly = false,
  }) async {
    if (!_isInitialized) return [];

    final targetFolder = folder ?? EmailFolder.inbox;
    final mailboxName = _getMailboxNameForFolder(targetFolder);

    if (mailboxName == null) {
      // Folder not available on server, return empty result
      return [];
    }

    final results = await _emailRepository.searchEmails(
      query: query,
      from: from,
      subject: subject,
      unreadOnly: unreadOnly,
      mailboxName: mailboxName,
    );

    return results.map((e) => e.copyWith(folder: targetFolder, mailboxName: mailboxName)).toList();
  }

  // Saves or updates a draft locally and on the server .
  Future<void> saveOrUpdateDraft(Email draft) async {
    //  Local update first (fast UI feedback)
    if (_isDraftEmpty(draft)) {
      _allEmails.removeWhere((e) => e.id == draft.id);
      notifyListeners();
      return;
    }

    final updatedDraft = draft.copyWith(folder: EmailFolder.drafts);
    final index = _allEmails.indexWhere((e) => e.id == draft.id);
    if (index != -1) {
      _allEmails[index] = updatedDraft;
    } else {
      _allEmails.add(updatedDraft);
    }
    notifyListeners();

    // Server update (best effort)
    final draftsMailbox = _getMailboxNameForFolder(EmailFolder.drafts);
    if (draftsMailbox == null) {
      // Server doesn't expose Drafts → keep local only
      return;
    }

    try {
      await _emailRepository.saveDraft(draft);
    } catch (e) {
      debugPrint('Failed to save draft on server: $e');
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

    final draftsMailbox = _getMailboxNameForFolder(EmailFolder.drafts);
    if (_isInitialized && draft.uid != 0 && draft.id.isNotEmpty && draftsMailbox != null) {
      _emailRepository.deleteEmail(draft.uid, mailboxName: draftsMailbox).catchError((_) {});
    }

    _allEmails.removeWhere((e) => e.id == draftId && e.folder == EmailFolder.drafts);
    notifyListeners();
  }

  bool _isDraftEmpty(Email draft) {
    return draft.subject.trim().isEmpty && draft.body.trim().isEmpty && draft.recipients.isEmpty;
  }

  

  List<Email> filterEmails(String query, EmailFolder folder) {
    final filtered = _allEmails.where((e) => e.folder == folder).toList();
    if (query.isEmpty) return filtered;

    final q = query.toLowerCase();
    return filtered.where((email) {
      return email.sender.toLowerCase().contains(q) ||
          email.subject.toLowerCase().contains(q);
    }).toList();
  }
 List<Email> getEmailsForMailbox(String mailboxName) {
  final target = mailboxName.trim().toLowerCase();

  return _allEmails.where((email) {
    return (email.mailboxName ?? '')
        .trim()
        .toLowerCase() == target;
  }).toList();
}
  void updateEmail(Email updatedEmail) {
    final index = _allEmails.indexWhere((e) => e.id == updatedEmail.id);
    if (index != -1) {
      _allEmails[index] = updatedEmail;
      notifyListeners();
    }
  }
  // unredCount dynamic
  int get unreadCount {
  final inboxMailbox = _getMailboxNameForFolder(EmailFolder.inbox);
  if (inboxMailbox == null) return 0;

  return _allEmails.where((e) {
    return (e.mailboxName ?? '').trim() == inboxMailbox.trim() && !e.isRead;
  }).length;
}
 
}
