import 'package:campus_app/pages/mensa/planner_helpers/mensa_day_notifier.dart';
import 'package:campus_app/pages/mensa/planner_helpers/restaurant_location.dart';
import 'package:campus_app/pages/planner/planner_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/mensa/widgets/meal_info_button.dart';

/// This widget shows a title and the corresponding meals that
/// are related to this category (e.g. "Komponentenessen")
class MealCategory extends StatelessWidget {
  /// The name of the category that is displayed above the meals
  final String categoryName;

  /// The meals, including their names and prices
  final List<MealItem> meals;

  const MealCategory({
    super.key,
    required this.categoryName,
    this.meals = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              categoryName,
              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
            ),
          ),
          Column(children: meals),
        ],
      ),
    );
  }
}

/// This widget shows a single dish that consists of a title, price
/// and optional properties
class MealItem extends StatelessWidget {
  final String name;
  final String price;
  final List<String> infos;
  final List<String> allergenes;
  final void Function(String) onPreferenceTap;

  const MealItem({
    super.key,
    required this.name,
    this.price = '0.0',
    this.infos = const [],
    this.allergenes = const [],
    required this.onPreferenceTap,
  });

  @override
  Widget build(BuildContext context) {
    final String location = context.read<RestaurantLocation>().name;
    final DateTime selectedDay = context.watch<MensaDayNotifier>().focusedDate;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                  ),
                ),
                // add‑to‑planner button
                Selector<PlannerState, bool>(
                  selector: (_, planner) => planner.hasMealEvent(
                    title: name,
                    location: location,
                    date: selectedDay,
                  ),
                  builder: (context, exists, _) {
                    return IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 20,
                      splashRadius: 18,
                      icon: Icon(exists ? Icons.event_busy_outlined : Icons.event_available_outlined),
                      tooltip: exists ? 'Remove from planner' : 'Add to planner',
                      onPressed: () async {
                        final planner = context.read<PlannerState>();
                        await planner.toggleMealEvent(
                          title: name,
                          price: price,
                          location: location,
                          date: selectedDay,
                        );

                        if (!context.mounted) return;
                        await Fluttertoast.showToast(
                          msg: exists ? 'Removed from planner' : 'Saved in planner',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          textColor: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          // Price
          Row(
            children: [
              // Price
              Container(
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? Colors.grey
                        : Provider.of<ThemesNotifier>(context)
                            .currentThemeData
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(0.4),
                  ),
                ),
                child: Text(
                  price,
                  style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.copyWith(
                        fontSize: 11,
                      ),
                ),
              ),
              // Infos
              if (infos.isNotEmpty)
                Row(
                  children: infos
                      .map(
                        (infoElement) => MealInfoButton(
                          info: infoElement,
                          onTap: () {
                            if (infoElement == 'V' || infoElement == 'VG' || infoElement == 'H') {
                              onPreferenceTap(infoElement);
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              Expanded(child: Container()),
              // Allergenes
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Text(
                  allergenes.join(', '),
                  style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.copyWith(
                        fontSize: 11,
                        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                            ? Colors.black38
                            : Provider.of<ThemesNotifier>(context)
                                .currentThemeData
                                .textTheme
                                .bodyMedium!
                                .color!
                                .withOpacity(0.4),
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
