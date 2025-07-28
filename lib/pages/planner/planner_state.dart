import 'dart:async';
import 'dart:collection';
import 'package:dartz/dartz.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_usecases.dart';
import 'package:flutter/material.dart';

// Application state for Planner feature, to be provided via Provider.
class PlannerState with ChangeNotifier {
  final PlannerUsecases plannerUsecases;
  PlannerState(this.plannerUsecases);

  final List<PlannerEventEntity> _events = [];
  UnmodifiableListView<PlannerEventEntity> get events => UnmodifiableListView(_events);

  Failure? _lastFailure;
  Failure? get lastFailure => _lastFailure;

  StreamSubscription<void>? _updates;

  Future<void> init() async {
    await _refresh();
    _updates = plannerUsecases.watch().listen((_) => _refresh());
  }

  // CRUD
  Future<void> addEvent(PlannerEventEntity e) => _run(() => plannerUsecases.addEvent(e));
  Future<void> updateEvent(PlannerEventEntity e) => _run(() => plannerUsecases.updateEvent(e));
  Future<void> deleteEvent(String id) => _run(() => plannerUsecases.deleteEvent(id));

  // Private helpers
  Future<void> _refresh() async {
    final result = await plannerUsecases.fetchEvents();
    result.fold(
      _setFailure,
      (list) {
        _events
          ..clear()
          ..addAll(list);
        _lastFailure = null;
      },
    );
    notifyListeners();
  }

  Future<void> _run(
    Future<Either<Failure, Unit>> Function() op,
  ) async {
    final result = await op();
    result.fold(_setFailure, (_) => _lastFailure = null);
    await _refresh();
  }

  void _setFailure(Failure f) {
    _lastFailure = f;
    notifyListeners();
  }

  // Resource cleanup
  Future<void> disposeWatcher() async => await _updates?.cancel();

  @override
  void dispose() {
    disposeWatcher();
    super.dispose();
  }
}

extension MealEvents on PlannerState {
  Future<void> addMealEventFromPrimitives({
    required String title,
    required String price,
    required String location,
    required DateTime date,
    TimeOfDay time = const TimeOfDay(hour: 12, minute: 0),
    Duration duration = const Duration(hours: 1),
  }) {
    final start = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return addEvent(
      PlannerEventEntity(
        title: title,
        description: '$location   •   $price',
        startDateTime: start,
        endDateTime: start.add(duration),
        color: const Color.fromARGB(255, 11, 138, 0),
      ),
    );
  }
}

// Meal toggle helpers for Mensa integration
extension MealEventToggle on PlannerState {
  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  bool _descMatchesLocation(String? description, String location) {
    final desc = (description ?? '').trim();
    return desc.startsWith(location);
  }

  Iterable<PlannerEventEntity> _matchingMealEvents({
    required String title,
    required String location,
    required DateTime date,
  }) sync* {
    for (final e in events) {
      if (_sameDay(e.startDateTime, date) && e.title == title && _descMatchesLocation(e.description, location)) {
        yield e;
      }
    }
  }

  // Returns true if an event with same `title` and `location` exists on that day.
  bool hasMealEvent({
    required String title,
    required String location,
    required DateTime date,
  }) {
    return _matchingMealEvents(title: title, location: location, date: date).isNotEmpty;
  }

  // Removes all matching meal events for that title/location on the given day.
  Future<void> removeMealEvents({
    required String title,
    required String location,
    required DateTime date,
  }) async {
    final matches = _matchingMealEvents(title: title, location: location, date: date).toList();
    for (final e in matches) {
      await deleteEvent(e.id);
    }
  }

  // Convenience: add if missing, otherwise remove.
  Future<void> toggleMealEvent({
    required String title,
    required String price,
    required String location,
    required DateTime date,
  }) async {
    if (hasMealEvent(title: title, location: location, date: date)) {
      await removeMealEvents(title: title, location: location, date: date);
    } else {
      await addMealEventFromPrimitives(
        title: title,
        price: price,
        location: location,
        date: date,
      );
    }
  }
}
