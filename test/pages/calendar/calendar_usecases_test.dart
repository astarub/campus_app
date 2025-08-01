import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/calendar/calendar_repository.dart';
import 'package:campus_app/pages/feed/calendar/calendar_usecases.dart';
import 'package:campus_app/pages/feed/calendar/entities/event_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calendar_usecases_test.mocks.dart';
import 'samples/event_list.dart';

@GenerateMocks([CalendarRepository])
void main() {
  late CalendarUsecases calendarUsecases;
  late MockCalendarRepository mockCalendarRepository;

  setUp(() {
    mockCalendarRepository = MockCalendarRepository();
    calendarUsecases = CalendarUsecases(calendarRepository: mockCalendarRepository);
  });

  /// List of event entities based on sample events feed
  final sampleEntities = <Event>[];

  for (final json in calendarSamplesEventList) {
    sampleEntities.add(Event.fromExternalJson(json));
  }

  group('[updateEventsAndFailures]', () {
    test('Should return a JSON object with list of failures and list of events', () async {
      final expectedReturn = {
        'failure': [CachFailure()],
        'events': sampleEntities,
      };

      // arrange: remoteFeed contains events entities and localFeed contains a CachFailure
      when(mockCalendarRepository.getAStAEvents()).thenAnswer((_) => Future.value(Right(sampleEntities)));
      when(mockCalendarRepository.getCachedEvents()).thenAnswer((_) => Left(CachFailure()));

      // act: function call
      final testReturn = await calendarUsecases.updateEventsAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verify(mockCalendarRepository.getAStAEvents());
      verify(mockCalendarRepository.getCachedEvents());
      verifyNoMoreInteractions(mockCalendarRepository);
    });

    test('Should return a JSON object with empty list of failures and list of events', () async {
      final expectedReturn = {
        'failure': [],
        'events': sampleEntities,
      };

      // arrange: remoteFeed contains events entities and localFeed contains a CachFailure
      when(mockCalendarRepository.getAStAEvents()).thenAnswer((_) => Future.value(Right(sampleEntities)));
      when(mockCalendarRepository.getCachedEvents()).thenAnswer((_) => Right(sampleEntities));

      // act: function call
      final testReturn = await calendarUsecases.updateEventsAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verify(mockCalendarRepository.getAStAEvents());
      verify(mockCalendarRepository.getCachedEvents());
      verifyNoMoreInteractions(mockCalendarRepository);
    });

    test('Should return a JSON object with empty list of events and list of failures', () async {
      final expectedReturn = {
        'failure': [CachFailure(), ServerFailure()],
        'events': [],
      };

      // arrange: remoteFeed contains events entities and localFeed contains a CachFailure
      when(mockCalendarRepository.getAStAEvents()).thenAnswer((_) => Future.value(Left(ServerFailure())));
      when(mockCalendarRepository.getCachedEvents()).thenAnswer((_) => Left(CachFailure()));

      // act: function call
      final testReturn = await calendarUsecases.updateEventsAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verify(mockCalendarRepository.getAStAEvents());
      verify(mockCalendarRepository.getCachedEvents());
      verifyNoMoreInteractions(mockCalendarRepository);
    });

    test('Should return a JSON object with list of events and ServerFailure', () async {
      final expectedReturn = {
        'failure': [ServerFailure()],
        'events': sampleEntities,
      };

      // arrange: remoteFeed contains events entities and localFeed contains a CachFailure
      when(mockCalendarRepository.getAStAEvents()).thenAnswer((_) => Future.value(Left(ServerFailure())));
      when(mockCalendarRepository.getCachedEvents()).thenAnswer((_) => Right(sampleEntities));

      // act: function call
      final testReturn = await calendarUsecases.updateEventsAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verify(mockCalendarRepository.getAStAEvents());
      verify(mockCalendarRepository.getCachedEvents());
      verifyNoMoreInteractions(mockCalendarRepository);
    });
  });

  group('[getCachedEventsAndFailures]', () {
    test('Should return a JSON object with empty list of failures and list of events', () {
      final expectedReturn = {
        'failure': [],
        'events': sampleEntities,
      };

      // arrange: localFeed contains events entities
      when(mockCalendarRepository.getCachedEvents()).thenAnswer((_) => Right(sampleEntities));

      // act: function call
      final testReturn = calendarUsecases.getCachedEventsAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verifyNever(mockCalendarRepository.getAStAEvents());
      verify(mockCalendarRepository.getCachedEvents());
      verifyNoMoreInteractions(mockCalendarRepository);
    });

    test('Should return a JSON object with empty list of events and list of failures', () {
      final expectedReturn = {
        'failure': [CachFailure()],
        'events': [],
      };

      // arrange: localFeed contains a CachFailure
      when(mockCalendarRepository.getCachedEvents()).thenAnswer((_) => Left(CachFailure()));

      // act: function call
      final testReturn = calendarUsecases.getCachedEventsAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verifyNever(mockCalendarRepository.getAStAEvents());
      verify(mockCalendarRepository.getCachedEvents());
      verifyNoMoreInteractions(mockCalendarRepository);
    });
  });
}
