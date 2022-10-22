import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

/// This widget displays 5 buttons in order to pick between the weekdays.
class MensaDaySelection extends StatefulWidget {
  /// Is executed whenever the the selected day changes.
  /// Returns the new selected value, which can be anything from 0 to 4 (Monday to Friday).
  final void Function(int) onChanged;

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

  /// This function calculates the dates depending on the current day `DateTime.now()`
  /// to show the dates of this week in the [MensaDaySelection] widget
  List<String> _generateDays() {
    List<String> calculatedDates = [];

    DateTime today = DateTime.now();

    if (today.weekday == 6) {
      today = today.add(const Duration(days: -1));
    } else if (today.weekday == 7) {
      today = today.add(const Duration(days: -2));
    }

    switch (today.weekday) {
      case 1: // Monday
        calculatedDates.add(DateFormat('dd.MM').format(today));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 1))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 2))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 3))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 4))));
        break;
      case 2: // Tuesday
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -1))));
        calculatedDates.add(DateFormat('dd.MM').format(today));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 1))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 2))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 3))));
        selectedDay = 1;
        break;
      case 3: // Wednesday
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -2))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -1))));
        calculatedDates.add(DateFormat('dd.MM').format(today));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 1))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 2))));
        selectedDay = 2;
        break;
      case 4: // Thursday
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -3))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -2))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -1))));
        calculatedDates.add(DateFormat('dd.MM').format(today));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: 1))));
        selectedDay = 3;
        break;
      default: // Friday, Saturday or Sunday
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -4))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -3))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -2))));
        calculatedDates.add(DateFormat('dd.MM').format(today.add(const Duration(days: -1))));
        calculatedDates.add(DateFormat('dd.MM').format(today));
        selectedDay = 4;
        break;
    }

    return calculatedDates;
  }

  void selectDay(int selected) {
    setState(() => selectedDay = selected);
    widget.onChanged(selected);
  }

  @override
  void initState() {
    super.initState();

    weekDates = _generateDays();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MensaDaySelectionItem(day: 'Mo', date: weekDates[0], onTap: () => selectDay(0), isActive: selectedDay == 0),
        MensaDaySelectionItem(day: 'Di', date: weekDates[1], onTap: () => selectDay(1), isActive: selectedDay == 1),
        MensaDaySelectionItem(day: 'Mi', date: weekDates[2], onTap: () => selectDay(2), isActive: selectedDay == 2),
        MensaDaySelectionItem(day: 'Do', date: weekDates[3], onTap: () => selectDay(3), isActive: selectedDay == 3),
        MensaDaySelectionItem(day: 'Fr', date: weekDates[4], onTap: () => selectDay(4), isActive: selectedDay == 4),
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
  bool isActive;

  MensaDaySelectionItem({
    Key? key,
    required this.day,
    required this.date,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: day != 'Fr' ? const EdgeInsets.only(right: 10) : EdgeInsets.zero,
      child: Material(
        color: isActive ? Colors.black : const Color.fromRGBO(245, 246, 250, 1),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          splashColor: isActive ? const Color.fromRGBO(255, 255, 255, 0.12) : const Color.fromRGBO(0, 0, 0, 0.06),
          highlightColor: isActive ? const Color.fromRGBO(255, 255, 255, 0.08) : const Color.fromRGBO(0, 0, 0, 0.04),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Center(
              child: Column(
                children: [
                  Text(
                    day,
                    style: isActive
                        ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium
                        : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium?.copyWith(
                              color: Colors.black,
                            ),
                  ),
                  Text(
                    date,
                    style: isActive
                        ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.copyWith(
                              color: Colors.white70,
                            )
                        : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
