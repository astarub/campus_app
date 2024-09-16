import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_de.dart';
import 'l10n_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @serverFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not load server data.'**
  String get serverFailureMessage;

  /// No description provided for @generalFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred.'**
  String get generalFailureMessage;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error.'**
  String get errorMessage;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occured...'**
  String get unexpectedError;

  /// No description provided for @invalid2FATokenFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'Your TOTP is incorrect. Please try again!'**
  String get invalid2FATokenFailureMessage;

  /// No description provided for @invalidLoginIDAndPasswordFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'The credentials are invalid!'**
  String get invalidLoginIDAndPasswordFailureMessage;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @login_prompt.
  ///
  /// In en, this message translates to:
  /// **'Please login with your RUB-ID and password.'**
  String get login_prompt;

  /// No description provided for @rubid.
  ///
  /// In en, this message translates to:
  /// **'Login-ID of your RUB-Account'**
  String get rubid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @empty_input_field.
  ///
  /// In en, this message translates to:
  /// **'Please enter your credentials!'**
  String get empty_input_field;

  /// No description provided for @login_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid input!'**
  String get login_error;

  /// No description provided for @login_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully logged in!'**
  String get login_success;

  /// No description provided for @login_already.
  ///
  /// In en, this message translates to:
  /// **'Allready logged in.'**
  String get login_already;

  /// No description provided for @enter_totp.
  ///
  /// In en, this message translates to:
  /// **'Please enter your TOTP.'**
  String get enter_totp;

  /// No description provided for @feed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feed;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @feedTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feedTitle;

  /// No description provided for @feedLeft.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feedLeft;

  /// No description provided for @feedRight.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get feedRight;

  /// No description provided for @feedFilter.
  ///
  /// In en, this message translates to:
  /// **'Feed Filter'**
  String get feedFilter;

  /// No description provided for @eventFilter.
  ///
  /// In en, this message translates to:
  /// **'Event Filter'**
  String get eventFilter;

  /// No description provided for @calendarEventLocationToBeAnnounced.
  ///
  /// In en, this message translates to:
  /// **'Event location to be announced.'**
  String get calendarEventLocationToBeAnnounced;

  /// No description provided for @calendarEventNoDescriptionGiven.
  ///
  /// In en, this message translates to:
  /// **'No description given.'**
  String get calendarEventNoDescriptionGiven;

  /// No description provided for @calendarEventHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get calendarEventHost;

  /// No description provided for @calendarEventVenue.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get calendarEventVenue;

  /// No description provided for @calendarEventNotificationOff.
  ///
  /// In en, this message translates to:
  /// **'Remove from Saved Events'**
  String get calendarEventNotificationOff;

  /// No description provided for @calendarEventNotificationOn.
  ///
  /// In en, this message translates to:
  /// **'Save Event'**
  String get calendarEventNotificationOn;

  /// No description provided for @calendarPageUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get calendarPageUpcoming;

  /// No description provided for @calendarPageSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get calendarPageSaved;

  /// No description provided for @calendarPageNoEventsUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'No events coming up'**
  String get calendarPageNoEventsUpcomingTitle;

  /// No description provided for @calendarPageNoEventsUpcomingText.
  ///
  /// In en, this message translates to:
  /// **'There are no events currently planned. Check back later!'**
  String get calendarPageNoEventsUpcomingText;

  /// No description provided for @calendarPageNoEventsSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'No events saved'**
  String get calendarPageNoEventsSavedTitle;

  /// No description provided for @calendarPageNoEventsSavedText.
  ///
  /// In en, this message translates to:
  /// **'Save events to see them here.'**
  String get calendarPageNoEventsSavedText;

  /// No description provided for @eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsTitle;

  /// No description provided for @navBarFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get navBarFeed;

  /// No description provided for @navBarEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get navBarEvents;

  /// No description provided for @navBarMensa.
  ///
  /// In en, this message translates to:
  /// **'Mensa'**
  String get navBarMensa;

  /// No description provided for @navBarWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navBarWallet;

  /// No description provided for @navBarMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navBarMore;

  /// No description provided for @navBarCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navBarCalendar;

  /// No description provided for @firebaseDecisionPopup.
  ///
  /// In en, this message translates to:
  /// **'To show you notifactions about spontaneous Events and Dates around campus, we currently use the \nGoogle service Firebase.\n\nIf that is a concern to you, we will respect that.\nWe plan to provide an alternative starting in January.'**
  String get firebaseDecisionPopup;

  /// No description provided for @firebaseDecisionPopupSlim.
  ///
  /// In en, this message translates to:
  /// **'To show you notifactions about spontaneous Events and Dates around campus, \nwe currently use the Google service Firebase.\nIf that is a concern to you, we will respect that.\nWe plan to provide an alternative starting in January.'**
  String get firebaseDecisionPopupSlim;

  /// No description provided for @firebaseDecisionAccept.
  ///
  /// In en, this message translates to:
  /// **'Yes, I don\'t mind.'**
  String get firebaseDecisionAccept;

  /// No description provided for @firebaseDecisionDecline.
  ///
  /// In en, this message translates to:
  /// **'No, I don\'t want that.'**
  String get firebaseDecisionDecline;

  /// No description provided for @chooseStudyProgram.
  ///
  /// In en, this message translates to:
  /// **'Choose your study program.'**
  String get chooseStudyProgram;

  /// No description provided for @onboardingAppName.
  ///
  /// In en, this message translates to:
  /// **'Campus App'**
  String get onboardingAppName;

  /// No description provided for @onboardingPresentedBy.
  ///
  /// In en, this message translates to:
  /// **'Presented by your AStA'**
  String get onboardingPresentedBy;

  /// No description provided for @onboardingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get onboardingLanguage;

  /// No description provided for @onboardingLanguageDetailed.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language.'**
  String get onboardingLanguageDetailed;

  /// No description provided for @onboardingStudyProgram.
  ///
  /// In en, this message translates to:
  /// **'Study Program'**
  String get onboardingStudyProgram;

  /// No description provided for @onboardingStudyProgramDetailed.
  ///
  /// In en, this message translates to:
  /// **'Choose your study program to see curated events and news.'**
  String get onboardingStudyProgramDetailed;

  /// No description provided for @onboardingPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get onboardingPrivacy;

  /// No description provided for @onboardingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Activate push notifications'**
  String get onboardingNotifications;

  /// No description provided for @onboardingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, I agree'**
  String get onboardingConfirm;

  /// No description provided for @onboardingDeny.
  ///
  /// In en, this message translates to:
  /// **'No, I do not agree'**
  String get onboardingDeny;

  /// No description provided for @onboardingTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get onboardingTheme;

  /// No description provided for @onboardingThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Contrast-rich or subdued. Day or Night.\nChoose your design.'**
  String get onboardingThemeDescription;

  /// No description provided for @onboardingThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get onboardingThemeSystem;

  /// No description provided for @onboardingThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get onboardingThemeLight;

  /// No description provided for @onboardingThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get onboardingThemeDark;

  /// No description provided for @onboardingFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get onboardingFeedback;

  /// No description provided for @allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get allergens;

  /// No description provided for @allergensAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get allergensAvoid;

  /// No description provided for @allergensGluten.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get allergensGluten;

  /// No description provided for @allergensWheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get allergensWheat;

  /// No description provided for @allergensRye.
  ///
  /// In en, this message translates to:
  /// **'Rye'**
  String get allergensRye;

  /// No description provided for @allergensBarley.
  ///
  /// In en, this message translates to:
  /// **'Barley'**
  String get allergensBarley;

  /// No description provided for @allergensOats.
  ///
  /// In en, this message translates to:
  /// **'Oats'**
  String get allergensOats;

  /// No description provided for @allergensSpelt.
  ///
  /// In en, this message translates to:
  /// **'Spelt'**
  String get allergensSpelt;

  /// No description provided for @allergensKamut.
  ///
  /// In en, this message translates to:
  /// **'Kamut'**
  String get allergensKamut;

  /// No description provided for @allergensCrustaceans.
  ///
  /// In en, this message translates to:
  /// **'Crustaceans'**
  String get allergensCrustaceans;

  /// No description provided for @allergensEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get allergensEggs;

  /// No description provided for @allergensFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get allergensFish;

  /// No description provided for @allergensPeanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get allergensPeanuts;

  /// No description provided for @allergensSoybeans.
  ///
  /// In en, this message translates to:
  /// **'Soybeans'**
  String get allergensSoybeans;

  /// No description provided for @allergensMilk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get allergensMilk;

  /// No description provided for @allergensNuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get allergensNuts;

  /// No description provided for @allergensAlmond.
  ///
  /// In en, this message translates to:
  /// **'Almond'**
  String get allergensAlmond;

  /// No description provided for @allergensHazelnut.
  ///
  /// In en, this message translates to:
  /// **'Hazelnut'**
  String get allergensHazelnut;

  /// No description provided for @allergensWalnut.
  ///
  /// In en, this message translates to:
  /// **'Walnut'**
  String get allergensWalnut;

  /// No description provided for @allergensCashewnut.
  ///
  /// In en, this message translates to:
  /// **'Cashewnut'**
  String get allergensCashewnut;

  /// No description provided for @allergensPecan.
  ///
  /// In en, this message translates to:
  /// **'Pecan'**
  String get allergensPecan;

  /// No description provided for @allergensBrazilNut.
  ///
  /// In en, this message translates to:
  /// **'BrazilNut'**
  String get allergensBrazilNut;

  /// No description provided for @allergensPistachio.
  ///
  /// In en, this message translates to:
  /// **'Pistachio'**
  String get allergensPistachio;

  /// No description provided for @allergensMacadamia.
  ///
  /// In en, this message translates to:
  /// **'Macadamia'**
  String get allergensMacadamia;

  /// No description provided for @allergensCelery.
  ///
  /// In en, this message translates to:
  /// **'Celery'**
  String get allergensCelery;

  /// No description provided for @allergensMustard.
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
  String get allergensMustard;

  /// No description provided for @allergensSesame.
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get allergensSesame;

  /// No description provided for @allergensSulfur.
  ///
  /// In en, this message translates to:
  /// **'Sulfur'**
  String get allergensSulfur;

  /// No description provided for @allergensLupins.
  ///
  /// In en, this message translates to:
  /// **'Lupins'**
  String get allergensLupins;

  /// No description provided for @allergensMolluscs.
  ///
  /// In en, this message translates to:
  /// **'Molluscs'**
  String get allergensMolluscs;

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// No description provided for @mealPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get mealPreferences;

  /// No description provided for @preferencesExclusive.
  ///
  /// In en, this message translates to:
  /// **'Exclusively'**
  String get preferencesExclusive;

  /// No description provided for @preferencesVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get preferencesVegetarian;

  /// No description provided for @preferencesVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get preferencesVegan;

  /// No description provided for @preferencesHalal.
  ///
  /// In en, this message translates to:
  /// **'Halal'**
  String get preferencesHalal;

  /// No description provided for @preferencesAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get preferencesAvoid;

  /// No description provided for @preferencesAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get preferencesAlcohol;

  /// No description provided for @preferencesFish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get preferencesFish;

  /// No description provided for @preferencesPoultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get preferencesPoultry;

  /// No description provided for @preferencesLamb.
  ///
  /// In en, this message translates to:
  /// **'Lamb'**
  String get preferencesLamb;

  /// No description provided for @preferencesBeef.
  ///
  /// In en, this message translates to:
  /// **'Beef'**
  String get preferencesBeef;

  /// No description provided for @preferencesPork.
  ///
  /// In en, this message translates to:
  /// **'Pork'**
  String get preferencesPork;

  /// No description provided for @preferencesGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get preferencesGame;

  /// No description provided for @mensaPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Dining Hall'**
  String get mensaPageTitle;

  /// No description provided for @mensaPagePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get mensaPagePreferences;

  /// No description provided for @mensaPageAllergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get mensaPageAllergens;

  /// No description provided for @imprintPageLegalNotice.
  ///
  /// In en, this message translates to:
  /// **'Legal Notice'**
  String get imprintPageLegalNotice;

  /// No description provided for @imprintPageLegalNoticeText.
  ///
  /// In en, this message translates to:
  /// **'<h4>Inhaltlich Verantwortliche gemäß § 10 Absatz 3 MDStV:</h4>\nStudierendenschaft der Ruhr-Universität Bochum<br>\nAllgemeiner Studierendenausschuss<br>\nSH 0/11<br>\nUniversitätsstr. 150<br>\n44780 Bochum<br>\n<br>\nInhaltlich Verantwortlich:<br>\nHanife Demir (Vorsitzende)<br>\n<br>\nVertretungsberechtigter Vorstand:<br>\nRon Agethen<br>\nEren Yavuz<br>\nElisabeth Tilbürger<br>\nHenry Herrmann<br>\nAli Sait Kücük<br>\n<br>\nTelefon: <a href=\"tel:+492343222416\">+49 234 3222416</a><br>\nE-Mail: <a href=\"mailto:info@asta-bochum.de\">info@asta-bochum.de</a><br>\nInternet: <a href=\"https://www.asta-bochum.de\">https://www.asta-bochum.de</a><br>\n<br>\nDie Studierendenschaft ist eine Teilkörperschaft öffentlichen Rechts.\n<br>\n<h4>Inhalte</h4><br>\nDie Inhalte unserer Seiten wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen. \nAls Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. \nNach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. \nVerpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt.<br>Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. \nBei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.\n<h4>Haftungshinweis</h4>\nUnser Angebot enthält Links zu externen Webseiten Dritter, auf deren Inhalte wir keinen Einfluss haben. \nDeshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. \nFür die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. \nDie verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. \nRechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. \nEine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. \nBei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.'**
  String get imprintPageLegalNoticeText;

  /// No description provided for @morePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings & More'**
  String get morePageTitle;

  /// No description provided for @morePageAstaA.
  ///
  /// In en, this message translates to:
  /// **'AstA'**
  String get morePageAstaA;

  /// No description provided for @morePageKulturCafe.
  ///
  /// In en, this message translates to:
  /// **'KulturCafé'**
  String get morePageKulturCafe;

  /// No description provided for @morePageBikeWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Bike Workshop'**
  String get morePageBikeWorkshop;

  /// No description provided for @morePageRepairCafe.
  ///
  /// In en, this message translates to:
  /// **'Repair Café'**
  String get morePageRepairCafe;

  /// No description provided for @morePageSocialCounseling.
  ///
  /// In en, this message translates to:
  /// **'Social Counseling'**
  String get morePageSocialCounseling;

  /// No description provided for @morePageDancingGroup.
  ///
  /// In en, this message translates to:
  /// **'Dancing Group'**
  String get morePageDancingGroup;

  /// No description provided for @morePageGamingHub.
  ///
  /// In en, this message translates to:
  /// **'Gaming Hub'**
  String get morePageGamingHub;

  /// No description provided for @morePageUsefulLinks.
  ///
  /// In en, this message translates to:
  /// **'Useful Links'**
  String get morePageUsefulLinks;

  /// No description provided for @morePageRubMail.
  ///
  /// In en, this message translates to:
  /// **'RubMail'**
  String get morePageRubMail;

  /// No description provided for @morePageMoodle.
  ///
  /// In en, this message translates to:
  /// **'Moodle'**
  String get morePageMoodle;

  /// No description provided for @morePageECampus.
  ///
  /// In en, this message translates to:
  /// **'eCampus'**
  String get morePageECampus;

  /// No description provided for @morePageFlexNow.
  ///
  /// In en, this message translates to:
  /// **'FlexNow'**
  String get morePageFlexNow;

  /// No description provided for @morePageUniSports.
  ///
  /// In en, this message translates to:
  /// **'University Sports'**
  String get morePageUniSports;

  /// No description provided for @morePageOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get morePageOther;

  /// No description provided for @morePageSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get morePageSettings;

  /// No description provided for @morePagePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get morePagePrivacy;

  /// No description provided for @morePageLegalNotice.
  ///
  /// In en, this message translates to:
  /// **'Legal Notice'**
  String get morePageLegalNotice;

  /// No description provided for @morePageUsedResources.
  ///
  /// In en, this message translates to:
  /// **'Used Resources'**
  String get morePageUsedResources;

  /// No description provided for @morePageFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get morePageFeedback;

  /// No description provided for @privacyPolicyPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Datenschutz'**
  String get privacyPolicyPrivacy;

  /// No description provided for @privacyPolicyText.
  ///
  /// In en, this message translates to:
  /// **'<h2>Verantwortliche Stelle im Sinne der Datenschutzgesetze, insbesondere der EU-Datenschutzgrundverordnung (DSGVO), ist:</h2><br>\n<br>\nAStA an der Ruhr-Universität Bochum<br>\nPaul Hoffstiepel (Vorsitzender)<br>\n<br>\nStudierendenhaus 0/11<br>\nUniversitätsstr. 150<br>\n44801 Bochum<br>\n<br>\nTelefon: <a href=\"tel:+492343222416\">+49 234 3222416</a><br>\nE-Mail: <a href=\"mailto:info@asta-bochum.de\">info@asta-bochum.de</a><br>\n<br>\nSie können Sie sich jederzeit mit einer Beschwerde an die zuständige Aufsichtsbehörde wenden. Diese ist:\n<br>\nLandesbeauftragte für Datenschutz und Informationsfreiheit Nordrhein-Westfalen<br>\nPostfach 20 04 44<br>\n40102 Düsseldorf<br>\nTel.: <a href=\"tel:+49211384240\">+49 211 384240</a><br>\nFax: +49 211 3842410<br>\nE-Mail: <a href=\"mailto:poststelle@ldi.nrw.de\">poststelle@ldi.nrw.de</a><br>\nInternet: <a href=\"https://ldi.nrw.de\">poststelle@ldi.nrw.de</a>https://ldi.nrw.de<br>\n<br>\n<h2>Datenverarbeitung durch die Nutzung der Campus App</h2><br>\nBei der Nutzung der Campus App werden Daten erhoben und ausgetauscht, die zur Verwendung des Angebotes erforderlich sind. Dies sind:<br>\n- IP-Adresse<br>\n- Verwendetes Betriebssystem<br>\n- Uhrzeit der Serveranfrage<br>\n- Übertragene Datenmenge<br>\n- Standortdaten<br>\n<br>\nDiese Daten werden bei der Nutzung der Campus App ebenfalls in Log-Dateien über den Zeitpunkt des Besuches hinaus auf einem Server, welcher durch den AStA betrieben wird und ggf. auf einem Server einer besuchten Seite gespeichert.<br>\nUnsere App stellt Neuigkeiten verschiedener Internetseiten bereit, die nicht von der verfassten Studierendenschaft der Ruhr-Universität Bochum betrieben werden. \nEin Einfluss auf die Verarbeitung der dort erhobenen Daten besteht nicht. \nDie oben genannten Nutzungsdaten werden dabei an folgende Anbieter übermittelt: <br>\n- ruhr-uni-bochum.de, Universitätsstraße 150, 44801 Bochum. Datenschutzerklärung: <a href=\"https://www.ruhr-uni-bochum.de/de/datenschutz\">https://www.ruhr-uni-bochum.de/de/datenschutz</a><br>\n<br>\nBei der Installation der App werden Benutzer:innen danach gefragt, ob sie Push Notifications zu bestimmten Themen bekommen möchten. \nWenn Nutzer:innen in den Bezug von Push Notifications Einwilligen werden personenbezogene Daten wie z.B. IP Adresse und die gewählten Themen an Server der Firma Google Inc. übertragen. \nDie Daten werden die Daten ohne angemessenes Schutzniveau im Sinne von Art 46 DSGVO an Server von Google in die USA übertragen. \nSiehe dazu auch „Schrems II-Urteil“  (Az.: C-311/18 vom 16.07.2020) des EuGH. \nEs besteht das Risiko, dass US-Sicherheitsbehörden auf die Daten zugreifen ohne dass Betroffene darüber Informiert werden und ohne dass Rechtsbehelfe eingelegt werden können. \nDie Übermittlung erfolgt daher nur auf der ausdrücklichen Einwilligung nach Art. 49 Abs 1 a der DSGVO.\n<br>\nDie Einwilligung kann jederzeit in der Campus App unter dem Menupunkt „Mehr“, im Untermenü „Einstellungen“ widerrufen werden.<br>\n<br>\nWeitere Informationen in den Datenschutzhinweisen zu Firebase von Google: <a href=\"https://firebase.google.com/support/privacy\">https://firebase.google.com/support/privacy</a><br>\n„Schrems II“ – Urteil des EuGH: <a href=\"https://curia.europa.eu/juris/liste.jsf?language=de&num=C-311/18\">https://curia.europa.eu/juris/liste.jsf?language=de&num=C-311/18</a><br>\n<br>\nDie Campus App enthält Links zu Webseiten anderer Anbieter.<br>\nWir haben keinen Einfluss darauf, dass diese Anbieter die Datenschutzbestimmungen einhalten.<br> \nEine permanente Überprüfung der Links ist ohne konkrete Hinweise auf Rechtsverstöße nicht zumutbar.<br> \nBei Bekanntwerden von Rechtsverstößen werden betroffene Links unverzüglich gelöscht.<br>\n<br>\nBei der Nutzung des Raumfinders der Campus App, werden die aktuellen Standortdaten des Endgerätes verabeitet und bis zum Schließen der App zwischengespeichert.<br> \nEine Einwilligung wird hierfür vom Betriebssystem eingeholt und kann jederzeit durch den Nutzer widerrufen werden.<br>\n<br>\nBei der Nutzung der Funktion zum Anzeigen des Semestertickets werden die RUB Logindaten (LoginID, Passwort) lokal auf dem Gerät gespeichert, dies ist zum Abrufen des Tickets unabdingbar. Eine Übermittlung der Daten erfolgt nur an den offizielen SSO Provider der RUB.\n<br>\n<h2>Zweck der Datenverarbeitung</h2><br>\nDie Verarbeitung der personenbezogenen Daten der Nutzer ist für den ordnungsgemäßen Betrieb der App erforderlich.<br> \nDabei ist es unerlässlich, dass beispielsweise beim Abrufen der Speisepläne durch einen Server des AStAs personenbezogene Daten erhoben werden.<br>\nDes Weiteren werden beim Laden der Artikel im Newsfeed, Daten an die oben genannten Seiten übermittelt.<br>\n<br>\n<h2>Löschung bzw. Sperrung der Daten</h2><br>\nNach den Grundsätzen der Datenvermeidung und der Datensparsamkeit speichern wir alle Daten, die wir für die in dieser Datenschutzerklärung genannten bzw. anderen rechtlich vorgeschriebenen Gründe erhoben haben nur so lange, wie dies für den jeweiligen Zweck notwendig ist. Nach Wegfall des Zweckes bzw. nach Ablauf der Fristen werden die Daten entsprechend der gesetzlichen Vorgaben gelöscht, vernichtet oder gesperrt.<br>\n<br>\nGesetzliche Grundlagen für die Aufbewahrungsfristen werden in der Abgabenordnung §§ 147 und 257 geregelt.<br>\n<br>\n<h2>Rechtsgrundlagen (nach Art. 13 DSGVO)</h2><br>\nWir speichern Ihre Daten nur lange, wie es notwendig ist. Wir verarbeiten Ihre Daten auf den folgenden Rechtsgrundlagen:<br>\n<br>\nArtikel 6 Absatz 1 und Artikel 7 DSGVO für die Erfüllung von Leistungen und rechtlicher Verpflichtungen.<br>\nArtikel 28 DSGVO für die Verarbeitung von personenbezogen Daten im Auftrag.<br>\nNach Ablauf der Fristen werden Ihre Daten routinemäßig gelöscht.<br>\n<br>\n<h2>Ihre Rechte</h2><br>\nDie Datenschutzgrundverordnung räumt Ihnen folgende Rechte ein:<br>\n<br>\nVerlangen einer Bestätigung über die Verarbeitung Sie betreffender personenbezogener Daten (Art. 15)<br>\nVerlangen einer Kopie der Daten (Art. 15)<br>\nRecht auf Korrektur unrichtiger Sie betreffender personenbezogener Daten (Art. 16)<br>\nRecht auf Vervollständigung unvollständiger, Sie betreffender personenbezogener Daten (Art. 16)<br>\nRecht auf Löschung Sie betreffender personenbezogener Daten („Recht auf Vergessenwerden“ Art. 17)<br>\nRecht auf Einschränkung Sie betreffender personenbezogener Daten (Art. 18)<br>\nRecht auf die Übertragung der Daten an einen Dritten (Art. 20)<br>\nBeschwerde bei der oben genannten Aufsichtsbehörde (Art. 77)<br>\nErteilte Einwilligungen können Sie mit Wirkung für die Zukunft widerrufen (Art. 7 Abs. 3)<br>\nRecht auf Widerspruch der Verarbeitung Sie betreffender personenbezogener Daten (Art. 21)<br>\nSollten Sie Fragen zu einzelnen Punkten haben oder eines Ihrer Rechte ausüben wollen, wenden Sie sich an die oben angegebene verantwortliche Stelle oder an unseren Datenschutzbeauftragten unter datenschutz@asta-bochum.de.<br>\n<br>'**
  String get privacyPolicyText;

  /// No description provided for @settingsSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSettings;

  /// No description provided for @settingsHeadlineTheming.
  ///
  /// In en, this message translates to:
  /// **'Theming'**
  String get settingsHeadlineTheming;

  /// No description provided for @settingsSystemDarkmode.
  ///
  /// In en, this message translates to:
  /// **'System Dark Mode'**
  String get settingsSystemDarkmode;

  /// No description provided for @settingsDarkmode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkmode;

  /// No description provided for @settingsHeadlineCoreData.
  ///
  /// In en, this message translates to:
  /// **'Core Data'**
  String get settingsHeadlineCoreData;

  /// No description provided for @settingsStudyProgram.
  ///
  /// In en, this message translates to:
  /// **'Study Program'**
  String get settingsStudyProgram;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsStudyProgramChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get settingsStudyProgramChange;

  /// No description provided for @settingsHeadlineBehaviour.
  ///
  /// In en, this message translates to:
  /// **'Behaviour'**
  String get settingsHeadlineBehaviour;

  /// No description provided for @settingsUseExternalBrowser.
  ///
  /// In en, this message translates to:
  /// **'Use External Browser for Links'**
  String get settingsUseExternalBrowser;

  /// No description provided for @settingsTextSize.
  ///
  /// In en, this message translates to:
  /// **'Use System Text Size'**
  String get settingsTextSize;

  /// No description provided for @settingsTicketFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Use Full-Screen for Semesterticket QR-Code'**
  String get settingsTicketFullscreen;

  /// No description provided for @settingsHeadlinePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsHeadlinePrivacy;

  /// No description provided for @settingsGoogleServices.
  ///
  /// In en, this message translates to:
  /// **'Google Services for Notifications'**
  String get settingsGoogleServices;

  /// No description provided for @settingsHeadlinePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push-Notifications'**
  String get settingsHeadlinePushNotifications;

  /// No description provided for @settingsPushNotificationsEvents.
  ///
  /// In en, this message translates to:
  /// **'Push-Notifications for saved Events'**
  String get settingsPushNotificationsEvents;

  /// No description provided for @controlRoomButton.
  ///
  /// In en, this message translates to:
  /// **'RUB Control Room'**
  String get controlRoomButton;

  /// No description provided for @controlRoomButtonDescription.
  ///
  /// In en, this message translates to:
  /// **'Always in service, for any emergency'**
  String get controlRoomButtonDescription;

  /// No description provided for @walletAddStudentTicket.
  ///
  /// In en, this message translates to:
  /// **'Add your semester ticket'**
  String get walletAddStudentTicket;

  /// No description provided for @faqCampusABC.
  ///
  /// In en, this message translates to:
  /// **'Campus ABC'**
  String get faqCampusABC;

  /// No description provided for @faqMandatoryAttendance.
  ///
  /// In en, this message translates to:
  /// **'Anwesenheitspflicht'**
  String get faqMandatoryAttendance;

  /// No description provided for @faqMandatoryAttendanceText.
  ///
  /// In en, this message translates to:
  /// **'Unabhängig von digitalen Semestern, was historisch betrachtet eine Ausnahmefallregelung an der RUB darstellt, \ngilt in einigen Ausnahmefällen und bestimmten Kursformaten eine Anwesenheitspflicht. Die Anwesenheitspflicht, \ndie früher bestand, ist mit Inkrafttreten des Hochschulzukunftsgesetzes NRW zum Oktober 2014 abgeschafft worden. \nDanach ist es grundsätzlich verboten die Erbringung und Eintragung einer Leistung von der Anwesenheit in einer \nLehrveranstaltung abhängig zu machen. Davon ausgenommen sind jedoch vor allem Exkursionen, Sprachkurse, Praktika, \npraktische Übungen und vergleichbare Lehrveranstaltungen. Sollte in einer deiner Veranstaltungen trotz des Verbotes \neine Anwesenheitspflicht verlangt werden, kannst du dich hier melden: \n<a href=\"https://asta-bochum.de/anwesenheitspflicht\">https://asta-bochum.de/anwesenheitspflicht</a>'**
  String get faqMandatoryAttendanceText;

  /// No description provided for @faqAStAMessenger.
  ///
  /// In en, this message translates to:
  /// **'AStA-Messenger'**
  String get faqAStAMessenger;

  /// No description provided for @faqAStAMessengerText.
  ///
  /// In en, this message translates to:
  /// **'Ab sofort sind wir unter der Mobilfunknummer <a href=\"https://wa.me/4915222614240\">+49 152 22614240</a>  für \nallgemeine Fragen bei Whatsapp erreichbar.'**
  String get faqAStAMessengerText;

  /// No description provided for @faqAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Barrierefreiheit'**
  String get faqAccessibility;

  /// No description provided for @faqAccessibilityText.
  ///
  /// In en, this message translates to:
  /// **'Barrierefreiheit bedeutet die Umwelt und Infrastruktur in dem Sinne zu gestalten, dass sie auch von Menschen mit \nBeeinträchtigungen ohne zusätzliche Hilfe in Anspruch genommen werden kann. Das Studium für Menschen mit \nBeeinträchtigungen ist in vielerlei Hinsicht erschwert. Die RUB besitzt jedoch Initiativen den Studienalltag so \nweit wie möglich zu vereinfachen und jeder bzw. jedem Studierenden zugänglich zu machen. Unserer „Autonomes \nReferat für Menschen mit Behinderungen und sämtlichen Beeinträchtigungen“ und das BZI des AkaFö sind dabei eure \nerste Anlaufstelle für einen Einblick in die Angebote. So bietet die Universitätsbibliothek (UB) z.B. einen \nService zur Literaturbeschaffung an, um Barrierefreiheit zu ermöglichen. Auf der Internetseite \n<a href=\"https://uni.ruhr-uni-bochum.de/de/inklusion\">https://uni.ruhr-uni-bochum.de/de/inklusion</a> \nsind weitergehende Informationen für euch aufgelistet.'**
  String get faqAccessibilityText;

  /// No description provided for @faqLibraries.
  ///
  /// In en, this message translates to:
  /// **'Bibliotheken'**
  String get faqLibraries;

  /// No description provided for @faqLibrariesText.
  ///
  /// In en, this message translates to:
  /// **'Das Bibliothekssystem der RUB setzt sich aus der Universitätsbibliothek (UB), dem zentralen Gebäude des Campus \nund den in den Gebäuden verteilten Fachbibliotheken zusammen. Diese bieten dir einen Raum zum Lernen und \nRecherchieren für Hausarbeiten und Referate oder zum Lernen für Klausuren. Für jede einzelne Bibliothek bestehen \ngesonderte Regeln, was eine mögliche Ausleihe und die Öffnungszeiten betrifft. Die UB ist in den Zeiten von MO-FR: \n8.00 bis 23.00 Uhr und SA-SO: von 10.00 bis 19.00 Uhr geöffnet. Die UB stellt eine große Zahl an Arbeitsplätzen mit \nund ohne PC bereit. Für die Benutzung der Schließfächer ist eine 2€-Münze erforderlich! Erfahrt alle auf Corona \nbezogenen und alle aktualisierten Informationen auf der Internetseite der UB. Im Servicereferat des AStA kannst du \nauch kostenfrei einen AStA-Chip erhalten, der in die UB-Schließfächer passt. Eine Auflistung aller Fachbibliotheken \nund weitere Informationen: <a href=\"https://www.ub.rub.de\">https://www.ub.rub.de</a>'**
  String get faqLibrariesText;

  /// No description provided for @faqCreditPoints.
  ///
  /// In en, this message translates to:
  /// **'Credit Points'**
  String get faqCreditPoints;

  /// No description provided for @faqCreditPointsText.
  ///
  /// In en, this message translates to:
  /// **'Credit Points (CP) werden für jede erbrachte Prüfungsleistung vergeben. Du brauchst eine gewisse Anzahl von CP, \num Module abzuschließen und dich letztlich für deine Abschlussprüfungen anzumelden. Dabei soll 1 CP einem \nArbeitsaufwand von 30 Semesterwochenstunden entsprechen. Dieser umfasst die Vor- und Nachbereitung sowie die \nWochenstunden der Veranstaltung. Wie viele CP für eine Lehrveranstaltung vergeben werden kannst du deiner \nPrüfungsordnung entnehmen.'**
  String get faqCreditPointsText;

  /// No description provided for @faqeECampus.
  ///
  /// In en, this message translates to:
  /// **'eCampus'**
  String get faqeECampus;

  /// No description provided for @faqeECampusText.
  ///
  /// In en, this message translates to:
  /// **'eCampus ist ein zentrales Verwaltungsportal für Studenten. Dort kann nach der Anmedlung das Semesterticket abgerufen werden oder auch der zu zahlende Semesterbeitrag eingesehen werden. Weitere Informationen findne sich unter <a href=\"https://www.it-services.ruhr-uni-bochum.de/services/ecampus.html.de\">https://www.it-services.ruhr-uni-bochum.de/services/ecampus.html.de</a>'**
  String get faqeECampusText;

  /// No description provided for @faqECTS.
  ///
  /// In en, this message translates to:
  /// **'ECTS'**
  String get faqECTS;

  /// No description provided for @faqECTSText.
  ///
  /// In en, this message translates to:
  /// **'Das „European Credit Transfer System“ (Europäisches System zur Übertragung und Akkumulierung von Studienleistungen), \nkurz ECTS, bietet die Möglichkeit, die an einer Hochschuleinrichtung erworbenen Leistungspunkte auf ein Studium an \neiner anderen Hochschuleinrichtung anzurechnen. ECTS-Leistungspunkte entsprechen dem Lernen auf der Grundlage von \ndefinierten Lernzielen und dem damit verbundenen Arbeitspensum. Es soll Studierende bei einem Umzug von einem Land \nin ein anderes behilflich sein und sie dabei unterstützen, ihre akademischen Qualifikationen und Studienzeiten im \nAusland anerkennen zu lassen. Mehr Infos findet ihr unter: \n<a href=\"https://education.ec.europa.eu/de/europaeisches-system-zur-uebertragung-und-akkumulierung-von-studienleistungen-ects\">\nhttps://education.ec.europa.eu/de/europaeisches-system-zur-uebertragung-und-akkumulierung-von-studienleistungen-ects</a>'**
  String get faqECTSText;

  /// No description provided for @faqInclusion.
  ///
  /// In en, this message translates to:
  /// **'Inklusion'**
  String get faqInclusion;

  /// No description provided for @faqInclusionText.
  ///
  /// In en, this message translates to:
  /// **'Unter Inklusion verstehen wir die Teilhabe aller Menschen an der Gesellschaft. Konnotiert ist dieser Begriff \ninsbesondere durch die Berücksichtigung benachteiligter Personengruppen, denen eine soziale Ungleichheit und mangelnde \nChancengleichheit infolge einer studienerschwerenden gesundheitlichen Beeinträchtigung vorausgeht. Wir an der RUB sind \nbestrebt die Chancen und das Recht auf Bildung für alle Menschen gleich zu gestalten. An der RUB gibt es diverse Initiativen, \ndie euch in diesen Belangen mit Rat und Tat zu Seite stehen. Unser „Autonomes Referat für Menschen mit Behinderungen und \nsämtlichen Beeinträchtigungen“ ist hierzu neben dem „BZI“ des AkaFö, dem Beratungszentrum zur Inklusion Behinderter, eure \nerste Anlaufstelle. Neu ist das Förderprojekt „Inklusive Hochschule“, das sich dem Ziel verschrieben hat, Studierenden \nmit Behinderung oder chronischer Erkrankung die gleichberechtigte Teilhabe am Studium zu ermöglichen. Dorthin könnt \nIhr Euch auch mit Kritik, Lob und Euren Wünschen zum Thema Inklusion an der RUB wenden (z.B. per Mail an \n<a href=\"mailto:inklusion@rub.de\">inklusion@rub.de</a>). Auf der Internetseite \n<a href=\"https://uni.ruhr-uni-bochum.de/de/inklusion\">https://uni.ruhr-uni-bochum.de/de/inklusion</a> sind Informationen \nzum BZI für euch aufgelistet. Auch die zentrale Studienberatung (ZSB) kann euch eine erste Hilfestellung in diesen \nBelangen geben.'**
  String get faqInclusionText;

  /// No description provided for @faqLabInternships.
  ///
  /// In en, this message translates to:
  /// **'Labor-Praktika'**
  String get faqLabInternships;

  /// No description provided for @faqLabInternshipsText.
  ///
  /// In en, this message translates to:
  /// **'Das Absolvieren von Labor-Praktika wird vor allem in naturwissenschaftlichen und ingenieurswissenschaftlichen \nStudiengängen sowie in der Medizin von dir erwartet. Es werden vorbereitende Einführungsveranstaltungen und Sicherheitsbelehrungen \nangeboten. Außerdem musst du weitere Anforderungen erfüllen. Diese kannst du auf den Webseiten der Lehrstühle erfahren.'**
  String get faqLabInternshipsText;

  /// No description provided for @faqCompensation.
  ///
  /// In en, this message translates to:
  /// **'Nachteilsausgleich'**
  String get faqCompensation;

  /// No description provided for @faqCompensationText.
  ///
  /// In en, this message translates to:
  /// **'Ein „Nachteilsausgleich“ bezeichnet im sozialrechtlichen Sinne die Ansprüche auf Hilfe und Ausgleich, die einem \njeden Studierenden mit Beeinträchtigungen unter bestimmten Voraussetzungen zustehen. Umfasst werden hinsichtlich \ndes Studiums an der RUB dabei Lehr- und Prüfungsbedingungen des jeweiligen Studiengangs. Neben der Verlängerung \nder Schreibzeit bei Klausuren können insbesondere flexible Pausenregelungen, die Notwendigkeit bestimmter technischer, \nelektronischer oder sonstiger apparativer Hilfen sowie einer Veränderung der Arbeitsplatzorganisation berücksichtigt \nwerden. Unser „Autonomes Referat für Menschen mit Behinderungen und sämtlichen Beeinträchtigungen“ ist hierzu neben \ndem „BZI“ des AkaFö, dem Beratungszentrum zur Inklusion Behinderter, eure erste Anlaufstelle. Hier erhaltet ihr \nBeratungsangebote und eine erste Hilfe und Information zu euren Möglichkeiten an der RUB.'**
  String get faqCompensationText;

  /// No description provided for @faqOptional.
  ///
  /// In en, this message translates to:
  /// **'Optionalbereich'**
  String get faqOptional;

  /// No description provided for @faqOptionalText.
  ///
  /// In en, this message translates to:
  /// **'Neben den Lehrveranstaltungen deines spezifischen Bachelor-Studienganges musst du zudem eine gewisse Anzahl von Kursen \nbelegen, in denen der Erwerb von fächerübergreifenden Kenntnissen und Kompetenzen im Vordergrund steht. Diese kannst \ndu weitestgehend nach Interesse aus verschiedenen geistes-, gesellschafts- und naturwissenschaftlichen Bereichen auswählen. \nZudem erhältst du Einblicke in Fremdsprachen, Präsentations- und Kommunikationstechniken, Informationstechnologien \nund interdisziplinäre oder schul- und unterrichtsbezogene Module. \n<a href=\"https://rub.de/optionalbereich/\">https://rub.de/optionalbereich/</a>'**
  String get faqOptionalText;

  /// No description provided for @faqExamWork.
  ///
  /// In en, this message translates to:
  /// **'Prüfungsleistungen'**
  String get faqExamWork;

  /// No description provided for @faqExamWorkText.
  ///
  /// In en, this message translates to:
  /// **'Welche Leistungen von dir im Rahmen einer Lehrveranstaltung erbracht werden müssen kannst du dem Modulhandbuch deines \nStudienfaches, dem Vorlesungsverzeichnis oder eCampus entnehmen. Es gibt sowohl benotete als auch unbenotete \nVeranstaltungen. Die meisten Prüfungsleistungen bestehen aus Klausuren, Referaten und/oder Hausarbeiten.'**
  String get faqExamWorkText;

  /// No description provided for @faqExamRegulations.
  ///
  /// In en, this message translates to:
  /// **'Prüfungsordnungen'**
  String get faqExamRegulations;

  /// No description provided for @faqExamRegulationsText.
  ///
  /// In en, this message translates to:
  /// **'In der Prüfungsordnung deines Studienganges sind diejenigen Prüfungsleistungen aufgeführt, die du für deinen Abschluss \nerbringen musst. Auch ist dort geregelt, ob und wie oft du eine nicht bestandene Prüfung wiederholen bzw. verschieben \nkannst. Schon allein im Hinblick auf deinen Studienverlauf und deinen Abschluss ist ein Blick in die Prüfungsordnung \ndringend zu empfehlen!'**
  String get faqExamRegulationsText;

  /// No description provided for @faqRoomOfSilence.
  ///
  /// In en, this message translates to:
  /// **'Raum der Stille'**
  String get faqRoomOfSilence;

  /// No description provided for @faqRoomOfSilenceText.
  ///
  /// In en, this message translates to:
  /// **'Der „Raum der Stille“ soll zu Beginn des Wintersemesters am 11.10. eingeweiht werden und religionsübergreifend spirituellen \nBedürfnissen und dem individuellen Gebet Raum geben. Er wird aber auch für Menschen da sein, die aus nicht-religiösen \nGründen die Stille suchen, um etwas für ihre Gesundheit und ihr Wohlbefinden zu tun. Die Anerkennung und Förderung \nreligiöser Vielfalt schafft eine Atmosphäre der gegenseitigen Verbundenheit und Wertschätzung. Der Raum befindet sich \nim Gebäude der Mensa auf der Ebene der Roten Beete.'**
  String get faqRoomOfSilenceText;

  /// No description provided for @faqSemesterTicket.
  ///
  /// In en, this message translates to:
  /// **'Semesterticket'**
  String get faqSemesterTicket;

  /// No description provided for @faqSemesterTicketText.
  ///
  /// In en, this message translates to:
  /// **'Der Geltungsbereich des Semestertickets erstreckt sich auf den gesamten VRR-Bereich und mittlerweile auch nach Venlo. \nZudem ist das Ticket in ganz NRW gültig. Beachte hierbei, dass es nur ausgedruckt oder per PDF mit einem amtlichen \nLichtbildausweis (Perso oder Reisepass) gültig ist. Das Ticket kann über eCampus abgerufen werden.\nFür einen Aufschlag von 12,33 € kannst du dein Semesterticket zu einem Deutschlandticket aufwerten. Beachte, dass\ndu bei Nutzung des Deutschlandtickets, den QR-Code des Deutschlandtickets, dein Semesterticket und ein Lichtbildausweis\nmitführen musst. \n<a href=\"https://studium.ruhr-uni-bochum.de/de/vom-semesterticket-zum-deutschlandticket\">Buchung/Infos</a>'**
  String get faqSemesterTicketText;

  /// No description provided for @faqSozialbeitrag.
  ///
  /// In en, this message translates to:
  /// **'Sozialbeitrag'**
  String get faqSozialbeitrag;

  /// No description provided for @faqSozialbeitragText.
  ///
  /// In en, this message translates to:
  /// **'Der Sozialbeitrag ist ein von jedem Studierenden für jedes Semester erneut zu entrichtender Pflichtbeitrag. \nDer Betrag beläuft sich im Sommersemester 2023 auf insgesamt 362,62 €. \nEnthalten sind 120 € für das Akademische Förderungswerk (AKAFÖ), welches z.B. für die Mensa und Wohnheime zuständig \nist, 220,02 € (regulär) für das Semesterticket sowie 20,1 € für die Studierendenschaft der RUB (AStA).'**
  String get faqSozialbeitragText;

  /// No description provided for @faqStudentSecretariat.
  ///
  /// In en, this message translates to:
  /// **'Studierendensekretariat'**
  String get faqStudentSecretariat;

  /// No description provided for @faqStudentSecretariatText.
  ///
  /// In en, this message translates to:
  /// **'Das Studierendensekretariat (Gebäude SSC, Ebene 0, Raum 229) sowie die Infopoints, die über den Campus verteilt \nsind, sind Anlaufstellen für Studierende zur Information rund um die Organisation des Studiums. Für weitere \nInformationen und den einzelnen Standorten verweisen wir auf folgende Links: \n<a href=\"https://rub.de/campusservice/standorte\">Standorte</a> und <a href=\"https://rub.de/studierendensekretariat\">\nStudierendensekretariat</a>'**
  String get faqStudentSecretariatText;

  /// No description provided for @faqTeamspeak.
  ///
  /// In en, this message translates to:
  /// **'Teamspeak'**
  String get faqTeamspeak;

  /// No description provided for @faqTeamspeakText.
  ///
  /// In en, this message translates to:
  /// **'Der Teamspeak-Server des AStA (TS³) bietet zu Zeiten von Corona eine persönliche Kontaktmöglichkeit des AStA zur \nStudierendenschaft. Meldet euch hierzu einfach unter \"AStARUB\" an.'**
  String get faqTeamspeakText;

  /// No description provided for @faqUNIC.
  ///
  /// In en, this message translates to:
  /// **'UNIC'**
  String get faqUNIC;

  /// No description provided for @faqUNICText.
  ///
  /// In en, this message translates to:
  /// **'Die Ruhr-Universität Bochum ist Teil des internationalen Universitätskonsortiums UNIC - „European University of \nPost-Industrial Cities“. Es ist ein Verbund von acht Universitäten, der sich der Förderung von studentischer Mobilität \nund gesellschaftlicher Integration widmet. Mit der Schaffung einer europäischen Universität soll der Austausch und \ndie Kooperation von Lehre, Forschung und Transfer gesteigert werden. Studierende, Forschende, Lehrende und das Personal \naus der Verwaltung sollen von den Möglichkeiten eines europäischen Campus profitieren. Zu UNIC gehören neben der RUB \ndie Universitäten aus Bilbao, Cork, Istanbul, Liège, Oulu, Rotterdam und Zagreb.'**
  String get faqUNICText;

  /// No description provided for @faqEvents.
  ///
  /// In en, this message translates to:
  /// **'Veranstaltungen'**
  String get faqEvents;

  /// No description provided for @faqEventsText.
  ///
  /// In en, this message translates to:
  /// **'Die Veranstaltungen deines Studienganges können sich von denen anderer Studienfächer unterscheiden. Die gängigsten \nFormen und Bezeichnungen haben wir für euch aufgeführt. Vorlesungen sind dadurch gekennzeichnet, dass ein:e Dozierende:r \nmeistens frontal oder unter Einbeziehung des oft großen Auditoriums den Stoff vermittelt. Arbeitsgemeinschaften, \nÜbungen, Tutorien und Seminare sind in der Regel auf eine geringere Anzahl an Teilnehmer:innen begrenzt. In diesen \nsteht oftmals das Erlernen der wissenschaftlichen Arbeitsweise des Studienganges im Vordergrund. Tutorien zeichnen \nzudem aus, dass sie von erfahrenen Studierenden geführt werden und den Übergang von der Schule zur Universität \nerleichtern sollen. Welche Leistungen du erbringen musst, hängt auch hier von deiner Studienordnung ab. Falls du \ndeine Dozierenden \"bewerten\" möchtest, die Didaktik nicht angemessen findest oder eine Meinung zur Digitalisierung \nabgeben möchtest, benutze den Melder des AStAs auf der Homepage: \n<a href=\"https://asta-bochum.de/melder-fuer-probleme-mit-digitaler-lehre/\">\nhttps://asta-bochum.de/melder-fuer-probleme-mit-digitaler-lehre/</a>'**
  String get faqEventsText;

  /// No description provided for @faqAccomodation.
  ///
  /// In en, this message translates to:
  /// **'Wohnungen'**
  String get faqAccomodation;

  /// No description provided for @faqAccomodationText.
  ///
  /// In en, this message translates to:
  /// **'Für alle Studierende, die nicht mehr zu Hause wohnen möchten oder denen dieses aufgrund eines studienbedingten \nOrtswechsels nicht mehr möglich ist, stellt sich zwangsläufig die Frage wo sie eine neue Bleibe finden. Abhilfe \nkönnen die 21 Wohnheime des Akademischen Förderungswerkes (AKAFÖ) schaffen. Diese sind auf studentisches Wohnen \nausgerichtet und in der Nähe der RUB angesiedelt. Es gibt sowohl die Möglichkeit in Apartments oder Einzelzimmern \nauf einer Gemeinschaftsetage als auch in Wohngemeinschaften zu leben. Zudem gibt es Wohnheime in privater \nTrägerschaft. Doch auch abseits von Wohnheimen ist der Wohnungsmarkt in Bochum nicht so belastet wie in anderen \nUniversitätsstädten, sodass du in der Umgebung Bochums leicht eine passende Wohnung oder eine WG finden wirst. \nAuch dabei bietet dir der AStA gerne eine Orientierungshilfe. AStA Wohnen findet sich unter:\n<a href=\"https://akafoe.de/wohnen\">https://akafoe.de/wohnen</a> bzw. \n<a href=\"https://asta-bochum.de/wohnungsboerse/\">https://asta-bochum.de/wohnungsboerse</a>'**
  String get faqAccomodationText;

  /// No description provided for @faqZoom.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get faqZoom;

  /// No description provided for @faqZoomText.
  ///
  /// In en, this message translates to:
  /// **'Zoom stellt eine Möglichkeit dar, virtuell an Veranstaltungen teilzunehmen. Welche Plattformen eure Dozierenden \npräferieren, erfahrt ihr von eurer Fakultät. Informationen zur Teilnahme und Erstellung einer Zoom Videokonferenz \nfindet ihr unter <a href=\"https://it-services.ruhr-uni-bochum.de/bk/zoom.html.de\">\nhttps://it-services.ruhr-uni-bochum.de/bk/zoom.html.de</a>'**
  String get faqZoomText;

  /// No description provided for @faqEmergencyNumber.
  ///
  /// In en, this message translates to:
  /// **'Zentrale Notrufnummer RUB'**
  String get faqEmergencyNumber;

  /// No description provided for @faqEmergencyNumberText.
  ///
  /// In en, this message translates to:
  /// **'Die Ruhr-Universität verfügt über eine Leitwarte, die 24 Stunden besetzt und über die Nummer durchgehend erreichbar \nist. Bei Notfällen alarmiert sie Feuerwehr, Notarzt oder Polizei und zuständige Stellen innerhalb der Universität. \nSpeichert euch die Notruf-Nummer am besten in euer Handy ein: <a href=\"tel:+492343223333\">0234 3223333</a>'**
  String get faqEmergencyNumberText;

  /// No description provided for @balanceMultipleTags.
  ///
  /// In en, this message translates to:
  /// **'Multiple NFC-Tags found! Try again.'**
  String get balanceMultipleTags;

  /// No description provided for @balanceIOSScanCard.
  ///
  /// In en, this message translates to:
  /// **'Scan your card.'**
  String get balanceIOSScanCard;

  /// No description provided for @balanceMensaBalance.
  ///
  /// In en, this message translates to:
  /// **'Mensa Balance'**
  String get balanceMensaBalance;

  /// No description provided for @balanceBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance: '**
  String get balanceBalance;

  /// No description provided for @balanceLastTransaction.
  ///
  /// In en, this message translates to:
  /// **'Last Transaction: '**
  String get balanceLastTransaction;

  /// No description provided for @balanceScanCard.
  ///
  /// In en, this message translates to:
  /// **'Scan Card'**
  String get balanceScanCard;

  /// No description provided for @balanceScanCardDetailed.
  ///
  /// In en, this message translates to:
  /// **'Hold your student ID to your phone to scan it.'**
  String get balanceScanCardDetailed;

  /// No description provided for @balanceNFCOff.
  ///
  /// In en, this message translates to:
  /// **'NFC deactivated'**
  String get balanceNFCOff;

  /// No description provided for @balanceNFCOffDetailed.
  ///
  /// In en, this message translates to:
  /// **'Your NFC needs to be activated to read your AKAFÖ balance.'**
  String get balanceNFCOffDetailed;

  /// No description provided for @balanceLastBalance.
  ///
  /// In en, this message translates to:
  /// **'Last Balance: '**
  String get balanceLastBalance;

  /// No description provided for @balanceLastScanned.
  ///
  /// In en, this message translates to:
  /// **'Last scanned Transaction: '**
  String get balanceLastScanned;

  /// No description provided for @ticketLoginLoginID.
  ///
  /// In en, this message translates to:
  /// **'RUB LoginID'**
  String get ticketLoginLoginID;

  /// No description provided for @ticketLoginPasswort.
  ///
  /// In en, this message translates to:
  /// **'RUB Password'**
  String get ticketLoginPasswort;

  /// No description provided for @ticketLoginLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get ticketLoginLogin;

  /// No description provided for @ticketLoginBothFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in both fields!'**
  String get ticketLoginBothFieldsError;

  /// No description provided for @ticketLoginInternetError.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection!'**
  String get ticketLoginInternetError;

  /// No description provided for @ticketLoginWrongDataError.
  ///
  /// In en, this message translates to:
  /// **'Wrong LoginID or Password!'**
  String get ticketLoginWrongDataError;

  /// No description provided for @ticketLoginLoadingError.
  ///
  /// In en, this message translates to:
  /// **'Error while loading the ticket!'**
  String get ticketLoginLoadingError;

  /// No description provided for @ticketLoginEncryptedInfo.
  ///
  /// In en, this message translates to:
  /// **'Your data is encrypted and saved locally. It is only sent to the RUB servers when logging in.'**
  String get ticketLoginEncryptedInfo;

  /// No description provided for @walletPageWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletPageWallet;

  /// No description provided for @walletPageBalance.
  ///
  /// In en, this message translates to:
  /// **'Dining Hall Balance'**
  String get walletPageBalance;

  /// No description provided for @walletPageCampusABC.
  ///
  /// In en, this message translates to:
  /// **'Campus ABC'**
  String get walletPageCampusABC;

  /// No description provided for @walletPageComingInFuture.
  ///
  /// In en, this message translates to:
  /// **'This area will be expanded in future versions to integrate useful guides.'**
  String get walletPageComingInFuture;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
