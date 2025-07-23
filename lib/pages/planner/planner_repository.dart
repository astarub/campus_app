import 'package:dartz/dartz.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/planner/planner_datasource.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:hive/hive.dart';

// Acts as a façade between data layer and domain/use‑case layers.
class PlannerRepository {
  final PlannerDatasource plannerDatasource;
  PlannerRepository(this.plannerDatasource);

  // Reads events from the datasource and returns them sorted by start time.
  Future<Either<Failure, List<PlannerEventEntity>>> getEvents() async {
    try {
      final list = await plannerDatasource.readAll();
      list.sort(
        (a, b) => a.startDateTime.compareTo(b.startDateTime),
      );
      return right(list);
    } catch (e) {
      if (e is HiveError) return left(StorageFailure());
      rethrow;
    }
  }

  // Persists a new or existing event.
  Future<Either<Failure, Unit>> upsert(PlannerEventEntity event) async {
    try {
      await plannerDatasource.put(event);
      return right(unit);
    } catch (e) {
      if (e is HiveError) return left(StorageFailure());
      rethrow;
    }
  }

  // Deletes an existing event.
  Future<Either<Failure, Unit>> remove(String id) async {
    try {
      await plannerDatasource.delete(id);
      return right(unit);
    } catch (e) {
      if (e is HiveError) return left(StorageFailure());
      rethrow;
    }
  }

  // Relay watch stream from datasource to notify callers of changes.
  Stream<void> watch() => plannerDatasource.watch().map((_) {});
}
