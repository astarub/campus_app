import 'dart:async';

import 'package:oidc/oidc.dart';

import 'package:campus_app/core/auth/keycloak_auth_datasource.dart';
import 'package:campus_app/core/auth/keycloak_auth_exception.dart';
import 'package:campus_app/core/auth/student_profile.dart';

/// Maps OIDC users to profiles used by the app
/// It does not connect the Keycloak and semester-ticket sessions
class KeycloakAuthRepository {
  final KeycloakAuthDataSource keycloakAuthDataSource;

  KeycloakAuthRepository({
    required this.keycloakAuthDataSource,
  });

  StudentProfile? get currentUser {
    return _createProfile(keycloakAuthDataSource.currentUser);
  }

  Stream<StudentProfile?> get userChanges {
    // map converts every emitted OIDC user into a StudentProfile
    return keycloakAuthDataSource.userChanges.map(_createProfile);
  }

  Stream<KeycloakSessionExpiredException> get sessionFailures {
    return keycloakAuthDataSource.sessionFailures;
  }

  Future<StudentProfile?> initialize() async {
    await keycloakAuthDataSource.initialize();
    return currentUser;
  }

  Future<StudentProfile?> login() async {
    final OidcUser? user = await keycloakAuthDataSource.login();
    return _createProfile(user);
  }

  Future<void> logout() async {
    await keycloakAuthDataSource.logout();
  }

  Future<void> dispose() async {
    await keycloakAuthDataSource.dispose();
  }

  StudentProfile? _createProfile(OidcUser? user) {
    if (user == null) return null;

    final Map<String, dynamic> claims = user.aggregatedClaims;
    // Use email or subject only when Keycloak provides no preferred username
    // These values are identifiers and never RUB ticket credentials
    // ?? uses an empty string only when none of the claims contains a value
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
    // Remove missing parts before joining the remaining names with a space
    final String combinedName = [
      givenName,
      familyName,
    ].whereType<String>().join(' ');

    // condition ? first : second selects one of the two values
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
    // dynamic accepts a claim value of any runtime type
    final dynamic value = claims[key];
    if (value == null) return null;

    final String text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
