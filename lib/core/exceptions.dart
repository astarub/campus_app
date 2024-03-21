/// response status code is not 200
class ServerException implements Exception {}

// failed to parse
class ParseException implements Exception {}

/// expected response is not existing
class EmptyResponseException implements Exception {}

/// RUB login credentials incorrect
class InvalidLoginIDAndPasswordException implements Exception {}

class MissingCredentialsException implements Exception {}

class TicketNotFoundException implements Exception {}

/// 2FA token is not correct
class Invalid2FATokenException implements Exception {}

/// object is not valid JSON
class JsonException implements Exception {}

/// some unexpected error occured
class UnexpectedException implements Exception {}

/// Error while authenticating to the appwrite backend
class AuthenticationException implements Exception {}

/// No connection to the backend
class NoConnectionException implements Exception {}

/// Too many request to the backend
class RateLimitException implements Exception {}
