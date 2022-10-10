import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/pages/mensa/widgets/day_selection.dart';
import 'package:campus_app/pages/mensa/widgets/expandable_restaurant.dart';
import 'package:campus_app/pages/mensa/widgets/meal_category.dart';
import 'package:campus_app/pages/mensa/widgets/preferences_popup.dart';
import 'package:campus_app/pages/mensa/widgets/allergenes_popup.dart';

class MensaPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const MensaPage({
    Key? key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<MensaPage> createState() => _MensaPageState();
}

class _MensaPageState extends State<MensaPage> {
  late Settings _settings;

  /// This function saves the new selected preferences with the [SettingsHandler]
  void saveChangedPreferences(List<String> newPreferences) {
    final Settings newSettings = Settings(
      useSystemDarkmode: _settings.useSystemDarkmode,
      useDarkmode: _settings.useDarkmode,
      mensaPreferences: newPreferences,
      mensaAllergenes: _settings.mensaAllergenes,
    );

    debugPrint('Saving new mensa preferences: ${newSettings.mensaPreferences}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  /// This function saves the new selected preferences with the [SettingsHandler]
  void saveChangedAllergenes(List<String> newAllergenes) {
    final Settings newSettings = Settings(
      useSystemDarkmode: _settings.useSystemDarkmode,
      useDarkmode: _settings.useDarkmode,
      mensaPreferences: _settings.mensaPreferences,
      mensaAllergenes: newAllergenes,
    );

    debugPrint('Saving new mensa allergenes: ${newSettings.mensaAllergenes}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  /// This function is called whenever one of the 3 preferences "vegetarian", "vegan"
  /// or "halal" is selected. It automatically adds or removes the preference from the list.
  void singlePreferenceSelected(String selectedPreference) {
    List<String> newPreferences = _settings.mensaPreferences;

    if (_settings.mensaPreferences.contains(selectedPreference)) {
      newPreferences.remove(selectedPreference);
    } else {
      newPreferences.add(selectedPreference);
    }

    saveChangedPreferences(newPreferences);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _settings = Provider.of<SettingsHandler>(context).currentSettings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: AnimatedExit(
          key: widget.pageExitAnimationKey,
          child: AnimatedEntry(
            key: widget.pageEntryAnimationKey,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
                  child: Column(
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          'Mensa',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                        ),
                      ),
                      // Day selection
                      MensaDaySelection(onChanged: (int _) {}),
                    ],
                  ),
                ),
                // Place expandables
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Filter popups
                      Padding(
                        padding: const EdgeInsets.only(bottom: 26),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: CampusButton.light(
                                  text: 'Präferenzen',
                                  width: null,
                                  onTap: () {
                                    widget.mainNavigatorKey.currentState?.push(PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (context, _, __) => PreferencesPopup(
                                        preferences:
                                            Provider.of<SettingsHandler>(context).currentSettings.mensaPreferences,
                                        onClose: saveChangedPreferences,
                                      ),
                                    ));
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: CampusButton.light(
                                  text: 'Allergene',
                                  width: null,
                                  onTap: () {
                                    widget.mainNavigatorKey.currentState?.push(PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (context, _, __) => AllergenesPopup(
                                        allergenes:
                                            Provider.of<SettingsHandler>(context).currentSettings.mensaAllergenes,
                                        onClose: saveChangedAllergenes,
                                      ),
                                    ));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Restaurants
                      ExpandableRestaurant(
                        name: 'Mensa der RUB',
                        imagePath: 'assets/img/mensa.png',
                        meals: [
                          MealCategory(
                            categoryName: 'Komponentenessen',
                            meals: [
                              MealItem(
                                name: 'Seelachs mit Gurken-Senfsauce',
                                price: 2.7,
                                infos: const ['F'],
                                allergenes: const ['d', 'g', 'j'],
                                onPreferenceTap: singlePreferenceSelected,
                              ),
                              //MealItem(name: 'Paniertes Kabeljaufilet mit Dillrahmsauce', price: 2.5),
                            ],
                          ),
                          MealCategory(
                            categoryName: 'Döner',
                            meals: [
                              MealItem(
                                name: 'Halal Hähnchendöner mit Pommes oder Reis und Salat',
                                price: 3.9,
                                infos: const ['G', 'H'],
                                allergenes: const ['a', 'al', 'g', 'j', 'l', '1', '2', '5'],
                                onPreferenceTap: singlePreferenceSelected,
                              ),
                            ],
                          ),
                          MealCategory(
                            categoryName: 'Vegetarische Menükomponente',
                            meals: [
                              MealItem(
                                name: 'Frühlingsrolle mit Pflaumen-Ingwer-Dip',
                                price: 1.8,
                                infos: const ['VG'],
                                allergenes: const ['a', 'al', 'f', 'i', 'k'],
                                onPreferenceTap: singlePreferenceSelected,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const ExpandableRestaurant(
                        name: 'Rote Beete',
                        imagePath: 'assets/img/rotebeete.png',
                        meals: [],
                      ),
                      const ExpandableRestaurant(
                        name: 'Q-West',
                        imagePath: 'assets/img/qwest.png',
                        meals: [],
                      ),
                      const ExpandableRestaurant(
                        name: 'Henkelmann',
                        imagePath: 'assets/img/henkelmann.png',
                        meals: [],
                      ),
                    ],
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
