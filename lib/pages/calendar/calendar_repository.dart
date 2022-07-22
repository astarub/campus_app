import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/calendar/calendar_event_entity.dart';
import 'package:campus_app/pages/calendar/calendar_event_model.dart';
import 'package:campus_app/pages/calendar/calendar_remote_datasource.dart';
import 'package:dartz/dartz.dart';

abstract class CalendarRepository {
  /// return a list of events or a failure
  Future<Either<Failure, List<CalendarEventEntity>>> getAStAEvents();
}

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDatasource calendarRemoteDatasource;

  CalendarRepositoryImpl({required this.calendarRemoteDatasource});

  @override
  Future<Either<Failure, List<CalendarEventEntity>>> getAStAEvents() async {
    try {
      final astaEventsJson =
          await calendarRemoteDatasource.getAStAEventsAsJsonArray();

      final List<CalendarEventEntity> entities = [];

      for (final element in astaEventsJson) {
        entities
            .add(CalendarEventModel.fromJson(element as Map<String, dynamic>));
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
