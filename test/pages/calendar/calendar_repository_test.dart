import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/calendar/calendar_datasource.dart';
import 'package:campus_app/pages/feed/calendar/calendar_repository.dart';
import 'package:campus_app/pages/feed/calendar/entities/event_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calendar_repository_test.mocks.dart';
import 'samples/event_list.dart';

@GenerateMocks([CalendarDatasource])
void main() {
  late CalendarRepository calendarRepository;
  late MockCalendarDatasource mockCalendarDatasource;

  setUp(() {
    mockCalendarDatasource = MockCalendarDatasource();
    calendarRepository = CalendarRepository(calendarDatasource: mockCalendarDatasource);
  });

  /// List of event entities based on sample news feed
  final sampleEntities = <Event>[];

  for (final json in calendarSamplesEventList) {
    sampleEntities.add(Event.fromExternalJson(json));
  }

  group('[getAStAEvents]', () {
    test('Should return list of events on successfully web request', () async {
      // arrange: datasource should respond with sample feed
      when(mockCalendarDatasource.getAStAEventsAsJsonArray()).thenAnswer((_) async => calendarSamplesEventList);

      // act: function call
      final testReturn = await calendarRepository.getAStAEvents();

      // assert: is actuall return equals expected return? -> List<Event>
      identical(testReturn, sampleEntities);
      verify(mockCalendarDatasource.getAStAEventsAsJsonArray());
      verify(mockCalendarDatasource.writeEventsToCache(any));
      verifyNoMoreInteractions(mockCalendarDatasource);
    });

    test('Should return a ServerFailure when ServerException was thrown', () async {
      /// ServerFailure on ServerException
      final expectedReturn = ServerFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockCalendarDatasource.getAStAEventsAsJsonArray()).thenThrow(ServerException());

      // act: function call
      final testReturn = await calendarRepository.getAStAEvents();

      // assert: is actuall return equals expected return? -> List<Event>
      identical(testReturn, expectedReturn);
      verify(mockCalendarDatasource.getAStAEventsAsJsonArray());
      verifyNoMoreInteractions(mockCalendarDatasource);
    });

    test('Should return a NoDataFailure when EmptyResponseException was thrown', () async {
      /// ServerFailure on ServerException
      final expectedReturn = NoDataFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockCalendarDatasource.getAStAEventsAsJsonArray()).thenThrow(EmptyResponseException());

      // act: function call
      final testReturn = await calendarRepository.getAStAEvents();

      // assert: is actuall return equals expected return? -> List<Event>
      identical(testReturn, expectedReturn);
      verify(mockCalendarDatasource.getAStAEventsAsJsonArray());
      verifyNoMoreInteractions(mockCalendarDatasource);
    });

    test('Should return a GeneralFailure when an unexpected exception was thrown', () async {
      /// ServerFailure on ServerException
      final expectedReturn = GeneralFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockCalendarDatasource.getAStAEventsAsJsonArray()).thenThrow(Exception());

      // act: function call
      final testReturn = await calendarRepository.getAStAEvents();

      // assert: is actuall return equals expected return? -> List<Event>
      identical(testReturn, expectedReturn);
      verify(mockCalendarDatasource.getAStAEventsAsJsonArray());
      verifyNoMoreInteractions(mockCalendarDatasource);
    });
  });

  group('[getCachedEvents]', () {
    test("Should return list of event etities if datasource doesn't throw a exception", () {
      // arrange: datasource return a news entity list
      when(mockCalendarDatasource.readEventsFromCache()).thenAnswer((_) => sampleEntities);

      // act: function call
      final testReturn = calendarRepository.getCachedEvents();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, sampleEntities);
      verify(mockCalendarDatasource.readEventsFromCache());
      verifyNoMoreInteractions(mockCalendarDatasource);
    });

    test('Should return a CachFailure on unexpected Exception inside readEventsFromCach()', () {
      /// CachFailure on unexpected Exception
      final expectedReturn = CachFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockCalendarDatasource.readEventsFromCache()).thenThrow(Exception());

      // act: funtion call
      final testReturn = calendarRepository.getCachedEvents();

      // assert: is testElement expected object? -> CachFailure
      identical(testReturn, expectedReturn);
      verify(mockCalendarDatasource.readEventsFromCache());
      verifyNoMoreInteractions(mockCalendarDatasource);
    });
  });

  group('[updateSavedEvents', () {
    test('Should return a list whith one saved events', () async {
      // TODO
    });

    test('Should return a list with two saved events', () async {
      // TODO
    });

    test('Should return a empty list of events', () async {
      // TODO
    });

    test('Should return a list with a single event', () async {
      // TODO
    });
  });
}
