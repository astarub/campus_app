import 'dart:async';

import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';
import 'package:simple_secure_storage/simple_secure_storage.dart';

import 'package:campus_app/core/auth/keycloak_config.dart';
import 'package:campus_app/core/auth/keycloak_auth_exception.dart';

/// Handles the OIDC login, encrypted token storage and session expiry
/// The repository maps the OIDC user to the app profile
class KeycloakAuthDataSource {
  // A ? after a type means that the value may be null
  // ?? uses the value on the right when the value on the left is null
  KeycloakAuthDataSource({
    OidcUserManager? userManager,
    CachedSimpleSecureStorage? secureStorage,
  }) : _userManager = userManager ??
            _createUserManager(
              secureStorage ?? (throw ArgumentError.notNull('secureStorage')),
            );

  final OidcUserManager _userManager;

  // Reports a saved session that can no longer be restored or refreshed
  // broadcast allows several listeners to receive the same expiry event
  final StreamController<KeycloakSessionExpiredException>
      _sessionFailuresController = StreamController.broadcast();

  // Listen for expiring tokens and check whether they are refreshed in time
  StreamSubscription<OidcEvent>? _eventSubscription;
  Timer? _tokenExpiryTimer;

  // => returns the value written after it
  OidcUser? get currentUser => _userManager.currentUser;

  // A Stream can deliver new values while the app is running
  Stream<OidcUser?> get userChanges => _userManager.userChanges();

  Stream<KeycloakSessionExpiredException> get sessionFailures =>
      _sessionFailuresController.stream;

  /// Restores a saved session and verifies that it is still valid
  Future<void> initialize() async {
    _startWatchingTokenEvents();

    // await pauses this method until the asynchronous operation completes
    // Remember whether a token existed because OIDC removes invalid tokens during init
    await _userManager.store.init();
    final Set<String> storedTokenKeys = await _userManager.store.getAllKeys(
      OidcStoreNamespace.secureTokens,
      managerId: _userManager.id,
    );
    final bool hadStoredSession = storedTokenKeys.contains(
      OidcConstants_Store.currentToken,
    );

    await _userManager.init();

    // A removed stored token means that the saved session has expired
    if (hadStoredSession && currentUser == null) {
      throw const KeycloakSessionExpiredException();
    }
  }

  /// Starts the platform login and returns null when it is cancelled
  Future<OidcUser?> login() async {
    await initialize();
    return _userManager.loginAuthorizationCodeFlow();
  }

  Future<void> logout() async {
    try {
      await initialize();
      await _userManager.logout();
    } finally {
      // Clear local tokens even when the server logout fails
      await _userManager.forgetUser();
    }
  }

  Future<void> dispose() async {
    _tokenExpiryTimer?.cancel();
    await _eventSubscription?.cancel();
    await _sessionFailuresController.close();
    await _userManager.dispose();
  }

  void _startWatchingTokenEvents() {
    // ??= assigns the listener only when no subscription exists yet
    _eventSubscription ??= _userManager.events().listen((OidcEvent event) {
      // is checks whether the event has this specific type
      if (event is OidcTokenExpiringEvent) {
        _watchExpiringToken(event.currentToken);
      }
    });
  }

  void _watchExpiringToken(OidcToken expiringToken) {
    final Duration? remainingLifetime =
        expiringToken.calculateExpiresInFromNow();
    if (remainingLifetime == null) return;

    _tokenExpiryTimer?.cancel();
    _tokenExpiryTimer = Timer(
      // Allow a short grace period for automatic token refresh
      remainingLifetime + const Duration(seconds: 5),
      () async {
        final OidcUser? user = currentUser;

        // A new token means that the refresh succeeded
        // Here ! negates a boolean result and || accepts either condition
        if (user == null || !identical(user.token, expiringToken)) return;

        // Clear the session if the expired token is still present
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
    // Store access, refresh and ID tokens in encrypted storage
    return OidcUserManager.lazy(
      id: 'campus-app',
      discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
        KeycloakConfig.issuer,
      ),
      // Mobile apps are public clients and must not contain a client secret
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
