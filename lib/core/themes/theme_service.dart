import 'package:flutter/cupertino.dart';

class ThemeService extends ChangeNotifier {
  bool isCampusNowThemeOn = true;

  void toogleCampusNowTheme() {
    isCampusNowThemeOn = !isCampusNowThemeOn;
    notifyListeners();
  }
}
