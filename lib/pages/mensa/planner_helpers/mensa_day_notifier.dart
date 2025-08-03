import 'package:flutter/material.dart';

class MensaDayNotifier extends ChangeNotifier {
  DateTime _focusedDate = DateTime.now();
  DateTime get focusedDate => _focusedDate;

  void setDay(DateTime day) {
    _focusedDate = day;
    notifyListeners();
  }
}
