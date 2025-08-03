import 'package:hive/hive.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';

// Thin wrapper around the Hive box used to store planner events locally.
class PlannerDatasource {
  static const _boxName = 'planner_events';

  Box<PlannerEventEntity> get _box => Hive.box<PlannerEventEntity>(_boxName);

  // Emits whenever any change happens in the events box.
  Stream<BoxEvent> watch() => _box.watch();

  // Reads all events from storage, preserving insertion order.
  Future<List<PlannerEventEntity>> readAll() async => _box.values.toList(growable: false);

  // Inserts or updates (upserts) an event by its id.
  Future<void> put(PlannerEventEntity event) => _box.put(event.id, event);

  // Removes an event by id.
  Future<void> delete(String id) => _box.delete(id);
}
