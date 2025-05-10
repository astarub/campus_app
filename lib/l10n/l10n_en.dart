// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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

  @override
  String get walletTitle => 'Wallet';

  @override
  String get addSemesterTicket => 'Add your semester ticket';

  @override
  String get rubEmergencyButton => 'RUB Emergency Center';

  @override
  String get rubEmergencyNote => 'Available 24/7 for any emergency';

  @override
  String get germanySemesterTicket => 'Germany Semester Ticket';

  @override
  String get mensaBalanceTitle => 'Mensa Balance';

  @override
  String get balanceLabel => 'Balance';

  @override
  String get euroSymbol => '€';

  @override
  String get lastTransactionLabel => 'Last transaction';

  @override
  String get scanCardTitle => 'Scan your card';

  @override
  String get scanCardText => 'Hold your student ID near your smartphone to scan it.';

  @override
  String get nfcDisabledTitle => 'NFC disabled';

  @override
  String get nfcDisabledText => 'To read your AKAFÖ balance, NFC must be enabled.';

  @override
  String get lastSavedBalance => 'Last saved balance';

  @override
  String get lastSavedTransaction => 'Last scanned transaction';

  @override
  String get navFeed => 'Feed';

  @override
  String get navEvents => 'Events';

  @override
  String get navMensa => 'Mensa';

  @override
  String get navWallet => 'Wallet';

  @override
  String get navMore => 'More';
}
