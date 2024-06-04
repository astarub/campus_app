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
  String get navBarMore => 'More';

  @override
  String get navBarCalendar => 'Calendar';

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

  @override
  String get mensaPageTitle => 'Dining Hall';

  @override
  String get mensaPagePreferences => 'Preferences';

  @override
  String get mensaPageAllergens => 'Allergens';

  @override
  String get imprintPageLegalNotice => 'Legal Notice';

  @override
  String get imprintPageLegalNoticeText => '''
                    <h4>Inhaltlich Verantwortliche gemäß § 10 Absatz 3 MDStV:</h4>
  
                    Studierendenschaft der Ruhr-Universität Bochum<br>
                    Allgemeiner Studierendenausschuss<br>
                    SH 0/11<br>
                    Universitätsstr. 150<br>
                    44780 Bochum<br>
                    <br>
                    Inhaltlich Verantwortlich:<br>
                    Hanife Demir (Vorsitzende)<br>
                    <br>
                    Vertretungsberechtigter Vorstand:<br>
                    Ron Agethen<br>
                    Eren Yavuz<br>
                    Elisabeth Tilbürger<br>
                    Henry Herrmann<br>
                    Ali Sait Kücük<br>
                    <br>
                    Telefon: <a href="tel:+492343222416">+49 234 3222416</a><br>
                    E-Mail: <a href="mailto:info@asta-bochum.de">info@asta-bochum.de</a><br>
                    Internet: <a href="https://www.asta-bochum.de">https://www.asta-bochum.de</a><br>
                    <br>
                    Die Studierendenschaft ist eine Teilkörperschaft öffentlichen Rechts.
                    <br>
                    <h4>Inhalte</h4><br>
                    Die Inhalte unserer Seiten wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen. 
                    Als Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. 
                    Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. 
                    Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt.<br>Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. 
                    Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.
                    <h4>Haftungshinweis</h4>
                    Unser Angebot enthält Links zu externen Webseiten Dritter, auf deren Inhalte wir keinen Einfluss haben. 
                    Deshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. 
                    Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. 
                    Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. 
                    Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. 
                    Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. 
                    Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.
                    ''';

  @override
  String get morePageTitle => 'Settings & More';

  @override
  String get morePageAstaA => 'AstA';

  @override
  String get morePageKulturCafe => 'KulturCafé';

  @override
  String get morePageBikeWorkshop => 'Bike Workshop';

  @override
  String get morePageRepairCafe => 'Repair Café';

  @override
  String get morePageSocialCounseling => 'Social Counseling';

  @override
  String get morePageDancingGroup => 'Dancing Group';

  @override
  String get morePageGamingHub => 'Gaming Hub';

  @override
  String get morePageUsefulLinks => 'Useful Links';

  @override
  String get morePageRubMail => 'RubMail';

  @override
  String get morePageMoodle => 'Moodle';

  @override
  String get morePageECampus => 'eCampus';

  @override
  String get morePageFlexNow => 'FlexNow';

  @override
  String get morePageUniSports => 'University Sports';

  @override
  String get morePageOther => 'Other';

  @override
  String get morePageSettings => 'Settings';

  @override
  String get morePagePrivacy => 'Privacy';

  @override
  String get morePageLegalNotice => 'Legal Notice';

  @override
  String get morePageUsedResources => 'Used Resources';

  @override
  String get morePageFeedback => 'Feedback';

  @override
  String get privacyPolicyPrivacy => 'Datenschutz';

  @override
  String get privacyPolicyText => '''
                    <h2>Verantwortliche Stelle im Sinne der Datenschutzgesetze, insbesondere der EU-Datenschutzgrundverordnung (DSGVO), ist:</h2><br>
                    <br>
                    AStA an der Ruhr-Universität Bochum<br>
                    Paul Hoffstiepel (Vorsitzender)<br>
                    <br>
                    Studierendenhaus 0/11<br>
                    Universitätsstr. 150<br>
                    44801 Bochum<br>
                    <br>
                    Telefon: <a href="tel:+492343222416">+49 234 3222416</a><br>
                    E-Mail: <a href="mailto:info@asta-bochum.de">info@asta-bochum.de</a><br>
                    <br>
                    Sie können Sie sich jederzeit mit einer Beschwerde an die zuständige Aufsichtsbehörde wenden. Diese ist:
                    <br>
                    Landesbeauftragte für Datenschutz und Informationsfreiheit Nordrhein-Westfalen<br>
                    Postfach 20 04 44<br>
                    40102 Düsseldorf<br>
                    
                    Tel.: <a href="tel:+49211384240">+49 211 384240</a><br>
                    Fax: +49 211 3842410<br>
                    E-Mail: <a href="mailto:poststelle@ldi.nrw.de">poststelle@ldi.nrw.de</a><br>
                    Internet: <a href="https://ldi.nrw.de">poststelle@ldi.nrw.de</a>https://ldi.nrw.de<br>
                    <br>
                    <h2>Datenverarbeitung durch die Nutzung der Campus App</h2><br>
                    Bei der Nutzung der Campus App werden Daten erhoben und ausgetauscht, die zur Verwendung des Angebotes erforderlich sind. Dies sind:<br>
                    - IP-Adresse<br>
                    - Verwendetes Betriebssystem<br>
                    - Uhrzeit der Serveranfrage<br>
                    - Übertragene Datenmenge<br>
                    - Standortdaten<br>
                    <br>
                    Diese Daten werden bei der Nutzung der Campus App ebenfalls in Log-Dateien über den Zeitpunkt des Besuches hinaus auf einem Server, welcher durch den AStA betrieben wird und ggf. auf einem Server einer besuchten Seite gespeichert.<br>
                    Unsere App stellt Neuigkeiten verschiedener Internetseiten bereit, die nicht von der verfassten Studierendenschaft der Ruhr-Universität Bochum betrieben werden. 
                    Ein Einfluss auf die Verarbeitung der dort erhobenen Daten besteht nicht. 
                    Die oben genannten Nutzungsdaten werden dabei an folgende Anbieter übermittelt: <br>
                    - ruhr-uni-bochum.de, Universitätsstraße 150, 44801 Bochum. Datenschutzerklärung: <a href="https://www.ruhr-uni-bochum.de/de/datenschutz">https://www.ruhr-uni-bochum.de/de/datenschutz</a><br>
                    <br>
                    Bei der Installation der App werden Benutzer:innen danach gefragt, ob sie Push Notifications zu bestimmten Themen bekommen möchten. 
                    Wenn Nutzer:innen in den Bezug von Push Notifications Einwilligen werden personenbezogene Daten wie z.B. IP Adresse und die gewählten Themen an Server der Firma Google Inc. übertragen. 
                    Die Daten werden die Daten ohne angemessenes Schutzniveau im Sinne von Art 46 DSGVO an Server von Google in die USA übertragen. 
                    Siehe dazu auch „Schrems II-Urteil“  (Az.: C-311/18 vom 16.07.2020) des EuGH. 
                    Es besteht das Risiko, dass US-Sicherheitsbehörden auf die Daten zugreifen ohne dass Betroffene darüber Informiert werden und ohne dass Rechtsbehelfe eingelegt werden können. 
                    Die Übermittlung erfolgt daher nur auf der ausdrücklichen Einwilligung nach Art. 49 Abs 1 a der DSGVO.
                    <br>
                    Die Einwilligung kann jederzeit in der Campus App unter dem Menupunkt „Mehr“, im Untermenü „Einstellungen“ widerrufen werden.<br>
                    <br>
                    Weitere Informationen in den Datenschutzhinweisen zu Firebase von Google: <a href="https://firebase.google.com/support/privacy"https://firebase.google.com/support/privacy</a><br>
                    „Schrems II“ – Urteil des EuGH: <a href="https://curia.europa.eu/juris/liste.jsf?language=de&num=C-311/18">https://curia.europa.eu/juris/liste.jsf?language=de&num=C-311/18</a><br>
                    <br>
                    Die Campus App enthält Links zu Webseiten anderer Anbieter.<br>
                    Wir haben keinen Einfluss darauf, dass diese Anbieter die Datenschutzbestimmungen einhalten.<br> 
                    Eine permanente Überprüfung der Links ist ohne konkrete Hinweise auf Rechtsverstöße nicht zumutbar.<br> 
                    Bei Bekanntwerden von Rechtsverstößen werden betroffene Links unverzüglich gelöscht.<br>
                    <br>
                    Bei der Nutzung des Raumfinders der Campus App, werden die aktuellen Standortdaten des Endgerätes verabeitet und bis zum Schließen der App zwischengespeichert.<br> 
                    Eine Einwilligung wird hierfür vom Betriebssystem eingeholt und kann jederzeit durch den Nutzer widerrufen werden.<br>
                    <br>
                    Bei der Nutzung der Funktion zum Anzeigen des Semestertickets werden die RUB Logindaten (LoginID, Passwort) lokal auf dem Gerät gespeichert, dies ist zum Abrufen des Tickets unabdingbar. Eine Übermittlung der Daten erfolgt nur an den offizielen SSO Provider der RUB.
                    <br>
                    <h2>Zweck der Datenverarbeitung</h2><br>
                    Die Verarbeitung der personenbezogenen Daten der Nutzer ist für den ordnungsgemäßen Betrieb der App erforderlich.<br> 
                    Dabei ist es unerlässlich, dass beispielsweise beim Abrufen der Speisepläne durch einen Server des AStAs personenbezogene Daten erhoben werden.<br>
                    Des Weiteren werden beim Laden der Artikel im Newsfeed, Daten an die oben genannten Seiten übermittelt.<br>
                    <br>
                    <h2>Löschung bzw. Sperrung der Daten</h2><br>
                    Nach den Grundsätzen der Datenvermeidung und der Datensparsamkeit speichern wir alle Daten, die wir für die in dieser Datenschutzerklärung genannten bzw. anderen rechtlich vorgeschriebenen Gründe erhoben haben nur so lange, wie dies für den jeweiligen Zweck notwendig ist. Nach Wegfall des Zweckes bzw. nach Ablauf der Fristen werden die Daten entsprechend der gesetzlichen Vorgaben gelöscht, vernichtet oder gesperrt.<br>
                    <br>
                    Gesetzliche Grundlagen für die Aufbewahrungsfristen werden in der Abgabenordnung §§ 147 und 257 geregelt.<br>
                    <br>
                    <h2>Rechtsgrundlagen (nach Art. 13 DSGVO)</h2><br>
                    Wir speichern Ihre Daten nur lange, wie es notwendig ist. Wir verarbeiten Ihre Daten auf den folgenden Rechtsgrundlagen:<br>
                    <br>
                    Artikel 6 Absatz 1 und Artikel 7 DSGVO für die Erfüllung von Leistungen und rechtlicher Verpflichtungen.<br>
                    Artikel 28 DSGVO für die Verarbeitung von personenbezogen Daten im Auftrag.<br>
                    Nach Ablauf der Fristen werden Ihre Daten routinemäßig gelöscht.<br>
                    <br>
                    <h2>Ihre Rechte</h2><br>
                    Die Datenschutzgrundverordnung räumt Ihnen folgende Rechte ein:<br>
                    <br>
                    Verlangen einer Bestätigung über die Verarbeitung Sie betreffender personenbezogener Daten (Art. 15)<br>
                    Verlangen einer Kopie der Daten (Art. 15)<br>
                    Recht auf Korrektur unrichtiger Sie betreffender personenbezogener Daten (Art. 16)<br>
                    Recht auf Vervollständigung unvollständiger, Sie betreffender personenbezogener Daten (Art. 16)<br>
                    Recht auf Löschung Sie betreffender personenbezogener Daten („Recht auf Vergessenwerden“ Art. 17)<br>
                    Recht auf Einschränkung Sie betreffender personenbezogener Daten (Art. 18)<br>
                    Recht auf die Übertragung der Daten an einen Dritten (Art. 20)<br>
                    Beschwerde bei der oben genannten Aufsichtsbehörde (Art. 77)<br>
                    Erteilte Einwilligungen können Sie mit Wirkung für die Zukunft widerrufen (Art. 7 Abs. 3)<br>
                    Recht auf Widerspruch der Verarbeitung Sie betreffender personenbezogener Daten (Art. 21)<br>
                    Sollten Sie Fragen zu einzelnen Punkten haben oder eines Ihrer Rechte ausüben wollen, wenden Sie sich an die oben angegebene verantwortliche Stelle oder an unseren Datenschutzbeauftragten unter datenschutz@asta-bochum.de.<br>
                    <br>
                    ''';

  @override
  String get settingsSettings => 'Settings';

  @override
  String get settingsHeadlineTheming => 'Theming';

  @override
  String get settingsSystemDarkmode => 'System Dark Mode';

  @override
  String get settingsDarkmode => 'Dark Mode';

  @override
  String get settingsHeadlineCoreData => 'Core Data';

  @override
  String get settingsStudyProgram => 'Study Program';

  @override
  String get settingsStudyProgramChange => 'Change';

  @override
  String get settingsHeadlineBehaviour => 'Behaviour';

  @override
  String get settingsUseExternalBrowser => 'Use External Browser for Links';

  @override
  String get settingsTextSize => 'Use System Text Size';

  @override
  String get settingsTicketFullscreen => 'Use Full-Screen for Semesterticket QR-Code';

  @override
  String get settingsHeadlinePrivacy => 'Privacy';

  @override
  String get settingsGoogleServices => 'Google Services for Notifications';

  @override
  String get settingsHeadlinePushNotifications => 'Push-Notifications';

  @override
  String get settingsPushNotificationsEvents => 'Push-Notifications for saved Events';

  @override
  String get controlRoomButton => 'RUB Control Room';

  @override
  String get controlRoomButtonDescription => 'Always in service, for any emergency';

  @override
  String get walletAddStudentTicket => 'Add your semester ticket';

  @override
  String get faqCampusABC => 'Campus ABC';

  // Untranslated for now, maybe ask ChatGPT.

  @override
  String get faqMandatoryAttendance => 'Anwesenheitspflicht';

  @override
  String get faqMandatoryAttendanceText => '''
      Unabhängig von digitalen Semestern, was historisch betrachtet eine Ausnahmefallregelung an der RUB darstellt, 
      gilt in einigen Ausnahmefällen und bestimmten Kursformaten eine Anwesenheitspflicht. Die Anwesenheitspflicht, 
      die früher bestand, ist mit Inkrafttreten des Hochschulzukunftsgesetzes NRW zum Oktober 2014 abgeschafft worden. 
      Danach ist es grundsätzlich verboten die Erbringung und Eintragung einer Leistung von der Anwesenheit in einer 
      Lehrveranstaltung abhängig zu machen. Davon ausgenommen sind jedoch vor allem Exkursionen, Sprachkurse, Praktika, 
      praktische Übungen und vergleichbare Lehrveranstaltungen. Sollte in einer deiner Veranstaltungen trotz des Verbotes 
      eine Anwesenheitspflicht verlangt werden, kannst du dich hier melden: 
      <a href="https://asta-bochum.de/anwesenheitspflicht">https://asta-bochum.de/anwesenheitspflicht</a>
    ''';

  @override
  String get faqAStAMessenger => 'AStA-Messenger';

  @override
  String get faqAStAMessengerText => '''
      Ab sofort sind wir unter der Mobilfunknummer <a href="https://wa.me/4915222614240">+49 152 22614240</a>  für 
      allgemeine Fragen bei Whatsapp erreichbar.
    ''';

  @override
  String get faqAccessibility => 'Barrierefreiheit';

  @override
  String get faqAccessibilityText => '''
      Barrierefreiheit bedeutet die Umwelt und Infrastruktur in dem Sinne zu gestalten, dass sie auch von Menschen mit 
      Beeinträchtigungen ohne zusätzliche Hilfe in Anspruch genommen werden kann. Das Studium für Menschen mit 
      Beeinträchtigungen ist in vielerlei Hinsicht erschwert. Die RUB besitzt jedoch Initiativen den Studienalltag so 
      weit wie möglich zu vereinfachen und jeder bzw. jedem Studierenden zugänglich zu machen. Unserer „Autonomes 
      Referat für Menschen mit Behinderungen und sämtlichen Beeinträchtigungen“ und das BZI des AkaFö sind dabei eure 
      erste Anlaufstelle für einen Einblick in die Angebote. So bietet die Universitätsbibliothek (UB) z.B. einen 
      Service zur Literaturbeschaffung an, um Barrierefreiheit zu ermöglichen. Auf der Internetseite 
      <a href="https://uni.ruhr-uni-bochum.de/de/inklusion">https://uni.ruhr-uni-bochum.de/de/inklusion</a> 
      sind weitergehende Informationen für euch aufgelistet.
    ''';

  @override
  String get faqLibraries => 'Bibliotheken';

  @override
  String get faqLibrariesText => '''
      Das Bibliothekssystem der RUB setzt sich aus der Universitätsbibliothek (UB), dem zentralen Gebäude des Campus 
      und den in den Gebäuden verteilten Fachbibliotheken zusammen. Diese bieten dir einen Raum zum Lernen und 
      Recherchieren für Hausarbeiten und Referate oder zum Lernen für Klausuren. Für jede einzelne Bibliothek bestehen 
      gesonderte Regeln, was eine mögliche Ausleihe und die Öffnungszeiten betrifft. Die UB ist in den Zeiten von MO-FR: 
      8.00 bis 23.00 Uhr und SA-SO: von 10.00 bis 19.00 Uhr geöffnet. Die UB stellt eine große Zahl an Arbeitsplätzen mit 
      und ohne PC bereit. Für die Benutzung der Schließfächer ist eine 2€-Münze erforderlich! Erfahrt alle auf Corona 
      bezogenen und alle aktualisierten Informationen auf der Internetseite der UB. Im Servicereferat des AStA kannst du 
      auch kostenfrei einen AStA-Chip erhalten, der in die UB-Schließfächer passt. Eine Auflistung aller Fachbibliotheken 
      und weitere Informationen: <a href="https://www.ub.rub.de">https://www.ub.rub.de</a>
    ''';

  @override
  String get faqCreditPoints => 'Credit Points';

  @override
  String get faqCreditPointsText => '''
      Credit Points (CP) werden für jede erbrachte Prüfungsleistung vergeben. Du brauchst eine gewisse Anzahl von CP, 
      um Module abzuschließen und dich letztlich für deine Abschlussprüfungen anzumelden. Dabei soll 1 CP einem 
      Arbeitsaufwand von 30 Semesterwochenstunden entsprechen. Dieser umfasst die Vor- und Nachbereitung sowie die 
      Wochenstunden der Veranstaltung. Wie viele CP für eine Lehrveranstaltung vergeben werden kannst du deiner 
      Prüfungsordnung entnehmen.
    ''';

  @override
  String get faqeECampus => 'eCampus';

  @override
  String get faqeECampusText => '''
      eCampus ist ein zentrales Verwaltungsportal für Studenten. Dort kann nach der Anmedlung das Semesterticket abgerufen 
      werden oder auch der zu zahlende Semesterbeitrag eingesehen werden. Weitere Informationen findne sich unter 
      <a href="https://www.it-services.ruhr-uni-bochum.de/services/ecampus.html.de">
      https://www.it-services.ruhr-uni-bochum.de/services/ecampus.html.de</a>
    ''';

  @override
  String get faqECTS => 'ECTS';

  @override
  String get faqECTSText => '''
      Das „European Credit Transfer System“ (Europäisches System zur Übertragung und Akkumulierung von Studienleistungen), 
      kurz ECTS, bietet die Möglichkeit, die an einer Hochschuleinrichtung erworbenen Leistungspunkte auf ein Studium an 
      einer anderen Hochschuleinrichtung anzurechnen. ECTS-Leistungspunkte entsprechen dem Lernen auf der Grundlage von 
      definierten Lernzielen und dem damit verbundenen Arbeitspensum. Es soll Studierende bei einem Umzug von einem Land 
      in ein anderes behilflich sein und sie dabei unterstützen, ihre akademischen Qualifikationen und Studienzeiten im 
      Ausland anerkennen zu lassen. Mehr Infos findet ihr unter: 
      <a href="https://education.ec.europa.eu/de/europaeisches-system-zur-uebertragung-und-akkumulierung-von-studienleistungen-ects">
      https://education.ec.europa.eu/de/europaeisches-system-zur-uebertragung-und-akkumulierung-von-studienleistungen-ects</a>
    ''';

  @override
  String get faqInclusion => 'Inklusion';

  @override
  String get faqInclusionText => '''
      Unter Inklusion verstehen wir die Teilhabe aller Menschen an der Gesellschaft. Konnotiert ist dieser Begriff 
      insbesondere durch die Berücksichtigung benachteiligter Personengruppen, denen eine soziale Ungleichheit und mangelnde 
      Chancengleichheit infolge einer studienerschwerenden gesundheitlichen Beeinträchtigung vorausgeht. Wir an der RUB sind 
      bestrebt die Chancen und das Recht auf Bildung für alle Menschen gleich zu gestalten. An der RUB gibt es diverse Initiativen, 
      die euch in diesen Belangen mit Rat und Tat zu Seite stehen. Unser „Autonomes Referat für Menschen mit Behinderungen und 
      sämtlichen Beeinträchtigungen“ ist hierzu neben dem „BZI“ des AkaFö, dem Beratungszentrum zur Inklusion Behinderter, eure 
      erste Anlaufstelle. Neu ist das Förderprojekt „Inklusive Hochschule“, das sich dem Ziel verschrieben hat, Studierenden 
      mit Behinderung oder chronischer Erkrankung die gleichberechtigte Teilhabe am Studium zu ermöglichen. Dorthin könnt 
      Ihr Euch auch mit Kritik, Lob und Euren Wünschen zum Thema Inklusion an der RUB wenden (z.B. per Mail an 
      <a href="mailto:inklusion@rub.de">inklusion@rub.de</a>). Auf der Internetseite 
      <a href="https://uni.ruhr-uni-bochum.de/de/inklusion">https://uni.ruhr-uni-bochum.de/de/inklusion</a> sind Informationen 
      zum BZI für euch aufgelistet. Auch die zentrale Studienberatung (ZSB) kann euch eine erste Hilfestellung in diesen 
      Belangen geben.
    ''';

  @override
  String get faqLabInternships => 'Labor-Praktika';

  @override
  String get faqLabInternshipsText => '''
      Das Absolvieren von Labor-Praktika wird vor allem in naturwissenschaftlichen und ingenieurswissenschaftlichen 
      Studiengängen sowie in der Medizin von dir erwartet. Es werden vorbereitende Einführungsveranstaltungen und Sicherheitsbelehrungen 
      angeboten. Außerdem musst du weitere Anforderungen erfüllen. Diese kannst du auf den Webseiten der Lehrstühle erfahren.
    ''';

  @override
  String get faqCompensation => 'Nachteilsausgleich';

  @override
  String get faqCompensationText => '''
        Ein „Nachteilsausgleich“ bezeichnet im sozialrechtlichen Sinne die Ansprüche auf Hilfe und Ausgleich, die einem 
        jeden Studierenden mit Beeinträchtigungen unter bestimmten Voraussetzungen zustehen. Umfasst werden hinsichtlich 
        des Studiums an der RUB dabei Lehr- und Prüfungsbedingungen des jeweiligen Studiengangs. Neben der Verlängerung 
        der Schreibzeit bei Klausuren können insbesondere flexible Pausenregelungen, die Notwendigkeit bestimmter technischer, 
        elektronischer oder sonstiger apparativer Hilfen sowie einer Veränderung der Arbeitsplatzorganisation berücksichtigt 
        werden. Unser „Autonomes Referat für Menschen mit Behinderungen und sämtlichen Beeinträchtigungen“ ist hierzu neben 
        dem „BZI“ des AkaFö, dem Beratungszentrum zur Inklusion Behinderter, eure erste Anlaufstelle. Hier erhaltet ihr 
        Beratungsangebote und eine erste Hilfe und Information zu euren Möglichkeiten an der RUB.
    ''';

  @override
  String get faqOptional => 'Optionalbereich';

  @override
  String get faqOptionalText => '''
      Neben den Lehrveranstaltungen deines spezifischen Bachelor-Studienganges musst du zudem eine gewisse Anzahl von Kursen 
      belegen, in denen der Erwerb von fächerübergreifenden Kenntnissen und Kompetenzen im Vordergrund steht. Diese kannst 
      du weitestgehend nach Interesse aus verschiedenen geistes-, gesellschafts- und naturwissenschaftlichen Bereichen auswählen. 
      Zudem erhältst du Einblicke in Fremdsprachen, Präsentations- und Kommunikationstechniken, Informationstechnologien 
      und interdisziplinäre oder schul- und unterrichtsbezogene Module. 
      <a href="https://rub.de/optionalbereich/">https://rub.de/optionalbereich/</a>
    ''';

  @override
  String get faqExamWork => 'Prüfungsleistungen';

  @override
  String get faqExamWorkText => '''
      Welche Leistungen von dir im Rahmen einer Lehrveranstaltung erbracht werden müssen kannst du dem Modulhandbuch deines 
      Studienfaches, dem Vorlesungsverzeichnis oder eCampus entnehmen. Es gibt sowohl benotete als auch unbenotete 
      Veranstaltungen. Die meisten Prüfungsleistungen bestehen aus Klausuren, Referaten und/oder Hausarbeiten.
    ''';

  @override
  String get faqExamRegulations => 'Prüfungsordnungen';

  @override
  String get faqExamRegulationsText => '''
      In der Prüfungsordnung deines Studienganges sind diejenigen Prüfungsleistungen aufgeführt, die du für deinen Abschluss 
      erbringen musst. Auch ist dort geregelt, ob und wie oft du eine nicht bestandene Prüfung wiederholen bzw. verschieben 
      kannst. Schon allein im Hinblick auf deinen Studienverlauf und deinen Abschluss ist ein Blick in die Prüfungsordnung 
      dringend zu empfehlen!
    ''';

  @override
  String get faqRoomOfSilence => 'Raum der Stille';

  @override
  String get faqRoomOfSilenceText => '''
      Der „Raum der Stille“ soll zu Beginn des Wintersemesters am 11.10. eingeweiht werden und religionsübergreifend spirituellen 
      Bedürfnissen und dem individuellen Gebet Raum geben. Er wird aber auch für Menschen da sein, die aus nicht-religiösen 
      Gründen die Stille suchen, um etwas für ihre Gesundheit und ihr Wohlbefinden zu tun. Die Anerkennung und Förderung 
      religiöser Vielfalt schafft eine Atmosphäre der gegenseitigen Verbundenheit und Wertschätzung. Der Raum befindet sich 
      im Gebäude der Mensa auf der Ebene der Roten Beete.
    ''';

  @override
  String get faqSemesterTicket => 'Semesterticket';

  @override
  String get faqSemesterTicketText => '''
      Der Geltungsbereich des Semestertickets erstreckt sich auf den gesamten VRR-Bereich und mittlerweile auch nach Venlo. 
      Zudem ist das Ticket in ganz NRW gültig. Beachte hierbei, dass es nur ausgedruckt oder per PDF mit einem amtlichen 
      Lichtbildausweis (Perso oder Reisepass) gültig ist. Das Ticket kann über eCampus abgerufen werden.
      Für einen Aufschlag von 12,33 € kannst du dein Semesterticket zu einem Deutschlandticket aufwerten. Beachte, dass
      du bei Nutzung des Deutschlandtickets, den QR-Code des Deutschlandtickets, dein Semesterticket und ein Lichtbildausweis
      mitführen musst. 
      <a href="https://studium.ruhr-uni-bochum.de/de/vom-semesterticket-zum-deutschlandticket">Buchung/Infos</a>
    ''';

  @override
  String get faqSozialbeitrag => 'Sozialbeitrag';

  @override
  String get faqSozialbeitragText => '''
      Der Sozialbeitrag ist ein von jedem Studierenden für jedes Semester erneut zu entrichtender Pflichtbeitrag. 
      Der Betrag beläuft sich im Sommersemester 2023 auf insgesamt 362,62 €. 
      Enthalten sind 120 € für das Akademische Förderungswerk (AKAFÖ), welches z.B. für die Mensa und Wohnheime zuständig 
      ist, 220,02 € (regulär) für das Semesterticket sowie 20,1 € für die Studierendenschaft der RUB (AStA).
      ''';

  @override
  String get faqStudentSecretariat => 'Studierendensekretariat';

  @override
  String get faqStudentSecretariatText => '''
      'Das Studierendensekretariat (Gebäude SSC, Ebene 0, Raum 229) sowie die Infopoints, die über den Campus verteilt 
      sind, sind Anlaufstellen für Studierende zur Information rund um die Organisation des Studiums. Für weitere 
      Informationen und den einzelnen Standorten verweisen wir auf folgende Links: 
      <a href="https://rub.de/campusservice/standorte">Standorte</a> und <a href="https://rub.de/studierendensekretariat">
      Studierendensekretariat</a>
    ''';

  @override
  String get faqTeamspeak => 'Teamspeak';

  @override
  String get faqTeamspeakText => '''
      Der Teamspeak-Server des AStA (TS³) bietet zu Zeiten von Corona eine persönliche Kontaktmöglichkeit des AStA zur 
      Studierendenschaft. Meldet euch hierzu einfach unter "AStARUB" an.
    ''';

  @override
  String get faqUNIC => 'UNIC';

  @override
  String get faqUNICText => '''
      Die Ruhr-Universität Bochum ist Teil des internationalen Universitätskonsortiums UNIC - „European University of 
      Post-Industrial Cities“. Es ist ein Verbund von acht Universitäten, der sich der Förderung von studentischer Mobilität 
      und gesellschaftlicher Integration widmet. Mit der Schaffung einer europäischen Universität soll der Austausch und 
      die Kooperation von Lehre, Forschung und Transfer gesteigert werden. Studierende, Forschende, Lehrende und das Personal 
      aus der Verwaltung sollen von den Möglichkeiten eines europäischen Campus profitieren. Zu UNIC gehören neben der RUB 
      die Universitäten aus Bilbao, Cork, Istanbul, Liège, Oulu, Rotterdam und Zagreb.
    ''';

  @override
  String get faqEvents => 'Veranstaltungen';

  @override
  String get faqEventsText => '''
      Die Veranstaltungen deines Studienganges können sich von denen anderer Studienfächer unterscheiden. Die gängigsten 
      Formen und Bezeichnungen haben wir für euch aufgeführt. Vorlesungen sind dadurch gekennzeichnet, dass ein:e Dozierende:r 
      meistens frontal oder unter Einbeziehung des oft großen Auditoriums den Stoff vermittelt. Arbeitsgemeinschaften, 
      Übungen, Tutorien und Seminare sind in der Regel auf eine geringere Anzahl an Teilnehmer:innen begrenzt. In diesen 
      steht oftmals das Erlernen der wissenschaftlichen Arbeitsweise des Studienganges im Vordergrund. Tutorien zeichnen 
      zudem aus, dass sie von erfahrenen Studierenden geführt werden und den Übergang von der Schule zur Universität 
      erleichtern sollen. Welche Leistungen du erbringen musst, hängt auch hier von deiner Studienordnung ab. Falls du 
      deine Dozierenden "bewerten" möchtest, die Didaktik nicht angemessen findest oder eine Meinung zur Digitalisierung 
      abgeben möchtest, benutze den Melder des AStAs auf der Homepage: 
      <a href="https://asta-bochum.de/melder-fuer-probleme-mit-digitaler-lehre/">
      https://asta-bochum.de/melder-fuer-probleme-mit-digitaler-lehre/</a>
    ''';

  @override
  String get faqAccomodation => 'Wohnungen';

  @override
  String get faqAccomodationText => '''
      Für alle Studierende, die nicht mehr zu Hause wohnen möchten oder denen dieses aufgrund eines studienbedingten 
      Ortswechsels nicht mehr möglich ist, stellt sich zwangsläufig die Frage wo sie eine neue Bleibe finden. Abhilfe 
      können die 21 Wohnheime des Akademischen Förderungswerkes (AKAFÖ) schaffen. Diese sind auf studentisches Wohnen 
      ausgerichtet und in der Nähe der RUB angesiedelt. Es gibt sowohl die Möglichkeit in Apartments oder Einzelzimmern 
      auf einer Gemeinschaftsetage als auch in Wohngemeinschaften zu leben. Zudem gibt es Wohnheime in privater 
      Trägerschaft. Doch auch abseits von Wohnheimen ist der Wohnungsmarkt in Bochum nicht so belastet wie in anderen 
      Universitätsstädten, sodass du in der Umgebung Bochums leicht eine passende Wohnung oder eine WG finden wirst. 
      Auch dabei bietet dir der AStA gerne eine Orientierungshilfe. AStA Wohnen findet sich unter:
      <a href="https://akafoe.de/wohnen">https://akafoe.de/wohnen</a> bzw. 
      <a href="https://asta-bochum.de/wohnungsboerse/">https://asta-bochum.de/wohnungsboerse</a>
    ''';

  @override
  String get faqZoom => 'Zoom';

  @override
  String get faqZoomText => '''
      Zoom stellt eine Möglichkeit dar, virtuell an Veranstaltungen teilzunehmen. Welche Plattformen eure Dozierenden 
      präferieren, erfahrt ihr von eurer Fakultät. Informationen zur Teilnahme und Erstellung einer Zoom Videokonferenz 
      findet ihr unter <a href="https://it-services.ruhr-uni-bochum.de/bk/zoom.html.de">
      https://it-services.ruhr-uni-bochum.de/bk/zoom.html.de</a>
    ''';

  @override
  String get faqEmergencyNumber => 'Zentrale Notrufnummer RUB';

  @override
  String get faqEmergencyNumberText => '''
      Die Ruhr-Universität verfügt über eine Leitwarte, die 24 Stunden besetzt und über die Nummer durchgehend erreichbar 
      ist. Bei Notfällen alarmiert sie Feuerwehr, Notarzt oder Polizei und zuständige Stellen innerhalb der Universität. 
      Speichert euch die Notruf-Nummer am besten in euer Handy ein: <a href="tel:+492343223333">0234 3223333</a>
    ''';

  @override
  String get balanceMultipleTags => 'Multiple NFC-Tags found! Try again.';

  @override
  String get balanceIOSScanCard => 'Scan your card.';

  @override
  String get balanceMensaBalance => 'Mensa Balance';

  @override
  String get balanceBalance => 'Balance: ';

  @override
  String get balanceLastTransaction => 'Last Transaction: ';

  @override
  String get balanceScanCard => 'Scan Card';

  @override
  String get balanceScanCardDetailed => 'Hold your student ID to your phone to scan it.';

  @override
  String get balanceNFCOff => 'NFC deactivated';

  @override
  String get balanceNFCOffDetailed => 'Your NFC needs to be activated to read your AKAFÖ balance.';

  @override
  String get balanceLastBalance => 'Last Balance: ';

  @override
  String get balanceLastScanned => 'Last scanned Transaction: ';

  @override
  String get ticketLoginLoginID => 'RUB LoginID';

  @override
  String get ticketLoginPasswort => 'RUB Password';

  @override
  String get ticketLoginLogin => 'Login';

  @override
  String get ticketLoginBothFieldsError => 'Please fill in both fields!';

  @override
  String get ticketLoginInternetError => 'Check your internet connection!';

  @override
  String get ticketLoginWrongDataError => 'Wrong LoginID or Password!';

  @override
  String get ticketLoginLoadingError => 'Error while loading the ticket!';

  @override
  String get ticketLoginEncryptedInfo =>
      'Your data is encrypted and saved locally. It is only sent to the RUB servers when logging in.';

  @override
  String get walletPageWallet => 'Wallet';

  @override
  String get walletPageBalance => 'Dining Hall Balance';

  @override
  String get walletPageCampusABC => 'Campus ABC';

  @override
  String get walletPageComingInFuture => 'This area will be expanded in future versions to integrate useful guides.';
}
