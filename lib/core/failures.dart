abstract class Failure {}

/// server unreachable
class ServerFailure extends Failure {}

/// some failure / unexpected failure
class GeneralFailure extends Failure {}
