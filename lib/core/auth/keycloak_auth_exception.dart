// Marks a saved Keycloak session that can no longer be used.
class KeycloakSessionExpiredException implements Exception {
  const KeycloakSessionExpiredException();
}
