import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/calendar/calendar_datasource.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CalendarRepository {
  /// return a list of events or a failure
  Future<Either<Failure, List<Event>>> getAStAEvents();
}

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarDatasource calendarRemoteDatasource;

  CalendarRepositoryImpl({required this.calendarRemoteDatasource});

  @override
  Future<Either<Failure, List<Event>>> getAStAEvents() async {
    try {
      final astaEventsJson = await calendarRemoteDatasource.getAStAEventsAsJsonArray();

      final List<Event> entities = [];

      for (final element in astaEventsJson) {
        entities.add(Event.fromJson(element));
      }

      return Right(entities);
    } catch (e) {
      switch (e.runtimeType) {
        case ServerException:
          return Left(ServerFailure());

        case EmptyResponseException:
          return Left(ServerFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }
}
