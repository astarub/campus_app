import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_onboarding/flutter_onboarding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:campus_app/l10n/l10n.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:campus_app/core/backend/entities/study_course_entity.dart';
import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/pages/more/widgets/language_selection.dart';
import 'package:campus_app/pages/home/widgets/animated_onboarding_entry.dart';
import 'package:campus_app/pages/home/widgets/study_selection.dart';
import 'package:campus_app/pages/home/widgets/theme_selection.dart';
import 'package:campus_app/utils/onboarding_data.dart';
import 'package:campus_app/utils/pages/main_utils.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/campus_segmented_triple_control.dart';
import 'package:campus_app/utils/widgets/campus_text_button.dart';

class OnboardingPage extends StatefulWidget {
  final GlobalKey<HomePageState> homePageKey;

  final GlobalKey<NavigatorState> mainNavigatorKey;

  const OnboardingPage({
    super.key,
    required this.homePageKey,
    required this.mainNavigatorKey,
  });

  @override
  State<OnboardingPage> createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final GlobalKey<HomePageState> homeKey = GlobalKey();
  final GlobalKey<OnboardingSliderState> onboardingSliderKey = GlobalKey();
  final GlobalKey<ThemeSelectionState> themeSelectionKey = GlobalKey();

  final BackendRepository backendRepository = sl<BackendRepository>();
  final MainUtils mainUtils = sl<MainUtils>();

  List<Locale> availableLocales = AppLocalizations.supportedLocales;
  // Selected study courses
  Locale selectedLocale = const Locale('de');

  // Selected options during onboarding
  List<StudyCourse> selectedStudies = [];

  bool firebaseAccepted = true;
  int selectedTheme = 0;

