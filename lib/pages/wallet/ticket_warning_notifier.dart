import 'package:flutter/material.dart';

// This Notifier tracks the ticket warning globally, since the value is changed by processes outside of the Wallet page
class TicketWarningNotifier extends ChangeNotifier {
  bool _showWarning = false;

  bool get showWarning => _showWarning;

  void set(bool value) {
    _showWarning = value;
    notifyListeners();
  }
}
