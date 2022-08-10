import 'package:flutter/material.dart';

enum AuthentificationState { unauthenticated, authentication2FA, authenticated }

class AuthentificationHandler with ChangeNotifier {
  AuthentificationState _currentAuthState = AuthentificationState.unauthenticated;

  set currentAuthState(AuthentificationState state) {
    _currentAuthState = state;
  }

  AuthentificationState get currentAuthState => _currentAuthState;
}
