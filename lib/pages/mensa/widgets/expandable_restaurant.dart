import 'dart:async';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/mensa/widgets/meal_category.dart';
import 'package:campus_app/utils/widgets/animated_expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  /// Selected date
  final DateTime selectedDate;

  final Stream<DateTime> stream;

  const ExpandableRestaurant({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.meals,
    required this.openingHours,
    required this.selectedDate,
    required this.stream,
  }) : super(key: key);

  @override
  State<ExpandableRestaurant> createState() => _ExpandableRestaurantState();
}

enum RestaurantStatus { open, closed, unknown }

class _ExpandableRestaurantState extends State<ExpandableRestaurant> with WidgetsBindingObserver {
  /// Key to acess the state of the AnimatedExpandable() for showing & hiding the meals
  final GlobalKey<AnimatedExpandableState> restaurantExpandableKey = GlobalKey();

  bool _isExpanded = false;

  RestaurantStatus status = RestaurantStatus.unknown;
  String openingHours = '';
  int closingHourGlobal = 0;
  int closingMinuteGlobal = 0;
  String remainingTime = '';
  DateTime stateDate = DateTime.now();
  Timer? timer;

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
            children: <Widget>[
                  // Opening hours
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (getOpeningHours(stateDate).isNotEmpty)
                          Text(
                            'Reguläre Öffnungszeiten: ${getOpeningHours(stateDate)} Uhr',
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                          ),
                        Text(
                          (status == RestaurantStatus.open && DateUtils.isSameDay(stateDate, DateTime.now()))
                              ? 'Verbleibende Zeit: $remainingTime'
                              : 'Geschlossen / Speiseplan von ${DateFormat('dd.MM.yyyy').format(widget.selectedDate)}',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ] +
                widget.meals,
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Updates the opening state of the current restaurant and sets the remaining time timer
    if (state == AppLifecycleState.resumed) {
      setOpeningStatus(stateDate);
      setTimer();
    }
  }

  /// Get opening hours of specific weekday.
  /// Returns the opening hours as definied at creation of the widget itself (restaurant config)
  /// or an empty string. An empty string indicates some malformed restaurant configuration.
  String getOpeningHours(DateTime weekdayDate) {
    // Get all opening/closed days
    // dayRanges: 1-7, 1-5, 6, 7 etc. depending on openening hour definition
    final List<String> dayRanges = widget.openingHours.keys.toList();

    try {
      // Choose the right opening hours in accordance to the current weekday
      for (final String dayRange in dayRanges) {
        // If dayRange is a single day (= a single integer)
        final weekdayInt = int.tryParse(dayRange) ?? -1; // avoid null -> failed parsing -1
        if (weekdayInt == weekdayDate.weekday) {
          return widget.openingHours[dayRange]!;
        } else if (weekdayInt != -1) {
          // Isn't the selected day
          continue;
        }

        // If dayRange has format $INT-$INT, e.g. 1-5 or 1-7
        final int? lower = int.tryParse(dayRange.split('-')[0]);
        final int? upper = int.tryParse(dayRange.split('-')[1]);
        if (weekdayDate.weekday >= lower! && weekdayDate.weekday <= upper!) {
          return widget.openingHours[dayRange]!;
        }
      }
    } catch (_) {
      // openingHours are malformed
      // e.g. 1- or -5 instead of 1-5 or 5
      return '';
    }

    // selectedDay isn't in map or restaurant is closed
    return '';
  }

  @override
  void initState() {
    super.initState();

    // Set the initial date
    stateDate = widget.selectedDate;

    // Get the current restaurant status
    setOpeningStatus(stateDate);

    // Set the remaining time timer
    setTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Listen for new day selections
      widget.stream.listen((streamedDate) {
        if (mounted) {
          setState(() {
            stateDate = streamedDate;
          });
          setOpeningStatus(streamedDate);
          setTimer();
        }
      });
    });
  }

  /// Retrieves the opening hours for the current day based on either a range of weekday Integers or a single Integer
  void setOpeningStatus(DateTime selectedDate) {
    // Default is closed state
    var tempStatus = RestaurantStatus.closed;

    // Set the status to closed on any selection beside the current date
    final now = DateTime.now();
    if (now.day != selectedDate.day) {
      setState(() => status = tempStatus);
      return;
    }

    // get opening hours from restaurant config that is hold inside the widget
    openingHours = getOpeningHours(selectedDate);

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

        // Set closing time globally for timer
        closingHourGlobal = int.tryParse(closingHour) ?? 0;
        closingMinuteGlobal = int.tryParse(closingMinute) ?? 0;

        // Combine both the hour and the minute to get an integer. Example: 14:30 becomes 1430
        final int openComb = int.tryParse(openingHour + openingMinute)!;
        final int closeComb = int.tryParse(closingHour + closingMinute)!;

        // Combine both the hour and the minute to get an integer. Example: 14:30 becomes 1430
        final int nowComb = int.tryParse(now.hour.toString().padLeft(2, '0') + now.minute.toString().padLeft(2, '0'))!;

        // Checks if the weekday is lower than Saturday and if the current time is in the span of the opening and closing hours
        if (now.weekday <= 5 && nowComb >= openComb && nowComb <= closeComb) {
          tempStatus = RestaurantStatus.open;
        }
      } else {
        tempStatus = RestaurantStatus.unknown;
      }
    }

    setState(() {
      status = tempStatus;
    });
  }

  // Checks whether the current restaurant is open and then runs a periodic timer to update the remaining time
  void setTimer() {
    final DateTime now = DateTime.now();

    if (status == RestaurantStatus.open && DateUtils.isSameDay(stateDate, now)) {
      // Abort if a timer is already running
      if (timer != null) return;

      // Set a timer
      Timer.periodic(const Duration(seconds: 1), (t) {
        timer = t;
        final DateTime now = DateTime.now();
        final DateTime closingDate = now.copyWith(
          hour: closingHourGlobal,
          minute: closingMinuteGlobal,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );

        final Duration difference = closingDate.difference(now);

        if (difference.inSeconds == 0) {
          t.cancel();
          timer = null;

          if (!mounted) return;

          setState(() {
            status = RestaurantStatus.closed;
            remainingTime = '';
          });
        } else {
          final int hours = difference.inHours % 24;
          final int minutes = difference.inMinutes % 60;
          final int seconds = difference.inSeconds % 60;

          if (!mounted) {
            t.cancel();
            return;
          }

          if (hours == 0) {
            setState(() {
              remainingTime = '${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
            });
          } else {
            setState(() {
              remainingTime =
                  '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
            });
          }
        }
      });
    }
  }
}
