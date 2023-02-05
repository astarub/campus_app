import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_onboarding/flutter_onboarding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/utils/pages/main_utils.dart';
import 'package:campus_app/pages/home/widgets/animated_onboarding_entry.dart';
import 'package:campus_app/pages/home/widgets/study_selection.dart';
import 'package:campus_app/pages/home/widgets/theme_selection.dart';
import 'package:campus_app/utils/onboarding_data.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_text_button.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/campus_segmented_triple_control.dart';

class OnboardingPage extends StatefulWidget {
  final GlobalKey<HomePageState> homePageKey;

  final GlobalKey<NavigatorState> mainNavigatorKey;

  const OnboardingPage({
    Key? key,
    required this.homePageKey,
    required this.mainNavigatorKey,
  }) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final GlobalKey<HomePageState> homeKey = GlobalKey();
  final GlobalKey<OnboardingSliderState> onboardingSliderKey = GlobalKey();
  final GlobalKey<ThemeSelectionState> themeSelectionKey = GlobalKey();

  late StudySelection studySelection;

  // Selected options during onboarding
  List<String> selectedStudies = [];
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

  void saveSelections() {
    final Settings newSettings = Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(
          useSystemDarkmode: selectedTheme == 0,
          useDarkmode: selectedTheme == 2,
          studyCourses: selectedStudies,
          useFirebase: firebaseAccepted ? FirebaseStatus.permitted : FirebaseStatus.forbidden,
        );

    if (firebaseAccepted) initializeFirebase();

    debugPrint('Onboarding completed. Selected study-courses: ${newSettings.studyCourses}');

    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  void openLink(BuildContext context, String url) {
    debugPrint('Opening external ressource: $url');

    // Open in external browser
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  void changeTheme(int selectedThemeMode) {
    selectedTheme = selectedThemeMode;
    themeSelectionKey.currentState?.changeTheme(selectedThemeMode);
  }

  @override
  void initState() {
    super.initState();

    studySelection = StudySelection(selectedStudies: selectedStudies);
  }

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
        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.shortestSide >= 600 ? 550 : null,
            child: OnboardingSlider(
              key: onboardingSliderKey,
              donePage: HomePage(key: homeKey, mainNavigatorKey: widget.mainNavigatorKey),
              onDone: saveSelections,
              doneButtonText: 'Abschließen',
              buttonTextStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium,
              backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
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
                color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? Colors.white
                    : const Color.fromRGBO(184, 186, 191, 1),
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
                            'Campus App',
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                          ),
                        ),
                      ),
                      AnimatedOnboardingEntry(
                        offsetDuration: const Duration(milliseconds: 2000),
                        interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                        child: Text(
                          'Präsentiert von deinem AStA',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                        ),
                      ),
                    ],
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
                              'Studiengang',
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                            ),
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                          child: Text(
                            'Wähle deinen aktuellen Studiengang, um für dich passende Events und News anzuzeigen.',
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
                              child: studySelection,
                            ),
                          ),
                        ),
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
                              'Datenschutz',
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
                                'Push-Benachrichtigungen aktivieren',
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
                              buttonText: 'Nein, möchte ich nicht.',
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
                            text: 'Ja, kein Problem',
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
                              'Theme',
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                            ),
                          ),
                        ),
                        AnimatedOnboardingEntry(
                          offsetDuration: const Duration(milliseconds: 500),
                          interval: const Interval(0.16, 1, curve: Curves.easeOutCubic),
                          child: Text(
                            'Kontrastreich oder unauffällig. Tag oder Nacht.\nWähle dein Design.',
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
                              leftTitle: 'System',
                              centerTitle: 'Hell',
                              rightTitle: 'Dunkel',
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
                              'Feedback',
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
}
