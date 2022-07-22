/// response status code is not 200
class ServerException implements Exception {}

/// expected response is not existing
class EmptyResponseException implements Exception {}

/// RUB login credentials incorrect
class InvalidLoginIDAndPasswordException implements Exception {}

/// 2FA token is not correct
class Invalid2FATokenException implements Exception {}
