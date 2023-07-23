import 'dart:async';

import 'package:dartz/dartz.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/calendar/calendar_datasource.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';

class CalendarRepository {
  final CalendarDatasource calendarDatasource;

  CalendarRepository({required this.calendarDatasource});

  /// Return a list of events or a failure
  Future<Either<Failure, List<Event>>> getAStAEvents() async {
    try {
      final astaEventsJson = await calendarDatasource.getAStAEventsAsJsonArray();

      final List<Event> entities = [];

      for (final Map<String, dynamic> eventJson in astaEventsJson) {
        final Event event = Event.fromExternalJson(eventJson);

        if (event.categories.map((cat) => cat.name).contains('UFO')) continue;

        entities.add(event);
      }

      // write entities to cach
      unawaited(calendarDatasource.writeEventsToCach(entities));

      return Right(entities);
    } catch (e) {
      switch (e.runtimeType) {
        case ServerException:
          return Left(ServerFailure());

        case JsonException:
          return Left(ServerFailure());

        case EmptyResponseException:
          return Left(NoDataFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }

  /// Return a list of cached events or a failure.
  Either<Failure, List<Event>> getCachedEvents() {
    try {
      final cachedEvents = calendarDatasource.readEventsFromCach();
      return Right(cachedEvents);
    } catch (e) {
      return Left(CachFailure());
    }
  }

  /// Return a list of saved events or a failure.
  Future<Either<Failure, List<Event>>> updateSavedEvents({Event? event}) async {
    try {
      final savedEvents = calendarDatasource.readEventsFromCach(saved: true);

      // update list of saved events
      if (event != null) {
        if (savedEvents.contains(event)) {
          savedEvents.remove(event);
        } else {
          savedEvents.add(event);
        }
      }

      unawaited(calendarDatasource.writeEventsToCach(savedEvents, saved: true));

      return Right(savedEvents);
    } catch (e) {
      return Left(CachFailure());
    }
  }
}
