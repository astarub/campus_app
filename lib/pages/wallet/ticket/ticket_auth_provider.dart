import 'package:flutter/material.dart';

import 'package:campus_app/core/auth/student_profile.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_auth_service.dart';

class TicketAuthProvider with ChangeNotifier {
  final TicketAuthService ticketAuthService;

  TicketAuthProvider({
    required this.ticketAuthService,
  });

  bool _isLoading = false;
  bool _isLoggedIn = false;
  StudentProfile? _currentUser;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  StudentProfile? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    // Load the saved ticket login when the app starts.
    await refreshFromStorage();
  }

  Future<void> refreshFromStorage() async {
    _isLoggedIn = await ticketAuthService.hasStoredCredentials();
    _currentUser = await ticketAuthService.getStoredStudentProfile();
    notifyListeners();
  }

  Future<bool> login({
    required String loginId,
    required String password,
  }) async {
    final String normalizedLoginId = loginId.trim();
    final bool hadStoredCredentials =
        await ticketAuthService.hasStoredCredentials();

    if (normalizedLoginId.isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill in both fields.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await ticketAuthService.login(
        loginId: normalizedLoginId,
        password: password,
      );
      _isLoggedIn = true;
      return true;
    } on InvalidLoginIDAndPasswordException {
      await ticketAuthService.logout();
      _isLoggedIn = false;
      _currentUser = null;
      _errorMessage = 'Invalid login ID and/or password.';
      return false;
    } on NoConnectionException {
      await _restorePreviousState(hadStoredCredentials);
      _errorMessage = 'Please check your internet connection.';
      return false;
    } on TicketNotFoundException {
      await _restorePreviousState(hadStoredCredentials);
      _errorMessage = 'No semester ticket found.';
      return false;
    } on ServiceUnavailableException {
      await _restorePreviousState(hadStoredCredentials);
      _errorMessage = 'The login service is currently unavailable.';
      return false;
    } catch (_) {
      await _restorePreviousState(hadStoredCredentials);
      _errorMessage = 'Login failed. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ticketAuthService.logout();
      _isLoggedIn = false;
      _currentUser = null;
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

  Future<void> _restorePreviousState(bool hadStoredCredentials) async {
    if (!hadStoredCredentials) {
      _isLoggedIn = false;
      _currentUser = null;
      return;
    }

    _isLoggedIn = await ticketAuthService.hasStoredCredentials();
    _currentUser = await ticketAuthService.getStoredStudentProfile();
  }
}
