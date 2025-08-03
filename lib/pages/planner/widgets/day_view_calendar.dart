import 'package:calendar_view/calendar_view.dart';
import 'package:campus_app/pages/planner/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/core/themes.dart';

// DayViewCalendar UI widget.
class DayViewCalendar extends StatelessWidget {
  const DayViewCalendar({
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
  final void Function(PlannerEventEntity) onEventTap;
  final void Function(DateTime date) onDateTap;

  @override
  Widget build(BuildContext context) {
    final theme = themesNotifier.currentThemeData;
    return DayView<PlannerEventEntity>(
      key: ValueKey('day_view_$focusedDay'),
      controller: eventController,
      initialDay: focusedDay,
      onDateTap: onDateTap,
      showLiveTimeLineInAllDays: true,
      timeLineWidth: 50,
      backgroundColor: theme.colorScheme.surface,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(color: theme.colorScheme.secondary),
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.headlineSmall,
        leftIconConfig: IconDataConfig(
          color: theme.colorScheme.primary,
        ),
        rightIconConfig: IconDataConfig(
          color: theme.colorScheme.primary,
        ),
      ),
      eventTileBuilder: (date, events, boundary, start, end) {
        return GestureDetector(
          onTap: () => onEventTap(events.first.event!),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: events.first.color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              events.first.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
      fullDayEventBuilder: (events, date) {
        return EventTile(
          events: events,
          onEventTap: onEventTap,
        );
      },
      hourIndicatorSettings: HourIndicatorSettings(
        color: theme.dividerColor,
      ),
    );
  }
}
