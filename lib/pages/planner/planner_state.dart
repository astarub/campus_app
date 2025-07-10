import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:hive/hive.dart';

class PlannerState with ChangeNotifier {
  final List<PlannerEventEntity> _events = [];
  List<PlannerEventEntity> get events => UnmodifiableListView(_events);
  late final Box<PlannerEventEntity> _box;
  late final StreamSubscription<BoxEvent> _sub;

  PlannerState() {
    _box = Hive.box<PlannerEventEntity>('planner_events');
    _events.addAll(_box.values);
    _sortEvents();
    _sub = _box.watch().listen(_onBoxEvent);
  }
  void addEvent(PlannerEventEntity event) {
    _events.add(event);
    _sortEvents();
    _box.put(event.id, event);
    notifyListeners();
  }

  void deleteEvent(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
    _box.delete(eventId);
    notifyListeners();
  }

  void updateEvent(PlannerEventEntity updatedEvent) {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      _sortEvents();
      _box.put(updatedEvent.id, updatedEvent);
      notifyListeners();
    }
  }

  void _sortEvents() {
    _events.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  void _onBoxEvent(BoxEvent event) {
    if (!event.deleted && event.value is PlannerEventEntity) {
      final entity = event.value as PlannerEventEntity;
      final idx = _events.indexWhere((e) => e.id == entity.id);
      if (idx == -1) {
        _events.add(entity);
      } else {
        _events[idx] = entity;
      }
    } else if (event.deleted) {
      _events.removeWhere((e) => e.id == event.key);
    }
    _sortEvents();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
