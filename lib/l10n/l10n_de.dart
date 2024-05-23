// ignore_for_file: non_constant_identifier_names

import 'package:campus_app/l10n/l10n.dart';

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
  String get close => 'Schließen';

  @override
  String get done => 'Abschließen';

  @override
  String get feedTitle => 'Feed';

  @override
  String get feedLeft => 'Feed';

  @override
  String get feedRight => 'Entdecken';

  @override
  String get feedFilter => 'Feed-Filter';

  @override
  String get eventFilter => 'Event-Filter';

  @override
  String get calendarEventLocationToBeAnnounced => 'Veranstaltungsort wird noch bekannt gegeben.';

  @override
  String get calendarEventNoDescriptionGiven => 'Keine Beschreibung vorhanden.';

  @override
  String get calendarEventHost => 'Veranstalter:in';

  @override
  String get calendarEventVenue => 'Veranstaltungsort';

  @override
  String get calendarEventNotificationOff => 'Nicht mehr merken';

  @override
  String get calendarEventNotificationOn => 'Merken';

  @override
  String get calendarPageUpcoming => 'Anstehend';

  @override
  String get calendarPageSaved => 'Gemerkt';

  @override
  String get calendarPageNoEventsUpcomingTitle => 'Keine Events in Sicht';

  @override
  String get calendarPageNoEventsUpcomingText =>
      'Es sind gerade keine Events geplant. Schau am besten später nochmal vorbei.';

  @override
  String get calendarPageNoEventsSavedTitle => 'Keine gemerkten Events';

  @override
  String get calendarPageNoEventsSavedText => 'Merke dir Events, um sie hier zu sehen.';

  @override
  String get eventsTitle => 'Events';

  @override
  String get navBarFeed => 'Feed';

  @override
  String get navBarEvents => 'Events';

  @override
  String get navBarMensa => 'Mensa';

  @override
  String get navBarWallet => 'Wallet';

  @override
  String get navBarMore => 'Mehr';

  @override
  String get navBarCalendar => 'Kalender';

  @override
  String get firebaseDecisionPopup => '''
        Um dir Benachrichtigungen über spontane Events und Termine rund um die Uni schicken zu können,
        verwenden wir derzeit Firebase, einen Service von Google.
        
        Solltest du dies nicht wollen, respektieren wir das.
        Im Januar werden wir dafür eine Google-freie Alternative einführen.''';

  @override
  String get firebaseDecisionPopupSlim => '''
        Um dir Benachrichtigungen über spontane Events und Termine rund um die Uni
        schicken zu können, verwenden wir derzeit Firebase, einen Service von Google.
        
        Solltest du dies nicht wollen, respektieren wir das.
        Im Januar werden wir dafür eine Google-freie Alternative einführen.''';

  @override
  String get firebaseDecisionAccept => 'Ja, kein Problem';

  @override
  String get firebaseDecisionDecline => 'Nein, möchte ich nicht.';

  @override
  String get chooseStudyProgram => 'Wähle deinen Studiengang';

  @override
  String get onboardingAppName => 'Campus App';

  @override
  String get onboardingPresentedBy => 'Präsentiert von deinem AStA';

  @override
  String get onboardingStudyProgram => 'Studiengang';

  @override
  String get onboardingStudyProgramDetailed =>
      'Wähle deinen aktuellen Studiengang, um für dich passende Events und News anzuzeigen.';

  @override
  String get onboardingPrivacy => 'Datenschutz';

  @override
  String get onboardingNotifications => 'Push-Benachrichtigungen aktivieren';

  @override
  String get onboardingConfirm => 'Ja, kein Problem';

  @override
  String get onboardingDeny => 'Nein, möchte ich nicht.';

  @override
  String get onboardingTheme => 'Theme';

  @override
  String get onboardingThemeDescription => 'Kontrastreich oder unauffällig. Tag oder Nacht.\nWähle dein Design.';

  @override
  String get onboardingThemeSystem => 'System';

  @override
  String get onboardingThemeLight => 'Hell';

  @override
  String get onboardingThemeDark => 'Dunkel';

  @override
  String get onboardingFeedback => 'Feedback';

  @override
  String get allergens => 'Allergene';

  @override
  String get allergensAvoid => 'Vermeiden von';

  @override
  String get allergensGluten => 'Gluten';

  @override
  String get allergensWheat => 'Weizen';

  @override
  String get allergensRye => 'Roggen';

  @override
  String get allergensBarley => 'Gerste';

  @override
  String get allergensOats => 'Hafer';

  @override
  String get allergensSpelt => 'Dinkel';

  @override
  String get allergensKamut => 'Kamut';

  @override
  String get allergensCrustaceans => 'Krebstiere';

  @override
  String get allergensEggs => 'Eier';

  @override
  String get allergensFish => 'Fisch';

  @override
  String get allergensPeanuts => 'Erdnüsse';

  @override
  String get allergensSoybeans => 'Sojabohnen';

  @override
  String get allergensMilk => 'Milch';

  @override
  String get allergensNuts => 'Schalenfrüchte';

  @override
  String get allergensAlmond => 'Mandeln';

  @override
  String get allergensHazelnut => 'Haselnuss';

  @override
  String get allergensWalnut => 'Walnuss';

  @override
  String get allergensCashewnut => 'Cashewnuss';

  @override
  String get allergensPecan => 'Pecanuss';

  @override
  String get allergensBrazilNut => 'Paranuss';

  @override
  String get allergensPistachio => 'Pistazie';

  @override
  String get allergensMacadamia => 'Macadamia-/Queenslandnuss';

  @override
  String get allergensCelery => 'Sellerie';

  @override
  String get allergensMustard => 'Senf';

  @override
  String get allergensSesame => 'Sesamsamen';

  @override
  String get allergensSulfur => 'Schwefeloxid';

  @override
  String get allergensLupins => 'Lupinen';

  @override
  String get allergensMolluscs => 'Weichtiere';

  @override
  String get mondayShort => 'Mo';

  @override
  String get tuesdayShort => 'Di';

  @override
  String get wednesdayShort => 'Mi';

  @override
  String get thursdayShort => 'Do';

  @override
  String get fridayShort => 'Fr';

  @override
  String get saturdayShort => 'Sa';

  @override
  String get sundayShort => 'So';

  @override
  String get mealPreferences => 'Präferenzen';

  @override
  String get preferencesExclusive => 'Ausschließlich';

  @override
  String get preferencesVegetarian => 'Vegetarisch';

  @override
  String get preferencesVegan => 'Vegan';

  @override
  String get preferencesHalal => 'Halal';

  @override
  String get preferencesAvoid => 'Vermeiden von';

  @override
  String get preferencesAlcohol => 'Alkohol';

  @override
  String get preferencesFish => 'Fisch';

  @override
  String get preferencesPoultry => 'Geflügel';

  @override
  String get preferencesLamb => 'Lamm';

  @override
  String get preferencesBeef => 'Rind';

  @override
  String get preferencesPork => 'Schwein';

  @override
  String get preferencesGame => 'Wild';
}
