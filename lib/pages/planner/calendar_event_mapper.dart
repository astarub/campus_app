import 'package:calendar_view/calendar_view.dart';
import 'package:rrule/rrule.dart';

import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_utils.dart';

List<CalendarEventData<PlannerEventEntity>> mapPlannerEvents(List<PlannerEventEntity> raw) {
  final List<CalendarEventData<PlannerEventEntity>> out = [];

  for (final event in raw) {
    if (event.rrule == null) {
      _expandSingle(event, out);
    } else {
      try {
        _expandRecurring(event, out);
      } catch (_) {
        _expandSingle(event, out);
      }
    }
  }
  return out;
}

void _expandSingle(
  PlannerEventEntity event,
  List<CalendarEventData<PlannerEventEntity>> sink,
) {
  final days = getDaysInBetween(event.startDateTime, event.endDateTime);
  for (final day in days) {
    final isFirst = day.isAtSameMomentAs(days.first);
    final isLast = day.isAtSameMomentAs(days.last);

    final start = isFirst ? event.startDateTime : DateTime.utc(day.year, day.month, day.day);

    final end = isLast ? event.endDateTime : DateTime.utc(day.year, day.month, day.day, 23, 59, 59);

    sink.add(
      CalendarEventData(
        date: day.toLocal(),
        startTime: start,
        endTime: end,
        title: event.title,
        description: event.description ?? '',
        color: event.color,
        event: event,
      ),
    );
  }
}

void _expandRecurring(
  PlannerEventEntity template,
  List<CalendarEventData<PlannerEventEntity>> sink,
) {
  final rule = RecurrenceRule.fromString(template.rrule!);
  final duration = template.endDateTime.difference(template.startDateTime);

  final instances = rule.getInstances(
    start: template.startDateTime,
    before: DateTime.now().toUtc().add(const Duration(days: 365 * 2)),
  );

  for (final start in instances) {
    final end = start.add(duration);

    final days = getDaysInBetween(start, end);
    for (final day in days) {
      final isFirst = day.isAtSameMomentAs(days.first);
      final isLast = day.isAtSameMomentAs(days.last);

      final dayStart = isFirst ? start : DateTime.utc(day.year, day.month, day.day);

      final dayEnd = isLast ? end : DateTime.utc(day.year, day.month, day.day, 23, 59, 59);

      sink.add(
        CalendarEventData(
          date: day.toLocal(),
          startTime: dayStart,
          endTime: dayEnd,
          title: template.title,
          description: template.description ?? '',
          color: template.color,
          event: template,
        ),
      );
    }
  }
}
