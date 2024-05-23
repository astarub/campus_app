// ignore_for_file: non_constant_identifier_names

import 'package:campus_app/l10n/l10n.dart';

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
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get feedTitle => 'Feed';

  @override
  String get feedLeft => 'Feed';

  @override
  String get feedRight => 'Explore';

  @override
  String get feedFilter => 'Feed Filter';

  @override
  String get eventFilter => 'Event Filter';

  @override
  String get calendarEventLocationToBeAnnounced => 'Event location to be announced.';

  @override
  String get calendarEventNoDescriptionGiven => 'No description given.';

  @override
  String get calendarEventHost => 'Host';

  @override
  String get calendarEventVenue => 'Venue';

  @override
  String get calendarEventNotificationOff => 'Remove from Saved Events';

  @override
  String get calendarEventNotificationOn => 'Save Event';

  @override
  String get calendarPageUpcoming => 'Upcoming';

  @override
  String get calendarPageSaved => 'Saved';

  @override
  String get calendarPageNoEventsUpcomingTitle => 'No events coming up';

  @override
  String get calendarPageNoEventsUpcomingText => 'There are no events currently planned. Check back later!';

  @override
  String get calendarPageNoEventsSavedTitle => 'No events saved';

  @override
  String get calendarPageNoEventsSavedText => 'Save events to see them here.';

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
        To show you notifactions about spontaneous Events and Dates around campus, we currently use the 
        Google service Firebase.

        If that is a concern to you, we will respect that.
        We plan to provide an alternative starting in January.''';

  @override
  String get firebaseDecisionPopupSlim => '''
        To show you notifactions about spontaneous Events and Dates around campus, 
        we currently use the Google service Firebase.

        If that is a concern to you, we will respect that.
        We plan to provide an alternative starting in January.''';

  @override
  String get firebaseDecisionAccept => "Yes, I don't mind.";

  @override
  String get firebaseDecisionDecline => "No, I don't want that.";

  @override
  String get chooseStudyProgram => 'Choose your study program.';

  @override
  String get onboardingAppName => 'Campus App';

  @override
  String get onboardingPresentedBy => 'Presented by your AStA';

  @override
  String get onboardingStudyProgram => 'Study Program';

  @override
  String get onboardingStudyProgramDetailed => 'Choose your study program to see curated events and news.';

  @override
  String get onboardingPrivacy => 'Privacy';

  @override
  String get onboardingNotifications => 'Activate push notifications';

  @override
  String get onboardingConfirm => 'Yes, I agree';

  @override
  String get onboardingDeny => 'No, I do not agree';

  @override
  String get onboardingTheme => 'Theme';

  @override
  String get onboardingThemeDescription => 'Contrast-rich or subdued. Day or Night.\nChoose your design.';

  @override
  String get onboardingThemeSystem => 'System';

  @override
  String get onboardingThemeLight => 'Light';

  @override
  String get onboardingThemeDark => 'Dark';

  @override
  String get onboardingFeedback => 'Feedback';

  @override
  String get allergens => 'Allergens';

  @override
  String get allergensAvoid => 'Avoid';

  @override
  String get allergensGluten => 'Gluten';

  @override
  String get allergensWheat => 'Wheat';

  @override
  String get allergensRye => 'Rye';

  @override
  String get allergensBarley => 'Barley';

  @override
  String get allergensOats => 'Oats';

  @override
  String get allergensSpelt => 'Spelt';

  @override
  String get allergensKamut => 'Kamut';

  @override
  String get allergensCrustaceans => 'Crustaceans';

  @override
  String get allergensEggs => 'Eggs';

  @override
  String get allergensFish => 'Fish';

  @override
  String get allergensPeanuts => 'Peanuts';

  @override
  String get allergensSoybeans => 'Soybeans';

  @override
  String get allergensMilk => 'Milk';

  @override
  String get allergensNuts => 'Nuts';

  @override
  String get allergensAlmond => 'Almond';

  @override
  String get allergensHazelnut => 'Hazelnut';

  @override
  String get allergensWalnut => 'Walnut';

  @override
  String get allergensCashewnut => 'Cashewnut';

  @override
  String get allergensPecan => 'Pecan';

  @override
  String get allergensBrazilNut => 'BrazilNut';

  @override
  String get allergensPistachio => 'Pistachio';

  @override
  String get allergensMacadamia => 'Macadamia';

  @override
  String get allergensCelery => 'Celery';

  @override
  String get allergensMustard => 'Mustard';

  @override
  String get allergensSesame => 'Sesame';

  @override
  String get allergensSulfur => 'Sulfur';

  @override
  String get allergensLupins => 'Lupins';

  @override
  String get allergensMolluscs => 'Molluscs';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get mealPreferences => 'Preferences';

  @override
  String get preferencesExclusive => 'Exclusively';

  @override
  String get preferencesVegetarian => 'Vegetarian';

  @override
  String get preferencesVegan => 'Vegan';

  @override
  String get preferencesHalal => 'Halal';

  @override
  String get preferencesAvoid => 'Avoid';

  @override
  String get preferencesAlcohol => 'Alcohol';

  @override
  String get preferencesFish => 'Fish';

  @override
  String get preferencesPoultry => 'Poultry';

  @override
  String get preferencesLamb => 'Lamb';

  @override
  String get preferencesBeef => 'Beef';

  @override
  String get preferencesPork => 'Pork';

  @override
  String get preferencesGame => 'Game';
}
