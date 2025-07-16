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
  });

  final ThemesNotifier themesNotifier;
  final DateTime focusedDay;
  final EventController<PlannerEventEntity> eventController;
  final void Function(PlannerEventEntity event) onEventTap;

  @override
  Widget build(BuildContext context) {
    final theme = themesNotifier.currentThemeData;
    return DayView<PlannerEventEntity>(
      key: ValueKey('day_view_$focusedDay'),
      controller: eventController,
      initialDay: focusedDay,
      showLiveTimeLineInAllDays: true,
      timeLineWidth: 60,
      backgroundColor: theme.colorScheme.surface,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(color: theme.colorScheme.secondary),
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.titleLarge,
      ),
      eventTileBuilder: (date, events, boundary, start, end) {
        return eventTile(events, () => onEventTap(events.first.event!));
      },
      fullDayEventBuilder: (events, date) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: eventTile(events, () => onEventTap(events.first.event!)),
            );
          },
        );
      },
    );
  }
}
