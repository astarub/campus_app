import 'dart:io';

class KeycloakConfig {
  // This class only stores settings and should not be created as an object.
  const KeycloakConfig._();

  // Address of our local Keycloak realm.
  static final Uri issuer = Uri.parse(
    Platform.isAndroid
        ? 'http://10.0.2.2:8080/realms/campus-app'
        : 'http://localhost:8080/realms/campus-app',
  );

  // Name of our app in Keycloak.
  static const String clientId = 'campus-app-flutter';

  static const String appAuthRedirectScheme = 'de.asta.bochum.campusapp';

  // Mobile platforms return directly to the app. Desktop platforms use a
  // temporary local port.
  static final Uri redirectUri = Uri.parse(
    Platform.isAndroid || Platform.isIOS || Platform.isMacOS
        ? '$appAuthRedirectScheme:/oauth2redirect'
        : 'http://127.0.0.1:0',
  );

  // Keycloak sends the user back here after logout.
  static final Uri postLogoutRedirectUri = Uri.parse(
    Platform.isAndroid || Platform.isIOS || Platform.isMacOS
        ? '$appAuthRedirectScheme:/endsessionredirect'
        : 'http://127.0.0.1:0',
  );
}
