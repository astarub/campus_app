import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:dartz/dartz.dart';

class CalendarUsecases {
  final CalendarRepository calendarRepository;

  CalendarUsecases({required this.calendarRepository});

  /// Return a JSON object `data` that contains failures and events.
  ///
  /// data := { 'failures': List\<Failure>, 'events': List\<Event> }
  Future<Map<String, List<dynamic>>> updateEventsAndFailures() async {
    // return data
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'events': <Event>[],
    };

    // get events from AStA API and cached events
    final Either<Failure, List<Event>> remoteEvents = await calendarRepository.getAStAEvents();
    final Either<Failure, List<Event>> cachedEvents = calendarRepository.getCachedEvents();

    // fold cachedEvents
    cachedEvents.fold(
      (failure) => data['failures']!.add(failure),
      (events) => data['events'] = events,
    );

    // fold remoteEvents
    remoteEvents.fold(
      (failure) => data['failures']!.add(failure),
      (events) => data['events'] = events, // overwrite cached feed
    );

    return data;
  }

  /// Return a JSON object `data` that contains failures and events.
  ///
  /// data := { 'failures': List\<Failure>, 'events': List\<Event> }
  Map<String, List<dynamic>> getCachedEventsAndFailures() {
    // return data
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'events': <Event>[],
    };

    // get only cached events
    final Either<Failure, List<Event>> cachedEvents = calendarRepository.getCachedEvents();

    // fold cachedEvents
    cachedEvents.fold(
      (failure) => data['failures']!.add(failure),
      (events) => data['events'] = events,
    );

    return data;
  }
}
