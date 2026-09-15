import 'dart:async';

import 'package:campus_app/core/auth/keycloak_auth_repository.dart';
import 'package:campus_app/core/auth/student_profile.dart';

class KeycloakAuthService {
  final KeycloakAuthRepository keycloakAuthRepository;

  KeycloakAuthService({
    required this.keycloakAuthRepository,
  });

  StudentProfile? get currentUser => keycloakAuthRepository.currentUser;

  Stream<StudentProfile?> get userChanges {
    return keycloakAuthRepository.userChanges;
  }

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
