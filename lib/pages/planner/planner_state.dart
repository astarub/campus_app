import 'dart:async';
import 'dart:collection';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_usecases.dart';

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
