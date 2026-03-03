import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/exceptions.dart';

// Service to handle email-based authentication using secure storage
class EmailAuthService extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();

  // Storage keys
  static const String _emailUsernameKey = 'email_loginId';
  static const String _emailPasswordKey = 'email_password';
  static const String _isAuthenticatedKey = 'email_is_authenticated';

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
  Future<void> authenticate(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        throw InvalidLoginIDAndPasswordException();
      }

      // Simulate API call to RUB email service
      await _validateEmailCredentials(username, password);

      // Save credentials
      await _secureStorage.write(key: _emailUsernameKey, value: username);
      await _secureStorage.write(key: _emailPasswordKey, value: password);
      await _secureStorage.write(key: _isAuthenticatedKey, value: 'true');

      _currentUsername = username;
      _currentPassword = password;
      _isAuthenticated = true;

      notifyListeners();
    } catch (e) {
      await logout(); // Clear state on failure
      rethrow;
    }
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

  // Log out and clear stored credentials
  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: _emailUsernameKey);
      await _secureStorage.delete(key: _emailPasswordKey);
      await _secureStorage.delete(key: _isAuthenticatedKey);
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
}
