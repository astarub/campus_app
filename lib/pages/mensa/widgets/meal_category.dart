import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

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
  final double price;

  const MealItem({
    Key? key,
    required this.name,
    this.price = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(name),
          // Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              price % 2 == 0 ? '${price.toInt()} €' : '${price}0 €',
              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
