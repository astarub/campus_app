import 'package:flutter/material.dart';

import 'package:campus_app/core/auth/auth_service.dart';
import 'package:campus_app/core/auth/student_profile.dart';
import 'package:campus_app/core/exceptions.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;

  AuthProvider({
    required this.authService,
  });

  bool _isLoading = false;
  bool _isLoggedIn = false;
  StudentProfile? _currentUser;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  StudentProfile? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async { // runs on the background and async
    // Called once when the app starts.
    await refreshFromStorage(); // wait until the data are loaded
  }

  Future<void> refreshFromStorage() async {
    // Pull the saved auth state back into memory.
    // This is useful on app start and after the wallet refreshed the ticket again.
    _isLoggedIn = await authService.hasStoredCredentials();
    _currentUser = await authService.getStoredStudentProfile();
    notifyListeners(); // Update the UI after state changes
  }

  Future<bool> login({
    // Parameter
    required String loginId,
    required String password,
  }) async {
    // Remove spaces before/after the login ID
    final String normalizedLoginId = loginId.trim();
    // Check if the user already had saved login data before this new login try
    final bool hadStoredCredentials = await authService.hasStoredCredentials();
    // Stop early if one of the fields is empty.
    if (normalizedLoginId.isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill in both fields.';
      notifyListeners();
      return false;
    }

    // Tell the UI that the login is running so buttons/spinners can react.
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // The provider should not know ticket details.
      // It just asks the service to do the real work.
      _currentUser = await authService.login(
        loginId: normalizedLoginId,
        password: password,
      );
      _isLoggedIn = true;
      return true;
    } on InvalidLoginIDAndPasswordException {
      // Go back to the last valid state if the entered credentials were wrong
      await _restorePreviousState(hadStoredCredentials);
      // Show a clear message for wrong login data
      _errorMessage = 'Invalid login ID and/or password.';
      return false;
    } on NoConnectionException {
      // Keep the old state if the login failed because there was no internet
      await _restorePreviousState(hadStoredCredentials);
      // Show a network related error
      _errorMessage = 'Please check your internet connection.';
      return false;
    } on TicketNotFoundException {
      // Restore the old state if no ticket could be loaded for this account.
      await _restorePreviousState(hadStoredCredentials);
      // Tell the user that no semester ticket was found.
      _errorMessage = 'No semester ticket found.';
      return false;
    } on ServiceUnavailableException {
      // Restore the old state if the external login flow is currently not reachable.
      await _restorePreviousState(hadStoredCredentials);
      // Show that the problem is on the service side.
      _errorMessage = 'The login service is currently unavailable.';
      return false;
    } catch (_) {
      // Fallback for anything unexpected that does not match the known cases above.
      await _restorePreviousState(hadStoredCredentials);
      // Generic error message for unknown failures.
      _errorMessage = 'Login failed. Please try again.';
      return false;
    } finally {
      // Login is finished here, no matter if it worked or failed
      _isLoading = false;
      // Refresh all listening widgets with the newest state
      notifyListeners();
    }
  }

  Future<void> logout() async {
    // Same idea here: the provider updates UI state, the service clears the stored data
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ask the auth service to clear the saved login and ticket data
      await authService.logout();
      _isLoggedIn = false;
      // Remove the current user from memory
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    // Used when the user taps back into the text fields.
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _restorePreviousState(bool hadStoredCredentials) async {
    if (!hadStoredCredentials) {
      // No old login existed, so we just reset everything.
      _isLoggedIn = false;
      _currentUser = null;
      return;
    }

    // If a valid login existed before, we keep that old state instead of kicking the user out.
    _isLoggedIn = await authService.hasStoredCredentials();
    _currentUser = await authService.getStoredStudentProfile();
  }
}
