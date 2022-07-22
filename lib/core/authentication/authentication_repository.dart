import 'package:campus_app/core/authentication/authentication_datasource.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticationRepository {
  /// Signin user with Login-ID of RUB and password.
  /// Return a failure if authentification goes wrong.
  Future<Either<Failure, Unit>> signInWithRUBLoginID({
    required String loginID,
    required String password,
  });

  /// Signout user who previously signedin
  Future<void> signOut();

  /// Check authentication status.
  /// Return true if user is allready authenticated.
  Future<bool> allreadyAuthenticated();

  /// Validate 2FA session.
  /// Return true if session is still valid.
  Future<bool> valid2FASession();

  /// Request 2FA session.
  /// Return a failure if authentication goes wrong.
  Future<Either<Failure, Unit>> signInWith2FA({
    required String totp,
  });
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationDatasource authenticationDatasource;

  AuthenticationRepositoryImpl({
    required this.authenticationDatasource,
  });

  @override
  Future<Either<Failure, Unit>> signInWithRUBLoginID({
    required String loginID,
    required String password,
  }) async {
    try {
      //* Login to moodle -> correct credentials
      //* -> a exception is thrown if credentials are incorrect
      await authenticationDatasource.credentialCheckByMoodle(
        username: loginID,
        password: password,
      );

      //* Store credentials securly
      await authenticationDatasource.storeLoginID(loginID);
      await authenticationDatasource.storePassword(password);

      return const Right(unit);
    } catch (e) {
      switch (e.runtimeType) {
        case ServerException:
          return Left(ServerFailure());

        case InvalidLoginIDAndPasswordException:
          return Left(InvalidLoginIDAndPasswordFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }

  @override
  Future<void> signOut() => Future.wait([
        authenticationDatasource.deleteLoginID(),
        authenticationDatasource.deletePassword(),
        authenticationDatasource.deleteMoodlePrivatetoken(),
        authenticationDatasource.deleteMoodleToken(),
        authenticationDatasource.deleteTokenId(),
      ]);

  @override
  Future<bool> allreadyAuthenticated() async {
    final loginID = await authenticationDatasource.getLoginID();
    final password = await authenticationDatasource.getPassword();

    if (loginID == null || password == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<bool> valid2FASession() async {
    try {
      final tokenId = await authenticationDatasource.getTokenId();

      if (tokenId == null) {
        return false;
      }

      final reponse =
          await authenticationDatasource.validate2FASession(tokenId: tokenId);

      if (reponse['valid'] == null) {
        return false;
      } else if (reponse['valid']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, Unit>> signInWith2FA({required String totp}) async {
    try {
      final loginID = await authenticationDatasource.getLoginID();
      final password = await authenticationDatasource.getPassword();

      if (loginID == null || password == null) {
        return Left(NotAuthenticatedFailure());
      }

      final tokenId =
          await authenticationDatasource.authenticateWithTOTPAndGetToken(
        username: loginID,
        password: password,
        totp: totp,
      );

      await authenticationDatasource.storeTokenId(tokenId);

      return const Right(unit);
    } catch (e) {
      switch (e.runtimeType) {
        case ServerException:
          return Left(ServerFailure());

        case EmptyResponseException:
          return Left(Invalid2FATokenFailure());

        case Invalid2FATokenException:
          return Left(Invalid2FATokenFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }
}
