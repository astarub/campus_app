import 'dart:convert';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/utils/apis/forgerock_api.dart';
import 'package:campus_app/utils/apis/moodle_api.dart';
import 'package:campus_app/utils/dio_utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'authentication_datasource_impl.dart';

abstract class AuthenticationDatasource {
  /// Request tokenId from forgerock instance.
  /// Throws an ServerException if respond code is not 200.
  /// Throws an Invalid2FATokenException if check goes wrong.
  Future<String> authenticateWithTOTPAndGetToken({
    required String username,
    required String password,
    required String totp,
  });

  /// Request Moodle token from moodle.rub.de/token.php.
  /// Throws an ServerException if respond code is not 200.
  /// Throws an InvalidPasswordException if check goes wrong.
  Future<void> credentialCheckByMoodle({
    required String username,
    required String password,
  });

  /// Delete login id from secure storage
  Future<void> deleteLoginID();

  /// Delete moodle privatetoken from secure storage
  Future<void> deleteMoodlePrivatetoken();

  /// Delete moodle token from secure storage
  Future<void> deleteMoodleToken();

  /// Delete password from secure storage
  Future<void> deletePassword();

  /// Delete password from secure storage
  Future<void> deleteTokenId();

  /// Get username (rub login id) from secure storage
  Future<String?> getLoginID();

  /// Get moodle private token from secure storage
  Future<String?> getMoodlePrivatetoken();

  /// Get moodle token from secure storage
  Future<String?> getMoodleToken();

  /// Get password from secure storage
  Future<String?> getPassword();

  /// Get forgerock tokenId from secure storage
  Future<String?> getTokenId();

  /// Store username (rub login id) encrypted
  Future<void> storeLoginID(String username);

  /// Store moodle private token encrypted
  Future<void> storeMoodlePrivatetoken(String privatetoken);

  /// Store moodle token encrypted
  Future<void> storeMoodleToken(String token);

  /// Store password encrypted
  Future<void> storePassword(String password);

  /// Store forgerock tokenId encrypted
  Future<void> storeTokenId(String tokenId);

  /// Request validation from forgerock instance.
  /// Throws an ServerException if respond code is not 200.
  Future<Map<String, dynamic>> validate2FASession({
    required String tokenId,
  });
}
