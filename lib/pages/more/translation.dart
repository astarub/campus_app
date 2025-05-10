import 'package:campus_app/core/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class Translation extends StatefulWidget {
  const Translation({super.key});

  @override
  State<Translation> createState() => _TranslationState();
}

class _TranslationState extends State<Translation> {
  String _selectedLanguage = 'en'; // Standard: Englisch

  final Map<String, String> _languageOptions = {
    'en': 'English',
    'de': 'Deutsch',
    'ar': 'Arabic',
  //add hier more languages
  };

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            // Back button & page title
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
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
                        'Languages',
                        style: theme.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Language selection UI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: InputDecoration(
                      labelText: 'Select Language',
                      border: OutlineInputBorder(),
                    ),
                    items: _languageOptions.entries
                        .map(
                          (entry) => DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: implement language switching logic here
                      Provider.of<SettingsHandler>(context, listen: false).setLocale(_selectedLanguage);// i added this for translation

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Language changed to ${_languageOptions[_selectedLanguage]}')),
                      );
                    },
                    child: const Text('Apply'),
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
