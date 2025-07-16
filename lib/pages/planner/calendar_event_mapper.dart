import 'package:calendar_view/calendar_view.dart';
import 'package:rrule/rrule.dart';

import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';

bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

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
  final start = event.startDateTime.toLocal();
  final end = event.endDateTime.toLocal();
  if (_sameDay(start, end)) {
    sink.add(
      CalendarEventData<PlannerEventEntity>(
        title: event.title,
        description: event.description,
        date: start,
        startTime: start,
        endTime: end,
        event: event,
      ),
    );
  } else {
    sink.add(
      CalendarEventData<PlannerEventEntity>(
        title: event.title,
        description: event.description,
        date: start,
        endDate: end,
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
  final duration = template.endDateTime.toLocal().difference(template.startDateTime.toLocal());

  final instances = rule.getInstances(
    start: template.startDateTime.toUtc(),
    before: DateTime.now().toUtc().add(const Duration(days: 365 * 2)),
  );

  for (final startUtc in instances) {
    final start = startUtc.toLocal();
    final end = start.add(duration);

    if (_sameDay(start, end)) {
      sink.add(
        CalendarEventData<PlannerEventEntity>(
          title: template.title,
          description: template.description,
          date: start,
          startTime: start,
          endTime: end,
          color: template.color,
          event: template,
        ),
      );
    } else {
      sink.add(
        CalendarEventData<PlannerEventEntity>(
          title: template.title,
          description: template.description,
          date: start,
          endDate: end,
          color: template.color,
          event: template,
        ),
      );
    }
  }
}
