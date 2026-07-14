import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:campus_app/core/auth/student_profile.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_repository.dart';
import 'package:campus_app/utils/pages/wallet_utils.dart';

class AuthService {
  // This service does the real login work in the background.
  // The UI should call this service instead of talking to storage or ticket code directly.
  final FlutterSecureStorage secureStorage;
  final TicketRepository ticketRepository;
  final WalletUtils walletUtils;

  AuthService({
    required this.secureStorage,
    required this.ticketRepository,
    required this.walletUtils,
  });

  /// Saves the credentials and verifies them through the existing
  /// semester ticket login flow.
  Future<StudentProfile> login({
    required String loginId,
    required String password,
  }) async {
    // Remove spaces before and after the username.
    // Example: " abc123 " becomes "abc123".
    final String normalizedLoginId = loginId.trim();

    // Read the old saved login data first.
    // We may need it again if the new login fails.
    final String? previousLoginId = await secureStorage.read(
      key: 'loginId',
    );
    final String? previousPassword = await secureStorage.read(
      key: 'password',
    );

    // Stop early if there is no internet.
    if (await walletUtils.hasNetwork() == false) {
      throw NoConnectionException();
    }

    // The old ticket system still reads username and password from secure storage.
    // Because of that, we must save the new values first.
    await secureStorage.write(
      key: 'loginId',
      value: normalizedLoginId,
    );
    await secureStorage.write(
      key: 'password',
      value: password,
    );

    try {
      // This starts the existing ticket login flow.
      // If that works, fresh ticket data will be saved too.
      await ticketRepository.loadTicket();

      // Now build one clean user/profile object from the saved ticket data.
      final StudentProfile? profile = await getStoredStudentProfile();

      if (profile == null) {
        // Login worked, but we still could not build a profile from the saved data.
        throw UnexpectedException();
      }

      // Send the created profile back to the provider/UI.
      return profile;
    } catch (_) {
      // If the new login fails, restore the old saved data.
      // This is important so we do not break an older working session.
      await _restoreCredential(
        key: 'loginId',
        previousValue: previousLoginId,
      );

      await _restoreCredential(
        key: 'password',
        previousValue: previousPassword,
      );

      rethrow;
    }
  }

  Future<StudentProfile?> getStoredStudentProfile() async {
    // Read the already saved login ID and ticket details from storage.
    // Then turn that raw data into one StudentProfile object.
    final String? loginId = await getStoredLoginId();
    final String? ticketDetailsEncoded = await ticketRepository.getTicketDetails();

    // If important data is missing, we cannot build a profile.
    if (loginId == null || loginId.isEmpty || ticketDetailsEncoded == null) {
      return null;
    }

    try {
      // Convert the saved JSON text into a normal Dart object.
      final dynamic decodedTicketDetails = jsonDecode(ticketDetailsEncoded);

      // We only continue if the decoded data is a key/value map.
      if (decodedTicketDetails is! Map<String, dynamic>) {
        return null;
      }

      // Keep this conversion here so the UI never has to read raw ticket JSON.
      return StudentProfile.fromTicketDetails(
        loginId: loginId,
        ticketDetails: decodedTicketDetails,
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns whether login credentials are currently stored.
  Future<bool> hasStoredCredentials() async {
    // Just check if both username and password exist in storage.
    final String? loginId = await getStoredLoginId();
    final String? password = await secureStorage.read(
      key: 'password',
    );

    return loginId != null &&
        loginId.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }

  Future<String?> getStoredLoginId() async {
    // The login screen uses this to show the last used username again.
    return secureStorage.read(
      key: 'loginId',
    );
  }

  /// Removes credentials and locally stored ticket data.
  Future<void> logout() async {
    // Remove the saved username.
    await secureStorage.delete(key: 'loginId');

    // Remove the saved password.
    await secureStorage.delete(key: 'password');

    // Also remove the saved ticket so old user data does not stay visible in the app.
    await ticketRepository.deleteTicket();
  }

  Future<void> _restoreCredential({
    required String key,
    required String? previousValue,
  }) async {
    // Small helper for the rollback logic above.
    // If there was no old value, delete the key.
    // If there was an old value, write it back.
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
