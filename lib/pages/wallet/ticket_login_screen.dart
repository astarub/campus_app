import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:campus_app/core/injection.dart';
//import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_repository.dart';
import 'package:campus_app/utils/pages/wallet_utils.dart';
import 'package:campus_app/utils/widgets/login_screen.dart';

class TicketCredentialManager {
  final TicketRepository ticketRepository = sl<TicketRepository>();
  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();
  final WalletUtils walletUtils = sl<WalletUtils>();

  static const String _loginIdKey = 'loginId';
  static const String _passwordKey = 'password';

  /// Attempts to load ticket with existing credentials, or shows login screen if needed
  Future<void> loadTicketWithCredentialCheck(
    BuildContext context, {
    void Function()? onTicketLoaded,
    void Function(String error)? onError,
  }) async {
    try {
      // First check if we have saved credentials
      final savedUsername = await secureStorage.read(key: _loginIdKey);
      final savedPassword = await secureStorage.read(key: _passwordKey);

      if (savedUsername != null && savedPassword != null) {
        // Try to load ticket with existing credentials
        await ticketRepository.loadTicket();
        onTicketLoaded?.call();
      } else {
        // No credentials found, show login screen
        _showTicketLoginScreen(context, onTicketLoaded: onTicketLoaded, onError: onError);
      }
    } catch (e) {
      // If existing credentials fail, show login screen
      _showTicketLoginScreen(context, onTicketLoaded: onTicketLoaded, onError: onError);
    }
  }

  /// Forces the login screen to appear (e.g., for re-authentication)
  Future<void> showTicketLoginScreen(
    BuildContext context, {
    void Function()? onTicketLoaded,
    void Function(String error)? onError,
  }) async {
    _showTicketLoginScreen(context, onTicketLoaded: onTicketLoaded, onError: onError);
  }

  /// Internal method to show the login screen
  void _showTicketLoginScreen(
    BuildContext context, {
    void Function()? onTicketLoaded,
    void Function(String error)? onError,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          loginType: LoginType.ticket,
          onLogin: (username, password) async {
            // This is where the actual ticket loading happens
            await _performTicketLogin(username, password);
          },
          onLoginSuccess: () {
            // Called when login is successful
            onTicketLoaded?.call();
          },
        ),
      ),
    );
  }

  /// Performs the actual ticket login with the provided credentials
  Future<void> _performTicketLogin(String username, String password) async {
    // Check network connectivity
    if (await walletUtils.hasNetwork() == false) {
      throw Exception('Überprüfe deine Internetverbindung!');
    }
    await secureStorage.write(key: _loginIdKey, value: username);
    await secureStorage.write(key: _passwordKey, value: password);
    // Attempt to load the ticket
    await ticketRepository.loadTicket();
  }

  /// Checks if ticket credentials are stored
  Future<bool> hasStoredCredentials() async {
    final username = await secureStorage.read(key: _loginIdKey);
    final password = await secureStorage.read(key: _passwordKey);
    return username != null && password != null;
  }

  /// Clears stored ticket credentials (for logout)
  Future<void> clearCredentials() async {
    await secureStorage.delete(key: _loginIdKey);
    await secureStorage.delete(key: _passwordKey);
  }

  /// Gets the stored username (if any)
  Future<String?> getStoredUsername() async {
    return await secureStorage.read(key: _loginIdKey);
  }

  /// Validates credentials without saving them
  Future<bool> validateCredentials(String username, String password) async {
    try {
      // Store current credentials temporarily
      final currentUsername = await secureStorage.read(key: _loginIdKey);
      final currentPassword = await secureStorage.read(key: _passwordKey);

      // Set the new credentials temporarily
      await secureStorage.write(key: _loginIdKey, value: username);
      await secureStorage.write(key: _passwordKey, value: password);

      // Try to load ticket
      await ticketRepository.loadTicket();

      // Restore original credentials
      if (currentUsername != null && currentPassword != null) {
        await secureStorage.write(key: _loginIdKey, value: currentUsername);
        await secureStorage.write(key: _passwordKey, value: currentPassword);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

// Extension or utility class for easy access
class TicketManager {
  static final TicketCredentialManager _credentialManager = TicketCredentialManager();

  /// Main method to load ticket - handles credential checking automatically
  static Future<void> loadTicket(
    BuildContext context, {
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    await _credentialManager.loadTicketWithCredentialCheck(
      context,
      onTicketLoaded: onSuccess,
      onError: onError,
    );
  }

  /// Force login screen to appear
  static Future<void> login(
    BuildContext context, {
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    await _credentialManager.showTicketLoginScreen(
      context,
      onTicketLoaded: onSuccess,
      onError: onError,
    );
  }

  /// Logout (clear credentials)
  static Future<void> logout() async {
    await _credentialManager.clearCredentials();
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await _credentialManager.hasStoredCredentials();
  }

  /// Get current username
  static Future<String?> getCurrentUsername() async {
    return await _credentialManager.getStoredUsername();
  }
}