  final SystemUiOverlayStyle lightSystemUiStyle = const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light, // iOS
    statusBarColor: Colors.white, // Android
    statusBarIconBrightness: Brightness.dark, // Android
    systemNavigationBarColor: Colors.white, // Android
    systemNavigationBarIconBrightness: Brightness.dark, // Android
  );
  final SystemUiOverlayStyle darkSystemUiStyle = const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark, // iOS
    statusBarColor: Color.fromRGBO(14, 20, 32, 1), // Android
    statusBarIconBrightness: Brightness.light, // Android
    systemNavigationBarColor: Color.fromRGBO(17, 25, 38, 1), // Android
    systemNavigationBarIconBrightness: Brightness.light, // Android
  );
  final SystemUiOverlayStyle lightTabletSystemUiStyle = const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light, // iOS
    statusBarColor: Color.fromRGBO(245, 246, 250, 1), // Android
    statusBarIconBrightness: Brightness.dark, // Android
    systemNavigationBarColor: Color.fromRGBO(245, 246, 250, 1), // Android
    systemNavigationBarIconBrightness: Brightness.dark, // Android
  );
  final SystemUiOverlayStyle darkTabletSystemUiStyle = const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark, // iOS
    statusBarColor: Color.fromRGBO(17, 25, 38, 1), // Android
    statusBarIconBrightness: Brightness.light, // Android
    systemNavigationBarColor: Color.fromRGBO(17, 25, 38, 1), // Android
    systemNavigationBarIconBrightness: Brightness.light, // Android
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MediaQuery.of(context).size.shortestSide < 600
          ? Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? lightSystemUiStyle
              : darkSystemUiStyle
          : Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? lightTabletSystemUiStyle
              : darkTabletSystemUiStyle,
      child: Scaffold(
        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.shortestSide >= 600 ? 550 : null,
            child: OnboardingSlider(
              key: onboardingSliderKey,
              donePage: HomePage(key: homeKey, mainNavigatorKey: widget.mainNavigatorKey),
              onDone: saveSelections,
              doneButtonText: AppLocalizations.of(context)!.done,
              buttonTextStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium,
              backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
              buttonColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? Colors.black
                  : const Color.fromRGBO(34, 40, 54, 1),
              pageIndicatorColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? Colors.black
                  : const Color.fromRGBO(184, 186, 191, 1),
              inactivePageIndicatorColor:
                  Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? const Color.fromARGB(255, 228, 228, 228)
                      : const Color.fromRGBO(34, 40, 54, 1),
              nextButtonIcon: SvgPicture.asset(
                'assets/img/icons/arrow-right.svg',
                colorFilter: ColorFilter.mode(
                  Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? Colors.white
                      : const Color.fromRGBO(184, 186, 191, 1),
                  BlendMode.srcIn,
                ),
              ),
              items: [
                // Welcome screen with logo
                SafeArea(
                  child: Column(
                    children: [
                      AnimatedOnboardingLogo(
                        offsetDuration: const Duration(milliseconds: 600),
                        logo: Container(
                          height: 300,
                          width: 300,
                          margin: const EdgeInsets.only(top: 80, bottom: 50),
                          child: Image.asset('assets/img/SplashScreen-logo.png', height: 300),
                        ),
                      ),
                      AnimatedOnboardingEntry(
                        offsetDuration: const Duration(milliseconds: 2000),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            AppLocalizations.of(context)!.onboardingAppName,
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                          ),
                        ),
                      ),
                      AnimatedOnboardingEntry(
                        offsetDuration: const Duration(milliseconds: 2000),
                        interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                        child: Text(
                          AppLocalizations.of(context)!.onboardingPresentedBy,
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                // Language Selection
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 100),
                    child: Column(
                      children: [
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 10),
                            child: Text(
                              AppLocalizations.of(context)!.onboardingLanguage,
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                            ),
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                          child: Text(
                            AppLocalizations.of(context)!.onboardingLanguageDetailed,
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: AnimatedOnboardingEntry(
                            offsetDuration: const Duration(milliseconds: 500),
                            interval: const Interval(0.16, 1, curve: Curves.easeOutCubic),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: LanguageSelection(
                                availableLocales: availableLocales,
                                saveSelection: setSelectedLocale,
                                selectedLocale: selectedLocale,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Choose study area
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 100),
                    child: Column(
                      children: [
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 10),
                            child: Text(
                              AppLocalizations.of(context)!.onboardingStudyProgram,
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                            ),
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                          child: Text(
                            AppLocalizations.of(context)!.onboardingStudyProgramDetailed,
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (Provider.of<SettingsHandler>(context, listen: false)
                            .currentSettings
                            .studyCourses
                            .isNotEmpty) ...[
                          Expanded(
                            child: AnimatedOnboardingEntry(
                              offsetDuration: const Duration(milliseconds: 500),
                              interval: const Interval(0.16, 1, curve: Curves.easeOutCubic),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: StudySelection(
                                  availableStudies:
                                      Provider.of<SettingsHandler>(context, listen: false).currentSettings.studyCourses,
                                  selectedStudies: selectedStudies,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: SizedBox(
                              height: 35,
                              child: CircularProgressIndicator(
                                backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                                color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                // Accept or decline use of Firebase
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 100),
                    child: Column(
                      children: [
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 10),
                            child: Text(
                              AppLocalizations.of(context)!.onboardingPrivacy,
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                            ),
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                          child: Text(
                            firebaseDescription,
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.16, 1, curve: Curves.easeOutCubic),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!.onboardingNotifications,
                                style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedOnboardingEntry(
                            offsetDuration: const Duration(milliseconds: 500),
                            interval: const Interval(0.24, 1, curve: Curves.easeOutCubic),
                            child: SingleChildScrollView(
                              child: Text(
                                privacyText,
                                style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ),
                        // No button
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.32, 1, curve: Curves.easeOutCubic),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 16),
                            child: CampusTextButton(
                              buttonText: AppLocalizations.of(context)!.onboardingDeny,
                              onTap: () {
                                firebaseAccepted = false;
                                onboardingSliderKey.currentState?.nextPage();
                              },
                            ),
                          ),
                        ),
                        // Yes button
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.40, 1, curve: Curves.easeOutCubic),
                          child: CampusButton(
                            text: AppLocalizations.of(context)!.onboardingConfirm,
                            onTap: () {
                              firebaseAccepted = true;
                              onboardingSliderKey.currentState?.nextPage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Choose theme
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 100),
                    child: Column(
                      children: [
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100, bottom: 80),
                            child: ThemeSelection(key: themeSelectionKey),
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              AppLocalizations.of(context)!.onboardingTheme,
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                            ),
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.16, 1, curve: Curves.easeOutCubic),
                          child: Text(
                            AppLocalizations.of(context)!.onboardingThemeDescription,
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Toggle
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.24, 1, curve: Curves.easeOutCubic),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: CampusSegmentedTripleControl(
                              leftTitle: AppLocalizations.of(context)!.onboardingThemeSystem,
                              centerTitle: AppLocalizations.of(context)!.onboardingThemeLight,
                              rightTitle: AppLocalizations.of(context)!.onboardingThemeDark,
                              onChanged: changeTheme,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Feedback
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 100),
                    child: Column(
                      children: [
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 10),
                            child: Text(
                              AppLocalizations.of(context)!.onboardingFeedback,
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                            ),
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                          child: Text(
                            feedbackDescription,
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.16, 1, curve: Curves.easeOutCubic),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CampusIconButton(
                                  iconPath: 'assets/img/icons/github.svg',
                                  onTap: () => openLink(context, 'https://github.com/astarub/campus_app/discussions'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: CampusIconButton(
                                    iconPath: 'assets/img/icons/discord-filled.svg',
                                    onTap: () => openLink(context, 'https://discord.gg/BYdg3pXjab'),
                                  ),
                                ),
                                CampusIconButton(
                                  iconPath: 'assets/img/icons/mail.svg',
                                  onTap: () => openLink(context, 'mailto:dev@asta-bochum.de'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedOnboardingEntry(
                              offsetDuration: const Duration(milliseconds: 500),
                              interval: const Interval(0.24, 1, curve: Curves.easeOutCubic),
                              child: SizedBox(
                                height: 80,
                                child: Image.asset(
                                  'assets/img/SplashScreen-AStA-branding.png',
                                  color:
                                      Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.dark
                                          ? const Color.fromRGBO(37, 49, 71, 1)
                                          : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeTheme(int selectedThemeMode) {
    selectedTheme = selectedThemeMode;
    themeSelectionKey.currentState?.changeTheme(selectedThemeMode);
  }

  @override
  void initState() {
    super.initState();

    backendRepository.loadStudyCourses(
      Provider.of<SettingsHandler>(context, listen: false),
    );

    selectedLocale = Provider.of<SettingsHandler>(context, listen: false).currentSettings.locale;
  }

  void openLink(BuildContext context, String url) {
    debugPrint('Opening external ressource: $url');

    // Open in external browser
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  void saveSelections() {
    final Settings newSettings = Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(
          useSystemDarkmode: selectedTheme == 0,
          useDarkmode: selectedTheme == 2,
          selectedStudyCourses: selectedStudies,
          studyCoursePopup: true,
          useFirebase: firebaseAccepted ? FirebaseStatus.permitted : FirebaseStatus.forbidden,
        );

    if (firebaseAccepted) mainUtils.initializeFirebase(widget.homePageKey.currentContext!);

    debugPrint('Onboarding completed. Selected study-courses: ${newSettings.selectedStudyCourses.map((c) => c.name)}');

    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;

    mainUtils.setIntialStudyCoursePublishers(Provider.of<SettingsHandler>(context, listen: false), selectedStudies);
  }

  // ignore: use_setters_to_change_properties
  void setSelectedLocale(Locale selected) {
    final Settings newSettings = Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(
          locale: selected,
        );

    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;

    selectedLocale = selected;
  }
}
