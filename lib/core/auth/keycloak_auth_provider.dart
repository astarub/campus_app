import 'dart:async';

import 'package:flutter/material.dart';

import 'package:campus_app/core/auth/keycloak_auth_exception.dart';
import 'package:campus_app/core/auth/keycloak_auth_service.dart';
import 'package:campus_app/core/auth/student_profile.dart';

/// Holds the Keycloak login state shown by the UI
/// The RUB ticket uses a separate provider and session
/// ChangeNotifier allows listening widgets to rebuild after notifyListeners is called
class KeycloakAuthProvider with ChangeNotifier {
  // final keeps this service reference from being replaced after construction
  final KeycloakAuthService keycloakAuthService;

  // required makes callers provide this named argument
  KeycloakAuthProvider({
    required this.keycloakAuthService,
  });

  // A leading underscore keeps this state private to the Dart library
  bool _isLoading = false;
  StudentProfile? _currentUser;
  String? _errorMessage;
  StreamSubscription<StudentProfile?>? _userSubscription;
  StreamSubscription<KeycloakSessionExpiredException>?
      _sessionFailureSubscription;

  // These getters use => to expose state without making the fields writable
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  StudentProfile? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    // Subscribe once so session changes continue to update the UI
    _userSubscription ??= keycloakAuthService.userChanges.listen(
      _updateUser,
      // _ ignores the error object because only the failure state is needed
      onError: (_) {
        _errorMessage = 'The login state could not be updated.';
        notifyListeners();
      },
    );

    // Report a failed token refresh as an expired session
    _sessionFailureSubscription ??= keycloakAuthService.sessionFailures.listen(
      (_) => _handleExpiredSession(),
    );

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Restore the saved session when the app starts
      _currentUser = await keycloakAuthService.initialize();
    } on KeycloakSessionExpiredException {
      // Ask for a new login when the saved session has expired
      _currentUser = null;
      _errorMessage = 'Your login session has expired. Please sign in again.';
    } catch (_) {
      _currentUser = null;
      _errorMessage = 'The saved login could not be loaded.';
    } finally {
      // finally runs after both successful and failed attempts
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<bool> completes later with true for success or false for failure
  Future<bool> login() async {
    // Prevent repeated taps from starting parallel login sessions
    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Keycloak opens the platform login page
      final StudentProfile? user = await keycloakAuthService.login();
      // Returning without a user means that the login was cancelled
      _currentUser = user;
      return user != null;
    } catch (_) {
      _errorMessage = 'Login failed. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> finishes later without a result and async allows await
  Future<void> logout() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // await continues only after the logout has finished
      await keycloakAuthService.logout();
      _currentUser = null;
    } catch (_) {
      _errorMessage = 'Logout failed. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  void _updateUser(StudentProfile? user) {
    _currentUser = user;
    notifyListeners();
  }

  void _handleExpiredSession() {
    // Clear the profile and ask the user to sign in again
    _currentUser = null;
    _errorMessage = 'Your login session has expired. Please sign in again.';
    notifyListeners();
  }

  @override
  void dispose() {
    // unawaited starts cleanup without turning dispose into an async method
    unawaited(_userSubscription?.cancel());
    unawaited(_sessionFailureSubscription?.cancel());
    super.dispose();
  }
}
