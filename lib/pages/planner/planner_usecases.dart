import 'package:dartz/dartz.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_repository.dart';

// Collection of commands/queries that the UI layer can call.
class PlannerUsecases {
  final PlannerRepository plannerRepository;
  PlannerUsecases(this.plannerRepository);

  // Fetch all stored events.
  Future<Either<Failure, List<PlannerEventEntity>>> fetchEvents() => plannerRepository.getEvents();

  // Add a new event.
  Future<Either<Failure, Unit>> addEvent(PlannerEventEntity e) => plannerRepository.upsert(e);

  // Update an existing event.
  Future<Either<Failure, Unit>> updateEvent(PlannerEventEntity e) => plannerRepository.upsert(e);

  // Delete an event by id.
  Future<Either<Failure, Unit>> deleteEvent(String id) => plannerRepository.remove(id);

  // Expose underlying change stream.
  Stream<void> watch() => plannerRepository.watch();
}
