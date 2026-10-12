import 'dart:io';

/// Stores Keycloak settings for the local Docker setup
/// Build-time dart defines can point the app to another realm
class KeycloakConfig {
  // A private constructor prevents creating KeycloakConfig objects
  const KeycloakConfig._();

  // static exposes the setting through the class without creating an object
  // const is fixed at compile time while final is assigned once at runtime
  static const String _configuredIssuer = String.fromEnvironment(
    'KEYCLOAK_ISSUER',
  );

  // Android emulators reach the host computer through 10.0.2.2 by default
  // Physical devices must set KEYCLOAK_ISSUER to an address they can reach
  // Use the value after ? when the condition is true
  // Use the value after : when the condition is false
  static final Uri issuer = Uri.parse(
    _configuredIssuer.isNotEmpty
        ? _configuredIssuer
        : Platform.isAndroid
            ? 'http://10.0.2.2:8080/realms/campus-app'
            : 'http://localhost:8080/realms/campus-app',
  );

  static const String clientId = String.fromEnvironment(
    'KEYCLOAK_CLIENT_ID',
    defaultValue: 'campus-app-flutter',
  );

  // Keep this scheme in sync with the platform settings and Keycloak client
  static const String appAuthRedirectScheme = 'de.asta.bochum.campusapp';

  // Mobile and macOS use the custom scheme while desktop uses a local port
  static final Uri redirectUri = Uri.parse(
    Platform.isAndroid || Platform.isIOS || Platform.isMacOS
        ? '$appAuthRedirectScheme:/oauth2redirect'
        : 'http://127.0.0.1:0',
  );

  static final Uri postLogoutRedirectUri = Uri.parse(
    Platform.isAndroid || Platform.isIOS || Platform.isMacOS
        ? '$appAuthRedirectScheme:/endsessionredirect'
        : 'http://127.0.0.1:0',
  );
}
