import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:campus_app/core/auth/student_profile.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_repository.dart';
import 'package:campus_app/utils/pages/wallet_utils.dart';

/// Handles the RUB ticket login and credentials stored on this device
/// These credentials remain separate from the Keycloak session
class TicketAuthService {
  final FlutterSecureStorage secureStorage;
  final TicketRepository ticketRepository;
  final WalletUtils walletUtils;

  TicketAuthService({
    required this.secureStorage,
    required this.ticketRepository,
    required this.walletUtils,
  });

  /// Loads a ticket with new credentials and restores the old ones on failure
  Future<StudentProfile> login({
    required String loginId,
    required String password,
  }) async {
    final String normalizedLoginId = loginId.trim();

    // Keep the previous credentials so a failed login cannot overwrite them
    final String? previousLoginId = await secureStorage.read(
      key: 'loginId',
    );
    final String? previousPassword = await secureStorage.read(
      key: 'password',
    );

    if (await walletUtils.hasNetwork() == false) {
      throw NoConnectionException();
    }

    // The ticket flow reads credentials directly from secure storage
    // Save the new values before starting the request
    await secureStorage.write(
      key: 'loginId',
      value: normalizedLoginId,
    );
    await secureStorage.write(
      key: 'password',
      value: password,
    );

    try {
      await ticketRepository.loadTicket();

      final StudentProfile? profile = await getStoredStudentProfile();

      if (profile == null) {
        throw UnexpectedException();
      }

      return profile;
    } catch (_) {
      // Restore the previous session when login or ticket loading fails
      await _restoreCredential(
        key: 'loginId',
        previousValue: previousLoginId,
      );

      await _restoreCredential(
        key: 'password',
        previousValue: previousPassword,
      );

      // rethrow passes the same error to the provider after cleanup
      rethrow;
    }
  }

  Future<StudentProfile?> getStoredStudentProfile() async {
    final String? loginId = await getStoredLoginId();
    final String? ticketDetailsEncoded =
        await ticketRepository.getTicketDetails();

    if (loginId == null || loginId.isEmpty || ticketDetailsEncoded == null) {
      return null;
    }

    try {
      final dynamic decodedTicketDetails = jsonDecode(ticketDetailsEncoded);

      // is! returns true when the decoded value is not the expected map type
      if (decodedTicketDetails is! Map<String, dynamic>) {
        return null;
      }

      return StudentProfile.fromTicketDetails(
        loginId: loginId,
        ticketDetails: decodedTicketDetails,
      );
    } catch (_) {
      return null;
    }
  }

  /// Checks whether credentials exist locally
  /// This does not confirm that the server still accepts them
  Future<bool> hasStoredCredentials() async {
    final String? loginId = await getStoredLoginId();
    final String? password = await secureStorage.read(
      key: 'password',
    );

    // && requires every condition in this chain to be true
    return loginId != null &&
        loginId.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }

  Future<String?> getStoredLoginId() async {
    return secureStorage.read(
      key: 'loginId',
    );
  }

  /// Removes the credentials and locally stored ticket
  Future<void> logout() async {
    await secureStorage.delete(key: 'loginId');

    await secureStorage.delete(key: 'password');

    await ticketRepository.deleteTicket();
  }

  Future<void> _restoreCredential({
    required String key,
    required String? previousValue,
  }) async {
    if (previousValue == null) {
      await secureStorage.delete(key: key);
      return;
    }

    await secureStorage.write(
      key: key,
      value: previousValue,
    );
  }
}
