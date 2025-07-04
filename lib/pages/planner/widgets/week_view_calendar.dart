import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/core/themes.dart';
import 'package:intl/intl.dart';

class WeekViewCalendar extends StatelessWidget {
  const WeekViewCalendar({
    super.key,
    required this.themesNotifier,
    required this.focusedDay,
    required this.eventController,
    required this.onEventTap,
  });

  final ThemesNotifier themesNotifier;
  final DateTime focusedDay;
  final EventController<PlannerEventEntity> eventController;
  final void Function(PlannerEventEntity event) onEventTap;

  @override
  Widget build(BuildContext context) {
    final theme = themesNotifier.currentThemeData;
    return WeekView<PlannerEventEntity>(
      key: ValueKey('week_view_$focusedDay'),
      controller: eventController,
      initialDay: focusedDay,
      showLiveTimeLineInAllDays: true,
      timeLineWidth: 60,
      backgroundColor: theme.colorScheme.surface,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(color: theme.colorScheme.secondary),
      weekDayStringBuilder: (int day) => DateFormat.E().format(DateTime(2024, 1, day == 7 ? 8 : day + 1)),
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.titleLarge,
      ),
      eventTileBuilder: (date, events, boundary, start, end) {
        return GestureDetector(
          onTap: () => onEventTap(events.first.event!),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: events.first.color.withAlpha(220),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              events.first.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
          ),
        );
      },
    );
  }
}
