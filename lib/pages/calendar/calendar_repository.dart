import 'dart:async';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/calendar/calendar_datasource.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:dartz/dartz.dart';

class CalendarRepository {
  final CalendarDatasource calendarDatasource;

  CalendarRepository({required this.calendarDatasource});

  /// Return a list of events or a failure
  Future<Either<Failure, List<Event>>> getAppEvents() async {
    try {
      final astaEventsJson = await calendarDatasource.getAppEventsAsJsonArray();

      final List<Event> entities = [];

      for (final Map<String, dynamic> event in astaEventsJson) {
        entities.add(Event.fromExternalJson(event));
      }

      // write entities to cache
      unawaited(calendarDatasource.writeEventsToCache(entities, app: true));

      return Right(entities);
    } catch (e) {
      switch (e.runtimeType) {
        case const (ServerException):
          return Left(ServerFailure());

        case const (JsonException):
          return Left(ServerFailure());

        case const (EmptyResponseException):
          return Left(NoDataFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }

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
      unawaited(
        calendarDatasource.clearEventEntityCache().then((_) => calendarDatasource.writeEventsToCache(entities)),
      );

      return Right(entities);
    } catch (e) {
      switch (e.runtimeType) {
        case const (ServerException):
          return Left(ServerFailure());

        case const (JsonException):
          return Left(ServerFailure());

        case const (EmptyResponseException):
          return Left(NoDataFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }

  /// Return a list of cached events or a failure.
  Either<Failure, List<Event>> getCachedEvents() {
    try {
      final cachedEvents = calendarDatasource.readEventsFromCache();
      final cachedAppEvents = calendarDatasource.readEventsFromCache(app: true);

      // Cache contains both app and asta events
      if (cachedAppEvents.isNotEmpty && cachedEvents.isNotEmpty) {
        return Right(
          List<Event>.from(cachedEvents) + List<Event>.from(cachedAppEvents),
        );
      }

      // Cache only contains app events
      if (cachedAppEvents.isNotEmpty && cachedEvents.isEmpty) {
        return Right(
          List<Event>.from(cachedAppEvents),
        );
      }

      // Cache only contains asta events
      return Right(
        List<Event>.from(cachedEvents),
      );
    } catch (e) {
      return Left(CachFailure());
    }
  }

  /// Return a list of saved events or a failure.
  Future<Either<Failure, List<Event>>> updateSavedEvents({Event? event}) async {
    try {
      final savedEvents = calendarDatasource.readEventsFromCache(saved: true);

      // update list of saved events
      if (event != null) {
        if (savedEvents.contains(event)) {
          savedEvents.remove(event);
        } else {
          savedEvents.add(event);
        }
      }

      unawaited(calendarDatasource.writeEventsToCache(savedEvents, saved: true));

      return Right(savedEvents);
    } catch (e) {
      return Left(CachFailure());
    }
  }
}
