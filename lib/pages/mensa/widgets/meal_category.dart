import 'package:flutter/material.dart';
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
    Key? key,
    required this.categoryName,
    this.meals = const [],
  }) : super(key: key);

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
    Key? key,
    required this.name,
    this.price = '0.0',
    this.infos = const [],
    this.allergenes = const [],
    required this.onPreferenceTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              name,
              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
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
