import 'dart:async';

import 'package:flutter/material.dart';

import 'package:campus_app/core/auth/keycloak_auth_service.dart';
import 'package:campus_app/core/auth/student_profile.dart';

class KeycloakAuthProvider with ChangeNotifier {
  final KeycloakAuthService keycloakAuthService;

  KeycloakAuthProvider({
    required this.keycloakAuthService,
  });

  bool _isLoading = false;
  StudentProfile? _currentUser;
  String? _errorMessage;
  StreamSubscription<StudentProfile?>? _userSubscription;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  StudentProfile? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    // Listen for Keycloak login and logout changes.
    _userSubscription ??= keycloakAuthService.userChanges.listen(
      _updateUser,
      onError: (_) {
        _errorMessage = 'The login state could not be updated.';
        notifyListeners();
      },
    );

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load an already saved Keycloak session when the app starts.
      _currentUser = await keycloakAuthService.initialize();
    } catch (_) {
      _currentUser = null;
      _errorMessage = 'The saved login could not be loaded.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login() async {
    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Keycloak opens the secure login page in the browser.
      final StudentProfile? user = await keycloakAuthService.login();
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

  Future<void> logout() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
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

  @override
  void dispose() {
    unawaited(_userSubscription?.cancel());
    super.dispose();
  }
}
