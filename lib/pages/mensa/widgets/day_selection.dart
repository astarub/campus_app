import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

/// This widget displays 5 buttons in order to pick between the weekdays.
class MensaDaySelection extends StatefulWidget {
  /// Is executed whenever the the selected day changes.
  /// Returns the new selected value, which can be anything from 0 to 4 (Monday to Friday).
  final void Function(int, DateTime) onChanged;

  const MensaDaySelection({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MensaDaySelection> createState() => _MensaDaySelectionState();
}

class _MensaDaySelectionState extends State<MensaDaySelection> {
  int selectedDay = 0;
  late final List<String> weekDates;

  ScrollController controller = ScrollController();

  bool leftArrowShown = false;
  bool rightArrowShown = true;

  /// This function calculates the dates depending on the current day `DateTime.now()`
  /// to show the dates of this week in the [MensaDaySelection] widget
  List<String> _generateDays() {
    final calculatedDates = <String>[];

    DateTime today = DateTime.now();

    if (today.weekday == 6) {
      today = today.add(const Duration(days: -1));
    } else if (today.weekday == 7) {
      today = today.add(const Duration(days: -2));
    }

    switch (today.weekday) {
      case 1: // Monday
        calculatedDates.add(DateFormat('dd.MM').format(today));
        for (int i = 1; i <= 4; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        for (int i = 7; i <= 11; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        break;
      case 2: // Tuesday
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -1))));
        calculatedDates.add(DateFormat('dd.MM').format(today));
        for (int i = 1; i <= 3; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        for (int i = 6; i <= 10; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        selectedDay = 1;
        break;
      case 3: // Wednesday
        for (int i = -2; i <= -1; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        calculatedDates.add(DateFormat('dd.MM').format(today));
        for (int i = 1; i <= 2; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        for (int i = 5; i <= 9; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        selectedDay = 2;
        break;
      case 4: // Thursday
        for (int i = -3; i <= -1; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        calculatedDates.add(DateFormat('dd.MM').format(today));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 1))));
        for (int i = 4; i <= 8; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        selectedDay = 3;
        break;
      default: // Friday, Saturday or Sunday
        for (int i = -4; i <= -1; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        calculatedDates.add(DateFormat('dd.MM').format(today));
        for (int i = 3; i <= 7; i++) {
          calculatedDates.add(DateFormat('dd.MM').format(today.add(Duration(days: i))));
        }
        selectedDay = 4;
        break;
    }

    return calculatedDates;
  }

  void selectDay(int selected, DateTime date) {
    setState(() => selectedDay = selected);
    widget.onChanged(selected, date);
  }

  @override
  void initState() {
    super.initState();

    weekDates = _generateDays();

    controller.addListener(() {
      if (controller.offset > 2) {
        setState(() {
          leftArrowShown = true;
        });
      } else {
        setState(() {
          leftArrowShown = false;
        });
      }

      if (controller.offset > controller.position.maxScrollExtent - 2) {
        setState(() {
          rightArrowShown = false;
        });
      } else {
        setState(() {
          rightArrowShown = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 65,
          child: ListView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              MensaDaySelectionItem(
                day: 'Mo',
                date: weekDates[0],
                onTap: () => selectDay(
                  0,
                  DateFormat('dd.MM').parse(weekDates[0]).copyWith(
                        year: now.year,
                        hour: now.hour,
                        minute: now.minute,
                        second: now.second,
                      ),
                ),
                isActive: selectedDay == 0,
              ),
              MensaDaySelectionItem(
                day: 'Di',
                date: weekDates[1],
                onTap: () => selectDay(
                  1,
                  DateFormat('dd.MM').parse(weekDates[1]).copyWith(
                        year: now.year,
                        hour: now.hour,
                        minute: now.minute,
                        second: now.second,
                      ),
                ),
                isActive: selectedDay == 1,
              ),
              MensaDaySelectionItem(
                day: 'Mi',
                date: weekDates[2],
                onTap: () => selectDay(
                  2,
                  DateFormat('dd.MM').parse(weekDates[2]).copyWith(
                        year: now.year,
                        hour: now.hour,
                        minute: now.minute,
                        second: now.second,
                      ),
                ),
                isActive: selectedDay == 2,
              ),
              MensaDaySelectionItem(
                day: 'Do',
                date: weekDates[3],
                onTap: () => selectDay(
                  3,
                  DateFormat('dd.MM').parse(weekDates[3]).copyWith(
                        year: now.year,
                        hour: now.hour,
                        minute: now.minute,
                        second: now.second,
                      ),
                ),
                isActive: selectedDay == 3,
              ),
              MensaDaySelectionItem(
                day: 'Fr',
                date: weekDates[4],
                onTap: () => selectDay(
                  4,
                  DateFormat('dd.MM').parse(weekDates[4]).copyWith(
                        year: now.year,
                        hour: now.hour,
                        minute: now.minute,
                        second: now.second,
                      ),
                ),
                isActive: selectedDay == 4,
              ),
              VerticalDivider(
                color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
              ),
              MensaDaySelectionItem(
                day: 'Mo',
                date: weekDates[5],
                onTap: () => selectDay(
                  5,
                  DateFormat('dd.MM').parse(weekDates[5]).copyWith(
                        year: now.year,
                        hour: now.hour,
                        minute: now.minute,
                        second: now.second,
                      ),
                ),
                isActive: selectedDay == 5,
              ),
              MensaDaySelectionItem(
                day: 'Di',
                date: weekDates[6],
                onTap: () => selectDay(
                  6,
                  DateFormat('dd.MM').parse(weekDates[6]).copyWith(
                        year: now.year,
                        hour: now.hour,
                        minute: now.minute,
                        second: now.second,
                      ),
                ),
                isActive: selectedDay == 6,
              ),
              MensaDaySelectionItem(
                day: 'Mi',
                date: weekDates[7],
                onTap: () => selectDay(
                  7,
                  DateFormat('dd.MM').parse(weekDates[7]).copyWith(
                        year: now.year,
                        hour: now.hour,
                        minute: now.minute,
                        second: now.second,
                      ),
                ),
                isActive: selectedDay == 7,
              ),
              MensaDaySelectionItem(
                day: 'Do',
                date: weekDates[8],
                onTap: () => selectDay(
                  8,
                  DateFormat('dd.MM').parse(weekDates[8])
                    ..copyWith(
                      year: now.year,
                      hour: now.hour,
                      minute: now.minute,
                      second: now.second,
                    ),
                ),
                isActive: selectedDay == 8,
              ),
              MensaDaySelectionItem(
                day: 'Fr',
                date: weekDates[9],
                onTap: () => selectDay(
                  9,
                  DateFormat('dd.MM').parse(weekDates[9])
                    ..copyWith(
                      year: now.year,
                      hour: now.hour,
                      minute: now.minute,
                      second: now.second,
                    ),
                ),
                isActive: selectedDay == 9,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: leftArrowShown
                    ? Icon(
                        Icons.keyboard_arrow_left,
                        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: rightArrowShown
                    ? Icon(
                        Icons.keyboard_arrow_right,
                        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// This widget represents one of the five items in the [MensaDaySelection] widget.
class MensaDaySelectionItem extends StatelessWidget {
  /// The weekday that is displayed in the top of the button
  final String day;

  /// The exact date that is displayed below the weekday
  final String date;

  /// The function that is executed when the button is pressed.
  /// Usually this updates a variable in the parent widget.
  final VoidCallback onTap;

  /// Wether the SelectionItem is the currently active one or not
  final bool isActive;

  const MensaDaySelectionItem({
    Key? key,
    required this.day,
    required this.date,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.shortestSide < 600 ? 5 : 20),
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
            ? isActive
                ? Colors.black
                : const Color.fromRGBO(245, 246, 250, 1)
            : isActive
                ? const Color.fromRGBO(34, 40, 54, 1)
                : const Color.fromRGBO(18, 24, 38, 1),
        borderRadius: BorderRadius.circular(15),
        border: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.dark
            ? Border.all(color: const Color.fromRGBO(34, 40, 54, 1))
            : null,
      ),
      child: Material(
        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
            ? isActive
                ? Colors.black
                : const Color.fromRGBO(245, 246, 250, 1)
            : isActive
                ? const Color.fromRGBO(34, 40, 54, 1)
                : const Color.fromRGBO(18, 24, 38, 1),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          splashColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? isActive
                  ? const Color.fromRGBO(255, 255, 255, 0.12)
                  : const Color.fromRGBO(0, 0, 0, 0.06)
              : const Color.fromRGBO(255, 255, 255, 0.06),
          highlightColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? isActive
                  ? const Color.fromRGBO(255, 255, 255, 0.08)
                  : const Color.fromRGBO(0, 0, 0, 0.04)
              : const Color.fromRGBO(255, 255, 255, 0.04),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
            child: Center(
              child: FittedBox(
                child: Column(
                  children: [
                    Text(
                      day,
                      style: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? isActive
                              ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium
                              : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium?.copyWith(
                                    color: Colors.black,
                                  )
                          : isActive
                              ? Provider.of<ThemesNotifier>(context)
                                  .currentThemeData
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.white)
                              : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium,
                    ),
                    Text(
                      date,
                      style: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? isActive
                              ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.copyWith(
                                    color: Colors.white70,
                                  )
                              : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium
                          : isActive
                              ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium
                              : Provider.of<ThemesNotifier>(context)
                                  .currentThemeData
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
