import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/animated_expandable.dart';
import 'package:campus_app/pages/mensa/widgets/meal_category.dart';

enum RestaurantStatus { open, closed, unknown }

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

  /// Opening hours in the format hh:mm-hh:mm
  final Map<String, String> openingHours;

  const ExpandableRestaurant({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.meals,
    required this.openingHours,
  }) : super(key: key);

  @override
  State<ExpandableRestaurant> createState() => _ExpandableRestaurantState();
}

class _ExpandableRestaurantState extends State<ExpandableRestaurant> {
  /// Key to acess the state of the AnimatedExpandable() for showing & hiding the meals
  final GlobalKey<AnimatedExpandableState> restaurantExpandableKey = GlobalKey();

  bool _isExpanded = false;
  DateTime now = DateTime.now();

  /// Retrieves the opening hours for the current day based on either a range of weekday Integers or a single Integer
  RestaurantStatus getOpeningStatus(Map<String, String> openingHoursMap) {
    // Get all opening/closed days
    final List<String> days = openingHoursMap.keys.toList();
    String openingHours = '';

    // Choose the right opening hours in accordance to the current weekday
    for (final String weekday in days) {
      final int weekdayInt = int.tryParse(weekday) != null ? int.tryParse(weekday)! : 0;

      if (!weekday.contains('-') && weekdayInt == now.weekday) {
        openingHours = openingHoursMap[weekday] != null ? openingHoursMap[weekday]! : '';
        continue;
      }
      if (weekday.split('-').length < 2) continue;

      final int lower = int.tryParse(weekday.split('-')[0]) != null ? int.tryParse(weekday.split('-')[0])! : 0;
      final int upper = int.tryParse(weekday.split('-')[1]) != null ? int.tryParse(weekday.split('-')[1])! : 0;

      if (now.weekday >= lower && now.weekday <= upper) {
        openingHours = openingHoursMap[weekday] != null ? widget.openingHours[weekday]! : '';
      }
    }

    RestaurantStatus status = RestaurantStatus.closed;

    // Checks if any openingHours exist for the current weekday, otherwise the status will be closed
    if (openingHours.isNotEmpty) {
      if (openingHours != 'unknown') {
        // Pick the individual number out of the hh:mm-hh:mm String
        final String openingHour =
            openingHours.split(':').isNotEmpty && int.tryParse(openingHours.substring(0, 2)) != null
                ? openingHours.substring(0, 2)
                : '0';
        final String openingMinute =
            openingHours.split(':').isNotEmpty && int.tryParse(openingHours.substring(3, 5)) != null
                ? openingHours.substring(3, 5)
                : '0';

        final String closingHour =
            openingHours.split(':').isNotEmpty && int.tryParse(openingHours.substring(6, 8)) != null
                ? openingHours.substring(6, 8)
                : '0';
        final String closingMinute =
            openingHours.split(':').isNotEmpty && int.tryParse(openingHours.substring(9)) != null
                ? openingHours.substring(9)
                : '0';

        // Combine both the hour and the minute to get an integer. Example: 14:30 becomes 1430
        final int openComb = int.tryParse(openingHour + openingMinute)!;
        final int closeComb = int.tryParse(closingHour + closingMinute)!;

        // Add a zero before the actual minute if it's lower than 10
        final String nowMinuteString = now.minute < 10 ? '0${now.minute}' : now.minute.toString();

        // Combine both the hour and the minute to get an integer. Example: 14:30 becomes 1430
        final int nowComb = int.tryParse(now.hour.toString() + nowMinuteString)!;

        // Checks if the weekday is lower than Saturday and if the current time is in the span of the opening and closing hours
        if (now.weekday <= 6 && nowComb >= openComb && nowComb <= closeComb) {
          status = RestaurantStatus.open;
        }
      } else {
        status = RestaurantStatus.unknown;
      }
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    // Get the current restaurant status
    final RestaurantStatus status = getOpeningStatus(widget.openingHours);

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
              if (Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light)
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    // Use here borderRadius
                    borderRadius: _isExpanded
                        ? const BorderRadius.only(topRight: Radius.circular(15))
                        : BorderRadius.circular(15),
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
                      : const Color.fromRGBO(255, 255, 255, 0.03),
                  onTap: () {
                    if (widget.meals.isNotEmpty) {
                      setState(() => _isExpanded = !_isExpanded);
                      restaurantExpandableKey.currentState!.toggleExpand();
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Open/Closed
                                Container(
                                  height: 25,
                                  width: 8,
                                  margin: const EdgeInsets.only(right: 3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme ==
                                            AppThemes.light
                                        ? status == RestaurantStatus.open
                                            ? const Color.fromRGBO(0, 207, 55, 1)
                                            : status == RestaurantStatus.unknown
                                                ? Colors.orange
                                                : const Color.fromRGBO(207, 0, 0, 1)
                                        : status == RestaurantStatus.open
                                            ? const Color.fromRGBO(94, 255, 83, 0.9)
                                            : status == RestaurantStatus.unknown
                                                ? Colors.orange
                                                : const Color.fromRGBO(255, 72, 72, 1),
                                  ),
                                ),
                                // Name
                                Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Text(
                                    widget.name,
                                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelLarge,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
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
