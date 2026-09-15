import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';

import 'package:campus_app/core/auth/keycloak_config.dart';

class KeycloakAuthDataSource {
  KeycloakAuthDataSource({OidcUserManager? userManager})
      : _userManager = userManager ?? _createUserManager();

  // This manager handles the OIDC login and stores the session.
  final OidcUserManager _userManager;

  // Returns the currently logged-in user, if one exists.
  OidcUser? get currentUser => _userManager.currentUser;

  // Informs listeners when the user logs in or out.
  Stream<OidcUser?> get userChanges => _userManager.userChanges();

  // Connects to Keycloak and loads a saved login session.
  Future<void> initialize() async {
    await _userManager.init();
  }

  // Opens Keycloak in the browser and waits for the login result.
  Future<OidcUser?> login() async {
    await initialize();
    return _userManager.loginAuthorizationCodeFlow();
  }

  // Logs the current user out of Keycloak.
  Future<void> logout() async {
    await initialize();
    await _userManager.logout();
  }

  // Closes streams when the data source is no longer needed.
  Future<void> dispose() async {
    await _userManager.dispose();
  }

  static OidcUserManager _createUserManager() {
    return OidcUserManager.lazy(
      id: 'campus-app',
      discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
        KeycloakConfig.issuer,
      ),
      clientCredentials: const OidcClientAuthentication.none(
        clientId: KeycloakConfig.clientId,
      ),
      store: OidcDefaultStore(),
      settings: OidcUserManagerSettings(
        redirectUri: KeycloakConfig.redirectUri,
        postLogoutRedirectUri: KeycloakConfig.postLogoutRedirectUri,
        scope: const ['openid', 'profile', 'email'],
        strictJwtVerification: true,
      ),
    );
  }
}
