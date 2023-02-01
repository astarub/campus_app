import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_onboarding/flutter_onboarding.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/home_page.dart';
import 'package:campus_app/utils/pages/main_utils.dart';
import 'package:campus_app/pages/home/widgets/animated_onboarding_entry.dart';
import 'package:campus_app/pages/home/widgets/study_selection.dart';
import 'package:campus_app/utils/onboarding_data.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_text_button.dart';

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
  final GlobalKey<OnboardingSliderState> onboardingSliderKey = GlobalKey();
  final GlobalKey<HomePageState> homeKey = GlobalKey();

  late StudySelection studySelection;

  // Selected options during onboarding
  List<String> selectedStudies = [];
  bool firebaseAccepted = true;

  void saveSelections() {
    final Settings newSettings = Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(
          studyCourses: selectedStudies,
          useFirebase: firebaseAccepted ? FirebaseStatus.permitted : FirebaseStatus.forbidden,
        );

    if (firebaseAccepted) initializeFirebase();

    debugPrint('Onboarding completed. Selected study-courses: ${newSettings.studyCourses}');

    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  @override
  void initState() {
    super.initState();

    studySelection = StudySelection(selectedStudies: selectedStudies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: OnboardingSlider(
        key: onboardingSliderKey,
        donePage: HomePage(key: homeKey, mainNavigatorKey: widget.mainNavigatorKey),
        onDone: saveSelections,
        doneButtonText: 'Abschließen',
        nextButtonIcon: SvgPicture.asset(
          'assets/img/icons/arrow-right.svg',
          color: Colors.white,
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
                      'Wähle deinen aktuellen Studiengang, um bspw. für dich passende Events anzuzeigen.',
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
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Push-Benachrichtigungen aktivieren',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: AnimatedOnboardingEntry(
                      offsetDuration: Duration(milliseconds: 500),
                      interval: Interval(0.24, 1, curve: Curves.easeOutCubic),
                      child: SingleChildScrollView(
                        child: Text(privacyText, textAlign: TextAlign.justify),
                      ),
                    ),
                  ),
                  // No button
                  AnimatedOnboardingEntry(
                    offsetDuration: const Duration(milliseconds: 500),
                    interval: const Interval(0.32, 1, curve: Curves.easeOutCubic),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
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
          Center(child: Text('tbd')),
          // Done
          Center(child: Text('tbd')),
        ],
      ),
    );
  }
}
