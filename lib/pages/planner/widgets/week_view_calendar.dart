import 'package:calendar_view/calendar_view.dart';
import 'package:campus_app/pages/planner/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/core/themes.dart';
import 'package:intl/intl.dart';

/// AUTOMATISCHE TEXTFARBE – KONTRAST
Color getReadableTextColor(Color backgroundColor) {
  double brightness = (backgroundColor.red * 0.299) +
      (backgroundColor.green * 0.587) +
      (backgroundColor.blue * 0.114);

  return brightness < 150 ? Colors.white : Colors.black;
}

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
      showLiveTimeLineInAllDays: true,
      initialDay: focusedDay,

      onDateTap: (date) {
        final events = eventController.getEventsOnDay(date);
        onDateTap(events, date);
      },

      timeLineWidth: timeLineWidth,
      backgroundColor: theme.colorScheme.surface,

      liveTimeIndicatorSettings:
          (DateTime.now().year == focusedDay.year &&
                  DateTime.now().month == focusedDay.month &&
                  DateTime.now().day == focusedDay.day)
              ? LiveTimeIndicatorSettings(
                  color: theme.colorScheme.secondary,
                )
              : LiveTimeIndicatorSettings(
                  color: const Color.fromARGB(0, 0, 0, 0),
                ),

      weekDayStringBuilder: (d) =>
          DateFormat.E().format(DateTime(2024, 1, d == 7 ? 8 : d + 1)),

      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.headlineSmall,
        leftIconConfig: IconDataConfig(color: theme.colorScheme.primary),
        rightIconConfig: IconDataConfig(color: theme.colorScheme.primary),
      ),

      /// *** WEEKLY EVENT BUILDER ***
      eventTileBuilder: (date, events, boundary, start, end) {
        final ev = events.first;
        final backgroundColor = ev.color.withOpacity(0.90);
        final textColor = getReadableTextColor(ev.color);

        return GestureDetector(
          onTap: () => onEventTap(ev.event!),

          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),

            child: Center(
              child: Text(
                ev.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
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
