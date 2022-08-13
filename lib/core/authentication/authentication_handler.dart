import 'package:campus_app/core/failures.dart';
import 'package:flutter/material.dart';

enum AuthState { unauthenticated, authentication2FA, authenticated }

class AuthenticationHandler with ChangeNotifier {
  AuthState _currentAuthState = AuthState.unauthenticated;
  Failure? _failure;

  void changeAuthState({
    required AuthState state,
    Failure? failure,
  }) {
    _currentAuthState = state;
    _failure = failure;
    notifyListeners();
  }

  AuthState get currentAuthState => _currentAuthState;
  Failure? get failure => _failure;
}
