import 'package:campus_app/core/authentication/authentication_datasource.dart';
import 'package:campus_app/core/authentication/authentication_handler.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticationRepository {
  /// Signin user with Login-ID of RUB and password.
  Future<void> signInWithRUBLoginID({
    required String loginID,
    required String password,
  });

  /// Signout user who previously signedin
  Future<void> signOut();

  /// Validate 2FA session.
  /// Return true if session is still valid.
  Future<bool> validate2FASession();

  /// Request 2FA session.
  Future<void> signInWith2FA({
    required String totp,
  });
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationDatasource authenticationDatasource;
  final AuthenticationHandler authenticationHandler;

  AuthenticationRepositoryImpl({
    required this.authenticationDatasource,
    required this.authenticationHandler,
  });

  @override
  Future<void> signInWithRUBLoginID({
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

      //* Notify authentication listeners about successfully login
      authenticationHandler.changeAuthState(
        state: AuthState.authenticated,
      );
    } catch (e) {
      //* Notify authentication listeners about failure at login
      switch (e.runtimeType) {
        case ServerException:
          authenticationHandler.changeAuthState(
            state: AuthState.unauthenticated,
            failure: ServerFailure(),
          );
          break;

        case InvalidLoginIDAndPasswordException:
          authenticationHandler.changeAuthState(
            state: AuthState.unauthenticated,
            failure: InvalidLoginIDAndPasswordFailure(),
          );
          break;

        default:
          authenticationHandler.changeAuthState(
            state: AuthState.unauthenticated,
            failure: GeneralFailure(),
          );
      }
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      authenticationDatasource.deleteLoginID(),
      authenticationDatasource.deletePassword(),
      authenticationDatasource.deleteMoodlePrivatetoken(),
      authenticationDatasource.deleteMoodleToken(),
      authenticationDatasource.deleteTokenId(),
    ]);

    //* Notify authentication listeners about logout
    authenticationHandler.changeAuthState(
      state: AuthState.unauthenticated,
    );
  }

  @override
  Future<bool> validate2FASession() async {
    try {
      final tokenId = await authenticationDatasource.getTokenId();
      final loginID = await authenticationDatasource.getLoginID();
      final password = await authenticationDatasource.getPassword();

      //* check if datasource know login credentials
      if (tokenId == null || loginID == null || password == null) {
        return false;
      }

      final reponse = await authenticationDatasource.validate2FASession(
        tokenId: tokenId,
      );

      //* validate forerock response
      if (reponse['valid'] == null) {
        return false;
      } else if (reponse['valid']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // each error should return a invalid session
      return false;
    }
  }

  @override
  Future<void> signInWith2FA({
    required String totp,
  }) async {
    try {
      final loginID = await authenticationDatasource.getLoginID();
      final password = await authenticationDatasource.getPassword();

      //* If currentState isn't authenticated or theire is no loginId or password
      //* then change state to unauthenticated and notify listeners about error
      if (authenticationHandler.currentAuthState != AuthState.authenticated ||
          loginID == null ||
          password == null) {
        authenticationHandler.changeAuthState(
          state: AuthState.unauthenticated,
          failure: NotAuthenticatedFailure(),
        );
        return;
      }

      final tokenId =
          await authenticationDatasource.authenticateWithTOTPAndGetToken(
        username: loginID,
        password: password,
        totp: totp,
      );

      await authenticationDatasource.storeTokenId(tokenId);

      authenticationHandler.changeAuthState(
        state: AuthState.authentication2FA,
      );
    } catch (e) {
      //* Notify authentication listeners about failure at 2FA-Login
      switch (e.runtimeType) {
        case ServerException:
          authenticationHandler.changeAuthState(
            state: AuthState.authenticated,
            failure: ServerFailure(),
          );
          break;

        case EmptyResponseException:
          authenticationHandler.changeAuthState(
            state: AuthState.authenticated,
            failure: Invalid2FATokenFailure(),
          );
          break;

        case Invalid2FATokenException:
          authenticationHandler.changeAuthState(
            state: AuthState.authenticated,
            failure: Invalid2FATokenFailure(),
          );
          break;

        default:
          authenticationHandler.changeAuthState(
            state: AuthState.authenticated,
            failure: GeneralFailure(),
          );
          break;
      }
    }
  }
}
