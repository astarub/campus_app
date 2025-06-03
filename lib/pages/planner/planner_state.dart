// lib/pages/planner/planner_state.dart
import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'entities/planner_event_entity.dart';

class PlannerState with ChangeNotifier {
  final Map<DateTime, List<PlannerEventEntity>> _events = LinkedHashMap(
    equals: isSameDay,
    hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year,
  );

  UnmodifiableMapView<DateTime, List<PlannerEventEntity>> get events => UnmodifiableMapView(_events);

  List<PlannerEventEntity> getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void addEvent(PlannerEventEntity event) {
    final dateKey = DateTime(event.date.year, event.date.month, event.date.day);
    if (_events[dateKey] == null) {
      _events[dateKey] = [];
    }
    _events[dateKey]!.add(event);
    _events[dateKey]!.sort((a, b) {
      final aDateTime = DateTime(0, 0, 0, a.startTime.hour, a.startTime.minute);
      final bDateTime = DateTime(0, 0, 0, b.startTime.hour, b.startTime.minute);
      return aDateTime.compareTo(bDateTime);
    });
    notifyListeners();
  }

  // TODO: Add methods for updating and deleting events
}
