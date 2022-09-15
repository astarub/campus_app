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
  late Settings settings = Provider.of<SettingsHandler>(context).currentSettings;

  void saveChangedPreferences(List<String> newPreferences) {
    final Settings newSettings = Settings(
      useSystemDarkmode: settings.useSystemDarkmode,
      useDarkmode: settings.useDarkmode,
      mensaPreferences: newPreferences,
      mensaAllergenes: settings.mensaAllergenes,
    );

    debugPrint('Saving new mensa preferences: ${newSettings.mensaPreferences}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    settings = Provider.of<SettingsHandler>(context).currentSettings;
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
                  color: Colors.white,
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
                                      pageBuilder: (context, _, __) => const AllergenesPopup(),
                                    ));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Restaurants
                      const ExpandableRestaurant(
                        name: 'Mensa der RUB',
                        meals: [
                          MealCategory(
                            categoryName: 'Komponentenessen',
                            meals: [
                              MealItem(
                                name: 'Seelachs mit Gurken-Senfsauce',
                                price: 2.7,
                                infos: ['F'],
                                allergenes: ['d', 'g', 'j'],
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
                                infos: ['G', 'H'],
                                allergenes: ['a', 'al', 'g', 'j', 'l', '1', '2', '5'],
                              ),
                            ],
                          ),
                          MealCategory(
                            categoryName: 'Vegetarische Menükomponente',
                            meals: [
                              MealItem(
                                name: 'Frühlingsrolle mit Pflaumen-Ingwer-Dip',
                                price: 1.8,
                                infos: ['VG'],
                                allergenes: ['a', 'al', 'f', 'i', 'k'],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const ExpandableRestaurant(name: 'Bistro der RUB', meals: []),
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
