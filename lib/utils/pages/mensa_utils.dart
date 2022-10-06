

import 'package:campus_app/utils/pages/presentation_functions.dart';

class MensaUtils extends Utils {
  bool isUppercase(String str) {
    return str == str.toUpperCase();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

}
