part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {}

/// user want to log out
class SignOutEvent extends AuthenticationEvent {}

/// authenticate user
class AuthCheckRequestedEvent extends AuthenticationEvent {}

/// validate 2FA session
class TOTPCheckRequestedEvent extends AuthenticationEvent {}
