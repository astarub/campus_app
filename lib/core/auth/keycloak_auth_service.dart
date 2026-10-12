import 'dart:async';

import 'package:campus_app/core/auth/keycloak_auth_exception.dart';
import 'package:campus_app/core/auth/keycloak_auth_repository.dart';
import 'package:campus_app/core/auth/student_profile.dart';

/// Keeps the UI-facing provider independent from OIDC and token storage
class KeycloakAuthService {
  final KeycloakAuthRepository keycloakAuthRepository;

  KeycloakAuthService({
    required this.keycloakAuthRepository,
  });

  // A Stream can send multiple updates while a Future completes with one result
  Stream<StudentProfile?> get userChanges {
    return keycloakAuthRepository.userChanges;
  }

  Stream<KeycloakSessionExpiredException> get sessionFailures {
    return keycloakAuthRepository.sessionFailures;
  }

  // A Future represents a result that becomes available later
  Future<StudentProfile?> initialize() {
    return keycloakAuthRepository.initialize();
  }

  Future<StudentProfile?> login() {
    return keycloakAuthRepository.login();
  }

  Future<void> logout() {
    return keycloakAuthRepository.logout();
  }

  Future<void> dispose() {
    return keycloakAuthRepository.dispose();
  }
}
