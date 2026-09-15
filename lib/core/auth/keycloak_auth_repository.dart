import 'dart:async';

import 'package:oidc/oidc.dart';

import 'package:campus_app/core/auth/keycloak_auth_datasource.dart';
import 'package:campus_app/core/auth/student_profile.dart';

class KeycloakAuthRepository {
  final KeycloakAuthDataSource keycloakAuthDataSource;

  KeycloakAuthRepository({
    required this.keycloakAuthDataSource,
  });

  // Returns the user who is currently logged in.
  StudentProfile? get currentUser {
    return _createProfile(keycloakAuthDataSource.currentUser);
  }

  // Sends a new profile when the Keycloak login changes.
  Stream<StudentProfile?> get userChanges {
    return keycloakAuthDataSource.userChanges.map(_createProfile);
  }

  // Starts Keycloak and loads a saved login, if one exists.
  Future<StudentProfile?> initialize() async {
    await keycloakAuthDataSource.initialize();
    return currentUser;
  }

  // Opens the Keycloak login and returns the logged-in user.
  Future<StudentProfile?> login() async {
    final OidcUser? user = await keycloakAuthDataSource.login();
    return _createProfile(user);
  }

  // Ends only the global Keycloak login.
  Future<void> logout() async {
    await keycloakAuthDataSource.logout();
  }

  Future<void> dispose() async {
    await keycloakAuthDataSource.dispose();
  }

  // Converts Keycloak data into the profile used by our app.
  StudentProfile? _createProfile(OidcUser? user) {
    if (user == null) return null;

    final Map<String, dynamic> claims = user.aggregatedClaims;
    final String loginId = _firstClaim(
          claims,
          const ['preferred_username', 'email', 'sub'],
        ) ??
        '';
    final String name = _readName(claims, loginId);

    return StudentProfile(
      name: name,
      loginId: loginId,
      email: _readClaim(claims, 'email'),
    );
  }

  String _readName(Map<String, dynamic> claims, String loginId) {
    final String? completeName = _readClaim(claims, 'name');
    if (completeName != null) return completeName;

    final String? givenName = _readClaim(claims, 'given_name');
    final String? familyName = _readClaim(claims, 'family_name');
    final String combinedName = [
      givenName,
      familyName,
    ].whereType<String>().join(' ');

    return combinedName.isNotEmpty ? combinedName : loginId;
  }

  String? _firstClaim(
    Map<String, dynamic> claims,
    List<String> keys,
  ) {
    for (final String key in keys) {
      final String? value = _readClaim(claims, key);
      if (value != null) return value;
    }

    return null;
  }

  String? _readClaim(Map<String, dynamic> claims, String key) {
    final dynamic value = claims[key];
    if (value == null) return null;

    final String text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
