import 'package:flutter/foundation.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/core/injection.dart';

class EmailService extends ChangeNotifier {
  final List<Email> _allEmails;
  final EmailSelectionController _selectionController = EmailSelectionController();
  final EmailAuthService _authService = sl<EmailAuthService>();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Modified constructor: Generates dummy emails internally
  EmailService() : _allEmails = List.generate(10, Email.dummy) {
    _selectionController.addListener(notifyListeners);
  }

  // Public API (unchanged)
  List<Email> get allEmails => List.unmodifiable(_allEmails);
  EmailSelectionController get selectionController => _selectionController;

  /// Initialize the email service with authenticated credentials
  Future<void> initialize() async {
    try {
      final credentials = await _authService.getCredentials();
      if (credentials == null) {
        throw Exception('No valid credentials found');
      }

      // Initialize your email client connection here
      // For example, connect to IMAP server with credentials
      await _connectToEmailServer(credentials['username']!, credentials['password']!);

      // Load initial emails
      await refreshEmails();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isInitialized = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Connect to the email server (IMAP/POP3)
  Future<void> _connectToEmailServer(String username, String password) async {
    // Implement your email server connection logic here
    // This would typically involve:
    // 1. Setting up IMAP/POP3 connection to RUB's email server
    // 2. Authenticating with the provided credentials
    // 3. Setting up folder/mailbox access

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 1));

    // Example connection setup (pseudo-code):
    // _imapClient = ImapClient();
    // await _imapClient.connectToServer('imap.rub.de', 993, isSecure: true);
    // await _imapClient.login(username, password);
  }

  /// Refresh emails from server
  Future<void> refreshEmails() async {
    if (!_isInitialized) {
      throw Exception('Email service not initialized');
    }

    try {
      // Fetch emails from server
      await _fetchEmailsFromServer();
      notifyListeners();
    } catch (e) {
      // Handle authentication errors
      if (e.toString().contains('authentication') || e.toString().contains('credentials')) {
        // Credentials might be invalid, logout user
        await _authService.logout();
        _isInitialized = false;
        notifyListeners();
      }
      rethrow;
    }
  }

  /// Fetch emails from the server
  Future<void> _fetchEmailsFromServer() async {
    // Implement your email fetching logic here
    // This would typically involve:
    // 1. Selecting the appropriate mailbox/folder
    // 2. Fetching email headers and metadata
    // 3. Updating your local email list

    // Simulate fetching delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Example fetching logic (pseudo-code):
    // final messages = await _imapClient.fetchMessages(count: 50);
    // _emails = messages.map((msg) => Email.fromImapMessage(msg)).toList();
  }

  /// Clear all email data (called on logout)
  void clear() {
    // Clear all email data
    _allEmails.clear();
    _isInitialized = false;
    notifyListeners();
  }

  /// Send email (requires authentication)
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

    final credentials = await _authService.getCredentials();
    if (credentials == null) {
      throw Exception('No valid credentials found');
    }

    // Implement email sending logic here
    await _sendEmailViaSmtp(
      username: credentials['username']!,
      password: credentials['password']!,
      to: to,
      subject: subject,
      body: body,
      cc: cc,
      bcc: bcc,
    );
  }

  /// Send email via SMTP
  Future<void> _sendEmailViaSmtp({
    required String username,
    required String password,
    required String to,
    required String subject,
    required String body,
    String? cc,
    String? bcc,
  }) async {
    // Implement SMTP sending logic here
    // Example (pseudo-code):
    // final smtpClient = SmtpClient();
    // await smtpClient.connect('smtp.rub.de', 587);
    // await smtpClient.authenticate(username, password);
    // await smtpClient.sendMessage(message);

    // Simulate sending delay
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Check if service needs re-authentication
  Future<bool> needsReAuthentication() async {
    if (!_isInitialized) return true;

    return !(await _authService.validateCurrentCredentials());
  }

  // Existing methods from original EmailService
  List<Email> filterEmails(String query, EmailFolder folder) {
    final filtered = _allEmails.where((e) => e.folder == folder).toList();
    if (query.isEmpty) return filtered;
    return filtered
        .where(
          (email) =>
              email.sender.toLowerCase().contains(query.toLowerCase()) ||
              email.subject.toLowerCase().contains(query.toLowerCase()),
        )
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
      final index = _allEmails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        _allEmails[index] = email.copyWith(folder: folder);
      }
    }
    notifyListeners();
  }

  void deleteEmailsPermanently(Iterable<Email> emails) {
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
    if (index != -1) {
      _allEmails[index] = draft.copyWith(folder: EmailFolder.drafts);
    } else {
      _allEmails.add(draft.copyWith(folder: EmailFolder.drafts));
    }
    notifyListeners();
  }

  void removeDraft(String draftId) {
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

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }
}
