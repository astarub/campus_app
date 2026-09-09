class KeycloakConfig {
  // This class only stores settings and should not be created as an object.
  const KeycloakConfig._();

  // Address of our local Keycloak realm.
  static final Uri issuer = Uri.parse(         //Uri is a Dart-Data Type for Adr.
    'http://localhost:8080/realms/campus-app',
  );

  // Name of our app in Keycloak.
  static const String clientId = 'campus-app-flutter';

  // Keycloak sends the login result back to this local address.
  // Port 0 means that Windows chooses a free port.
  static final Uri redirectUri = Uri.parse('http://127.0.0.1:0');

  // Keycloak sends the user back here after logout.
  static final Uri postLogoutRedirectUri = Uri.parse('http://127.0.0.1:0');
}
