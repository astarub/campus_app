import 'package:flutter/foundation.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';

class PlannerState with ChangeNotifier {
  final List<PlannerEventEntity> _events = [];
  List<PlannerEventEntity> get events => _events;

  void addEvent(PlannerEventEntity event) {
    _events.add(event);
    _sortEvents();
    notifyListeners();
  }

  void deleteEvent(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }

  void updateEvent(PlannerEventEntity updatedEvent) {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      _sortEvents();
      notifyListeners();
    }
  }

  // Helper method to keep events sorted
  void _sortEvents() {
    _events.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }
}
