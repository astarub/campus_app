import 'package:campus_app/pages/email_client/services/imap_email_service.dart';
import 'package:enough_mail/imap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:uuid/uuid.dart';

enum VerificationStatus { success, bounced, sendFailed, notAuthenticated, emptyEmail, outOfAttempts }

/// Email Address Verification Results to help give better feedback to the User
class VerificationResult {
  final VerificationStatus status;

  const VerificationResult._(this.status);

  static const success = VerificationResult._(VerificationStatus.success);
  static const sendFailed = VerificationResult._(VerificationStatus.sendFailed);
  static const bounced = VerificationResult._(VerificationStatus.bounced);
  static const notAuthenticed = VerificationResult._(VerificationStatus.notAuthenticated);
  static const emptyEmail = VerificationResult._(VerificationStatus.emptyEmail);
  static const outOfAttempts = VerificationResult._(VerificationStatus.outOfAttempts);
}

// Service to handle email-based authentication using secure storage
class EmailAuthService extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();

  // Storage keys
  static const String _emailUsernameKey = 'email_loginId';
  static const String _emailPasswordKey = 'email_password';
  static const String _isAuthenticatedKey = 'email_is_authenticated';
  static const String _emailDisplayNameKey = 'email_display_name';

  // Internal state
  bool _isAuthenticated = false;
  String? _currentUsername;
  String? _currentPassword;

  // Public getters
  bool get isAuthenticatedSync => _isAuthenticated;
  String? get currentUsername => _currentUsername;

  // Check if user is authenticated (reads from secure storage)
  Future<bool> isAuthenticated() async {
    try {
      final authStatus = await _secureStorage.read(key: _isAuthenticatedKey);
      final username = await _secureStorage.read(key: _emailUsernameKey);
      final password = await _secureStorage.read(key: _emailPasswordKey);

      _isAuthenticated = authStatus == 'true' && username != null && password != null;

      if (_isAuthenticated) {
        _currentUsername = username;
        _currentPassword = password;
      }

      notifyListeners();
      return _isAuthenticated;
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  // Authenticate and store credentials securely
  Future<void> authenticate(String username, String password, String emailAddress, String emailDisplayName) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        throw InvalidLoginIDAndPasswordException();
      }

      // Simulate API call to RUB email service
      await _validateEmailCredentials(username, password);

      // Save credentials
      await _secureStorage.write(key: _emailUsernameKey, value: username);
      await _secureStorage.write(key: _emailPasswordKey, value: password);
      await _secureStorage.write(key: 'email_sender_address', value: emailAddress);
      await _secureStorage.write(key: _emailDisplayNameKey, value: emailDisplayName);

      _currentUsername = username;
      _currentPassword = password;
      _isAuthenticated = true;

      notifyListeners();
    } catch (e) {
      await logout(); // Clear state on failure
      rethrow;
    }
  }

  // confirm an authentication only after the email address clears too
  Future<void> confirmAuthentication() async {
    await _secureStorage.write(key: _isAuthenticatedKey, value: 'true');
  }

  // Simulated email credential validation
  Future<void> _validateEmailCredentials(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (username.length < 3 || password.length < 6) {
      throw InvalidLoginIDAndPasswordException();
    }
  }

  // Return current credentials if authenticated
  Future<Map<String, String>?> getCredentials() async {
    if (!_isAuthenticated) {
      await isAuthenticated(); // Ensure auth state is current
    }

    if (_isAuthenticated && _currentUsername != null && _currentPassword != null) {
      return {
        'username': _currentUsername!,
        'password': _currentPassword!,
      };
    }

    return null;
  }

  // access point for sender email and Display Name
  Future<String?> getSenderEmail() async {
    return _secureStorage.read(key: 'email_sender_address');
  }

  Future<String?> getDisplayName() async {
    return _secureStorage.read(key: _emailDisplayNameKey);
  }

  // Log out and clear stored credentials
  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: _emailUsernameKey);
      await _secureStorage.delete(key: _emailPasswordKey);
      await _secureStorage.delete(key: _isAuthenticatedKey);
      await _secureStorage.delete(key: 'email_sender_address');
      await _secureStorage.delete(key: _emailDisplayNameKey);
    } catch (e) {
      debugPrint('Error clearing credentials: $e');
    }

    _currentUsername = null;
    _currentPassword = null;
    _isAuthenticated = false;

    notifyListeners();
  }

  // Refresh authentication state
  Future<void> refresh() async {
    await isAuthenticated();
  }

  // Validate currently stored credentials
  Future<bool> validateCurrentCredentials() async {
    if (!_isAuthenticated || _currentUsername == null || _currentPassword == null) {
      return false;
    }

    try {
      await _validateEmailCredentials(_currentUsername!, _currentPassword!);
      return true;
    } catch (e) {
      await logout(); // Invalidate session on failure
      return false;
    }
  }

  Uuid uuid = const Uuid();
  String code = '';
  DateTime timestamp = DateTime.now();

  // email address verification process, the user should be authenticated via credentials at this point
  Future<VerificationResult> verifyEmailAddress() async {
    if (!_isAuthenticated) return VerificationResult.notAuthenticed;

    // take to Imap service directly, avoid conflict with emailService initialization
    final username = _currentUsername;
    final password = _currentPassword;
    if (username == null || password == null) return VerificationResult.notAuthenticed;

    final emailAddress = await getSenderEmail() ?? '';
    if (emailAddress.isEmpty) return VerificationResult.emptyEmail;

    final imapService = sl<ImapEmailService>();

    // generate and storing the code
    _generateCode();

    try {
      // establish connection to the server
      final connected = await imapService.connect(username, password);
      if (!connected) return VerificationResult.sendFailed;

      timestamp = DateTime.now();

      final sent = await imapService.sendEmail(
        to: emailAddress,
        subject: 'Email Verification',
        body: 'ASTA Verification Email: $code',
        senderEmail: emailAddress,
        senderName: await getDisplayName() ?? '',
      );

      if (!sent) return VerificationResult.sendFailed;

      // delay to ensure the email will be available in the inbox
      await Future.delayed(const Duration(milliseconds: 1500));

      final result = await _findVerificationEmail(imapService);

      return result;
    } on ImapException catch (e) {
      debugPrint('Verification failed with IMAP error: $e');
      rethrow;
    } catch (e) {
      debugPrint('Verification failed with error: $e');
      return VerificationResult.sendFailed;
    } finally {
      await imapService.disconnect();
    }
  }

  void _generateCode() {
    code = uuid.v4();
  }

  // compare and search for the email in the inbox
  Future<VerificationResult> _findVerificationEmail(ImapEmailService imapService) async {
    // retrying variables
    const maxAttempts = 5;
    const retryInterval = Duration(seconds: 2);

    for (int i = 0; i <= maxAttempts; i++) {
      try {
        // limit sample to 15 most recent emails for efficiency, search will take too long
        final emails = await imapService.fetchEmails(
          count: 15,
        );

        // check for an undelivered email
        final bounce = emails.where(
          (e) =>
              e.senderEmail.toLowerCase().contains('mailer-daemon') &&
              e.subject.toLowerCase().contains('undelivered') &&
              e.date.isAfter(timestamp),
        );

        if (bounce.isNotEmpty) return VerificationResult.bounced;

        final target = emails.where((e) => e.subject.contains('Email Verification'));

        if (target.isNotEmpty) {
          final full = await imapService.fetchEmailByUid(target.first.uid);

          // search the body for the unique code
          if (full != null && (full.body.contains(code) || (full.htmlBody?.contains(code) ?? false))) {
            await confirmAuthentication(); // complete authentication
            return VerificationResult.success;
          }
        }
      } catch (e) {
        debugPrint('Email Verification: Attempt $i failed with error: $e');
      }

      if (i <= maxAttempts) {
        await Future.delayed(retryInterval);
      }
    }

    return VerificationResult.outOfAttempts;
  }
}
