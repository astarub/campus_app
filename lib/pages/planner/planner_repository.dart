import 'package:dartz/dartz.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/planner/planner_datasource.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:hive/hive.dart';

class PlannerRepository {
  final PlannerDatasource plannerDatasource;
  PlannerRepository(this.plannerDatasource);

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

  Future<Either<Failure, Unit>> upsert(PlannerEventEntity event) async {
    try {
      await plannerDatasource.put(event);
      return right(unit);
    } catch (e) {
      if (e is HiveError) return left(StorageFailure());
      rethrow;
    }
  }

  Future<Either<Failure, Unit>> remove(String id) async {
    try {
      await plannerDatasource.delete(id);
      return right(unit);
    } catch (e) {
      if (e is HiveError) return left(StorageFailure());
      rethrow;
    }
  }

  Stream<void> watch() => plannerDatasource.watch().map((_) {});
}
