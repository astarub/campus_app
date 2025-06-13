import 'package:flutter/foundation.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';

class PlannerState with ChangeNotifier {
  // This list will hold all the events in the planner
  final List<PlannerEventEntity> _events = [];
  List<PlannerEventEntity> get events => _events;

  void addEvent(PlannerEventEntity event) {
    _events.add(event);

    // Sort all events by their full start date and time to keep the list chronological
    _events.sort((a, b) {
      final aDateTime = DateTime(a.date.year, a.date.month, a.date.day, a.startTime.hour, a.startTime.minute);
      final bDateTime = DateTime(b.date.year, b.date.month, b.date.day, b.startTime.hour, b.startTime.minute);
      return aDateTime.compareTo(bDateTime);
    });

    // Notify listeners that the list of events has changed
    notifyListeners();
  }

  // You can add methods for updating and deleting events here later
  // void deleteEvent(PlannerEventEntity event) {
  //   _events.remove(event);
  //   notifyListeners();
  // }
}
