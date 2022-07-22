part of 'rubsignin_bloc.dart';

@immutable
abstract class RUBSignInEvent {}

class RUBSignInWithUsernameAndPassword extends RUBSignInEvent {
  final String? loginId;
  final String? password;

  RUBSignInWithUsernameAndPassword({
    required this.loginId,
    required this.password,
  });
}

class RUBSignInWithTOTP extends RUBSignInEvent {
  final String? totp;

  RUBSignInWithTOTP({required this.totp});
}
