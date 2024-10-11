import 'package:campus_app/l10n/l10n.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([super.locale = 'en']);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get serverFailureMessage => 'Could not load server data.';

  @override
  String get generalFailureMessage => 'An error has occurred.';

  @override
  String get errorMessage => 'Error.';

  @override
  String get unexpectedError => 'An unexpected error occured...';

  @override
  String get invalid2FATokenFailureMessage => 'Your TOTP is incorrect. Please try again!';

  @override
  String get invalidLoginIDAndPasswordFailureMessage => 'The credentials are invalid!';

  @override
  String get welcome => 'Welcome!';

  @override
  String get login_prompt => 'Please login with your RUB-ID and password.';

  @override
  String get rubid => 'Login-ID of your RUB-Account';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get empty_input_field => 'Please enter your credentials!';

  @override
  String get login_error => 'Invalid input!';

  @override
  String get login_success => 'Successfully logged in!';

  @override
  String get login_already => 'Allready logged in.';

  @override
  String get enter_totp => 'Please enter your TOTP.';
}
