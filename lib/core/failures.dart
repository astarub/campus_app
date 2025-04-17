abstract class Failure {}

/// server unreachable
class ServerFailure extends Failure {}

/// translation unsuccessful
class TranslationFailure extends Failure {}

/// some failure / unexpected failure
class GeneralFailure extends Failure {}

/// given credentials are incorrect
class InvalidLoginIDAndPasswordFailure extends Failure {}

/// given 2FA token is invalid
class Invalid2FATokenFailure extends Failure {}

/// user has to authenticate
class NotAuthenticatedFailure extends Failure {}

/// their isn't data to display or update
class NoDataFailure extends Failure {}

/// caching goes wrong
class CachFailure extends Failure {}
