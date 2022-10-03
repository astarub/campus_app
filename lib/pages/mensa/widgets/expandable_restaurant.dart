import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/animated_expandable.dart';
import 'package:campus_app/pages/mensa/widgets/meal_category.dart';

/// This widget displays one restaurant and its meals, which can be
/// expanded and collapsed
class ExpandableRestaurant extends StatefulWidget {
  /// The name of the restaurant
  final String name;

  /// The path to the asset image that is displayed on the right side
  /// of the restaurant widget
  final String imagePath;

  /// The list of meal categories with their corresponding meals
  final List<MealCategory> meals;

  const ExpandableRestaurant({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.meals,
  }) : super(key: key);

  @override
  State<ExpandableRestaurant> createState() => _ExpandableRestaurantState();
}

class _ExpandableRestaurantState extends State<ExpandableRestaurant> {
  /// Key to acess the state of the AnimatedExpandable() for showing & hiding the meals
  final GlobalKey<AnimatedExpandableState> restaurantExpandableKey = GlobalKey();

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant header
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              highlightColor: const Color.fromRGBO(0, 0, 0, 0.03),
              splashColor: const Color.fromRGBO(0, 0, 0, 0.04),
              onTap: () {
                if (widget.meals.isNotEmpty) {
                  setState(() => _isExpanded = !_isExpanded);
                  restaurantExpandableKey.currentState!.toggleExpand();
                }
              },
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(15),
                        bottomRight: _isExpanded ? Radius.zero : const Radius.circular(15)),
                    child: Image.asset(
                      widget.imagePath,
                      height: 57,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelLarge,
                        ),
                        Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Items
          AnimatedExpandable(
            key: restaurantExpandableKey,
            children: widget.meals,
          ),
        ],
      ),
    );
  }
}
