// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:campus_app/pages/mensa/widgets/meal_category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'package:campus_app/l10n/l10n_de.dart';
import 'package:campus_app/l10n/l10n_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale);

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
  static const List<Locale> supportedLocales = <Locale>[Locale('de'), Locale('en'), Locale('pt')];

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

  String get close;

  String get done;

  String get feedTitle;

  String get feedLeft;

  String get feedRight;

  String get feedFilter;

  String get eventFilter;

  String get calendarEventLocationToBeAnnounced;

  String get calendarEventNoDescriptionGiven;

  String get calendarEventHost;

  String get calendarEventVenue;

  String get calendarEventNotificationOff;

  String get calendarEventNotificationOn;

  String get calendarPageUpcoming;

  String get calendarPageSaved;

  String get calendarPageNoEventsUpcomingTitle;

  String get calendarPageNoEventsUpcomingText;

  String get calendarPageNoEventsSavedTitle;

  String get calendarPageNoEventsSavedText;

  String get eventsTitle;

  String get navBarFeed;

  String get navBarEvents;

  String get navBarMensa;

  String get navBarWallet;

  String get navBarMore;

  String get navBarCalendar;

  String get firebaseDecisionPopup;

  String get firebaseDecisionPopupSlim;

  String get firebaseDecisionAccept;

  String get firebaseDecisionDecline;

  String get chooseStudyProgram;

  String get onboardingAppName;

  String get onboardingPresentedBy;

  String get onboardingStudyProgram;

  String get onboardingStudyProgramDetailed;

  String get onboardingPrivacy;

  String get onboardingNotifications;

  String get onboardingConfirm;

  String get onboardingDeny;

  String get onboardingTheme;

  String get onboardingThemeDescription;

  String get onboardingThemeSystem;

  String get onboardingThemeLight;

  String get onboardingThemeDark;

  String get onboardingFeedback;

  String get allergens;

  String get allergensAvoid;

  String get allergensGluten;

  String get allergensWheat;

  String get allergensRye;

  String get allergensBarley;

  String get allergensOats;

  String get allergensSpelt;

  String get allergensKamut;

  String get allergensCrustaceans;

  String get allergensEggs;

  String get allergensFish;

  String get allergensPeanuts;

  String get allergensSoybeans;

  String get allergensMilk;

  String get allergensNuts;

  String get allergensAlmond;

  String get allergensHazelnut;

  String get allergensWalnut;

  String get allergensCashewnut;

  String get allergensPecan;

  String get allergensBrazilNut;

  String get allergensPistachio;

  String get allergensMacadamia;

  String get allergensCelery;

  String get allergensMustard;

  String get allergensSesame;

  String get allergensSulfur;

  String get allergensLupins;

  String get allergensMolluscs;

  String get mondayShort;

  String get tuesdayShort;

  String get wednesdayShort;

  String get thursdayShort;

  String get fridayShort;

  String get saturdayShort;

  String get sundayShort;

  String get mealPreferences;

  String get preferencesExclusive;

  String get preferencesVegetarian;

  String get preferencesVegan;

  String get preferencesHalal;

  String get preferencesAvoid;

  String get preferencesAlcohol;

  String get preferencesFish;

  String get preferencesPoultry;

  String get preferencesLamb;

  String get preferencesBeef;

  String get preferencesPork;

  String get preferencesGame;

  String get mensaPageTitle;

  String get mensaPagePreferences;

  String get mensaPageAllergens;

  String get imprintPageLegalNotice;

  String get imprintPageLegalNoticeText;

  String get morePageTitle;

  String get morePageAstaA;

  String get morePageKulturCafe;

  String get morePageBikeWorkshop;

  String get morePageRepairCafe;

  String get morePageSocialCounseling;

  String get morePageDancingGroup;

  String get morePageGamingHub;

  String get morePageUsefulLinks;

  String get morePageRubMail;

  String get morePageMoodle;

  String get morePageECampus;

  String get morePageFlexNow;

  String get morePageUniSports;

  String get morePageOther;

  String get morePageSettings;

  String get morePagePrivacy;

  String get morePageLegalNotice;

  String get morePageUsedResources;

  String get morePageFeedback;

  String get privacyPolicyPrivacy;

  String get privacyPolicyText;

  String get settingsSettings;

  String get settingsHeadlineTheming;

  String get settingsSystemDarkmode;

  String get settingsDarkmode;

  String get settingsHeadlineCoreData;

  String get settingsStudyProgram;

  String get settingsStudyProgramChange;

  String get settingsHeadlineBehaviour;

  String get settingsUseExternalBrowser;

  String get settingsTextSize;

  String get settingsTicketFullscreen;

  String get settingsHeadlinePrivacy;

  String get settingsGoogleServices;

  String get settingsHeadlinePushNotifications;

  String get settingsPushNotificationsEvents;

  String get controlRoomButton;

  String get controlRoomButtonDescription;

  String get walletAddStudentTicket;

  String get faqCampusABC;

  String get faqMandatoryAttendance;

  String get faqMandatoryAttendanceText;

  String get faqAStAMessenger;

  String get faqAStAMessengerText;

  String get faqAccessibility;

  String get faqAccessibilityText;

  String get faqLibraries;

  String get faqLibrariesText;

  String get faqCreditPoints;

  String get faqCreditPointsText;

  String get faqeECampus;

  String get faqeECampusText;

  String get faqECTS;

  String get faqECTSText;

  String get faqInclusion;

  String get faqInclusionText;

  String get faqLabInternships;

  String get faqLabInternshipsText;

  String get faqCompensation;

  String get faqCompensationText;

  String get faqOptional;

  String get faqOptionalText;

  String get faqExamWork;

  String get faqExamWorkText;

  String get faqExamRegulations;

  String get faqExamRegulationsText;

  String get faqRoomOfSilence;

  String get faqRoomOfSilenceText;

  String get faqSemesterTicket;

  String get faqSemesterTicketText;

  String get faqSozialbeitrag;

  String get faqSozialbeitragText;

  String get faqStudentSecretariat;

  String get faqStudentSecretariatText;

  String get faqTeamspeak;

  String get faqTeamspeakText;

  String get faqUNIC;

  String get faqUNICText;

  String get faqEvents;

  String get faqEventsText;

  String get faqAccomodation;

  String get faqAccomodationText;

  String get faqZoom;

  String get faqZoomText;

  String get faqEmergencyNumber;

  String get faqEmergencyNumberText;

  String get balanceMultipleTags;

  String get balanceIOSScanCard;

  String get balanceMensaBalance;

  String get balanceBalance;

  String get balanceLastTransaction;

  String get balanceScanCard;

  String get balanceScanCardDetailed;

  String get balanceNFCOff;

  String get balanceNFCOffDetailed;

  String get balanceLastBalance;

  String get balanceLastScanned;

  String get ticketLoginLoginID;

  String get ticketLoginPasswort;

  String get ticketLoginLogin;

  String get ticketLoginBothFieldsError;

  String get ticketLoginInternetError;

  String get ticketLoginWrongDataError;

  String get ticketLoginLoadingError;

  String get ticketLoginEncryptedInfo;

  String get walletPageWallet;

  String get walletPageBalance;

  String get walletPageCampusABC;

  String get walletPageComingInFuture;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
