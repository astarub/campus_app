import 'l10n.dart';

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([super.locale = 'de']);

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
  String get feed => 'Feed';

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
  String get calendarPageNoEventsUpcomingText => 'Es sind gerade keine Events geplant. Schau am besten später nochmal vorbei.';

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
  String get firebaseDecisionPopup => 'Um dir Benachrichtigungen über spontane Events und Termine rund um die Uni schicken zu können,\nverwenden wir derzeit Firebase, einen Service von Google.\nSolltest du dies nicht wollen, respektieren wir das.\nIm Januar werden wir dafür eine Google-freie Alternative einführen.';

  @override
  String get firebaseDecisionPopupSlim => 'Um dir Benachrichtigungen über spontane Events und Termine rund um die Uni\nschicken zu können, verwenden wir derzeit Firebase, einen Service von Google.\nSolltest du dies nicht wollen, respektieren wir das.\nIm Januar werden wir dafür eine Google-freie Alternative einführen.';

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
  String get onboardingStudyProgramDetailed => 'Wähle deinen aktuellen Studiengang, um für dich passende Events und News anzuzeigen.';

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

  @override
  String get mensaPageTitle => 'Mensa';

  @override
  String get mensaPagePreferences => 'Präferenzen';

  @override
  String get mensaPageAllergens => 'Allergene';

  @override
  String get imprintPageLegalNotice => 'Impressum';

  @override
  String get imprintPageLegalNoticeText => '<h4>Inhaltlich Verantwortliche gemäß § 10 Absatz 3 MDStV:</h4>\nStudierendenschaft der Ruhr-Universität Bochum<br>\nAllgemeiner Studierendenausschuss<br>\nSH 0/11<br>\nUniversitätsstr. 150<br>\n44780 Bochum<br>\n<br>\nInhaltlich Verantwortlich:<br>\nHanife Demir (Vorsitzende)<br>\n<br>\nVertretungsberechtigter Vorstand:<br>\nRon Agethen<br>\nEren Yavuz<br>\nElisabeth Tilbürger<br>\nHenry Herrmann<br>\nAli Sait Kücük<br>\n<br>\nTelefon: <a href=\"tel:+492343222416\">+49 234 3222416</a><br>\nE-Mail: <a href=\"mailto:info@asta-bochum.de\">info@asta-bochum.de</a><br>\nInternet: <a href=\"https://www.asta-bochum.de\">https://www.asta-bochum.de</a><br>\n<br>\nDie Studierendenschaft ist eine Teilkörperschaft öffentlichen Rechts.\n<br>\n<h4>Inhalte</h4><br>\nDie Inhalte unserer Seiten wurden mit größter Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte können wir jedoch keine Gewähr übernehmen. \nAls Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. \nNach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. \nVerpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt.<br>Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. \nBei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.\n<h4>Haftungshinweis</h4>\nUnser Angebot enthält Links zu externen Webseiten Dritter, auf deren Inhalte wir keinen Einfluss haben. \nDeshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. \nFür die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. \nDie verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. \nRechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. \nEine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. \nBei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.';

  @override
  String get morePageTitle => 'Einstellungen & Mehr';

  @override
  String get morePageAstaA => 'AStA';

  @override
  String get morePageKulturCafe => 'KulturCafé';

  @override
  String get morePageBikeWorkshop => 'Fahrradwerkstatt';

  @override
  String get morePageRepairCafe => 'Repair Café';

  @override
  String get morePageSocialCounseling => 'Sozialberatung';

  @override
  String get morePageDancingGroup => 'Tanzkreis';

  @override
  String get morePageGamingHub => 'Gaming Hub';

  @override
  String get morePageUsefulLinks => 'Nützliche Links';

  @override
  String get morePageRubMail => 'RubMail';

  @override
  String get morePageMoodle => 'Moodle';

  @override
  String get morePageECampus => 'eCampus';

  @override
  String get morePageFlexNow => 'FlexNow';

  @override
  String get morePageUniSports => 'Hochschulsport';

  @override
  String get morePageOther => 'Sonstiges';

  @override
  String get morePageSettings => 'Einstellungen';

  @override
  String get morePagePrivacy => 'Datenschutz';

  @override
  String get morePageLegalNotice => 'Impressum';

  @override
  String get morePageUsedResources => 'Verwendete Ressourcen';

  @override
  String get morePageFeedback => 'Feedback';

  @override
  String get privacyPolicyPrivacy => 'Datenschutz';

  @override
  String get privacyPolicyText => '<h2>Verantwortliche Stelle im Sinne der Datenschutzgesetze, insbesondere der EU-Datenschutzgrundverordnung (DSGVO), ist:</h2><br>\n<br>\nAStA an der Ruhr-Universität Bochum<br>\nPaul Hoffstiepel (Vorsitzender)<br>\n<br>\nStudierendenhaus 0/11<br>\nUniversitätsstr. 150<br>\n44801 Bochum<br>\n<br>\nTelefon: <a href=\"tel:+492343222416\">+49 234 3222416</a><br>\nE-Mail: <a href=\"mailto:info@asta-bochum.de\">info@asta-bochum.de</a><br>\n<br>\nSie können Sie sich jederzeit mit einer Beschwerde an die zuständige Aufsichtsbehörde wenden. Diese ist:\n<br>\nLandesbeauftragte für Datenschutz und Informationsfreiheit Nordrhein-Westfalen<br>\nPostfach 20 04 44<br>\n40102 Düsseldorf<br>\nTel.: <a href=\"tel:+49211384240\">+49 211 384240</a><br>\nFax: +49 211 3842410<br>\nE-Mail: <a href=\"mailto:poststelle@ldi.nrw.de\">poststelle@ldi.nrw.de</a><br>\nInternet: <a href=\"https://ldi.nrw.de\">poststelle@ldi.nrw.de</a>https://ldi.nrw.de<br>\n<br>\n<h2>Datenverarbeitung durch die Nutzung der Campus App</h2><br>\nBei der Nutzung der Campus App werden Daten erhoben und ausgetauscht, die zur Verwendung des Angebotes erforderlich sind. Dies sind:<br>\n- IP-Adresse<br>\n- Verwendetes Betriebssystem<br>\n- Uhrzeit der Serveranfrage<br>\n- Übertragene Datenmenge<br>\n- Standortdaten<br>\n<br>\nDiese Daten werden bei der Nutzung der Campus App ebenfalls in Log-Dateien über den Zeitpunkt des Besuches hinaus auf einem Server, welcher durch den AStA betrieben wird und ggf. auf einem Server einer besuchten Seite gespeichert.<br>\nUnsere App stellt Neuigkeiten verschiedener Internetseiten bereit, die nicht von der verfassten Studierendenschaft der Ruhr-Universität Bochum betrieben werden. \nEin Einfluss auf die Verarbeitung der dort erhobenen Daten besteht nicht. \nDie oben genannten Nutzungsdaten werden dabei an folgende Anbieter übermittelt: <br>\n- ruhr-uni-bochum.de, Universitätsstraße 150, 44801 Bochum. Datenschutzerklärung: <a href=\"https://www.ruhr-uni-bochum.de/de/datenschutz\">https://www.ruhr-uni-bochum.de/de/datenschutz</a><br>\n<br>\nBei der Installation der App werden Benutzer:innen danach gefragt, ob sie Push Notifications zu bestimmten Themen bekommen möchten. \nWenn Nutzer:innen in den Bezug von Push Notifications Einwilligen werden personenbezogene Daten wie z.B. IP Adresse und die gewählten Themen an Server der Firma Google Inc. übertragen. \nDie Daten werden die Daten ohne angemessenes Schutzniveau im Sinne von Art 46 DSGVO an Server von Google in die USA übertragen. \nSiehe dazu auch „Schrems II-Urteil“  (Az.: C-311/18 vom 16.07.2020) des EuGH. \nEs besteht das Risiko, dass US-Sicherheitsbehörden auf die Daten zugreifen ohne dass Betroffene darüber Informiert werden und ohne dass Rechtsbehelfe eingelegt werden können. \nDie Übermittlung erfolgt daher nur auf der ausdrücklichen Einwilligung nach Art. 49 Abs 1 a der DSGVO.\n<br>\nDie Einwilligung kann jederzeit in der Campus App unter dem Menupunkt „Mehr“, im Untermenü „Einstellungen“ widerrufen werden.<br>\n<br>\nWeitere Informationen in den Datenschutzhinweisen zu Firebase von Google: <a href=\"https://firebase.google.com/support/privacy\"https://firebase.google.com/support/privacy</a><br>\n„Schrems II“ – Urteil des EuGH: <a href=\"https://curia.europa.eu/juris/liste.jsf?language=de&num=C-311/18\">https://curia.europa.eu/juris/liste.jsf?language=de&num=C-311/18</a><br>\n<br>\nDie Campus App enthält Links zu Webseiten anderer Anbieter.<br>\nWir haben keinen Einfluss darauf, dass diese Anbieter die Datenschutzbestimmungen einhalten.<br> \nEine permanente Überprüfung der Links ist ohne konkrete Hinweise auf Rechtsverstöße nicht zumutbar.<br> \nBei Bekanntwerden von Rechtsverstößen werden betroffene Links unverzüglich gelöscht.<br>\n<br>\nBei der Nutzung des Raumfinders der Campus App, werden die aktuellen Standortdaten des Endgerätes verabeitet und bis zum Schließen der App zwischengespeichert.<br> \nEine Einwilligung wird hierfür vom Betriebssystem eingeholt und kann jederzeit durch den Nutzer widerrufen werden.<br>\n<br>\nBei der Nutzung der Funktion zum Anzeigen des Semestertickets werden die RUB Logindaten (LoginID, Passwort) lokal auf dem Gerät gespeichert, dies ist zum Abrufen des Tickets unabdingbar. Eine Übermittlung der Daten erfolgt nur an den offizielen SSO Provider der RUB.\n<br>\n<h2>Zweck der Datenverarbeitung</h2><br>\nDie Verarbeitung der personenbezogenen Daten der Nutzer ist für den ordnungsgemäßen Betrieb der App erforderlich.<br> \nDabei ist es unerlässlich, dass beispielsweise beim Abrufen der Speisepläne durch einen Server des AStAs personenbezogene Daten erhoben werden.<br>\nDes Weiteren werden beim Laden der Artikel im Newsfeed, Daten an die oben genannten Seiten übermittelt.<br>\n<br>\n<h2>Löschung bzw. Sperrung der Daten</h2><br>\nNach den Grundsätzen der Datenvermeidung und der Datensparsamkeit speichern wir alle Daten, die wir für die in dieser Datenschutzerklärung genannten bzw. anderen rechtlich vorgeschriebenen Gründe erhoben haben nur so lange, wie dies für den jeweiligen Zweck notwendig ist. Nach Wegfall des Zweckes bzw. nach Ablauf der Fristen werden die Daten entsprechend der gesetzlichen Vorgaben gelöscht, vernichtet oder gesperrt.<br>\n<br>\nGesetzliche Grundlagen für die Aufbewahrungsfristen werden in der Abgabenordnung §§ 147 und 257 geregelt.<br>\n<br>\n<h2>Rechtsgrundlagen (nach Art. 13 DSGVO)</h2><br>\nWir speichern Ihre Daten nur lange, wie es notwendig ist. Wir verarbeiten Ihre Daten auf den folgenden Rechtsgrundlagen:<br>\n<br>\nArtikel 6 Absatz 1 und Artikel 7 DSGVO für die Erfüllung von Leistungen und rechtlicher Verpflichtungen.<br>\nArtikel 28 DSGVO für die Verarbeitung von personenbezogen Daten im Auftrag.<br>\nNach Ablauf der Fristen werden Ihre Daten routinemäßig gelöscht.<br>\n<br>\n<h2>Ihre Rechte</h2><br>\nDie Datenschutzgrundverordnung räumt Ihnen folgende Rechte ein:<br>\n<br>\nVerlangen einer Bestätigung über die Verarbeitung Sie betreffender personenbezogener Daten (Art. 15)<br>\nVerlangen einer Kopie der Daten (Art. 15)<br>\nRecht auf Korrektur unrichtiger Sie betreffender personenbezogener Daten (Art. 16)<br>\nRecht auf Vervollständigung unvollständiger, Sie betreffender personenbezogener Daten (Art. 16)<br>\nRecht auf Löschung Sie betreffender personenbezogener Daten („Recht auf Vergessenwerden“ Art. 17)<br>\nRecht auf Einschränkung Sie betreffender personenbezogener Daten (Art. 18)<br>\nRecht auf die Übertragung der Daten an einen Dritten (Art. 20)<br>\nBeschwerde bei der oben genannten Aufsichtsbehörde (Art. 77)<br>\nErteilte Einwilligungen können Sie mit Wirkung für die Zukunft widerrufen (Art. 7 Abs. 3)<br>\nRecht auf Widerspruch der Verarbeitung Sie betreffender personenbezogener Daten (Art. 21)<br>\nSollten Sie Fragen zu einzelnen Punkten haben oder eines Ihrer Rechte ausüben wollen, wenden Sie sich an die oben angegebene verantwortliche Stelle oder an unseren Datenschutzbeauftragten unter datenschutz@asta-bochum.de.<br>\n<br>';

  @override
  String get settingsSettings => 'Einstellungen';

  @override
  String get settingsHeadlineTheming => 'Theming';

  @override
  String get settingsSystemDarkmode => 'System Darkmode';

  @override
  String get settingsDarkmode => 'Darkmode';

  @override
  String get settingsHeadlineCoreData => 'Stammdaten';

  @override
  String get settingsStudyProgram => 'Studiengang';

  @override
  String get settingsStudyProgramChange => 'Ändern';

  @override
  String get settingsHeadlineBehaviour => 'Verhalten';

  @override
  String get settingsUseExternalBrowser => 'Verwende externen Browser für Links';

  @override
  String get settingsTextSize => 'Verwende Textgröße des Systems';

  @override
  String get settingsTicketFullscreen => 'Vollbildschirmmodus QR-Code Semesterticket';

  @override
  String get settingsHeadlinePrivacy => 'Datenschutz';

  @override
  String get settingsGoogleServices => 'Google Services für Benachrichtigungen';

  @override
  String get settingsHeadlinePushNotifications => 'Push-Benachrichtigungen';

  @override
  String get settingsPushNotificationsEvents => 'Benachrichtigungen für gespeicherte Events';

  @override
  String get controlRoomButton => 'Leitwarte der RUB';

  @override
  String get controlRoomButtonDescription => ' 24/7 besetzt, für jegliche Notfälle';

  @override
  String get walletAddStudentTicket => 'Füge dein Semesterticket hinzu';

  @override
  String get faqCampusABC => 'Campus ABC';

  @override
  String get faqMandatoryAttendance => 'Anwesenheitspflicht';

  @override
  String get faqMandatoryAttendanceText => 'Unabhängig von digitalen Semestern, was historisch betrachtet eine Ausnahmefallregelung an der RUB darstellt, \ngilt in einigen Ausnahmefällen und bestimmten Kursformaten eine Anwesenheitspflicht. Die Anwesenheitspflicht, \ndie früher bestand, ist mit Inkrafttreten des Hochschulzukunftsgesetzes NRW zum Oktober 2014 abgeschafft worden. \nDanach ist es grundsätzlich verboten die Erbringung und Eintragung einer Leistung von der Anwesenheit in einer \nLehrveranstaltung abhängig zu machen. Davon ausgenommen sind jedoch vor allem Exkursionen, Sprachkurse, Praktika, \npraktische Übungen und vergleichbare Lehrveranstaltungen. Sollte in einer deiner Veranstaltungen trotz des Verbotes \neine Anwesenheitspflicht verlangt werden, kannst du dich hier melden: \n<a href=\"https://asta-bochum.de/anwesenheitspflicht\">https://asta-bochum.de/anwesenheitspflicht</a>';

  @override
  String get faqAStAMessenger => 'AStA-Messenger';

  @override
  String get faqAStAMessengerText => 'Ab sofort sind wir unter der Mobilfunknummer <a href=\"https://wa.me/4915222614240\">+49 152 22614240</a>  für \nallgemeine Fragen bei Whatsapp erreichbar.';

  @override
  String get faqAccessibility => 'Barrierefreiheit';

  @override
  String get faqAccessibilityText => 'Barrierefreiheit bedeutet die Umwelt und Infrastruktur in dem Sinne zu gestalten, dass sie auch von Menschen mit \nBeeinträchtigungen ohne zusätzliche Hilfe in Anspruch genommen werden kann. Das Studium für Menschen mit \nBeeinträchtigungen ist in vielerlei Hinsicht erschwert. Die RUB besitzt jedoch Initiativen den Studienalltag so \nweit wie möglich zu vereinfachen und jeder bzw. jedem Studierenden zugänglich zu machen. Unserer „Autonomes \nReferat für Menschen mit Behinderungen und sämtlichen Beeinträchtigungen“ und das BZI des AkaFö sind dabei eure \nerste Anlaufstelle für einen Einblick in die Angebote. So bietet die Universitätsbibliothek (UB) z.B. einen \nService zur Literaturbeschaffung an, um Barrierefreiheit zu ermöglichen. Auf der Internetseite \n<a href=\"https://uni.ruhr-uni-bochum.de/de/inklusion\">https://uni.ruhr-uni-bochum.de/de/inklusion</a> \nsind weitergehende Informationen für euch aufgelistet.';

  @override
  String get faqLibraries => 'Bibliotheken';

  @override
  String get faqLibrariesText => 'Das Bibliothekssystem der RUB setzt sich aus der Universitätsbibliothek (UB), dem zentralen Gebäude des Campus \nund den in den Gebäuden verteilten Fachbibliotheken zusammen. Diese bieten dir einen Raum zum Lernen und \nRecherchieren für Hausarbeiten und Referate oder zum Lernen für Klausuren. Für jede einzelne Bibliothek bestehen \ngesonderte Regeln, was eine mögliche Ausleihe und die Öffnungszeiten betrifft. Die UB ist in den Zeiten von MO-FR: \n8.00 bis 23.00 Uhr und SA-SO: von 10.00 bis 19.00 Uhr geöffnet. Die UB stellt eine große Zahl an Arbeitsplätzen mit \nund ohne PC bereit. Für die Benutzung der Schließfächer ist eine 2€-Münze erforderlich! Erfahrt alle auf Corona \nbezogenen und alle aktualisierten Informationen auf der Internetseite der UB. Im Servicereferat des AStA kannst du \nauch kostenfrei einen AStA-Chip erhalten, der in die UB-Schließfächer passt. Eine Auflistung aller Fachbibliotheken \nund weitere Informationen: <a href=\"https://www.ub.rub.de\">https://www.ub.rub.de</a>';

  @override
  String get faqCreditPoints => 'Credit Points';

  @override
  String get faqCreditPointsText => 'Credit Points (CP) werden für jede erbrachte Prüfungsleistung vergeben. Du brauchst eine gewisse Anzahl von CP, \num Module abzuschließen und dich letztlich für deine Abschlussprüfungen anzumelden. Dabei soll 1 CP einem \nArbeitsaufwand von 30 Semesterwochenstunden entsprechen. Dieser umfasst die Vor- und Nachbereitung sowie die \nWochenstunden der Veranstaltung. Wie viele CP für eine Lehrveranstaltung vergeben werden kannst du deiner \nPrüfungsordnung entnehmen.';

  @override
  String get faqeECampus => 'eCampus';

  @override
  String get faqeECampusText => 'eCampus ist ein zentrales Verwaltungsportal für Studenten. Dort kann nach der Anmedlung das Semesterticket abgerufen \nwerden oder auch der zu zahlende Semesterbeitrag eingesehen werden. Weitere Informationen findne sich unter \n<a href=\"https://www.it-services.ruhr-uni-bochum.de/services/ecampus.html.de\">\nhttps://www.it-services.ruhr-uni-bochum.de/services/ecampus.html.de</a>';

  @override
  String get faqECTS => 'ECTS';

  @override
  String get faqECTSText => 'Das „European Credit Transfer System“ (Europäisches System zur Übertragung und Akkumulierung von Studienleistungen), \nkurz ECTS, bietet die Möglichkeit, die an einer Hochschuleinrichtung erworbenen Leistungspunkte auf ein Studium an \neiner anderen Hochschuleinrichtung anzurechnen. ECTS-Leistungspunkte entsprechen dem Lernen auf der Grundlage von \ndefinierten Lernzielen und dem damit verbundenen Arbeitspensum. Es soll Studierende bei einem Umzug von einem Land \nin ein anderes behilflich sein und sie dabei unterstützen, ihre akademischen Qualifikationen und Studienzeiten im \nAusland anerkennen zu lassen. Mehr Infos findet ihr unter: \n<a href=\"https://education.ec.europa.eu/de/europaeisches-system-zur-uebertragung-und-akkumulierung-von-studienleistungen-ects\">\nhttps://education.ec.europa.eu/de/europaeisches-system-zur-uebertragung-und-akkumulierung-von-studienleistungen-ects</a>';

  @override
  String get faqInclusion => 'Inklusion';

  @override
  String get faqInclusionText => 'Unter Inklusion verstehen wir die Teilhabe aller Menschen an der Gesellschaft. Konnotiert ist dieser Begriff \ninsbesondere durch die Berücksichtigung benachteiligter Personengruppen, denen eine soziale Ungleichheit und mangelnde \nChancengleichheit infolge einer studienerschwerenden gesundheitlichen Beeinträchtigung vorausgeht. Wir an der RUB sind \nbestrebt die Chancen und das Recht auf Bildung für alle Menschen gleich zu gestalten. An der RUB gibt es diverse Initiativen, \ndie euch in diesen Belangen mit Rat und Tat zu Seite stehen. Unser „Autonomes Referat für Menschen mit Behinderungen und \nsämtlichen Beeinträchtigungen“ ist hierzu neben dem „BZI“ des AkaFö, dem Beratungszentrum zur Inklusion Behinderter, eure \nerste Anlaufstelle. Neu ist das Förderprojekt „Inklusive Hochschule“, das sich dem Ziel verschrieben hat, Studierenden \nmit Behinderung oder chronischer Erkrankung die gleichberechtigte Teilhabe am Studium zu ermöglichen. Dorthin könnt \nIhr Euch auch mit Kritik, Lob und Euren Wünschen zum Thema Inklusion an der RUB wenden (z.B. per Mail an \n<a href=\"mailto:inklusion@rub.de\">inklusion@rub.de</a>). Auf der Internetseite \n<a href=\"https://uni.ruhr-uni-bochum.de/de/inklusion\">https://uni.ruhr-uni-bochum.de/de/inklusion</a> sind Informationen \nzum BZI für euch aufgelistet. Auch die zentrale Studienberatung (ZSB) kann euch eine erste Hilfestellung in diesen \nBelangen geben.';

  @override
  String get faqLabInternships => 'Labor-Praktika';

  @override
  String get faqLabInternshipsText => 'Das Absolvieren von Labor-Praktika wird vor allem in naturwissenschaftlichen und ingenieurswissenschaftlichen \nStudiengängen sowie in der Medizin von dir erwartet. Es werden vorbereitende Einführungsveranstaltungen und Sicherheitsbelehrungen \nangeboten. Außerdem musst du weitere Anforderungen erfüllen. Diese kannst du auf den Webseiten der Lehrstühle erfahren.';

  @override
  String get faqCompensation => 'Nachteilsausgleich';

  @override
  String get faqCompensationText => 'Ein „Nachteilsausgleich“ bezeichnet im sozialrechtlichen Sinne die Ansprüche auf Hilfe und Ausgleich, die einem \njeden Studierenden mit Beeinträchtigungen unter bestimmten Voraussetzungen zustehen. Umfasst werden hinsichtlich \ndes Studiums an der RUB dabei Lehr- und Prüfungsbedingungen des jeweiligen Studiengangs. Neben der Verlängerung \nder Schreibzeit bei Klausuren können insbesondere flexible Pausenregelungen, die Notwendigkeit bestimmter technischer, \nelektronischer oder sonstiger apparativer Hilfen sowie einer Veränderung der Arbeitsplatzorganisation berücksichtigt \nwerden. Unser „Autonomes Referat für Menschen mit Behinderungen und sämtlichen Beeinträchtigungen“ ist hierzu neben \ndem „BZI“ des AkaFö, dem Beratungszentrum zur Inklusion Behinderter, eure erste Anlaufstelle. Hier erhaltet ihr \nBeratungsangebote und eine erste Hilfe und Information zu euren Möglichkeiten an der RUB.';

  @override
  String get faqOptional => 'Optionalbereich';

  @override
  String get faqOptionalText => 'Neben den Lehrveranstaltungen deines spezifischen Bachelor-Studienganges musst du zudem eine gewisse Anzahl von Kursen \nbelegen, in denen der Erwerb von fächerübergreifenden Kenntnissen und Kompetenzen im Vordergrund steht. Diese kannst \ndu weitestgehend nach Interesse aus verschiedenen geistes-, gesellschafts- und naturwissenschaftlichen Bereichen auswählen. \nZudem erhältst du Einblicke in Fremdsprachen, Präsentations- und Kommunikationstechniken, Informationstechnologien \nund interdisziplinäre oder schul- und unterrichtsbezogene Module. \n<a href=\"https://rub.de/optionalbereich/\">https://rub.de/optionalbereich/</a>';

  @override
  String get faqExamWork => 'Prüfungsleistungen';

  @override
  String get faqExamWorkText => 'Welche Leistungen von dir im Rahmen einer Lehrveranstaltung erbracht werden müssen kannst du dem Modulhandbuch deines \nStudienfaches, dem Vorlesungsverzeichnis oder eCampus entnehmen. Es gibt sowohl benotete als auch unbenotete \nVeranstaltungen. Die meisten Prüfungsleistungen bestehen aus Klausuren, Referaten und/oder Hausarbeiten.';

  @override
  String get faqExamRegulations => 'Prüfungsordnungen';

  @override
  String get faqExamRegulationsText => 'In der Prüfungsordnung deines Studienganges sind diejenigen Prüfungsleistungen aufgeführt, die du für deinen Abschluss \nerbringen musst. Auch ist dort geregelt, ob und wie oft du eine nicht bestandene Prüfung wiederholen bzw. verschieben \nkannst. Schon allein im Hinblick auf deinen Studienverlauf und deinen Abschluss ist ein Blick in die Prüfungsordnung \ndringend zu empfehlen!';

  @override
  String get faqRoomOfSilence => 'Raum der Stille';

  @override
  String get faqRoomOfSilenceText => 'Der „Raum der Stille“ soll zu Beginn des Wintersemesters am 11.10. eingeweiht werden und religionsübergreifend spirituellen \nBedürfnissen und dem individuellen Gebet Raum geben. Er wird aber auch für Menschen da sein, die aus nicht-religiösen \nGründen die Stille suchen, um etwas für ihre Gesundheit und ihr Wohlbefinden zu tun. Die Anerkennung und Förderung \nreligiöser Vielfalt schafft eine Atmosphäre der gegenseitigen Verbundenheit und Wertschätzung. Der Raum befindet sich \nim Gebäude der Mensa auf der Ebene der Roten Beete.';

  @override
  String get faqSemesterTicket => 'Semesterticket';

  @override
  String get faqSemesterTicketText => 'Der Geltungsbereich des Semestertickets erstreckt sich auf den gesamten VRR-Bereich und mittlerweile auch nach Venlo. \nZudem ist das Ticket in ganz NRW gültig. Beachte hierbei, dass es nur ausgedruckt oder per PDF mit einem amtlichen \nLichtbildausweis (Perso oder Reisepass) gültig ist. Das Ticket kann über eCampus abgerufen werden.\nFür einen Aufschlag von 12,33 € kannst du dein Semesterticket zu einem Deutschlandticket aufwerten. Beachte, dass\ndu bei Nutzung des Deutschlandtickets, den QR-Code des Deutschlandtickets, dein Semesterticket und ein Lichtbildausweis\nmitführen musst. \n<a href=\"https://studium.ruhr-uni-bochum.de/de/vom-semesterticket-zum-deutschlandticket\">Buchung/Infos</a>';

  @override
  String get faqSozialbeitrag => 'Sozialbeitrag';

  @override
  String get faqSozialbeitragText => 'Der Sozialbeitrag ist ein von jedem Studierenden für jedes Semester erneut zu entrichtender Pflichtbeitrag. \nDer Betrag beläuft sich im Sommersemester 2023 auf insgesamt 362,62 €. \nEnthalten sind 120 € für das Akademische Förderungswerk (AKAFÖ), welches z.B. für die Mensa und Wohnheime zuständig \nist, 220,02 € (regulär) für das Semesterticket sowie 20,1 € für die Studierendenschaft der RUB (AStA).';

  @override
  String get faqStudentSecretariat => 'Studierendensekretariat';

  @override
  String get faqStudentSecretariatText => 'Das Studierendensekretariat (Gebäude SSC, Ebene 0, Raum 229) sowie die Infopoints, die über den Campus verteilt \nsind, sind Anlaufstellen für Studierende zur Information rund um die Organisation des Studiums. Für weitere \nInformationen und den einzelnen Standorten verweisen wir auf folgende Links: \n<a href=\"https://rub.de/campusservice/standorte\">Standorte</a> und <a href=\"https://rub.de/studierendensekretariat\">\nStudierendensekretariat</a>';

  @override
  String get faqTeamspeak => 'Teamspeak';

  @override
  String get faqTeamspeakText => 'Der Teamspeak-Server des AStA (TS³) bietet zu Zeiten von Corona eine persönliche Kontaktmöglichkeit des AStA zur \nStudierendenschaft. Meldet euch hierzu einfach unter \"AStARUB\" an.';

  @override
  String get faqUNIC => 'UNIC';

  @override
  String get faqUNICText => 'Die Ruhr-Universität Bochum ist Teil des internationalen Universitätskonsortiums UNIC - „European University of \nPost-Industrial Cities“. Es ist ein Verbund von acht Universitäten, der sich der Förderung von studentischer Mobilität \nund gesellschaftlicher Integration widmet. Mit der Schaffung einer europäischen Universität soll der Austausch und \ndie Kooperation von Lehre, Forschung und Transfer gesteigert werden. Studierende, Forschende, Lehrende und das Personal \naus der Verwaltung sollen von den Möglichkeiten eines europäischen Campus profitieren. Zu UNIC gehören neben der RUB \ndie Universitäten aus Bilbao, Cork, Istanbul, Liège, Oulu, Rotterdam und Zagreb.';

  @override
  String get faqEvents => 'Veranstaltungen';

  @override
  String get faqEventsText => 'Die Veranstaltungen deines Studienganges können sich von denen anderer Studienfächer unterscheiden. Die gängigsten \nFormen und Bezeichnungen haben wir für euch aufgeführt. Vorlesungen sind dadurch gekennzeichnet, dass ein:e Dozierende:r \nmeistens frontal oder unter Einbeziehung des oft großen Auditoriums den Stoff vermittelt. Arbeitsgemeinschaften, \nÜbungen, Tutorien und Seminare sind in der Regel auf eine geringere Anzahl an Teilnehmer:innen begrenzt. In diesen \nsteht oftmals das Erlernen der wissenschaftlichen Arbeitsweise des Studienganges im Vordergrund. Tutorien zeichnen \nzudem aus, dass sie von erfahrenen Studierenden geführt werden und den Übergang von der Schule zur Universität \nerleichtern sollen. Welche Leistungen du erbringen musst, hängt auch hier von deiner Studienordnung ab. Falls du \ndeine Dozierenden \"bewerten\" möchtest, die Didaktik nicht angemessen findest oder eine Meinung zur Digitalisierung \nabgeben möchtest, benutze den Melder des AStAs auf der Homepage: \n<a href=\"https://asta-bochum.de/melder-fuer-probleme-mit-digitaler-lehre\">\nhttps://asta-bochum.de/melder-fuer-probleme-mit-digitaler-lehre/</a>';

  @override
  String get faqAccomodation => 'Wohnungen';

  @override
  String get faqAccomodationText => 'Für alle Studierende, die nicht mehr zu Hause wohnen möchten oder denen dieses aufgrund eines studienbedingten \nOrtswechsels nicht mehr möglich ist, stellt sich zwangsläufig die Frage wo sie eine neue Bleibe finden. Abhilfe \nkönnen die 21 Wohnheime des Akademischen Förderungswerkes (AKAFÖ) schaffen. Diese sind auf studentisches Wohnen \nausgerichtet und in der Nähe der RUB angesiedelt. Es gibt sowohl die Möglichkeit in Apartments oder Einzelzimmern \nauf einer Gemeinschaftsetage als auch in Wohngemeinschaften zu leben. Zudem gibt es Wohnheime in privater \nTrägerschaft. Doch auch abseits von Wohnheimen ist der Wohnungsmarkt in Bochum nicht so belastet wie in anderen \nUniversitätsstädten, sodass du in der Umgebung Bochums leicht eine passende Wohnung oder eine WG finden wirst. \nAuch dabei bietet dir der AStA gerne eine Orientierungshilfe. AStA Wohnen findet sich unter:\n<a href=\"https://akafoe.de/wohnen\">https://akafoe.de/wohnen</a> bzw. \n<a href=\"https://asta-bochum.de/wohnungsboerse/\">https://asta-bochum.de/wohnungsboerse</a>';

  @override
  String get faqZoom => 'Zoom';

  @override
  String get faqZoomText => 'Zoom stellt eine Möglichkeit dar, virtuell an Veranstaltungen teilzunehmen. Welche Plattformen eure Dozierenden \npräferieren, erfahrt ihr von eurer Fakultät. Informationen zur Teilnahme und Erstellung einer Zoom Videokonferenz \nfindet ihr unter <a href=\"https://it-services.ruhr-uni-bochum.de/bk/zoom.html.de\">\nhttps://it-services.ruhr-uni-bochum.de/bk/zoom.html.de</a>';

  @override
  String get faqEmergencyNumber => 'Zentrale Notrufnummer RUB';

  @override
  String get faqEmergencyNumberText => 'Die Ruhr-Universität verfügt über eine Leitwarte, die 24 Stunden besetzt und über die Nummer durchgehend erreichbar \nist. Bei Notfällen alarmiert sie Feuerwehr, Notarzt oder Polizei und zuständige Stellen innerhalb der Universität. \nSpeichert euch die Notruf-Nummer am besten in euer Handy ein: <a href=\"tel:+492343223333\">0234 3223333</a>';

  @override
  String get balanceMultipleTags => 'Mehrere NFC-Tags gefunden! Versuche es noch einmal.';

  @override
  String get balanceIOSScanCard => 'Scanne deine Karte.';

  @override
  String get balanceMensaBalance => 'Mensa Guthaben';

  @override
  String get balanceBalance => 'Guthaben: ';

  @override
  String get balanceLastTransaction => 'Letzte Abbuchung: ';

  @override
  String get balanceScanCard => 'Karte scannen';

  @override
  String get balanceScanCardDetailed => 'Halte deinen Studierendenausweis an dein Smartphone, um ihn zu scannen.';

  @override
  String get balanceNFCOff => 'NFC deaktiviert';

  @override
  String get balanceNFCOffDetailed => 'Um dein AKAFÖ Guthaben auslesen zu können, muss NFC aktiviert sein.';

  @override
  String get balanceLastBalance => 'Letztes Guthaben: ';

  @override
  String get balanceLastScanned => 'Letzte gescannte Abbuchung: ';

  @override
  String get ticketLoginLoginID => 'RUB LoginID';

  @override
  String get ticketLoginPasswort => 'RUB Passwort';

  @override
  String get ticketLoginLogin => 'Login';

  @override
  String get ticketLoginBothFieldsError => 'Bitte fülle beide Felder aus!';

  @override
  String get ticketLoginInternetError => 'Überprüfe deine Internetverbindung!';

  @override
  String get ticketLoginWrongDataError => 'Falsche LoginID und/oder Passwort!';

  @override
  String get ticketLoginLoadingError => 'Fehler beim Laden des Tickets!';

  @override
  String get ticketLoginEncryptedInfo => 'Deine Daten werden verschlüsselt auf deinem Gerät gespeichert und nur bei der Anmeldung an die RUB gesendet.';

  @override
  String get walletPageWallet => 'Wallet';

  @override
  String get walletPageBalance => 'Mensa Guthaben';

  @override
  String get walletPageCampusABC => 'Campus ABC';

  @override
  String get walletPageComingInFuture => 'Dieser Bereich wird in zukünftigen Versionen stetig ergänzt und um nützliche Hilfen in die App zu integrieren.';
}
