// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get helloWorld => 'Hallo Welt!';

  @override
  String get serverFailureMessage => 'Serverdaten konnten nicht geladen werden.';

  @override
  String get generalFailureMessage => 'Ein Fehler ist aufgetreten.';

  @override
  String get errorMessage => 'Fehler.';

  @override
  String get unexpectedError => 'Ein unerwarteter Fehler ist aufgetreten...';

  @override
  String get invalid2FATokenFailureMessage => 'Dein Einmalcode (TOTP) is ungültig. Bitte versuche es erneut!';

  @override
  String get invalidLoginIDAndPasswordFailureMessage => 'Die Anmeldedaten sind ungültig!';

  @override
  String get welcome => 'Willkommen!';

  @override
  String get login_prompt => 'Bitte melde dich mit deiner RUB-ID und deinem Passwort an.';

  @override
  String get rubid => 'Login-ID von deinem RUB-Account';

  @override
  String get password => 'Passwort';

  @override
  String get login => 'Anmelden';

  @override
  String get empty_input_field => 'Bitte gib deine Anmeldedaten ein!';

  @override
  String get login_error => 'Ungültige Eingabe!';

  @override
  String get login_success => 'Erfolgreich angemeldet!';

  @override
  String get login_already => 'Du bist bereits angemeldet.';

  @override
  String get enter_totp => 'Bitte gib deinen Einmalcode (TOTP) ein.';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get addSemesterTicket => 'Füge dein Semesterticket hinzu';

  @override
  String get rubEmergencyButton => 'Leitwarte der RUB';

  @override
  String get rubEmergencyNote => '24/7 besetzt, für jegliche Notfälle';

  @override
  String get germanySemesterTicket => 'Deutschlandsemesterticket';

  @override
  String get mensaBalanceTitle => 'Mensa Guthaben';

  @override
  String get balanceLabel => 'Guthaben';

  @override
  String get euroSymbol => '€';

  @override
  String get lastTransactionLabel => 'Letzte Abbuchung';

  @override
  String get scanCardTitle => 'Karte scannen';

  @override
  String get scanCardText => 'Halte deinen Studierendenausweis an dein Smartphone, um ihn zu scannen.';

  @override
  String get nfcDisabledTitle => 'NFC deaktiviert';

  @override
  String get nfcDisabledText => 'Um dein AKAFÖ Guthaben auslesen zu können, muss NFC aktiviert sein.';

  @override
  String get lastSavedBalance => 'Letztes Guthaben';

  @override
  String get lastSavedTransaction => 'Letzte gescannte Abbuchung';

  @override
  String get navFeed => 'Feed';

  @override
  String get navEvents => 'Veranstaltungen';

  @override
  String get navMensa => 'Mensa';

  @override
  String get navWallet => 'Wallet';

  @override
  String get navMore => 'Mehr';
}
