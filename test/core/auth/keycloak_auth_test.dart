import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oidc/oidc.dart';

import 'package:campus_app/core/auth/keycloak_auth_datasource.dart';
import 'package:campus_app/core/auth/keycloak_auth_exception.dart';
import 'package:campus_app/core/auth/keycloak_auth_provider.dart';
import 'package:campus_app/core/auth/keycloak_auth_service.dart';
import 'package:campus_app/core/auth/keycloak_config.dart';

import 'keycloak_auth_test.mocks.dart';

// Generates safe test replacements for Keycloak and the OIDC storage.
@GenerateMocks([OidcUserManager, OidcStore, KeycloakAuthService])
void main() {
  // Verifies that deployments can replace the local Keycloak settings.
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

  // These tests simulate app startup without contacting a real Keycloak server.
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
      // No stored token means that the user has not signed in yet.
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
      // A stored token without a current user represents an expired session.
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
  });

  test('provider shows a clear message for an expired session', () async {
    // Simulate an expired login without starting a real Keycloak server.
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
}
