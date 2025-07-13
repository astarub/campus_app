import 'package:hive/hive.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';

class PlannerDatasource {
  static const _boxName = 'planner_events';

  Box<PlannerEventEntity> get _box => Hive.box<PlannerEventEntity>(_boxName);

  Stream<BoxEvent> watch() => _box.watch();

  Future<List<PlannerEventEntity>> readAll() async => _box.values.toList(growable: false);

  Future<void> put(PlannerEventEntity event) => _box.put(event.id, event);

  Future<void> delete(String id) => _box.delete(id);
}
