import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:get_it/get_it.dart';

class EmailAuthService {
  final FlutterSecureStorage _secureStorage;

  EmailAuthService({required FlutterSecureStorage secureStorage}) : _secureStorage = secureStorage;

  /// Check if user has valid login credentials
  Future<bool> hasValidCredentials() async {
    try {
      final String? loginId = await _secureStorage.read(key: 'loginId');
      final String? password = await _secureStorage.read(key: 'password');

      return loginId != null && password != null && loginId.isNotEmpty && password.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get stored credentials
  Future<Map<String, String?>> getCredentials() async {
    try {
      final String? loginId = await _secureStorage.read(key: 'loginId');
      final String? password = await _secureStorage.read(key: 'password');

      return {
        'loginId': loginId,
        'password': password,
      };
    } catch (e) {
      return {
        'loginId': null,
        'password': null,
      };
    }
  }

  /// Store credentials (if needed for email-specific auth)
  Future<void> storeCredentials(String loginId, String password) async {
    await _secureStorage.write(key: 'loginId', value: loginId);
    await _secureStorage.write(key: 'password', value: password);
  }

  /// Clear credentials
  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: 'loginId');
    await _secureStorage.delete(key: 'password');
  }
}
