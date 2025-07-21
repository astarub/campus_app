import 'package:calendar_view/calendar_view.dart';
import 'package:campus_app/pages/planner/widgets/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/core/themes.dart';

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
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
      fullDayEventBuilder: (events, date) {
        return eventTile(events, onEventTap);
      },
    );
  }
}
