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
        color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant header
          Stack(
            children: [
              if(Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light)
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect( // Use here borderRadius
                    borderRadius: _isExpanded ? const BorderRadius.only(topRight: Radius.circular(15)) : BorderRadius.circular(15),
                    child: Image.asset(
                      widget.imagePath,
                      height: 57,
                    ),
                  ),
                ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  splashColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? const Color.fromRGBO(0, 0, 0, 0.04)
                      : const Color.fromRGBO(255, 255, 255, 0.04),
                  highlightColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? const Color.fromRGBO(0, 0, 0, 0.03)
                      : const Color.fromRGBO(255, 255, 255, 0.7),
                  onTap: () {
                    if (widget.meals.isNotEmpty) {
                      setState(() => _isExpanded = !_isExpanded);
                      restaurantExpandableKey.currentState!.toggleExpand();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelLarge,
                        ),
                        Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light ? Colors.black : Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
