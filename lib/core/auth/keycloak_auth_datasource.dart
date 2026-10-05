import 'dart:async';

import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';
import 'package:simple_secure_storage/simple_secure_storage.dart';

import 'package:campus_app/core/auth/keycloak_config.dart';
import 'package:campus_app/core/auth/keycloak_auth_exception.dart';

class KeycloakAuthDataSource {
  KeycloakAuthDataSource({
    OidcUserManager? userManager,
    CachedSimpleSecureStorage? secureStorage,
  }) : _userManager = userManager ??
            _createUserManager(
              secureStorage ?? (throw ArgumentError.notNull('secureStorage')),
            );

  // This manager handles the OIDC login and stores the session.
  final OidcUserManager _userManager;

  // Sends a signal when the app must remove an expired login session.
  final StreamController<KeycloakSessionExpiredException>
      _sessionFailuresController = StreamController.broadcast();

  // These objects watch the current access token until it expires.
  StreamSubscription<OidcEvent>? _eventSubscription;
  Timer? _tokenExpiryTimer;

  // Returns the currently logged-in user, if one exists.
  OidcUser? get currentUser => _userManager.currentUser;

  // Informs listeners when the user logs in or out.
  Stream<OidcUser?> get userChanges => _userManager.userChanges();

  // Informs the provider when a saved session is no longer valid.
  Stream<KeycloakSessionExpiredException> get sessionFailures =>
      _sessionFailuresController.stream;

  // Connects to Keycloak and loads a saved login session.
  Future<void> initialize() async {
    _startWatchingTokenEvents();

    // Remember if a login existed before OIDC checks and cleans the storage.
    await _userManager.store.init();
    final Set<String> storedTokenKeys = await _userManager.store.getAllKeys(
      OidcStoreNamespace.secureTokens,
      managerId: _userManager.id,
    );
    final bool hadStoredSession = storedTokenKeys.contains(
      OidcConstants_Store.currentToken,
    );

    await _userManager.init();

    // A missing user after a saved login means that the session expired.
    if (hadStoredSession && currentUser == null) {
      throw const KeycloakSessionExpiredException();
    }
  }

  // Opens Keycloak in the browser and waits for the login result.
  Future<OidcUser?> login() async {
    await initialize();
    return _userManager.loginAuthorizationCodeFlow();
  }

  // Logs the current user out of Keycloak.
  Future<void> logout() async {
    await initialize();
    try {
      await _userManager.logout();
    } finally {
      // Always remove local tokens, even if the server logout fails.
      await _userManager.forgetUser();
    }
  }

  // Closes streams when the data source is no longer needed.
  Future<void> dispose() async {
    _tokenExpiryTimer?.cancel();
    await _eventSubscription?.cancel();
    await _sessionFailuresController.close();
    await _userManager.dispose();
  }

  void _startWatchingTokenEvents() {
    // Start only one listener for token expiry events.
    _eventSubscription ??= _userManager.events().listen((OidcEvent event) {
      if (event is OidcTokenExpiringEvent) {
        _watchExpiringToken(event.currentToken);
      }
    });
  }

  void _watchExpiringToken(OidcToken expiringToken) {
    // Wait until the old access token has really expired.
    final Duration? remainingLifetime =
        expiringToken.calculateExpiresInFromNow();
    if (remainingLifetime == null) return;

    _tokenExpiryTimer?.cancel();
    _tokenExpiryTimer = Timer(
      remainingLifetime + const Duration(seconds: 5),
      () async {
        final OidcUser? user = currentUser;

        // A successful refresh replaces the old token with a new one.
        if (user == null || !identical(user.token, expiringToken)) return;

        // The old token is still active, so refreshing the session failed.
        await _userManager.forgetUser();
        _sessionFailuresController.add(
          const KeycloakSessionExpiredException(),
        );
      },
    );
  }

  static OidcUserManager _createUserManager(
    CachedSimpleSecureStorage secureStorage,
  ) {
    // OIDC stores access, refresh, and ID tokens in encrypted storage.
    return OidcUserManager.lazy(
      id: 'campus-app',
      discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
        KeycloakConfig.issuer,
      ),
      clientCredentials: const OidcClientAuthentication.none(
        clientId: KeycloakConfig.clientId,
      ),
      store: OidcDefaultStore(
        secureStorageInstance: secureStorage,
      ),
      settings: OidcUserManagerSettings(
        redirectUri: KeycloakConfig.redirectUri,
        postLogoutRedirectUri: KeycloakConfig.postLogoutRedirectUri,
        scope: const ['openid', 'profile', 'email'],
        strictJwtVerification: true,
      ),
    );
  }
}
