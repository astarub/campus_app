import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/core/themes.dart';

class MonthViewCalendar extends StatelessWidget {
  const MonthViewCalendar({
    super.key,
    required this.themesNotifier,
    required this.focusedDay,
    required this.eventController,
    required this.onEventTap,
    required this.onDateTap,
  });

  final ThemesNotifier themesNotifier;
  final DateTime focusedDay;
  final EventController<PlannerEventEntity> eventController;
  final void Function(PlannerEventEntity event) onEventTap;
  final void Function(DateTime date) onDateTap;

  @override
  Widget build(BuildContext context) {
    final theme = themesNotifier.currentThemeData;
    return MonthView<PlannerEventEntity>(
      key: ValueKey('month_view_$focusedDay'),
      controller: eventController,
      initialMonth: focusedDay,
      borderColor: theme.dividerColor,
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.titleLarge,
      ),
      weekDayBuilder: (dayIndex) {
        final day = DateTime(2024).add(Duration(days: dayIndex));
        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Center(
            child: Text(
              DateFormat.E().format(day),
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(204),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
      cellBuilder: (date, events, isToday, isInMonth, hideDaysNotInMonth) {
        if (!isInMonth) {
          return Container();
        }

        if (events.isNotEmpty) {
          return GestureDetector(
            onTap: () => onEventTap(events.first.event!),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: events.first.color.withAlpha(220),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${date.day}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white.withAlpha(230),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Text(
                        events.first.title,
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          final backgroundColor = isToday ? theme.primaryColor.withAlpha(51) : theme.colorScheme.surface;
          final textColor = isToday ? theme.primaryColor : theme.colorScheme.onSurface;
          return Container(
            color: backgroundColor,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(color: textColor, fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          );
        }
      },
      onCellTap: (events, date) {
        if (date.month != focusedDay.month) return;
        if (events.isEmpty) onDateTap(date);
      },
    );
  }
}
