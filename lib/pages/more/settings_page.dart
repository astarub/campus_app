import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/pages/more/widgets/leading_text_switch.dart';

/// This page displays the app settings
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _systemDarkmode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
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
            // Imprint
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SectionHeadline(headline: 'Theming'),
                  // System Darkmode
                  LeadingTextSwitch(
                    text: 'System Darkmode',
                    isActive: _systemDarkmode,
                    onToggle: (value) {
                      setState(() {
                        _systemDarkmode = !_systemDarkmode;
                      });
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
}

/// This widget displays a single section headline in the settings page
class SectionHeadline extends StatelessWidget {
  final String headline;

  const SectionHeadline({
    Key? key,
    required this.headline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        headline,
        textAlign: TextAlign.left,
        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
      ),
    );
  }
}
