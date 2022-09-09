import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/mensa/widgets/day_selection.dart';
import 'package:campus_app/pages/mensa/widgets/expandable_restaurant.dart';
import 'package:campus_app/pages/mensa/widgets/meal_category.dart';

class MensaPage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const MensaPage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<MensaPage> createState() => _MensaPageState();
}

class _MensaPageState extends State<MensaPage> {
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
                          'Events',
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
                    children: const [
                      ExpandableRestaurant(
                        name: 'Mensa der RUB',
                        meals: [
                          MealCategory(
                            categoryName: 'Komponentenessen',
                            meals: [
                              MealItem(name: 'Paniertes Kabeljaufilet mit Dillrahmsauce', price: 2.5),
                              MealItem(name: 'Paniertes Kabeljaufilet mit Dillrahmsauce', price: 2.5),
                            ],
                          ),
                          MealCategory(
                            categoryName: 'Döner',
                            meals: [
                              MealItem(name: 'Halal Hähnchendöner mit Pommes oder Reis und Salat', price: 3.9),
                            ],
                          ),
                        ],
                      ),
                      ExpandableRestaurant(name: 'Bistro der RUB', meals: []),
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
