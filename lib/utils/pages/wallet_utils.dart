import 'dart:async';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WalletUtils {
  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('api-app.asta-bochum.de');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
