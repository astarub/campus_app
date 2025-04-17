import 'package:dartz/dartz.dart';

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';

class CalendarUsecases {
  final CalendarRepository calendarRepository;

  CalendarUsecases({required this.calendarRepository});

  /// Return a JSON object `data` that contains failures and events.
  ///
  /// data := { 'failures': List\<Failure>, 'events': List\<Event> }
  Future<Map<String, List<dynamic>>> updateEventsAndFailures(String locale) async {
    // return data
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'events': <Event>[],
      'saved': <Event>[],
    };

    // get events from AStA API and cached events
    final Either<Failure, List<Event>> remoteEvents = await calendarRepository.getEvents(locale);
    final Either<Failure, List<Event>> cachedEvents = calendarRepository.getCachedEvents();
    final Either<Failure, List<Event>> savedEvents = await calendarRepository.updateSavedEvents();

    // fold cachedEvents
    cachedEvents.fold(
      (failure) => data['failures']!.add(failure),
      (events) => data['events'] = events,
    );

    // fold savedEvents
    savedEvents.fold(
      (failure) => data['failures']!.add(failure),
      (events) => data['saved'] = events,
    );

    // fold remoteEvents
    remoteEvents.fold(
      (failure) => data['failures']!.add(failure),
      (events) => data['events'] = events, // overwrite cached feed
    );

    List<Event>.from(data['events']!).sort((a, b) {
      return a.startDate.compareTo(b.startDate);
    });

    List<Event>.from(data['saved']!).sort((a, b) {
      return a.startDate.compareTo(b.startDate);
    });

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
      'saved': <Event>[],
    };

    // get only cached events
    final Either<Failure, List<Event>> cachedEvents = calendarRepository.getCachedEvents();

    // fold cachedEvents
    cachedEvents.fold(
      (failure) => data['failures']!.add(failure),
      (events) => data['events'] = events,
    );

    List<Event>.from(data['events']!).sort((a, b) {
      return a.startDate.compareTo(b.startDate);
    });

    List<Event>.from(data['saved']!).sort((a, b) {
      return a.startDate.compareTo(b.startDate);
    });

    return data;
  }
}
