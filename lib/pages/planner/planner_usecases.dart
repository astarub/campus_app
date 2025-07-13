import 'package:dartz/dartz.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_repository.dart';

class PlannerUsecases {
  final PlannerRepository plannerRepository;
  PlannerUsecases(this.plannerRepository);

  Future<Either<Failure, List<PlannerEventEntity>>> fetchEvents() => plannerRepository.getEvents();

  Future<Either<Failure, Unit>> addEvent(PlannerEventEntity e) => plannerRepository.upsert(e);

  Future<Either<Failure, Unit>> updateEvent(PlannerEventEntity e) => plannerRepository.upsert(e);

  Future<Either<Failure, Unit>> deleteEvent(String id) => plannerRepository.remove(id);

  Stream<void> watch() => plannerRepository.watch();
}
