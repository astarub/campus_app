import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oidc/oidc.dart';

import 'package:campus_app/core/auth/keycloak_auth_datasource.dart';
import 'package:campus_app/core/auth/keycloak_auth_exception.dart';
import 'package:campus_app/core/auth/keycloak_auth_provider.dart';
import 'package:campus_app/core/auth/keycloak_auth_service.dart';
import 'package:campus_app/core/auth/keycloak_config.dart';
import 'package:campus_app/core/auth/student_profile.dart';

import 'keycloak_auth_test.mocks.dart';

// These tests use mocks and do not contact a real Keycloak server
// Regenerate the Mockito file after changing the mocked classes
@GenerateMocks([OidcUserManager, OidcStore, KeycloakAuthService])
void main() {
  test('uses the configured Keycloak issuer and client ID', () {
    const configuredIssuer = String.fromEnvironment('KEYCLOAK_ISSUER');
    const configuredClientId = String.fromEnvironment(
      'KEYCLOAK_CLIENT_ID',
      defaultValue: 'campus-app-flutter',
    );

    expect(
      KeycloakConfig.issuer.toString(),
      configuredIssuer.isNotEmpty
          ? configuredIssuer
          : 'http://localhost:8080/realms/campus-app',
    );
    expect(KeycloakConfig.clientId, configuredClientId);
  });

  group('KeycloakAuthDataSource.initialize', () {
    late MockOidcUserManager userManager;
    late MockOidcStore store;

    setUp(() {
      userManager = MockOidcUserManager();
      store = MockOidcStore();

      when(userManager.store).thenReturn(store);
      when(userManager.id).thenReturn('campus-app');
      when(userManager.events()).thenAnswer((_) => const Stream.empty());
      when(store.init()).thenAnswer((_) async {});
      when(userManager.init()).thenAnswer((_) async {});
      when(userManager.currentUser).thenReturn(null);
    });

    test('accepts an empty saved session', () async {
      when(
        store.getAllKeys(
          OidcStoreNamespace.secureTokens,
          managerId: 'campus-app',
        ),
      ).thenAnswer((_) async => <String>{});
      final dataSource = KeycloakAuthDataSource(userManager: userManager);

      await expectLater(dataSource.initialize(), completes);
    });

    test('reports a saved session that could not be restored', () async {
      when(
        store.getAllKeys(
          OidcStoreNamespace.secureTokens,
          managerId: 'campus-app',
        ),
      ).thenAnswer((_) async => <String>{OidcConstants_Store.currentToken});
      final dataSource = KeycloakAuthDataSource(userManager: userManager);

      await expectLater(
        dataSource.initialize(),
        throwsA(isA<KeycloakSessionExpiredException>()),
      );
    });

    test('logout clears local tokens when initialization fails', () async {
      when(
        store.getAllKeys(
          OidcStoreNamespace.secureTokens,
          managerId: 'campus-app',
        ),
      ).thenAnswer((_) async => <String>{});
      when(userManager.init()).thenThrow(StateError('Initialization failed'));
      when(userManager.forgetUser()).thenAnswer((_) async {});
      final dataSource = KeycloakAuthDataSource(userManager: userManager);

      await expectLater(dataSource.logout(), throwsStateError);

      verify(userManager.forgetUser()).called(1);
    });
  });

  test('provider shows a clear message for an expired session', () async {
    final service = MockKeycloakAuthService();
    when(service.userChanges).thenAnswer((_) => const Stream.empty());
    when(service.sessionFailures).thenAnswer((_) => const Stream.empty());
    when(service.initialize()).thenThrow(
      const KeycloakSessionExpiredException(),
    );
    final provider = KeycloakAuthProvider(keycloakAuthService: service);

    await provider.initialize();

    expect(provider.isLoggedIn, isFalse);
    expect(provider.isLoading, isFalse);
    expect(
      provider.errorMessage,
      'Your login session has expired. Please sign in again.',
    );
    provider.dispose();
  });

  test('provider treats a cancelled login as no login', () async {
    final service = MockKeycloakAuthService();
    when(service.login()).thenAnswer((_) async => null);
    final provider = KeycloakAuthProvider(keycloakAuthService: service);

    final success = await provider.login();

    expect(success, isFalse);
    expect(provider.isLoggedIn, isFalse);
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
    verify(service.login()).called(1);
    provider.dispose();
  });

  test('provider prevents parallel login attempts', () async {
    final service = MockKeycloakAuthService();
    // Keep the first login pending while a second attempt starts
    final pendingLogin = Completer<StudentProfile?>();
    when(service.login()).thenAnswer((_) => pendingLogin.future);
    final provider = KeycloakAuthProvider(keycloakAuthService: service);

    final firstLogin = provider.login();
    final secondLogin = await provider.login();

    expect(secondLogin, isFalse);
    expect(provider.isLoading, isTrue);
    verify(service.login()).called(1);

    const profile = StudentProfile(
      name: 'Test User',
      loginId: 'test-user',
    );
    pendingLogin.complete(profile);

    expect(await firstLogin, isTrue);
    expect(provider.currentUser, same(profile));
    expect(provider.isLoading, isFalse);
    provider.dispose();
  });
}
