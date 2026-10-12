/// Identifies a saved Keycloak session that can no longer be restored or refreshed
/// An empty token store is still a normal logged-out state
/// The class needs no fields because catch blocks identify it by its type
class KeycloakSessionExpiredException implements Exception {
  const KeycloakSessionExpiredException();
}
