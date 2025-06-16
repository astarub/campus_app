import 'dart:io' show Platform;

import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/main.dart';
import 'package:campus_app/pages/home/widgets/study_course_popup.dart';
import 'package:campus_app/pages/more/widgets/leading_button.dart';
import 'package:campus_app/pages/more/widgets/leading_text_switch.dart';
import 'package:campus_app/utils/pages/main_utils.dart';
import 'package:campus_app/utils/widgets/animated_conditional.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This widget displays a single section headline in the settings page
class SectionHeadline extends StatelessWidget {
  final String headline;

  const SectionHeadline({
    super.key,
    required this.headline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Text(
        headline,
        textAlign: TextAlign.left,
        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
      ),
    );
  }
}

/// This page displays the app settings
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late Settings settings;

  final GlobalKey<AnimatedConditionalState> _darkmodeAnimationKey = GlobalKey();

  final BackendRepository backendRepository = sl<BackendRepository>();
  final MainUtils mainUtils = sl<MainUtils>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 0, left: 20, right: 20),
        child: Column(
          children: [
            // Back button & page title
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    CampusIconButton(
                      iconPath: 'assets/img/icons/arrow-left.svg',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Align(
                      child: Text(
                        'Einstellungen',
                        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Settings
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SectionHeadline(headline: 'Theming'),
                  // System Darkmode
                  LeadingTextSwitch(
                    text: 'System Darkmode',
                    isActive: Provider.of<SettingsHandler>(context).currentSettings.useSystemDarkmode,
                    onToggle: (switchValue) {
                      // Notify the UI that the ThemeMode has changed
                      if (switchValue) {
                        Provider.of<ThemesNotifier>(context, listen: false).currentThemeMode = ThemeMode.system;
                        Provider.of<SettingsHandler>(context, listen: false).currentSettings =
                            settings.copyWith(useSystemDarkmode: switchValue);
                      } else {
                        // Apply the system brightness to the useDarkmode setting as a default falue
                        // in order to not change the brightness whenever the useSystemDarkmode setting is turned off
                        if (MediaQuery.of(context).platformBrightness == Brightness.light) {
                          Provider.of<ThemesNotifier>(context, listen: false).currentThemeMode = ThemeMode.light;
                          Provider.of<SettingsHandler>(context, listen: false).currentSettings = settings.copyWith(
                            useDarkmode: false,
                            useSystemDarkmode: switchValue,
                          );
                        } else {
                          Provider.of<ThemesNotifier>(context, listen: false).currentThemeMode = ThemeMode.dark;
                          Provider.of<SettingsHandler>(context, listen: false).currentSettings = settings.copyWith(
                            useDarkmode: true,
                            useSystemDarkmode: switchValue,
                          );
                        }
                      }

                      // Show or hide the darkmode option
                      if (switchValue) {
                        _darkmodeAnimationKey.currentState?.animateOut();
                      } else {
                        _darkmodeAnimationKey.currentState?.animateIn();
                      }
                    },
                  ),
                  // Darkmode ~  !! Still not ideal, only animates in, not out
                  Offstage(
                    offstage: Provider.of<SettingsHandler>(context).currentSettings.useSystemDarkmode,
                    child: AnimatedConditional(
                      key: _darkmodeAnimationKey,
                      child: LeadingTextSwitch(
                        text: 'Darkmode',
                        isActive: Provider.of<SettingsHandler>(context).currentSettings.useDarkmode,
                        onToggle: (switchValue) {
                          Provider.of<SettingsHandler>(context, listen: false).currentSettings =
                              settings.copyWith(useDarkmode: switchValue);

                          // Notify the UI that the currentTheme has changed
                          if (switchValue) {
                            Provider.of<ThemesNotifier>(context, listen: false).currentTheme = AppThemes.dark;
                          } else {
                            Provider.of<ThemesNotifier>(context, listen: false).currentTheme = AppThemes.light;
                          }
                        },
                      ),
                    ),
                  ),
                  const SectionHeadline(headline: 'Stammdaten'),
                  LeadingButton(
                    text: 'Studiengang',
                    buttonText: 'Ändern',
                    onTap: () => campusAppKey.currentState?.mainNavigatorKey.currentState?.push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, _, __) => const StudyCoursePopup(),
                      ),
                    ),
                    height: 45,
                    width: 80,
                  ),
                  const SectionHeadline(headline: 'Verhalten'),
                  // External Browser
                  LeadingTextSwitch(
                    text: 'Verwende externen Browser für Links',
                    isActive: Provider.of<SettingsHandler>(context).currentSettings.useExternalBrowser,
                    onToggle: (switchValue) {
                      Provider.of<SettingsHandler>(context, listen: false).currentSettings =
                          settings.copyWith(useExternalBrowser: switchValue);
                    },
                  ),
                  // Apply app to system text scaling
                  LeadingTextSwitch(
                    text: 'Verwende Textgröße vom System',
                    isActive: Provider.of<SettingsHandler>(context).currentSettings.useSystemTextScaling,
                    onToggle: (switchValue) {
                      Provider.of<SettingsHandler>(context, listen: false).currentSettings =
                          settings.copyWith(useSystemTextScaling: switchValue);
                    },
                  ),
                  // Display semester ticket on a separate page
                  LeadingTextSwitch(
                    text: 'Vollbildschirmmodus QR-Code Semesterticket',
                    isActive: Provider.of<SettingsHandler>(context).currentSettings.displayFullscreenTicket,
                    onToggle: (switchValue) {
                      Provider.of<SettingsHandler>(context, listen: false).currentSettings =
                          settings.copyWith(displayFullscreenTicket: switchValue);
                    },
                  ),
                  const SectionHeadline(headline: 'Datenschutz'),
                  // Use Google services
                  LeadingTextSwitch(
                    text: 'Google Services für Benachrichtigungen',
                    isActive:
                        Provider.of<SettingsHandler>(context).currentSettings.useFirebase == FirebaseStatus.permitted,
                    onToggle: (switchValue) async {
                      if (switchValue) {
                        Provider.of<SettingsHandler>(context, listen: false).currentSettings = settings.copyWith(
                          useFirebase: FirebaseStatus.permitted,
                        );

                        await mainUtils.initializeFirebase(context);
                      } else {
                        if (mounted) {
                          Provider.of<SettingsHandler>(context, listen: false).currentSettings = settings.copyWith(
                            useFirebase: FirebaseStatus.forbidden,
                          );
                        }

                        try {
                          await backendRepository.removeAllSavedEvents(
                            Provider.of<SettingsHandler>(
                              context,
                              listen: false,
                            ),
                          );
                          await FirebaseMessaging.instance.deleteToken();
                        } catch (e) {
                          debugPrint(
                            'Could not remove the device from Firebase. Retrying next restart.',
                          );
                        }
                      }
                    },
                  ),
                  const SectionHeadline(headline: 'Push-Benachrichtigungen'),
                  LeadingTextSwitch(
                    text: 'Benachrichtigungen für gespeicherte Events',
                    isActive: Provider.of<SettingsHandler>(context).currentSettings.savedEventsNotifications,
                    onToggle: (switchValue) async {
                      if (switchValue) {
                        Provider.of<SettingsHandler>(context, listen: false).currentSettings =
                            settings.copyWith(savedEventsNotifications: true);
                      } else {
                        Provider.of<SettingsHandler>(context, listen: false).currentSettings =
                            settings.copyWith(savedEventsNotifications: false);

                        try {
                          final provider = Provider.of<SettingsHandler>(context, listen: false);

                          await backendRepository.unsubscribeFromAllSavedEvents(
                            provider,
                          );
                          await backendRepository.removeAllSavedEvents(
                            provider,
                          );
                        } on NoConnectionException {
                          debugPrint(
                            'Could not remove all saved events from the backend. Retrying next restart.',
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    settings = Provider.of<SettingsHandler>(context).currentSettings;
  }
}
