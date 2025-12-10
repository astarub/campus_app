import 'package:calendar_view/calendar_view.dart';
import 'package:campus_app/pages/planner/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/core/themes.dart';

/// AUTOMATISCHE TEXTFARBE – KONTRAST
Color getReadableTextColor(Color backgroundColor) {
  double brightness = (backgroundColor.red * 0.299) +
      (backgroundColor.green * 0.587) +
      (backgroundColor.blue * 0.114);

  return brightness < 150 ? Colors.white : Colors.black;
}

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

      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: theme.colorScheme.secondary,
      ),

      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.headlineSmall,
        leftIconConfig: IconDataConfig(color: theme.colorScheme.primary),
        rightIconConfig: IconDataConfig(color: theme.colorScheme.primary),
      ),

      /// *** DAY EVENT BUILDER ***
      eventTileBuilder: (date, events, boundary, start, end) {
        final ev = events.first;
        final backgroundColor = ev.color.withOpacity(0.90);
        final textColor = getReadableTextColor(ev.color);

        return GestureDetector(
          onTap: () => onEventTap(ev.event!),

          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),

            child: Text(
              ev.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
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
