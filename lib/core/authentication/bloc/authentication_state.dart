part of 'authentication_bloc.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

/// user has to authenticat
class AuthenticationTodoState extends AuthenticationState {}

/// valid 2FA session for authenticated user
class Authentication2FADoneState extends AuthenticationState {}

/// validate 2FA session for authenticated user
class Authentication2FATodoState extends AuthenticationState {}
