import 'package:calendar_view/calendar_view.dart';
import 'package:campus_app/pages/planner/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/core/themes.dart';
import 'package:intl/intl.dart';

// WeekViewCalendar UI widget.
class WeekViewCalendar extends StatelessWidget {
  const WeekViewCalendar({
    super.key,
    required this.themesNotifier,
    required this.focusedDay,
    required this.eventController,
    required this.onEventTap,
    this.timeLineWidth = 30,
    required this.onDateTap,
  });

  final ThemesNotifier themesNotifier;
  final DateTime focusedDay;
  final EventController<PlannerEventEntity> eventController;
  final void Function(PlannerEventEntity event) onEventTap;
  final double timeLineWidth;
  final void Function(
    List<CalendarEventData<PlannerEventEntity>> events,
    DateTime date,
  ) onDateTap;

  Widget _buildFullDayRow(
    BuildContext context,
    List<CalendarEventData<PlannerEventEntity>> events,
    DateTime _,
  ) {
    return EventTile(
      events: events,
      onEventTap: onEventTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = themesNotifier.currentThemeData;
    return WeekView<PlannerEventEntity>(
      key: ValueKey('week_view_$focusedDay'),
      controller: eventController,
      initialDay: focusedDay,
      onDateTap: (date) {
        final events = eventController.getEventsOnDay(date);
        onDateTap(events, date);
      },
      timeLineWidth: timeLineWidth,
      backgroundColor: theme.colorScheme.surface,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(color: theme.colorScheme.secondary),
      weekDayStringBuilder: (d) => DateFormat.E().format(DateTime(2024, 1, d == 7 ? 8 : d + 1)),
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
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      fullDayEventBuilder: (e, d) => _buildFullDayRow(context, e, d),
      hourIndicatorSettings: HourIndicatorSettings(
        color: theme.dividerColor,
      ),
    );
  }
}
