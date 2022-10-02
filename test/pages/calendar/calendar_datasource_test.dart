import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/calendar/calendar_datasource.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/entities/organizer_entity.dart';
import 'package:campus_app/pages/calendar/entities/venue_entity.dart';
import 'package:campus_app/utils/constants.dart';

import 'calendar_datasource_test.mocks.dart';
import 'samples/event_list.dart';
import 'samples/eventfeed_response.dart';

/// Create an empty Event
Event emptyEvent({String title = 'Title'}) {
  return Event(
    id: 0,
    url: 'Url',
    title: title,
    description: 'Description',
    slug: 'Slug',
    hasImage: false,
    startDate: DateTime(0),
    endDate: DateTime(1),
    venue: const Venue(id: 0, name: '', slug: '', url: ''),
    organizers: const [Organizer(id: 0, url: '', name: '', slug: '')],
  );
}

@GenerateMocks([Dio, Box])
void main() {
  late CalendarDatasource calendarDatasource;
  late Dio mockClient;
  late Box mockCach;

  setUp(() async {
    mockClient = MockDio();
    mockCach = MockBox();

    calendarDatasource = CalendarDatasource(client: mockClient, eventCach: mockCach);
  });

  group('[getAStAEventsAsJsonArray]', () {
    /// A Dio response on successfully request
    final resSuccess = Response(
      requestOptions: RequestOptions(path: astaEvents),
      statusCode: 200,
      data: calendarSampleEventfeedResponse,
    );

    /// A Dio response on failed request thougth connection error (statuscode 404)
    final resFailure = Response(
      requestOptions: RequestOptions(path: astaEvents),
      statusCode: 404,
    );

    /// A Dio response that contains no data
    final resInvalidJson = Response(
      requestOptions: RequestOptions(path: astaEvents),
      statusCode: 200,
    );

    /// A Dio response that contains no data
    final resEmpty = Response(
      requestOptions: RequestOptions(path: astaEvents),
      statusCode: 200,
      data: {'events': []},
    );

    test('Should return a list of JSON objects after successfully GET request', () {
      // arrange: Dio respond with statuscode 200 and correct JSON data
      when(mockClient.get(astaEvents)).thenAnswer((_) async => resSuccess);

      // act: function call
      final testReturn = calendarDatasource.getAStAEventsAsJsonArray();

      // assert: is testElement expected object? -> List of JSON
      identical(testReturn, calendarSamplesEventList); // is the returned object the expected one?
      verify(mockClient.get(astaEvents)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()
    });

    test('Should throw a ServerException on failed web request', () {
      // arrange: Dio respond with statuscode 404
      when(mockClient.get(astaEvents)).thenAnswer((_) async => resFailure);

      // assert: is ServerException thrown?
      expect(() => calendarDatasource.getAStAEventsAsJsonArray(), throwsA(isA<ServerException>()));
      verify(mockClient.get(astaEvents)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });

    test('Should throw a JsonException when returned object does not contain data', () {
      // arrange: Dio respond is not valid JSON
      when(mockClient.get(astaEvents)).thenAnswer((_) async => resInvalidJson);

      // assert: is JsonException thrown?
      expect(() => calendarDatasource.getAStAEventsAsJsonArray(), throwsA(isA<JsonException>()));
      verify(mockClient.get(astaEvents)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });

    test('Should throw a EmptyResponseException when returned object does not contain events', () {
      // arrange: Dio Response contain no events
      when(mockClient.get(astaEvents)).thenAnswer((_) async => resEmpty);

      // assert: is EmptyResponseException thrown?
      expect(() => calendarDatasource.getAStAEventsAsJsonArray(), throwsA(isA<EmptyResponseException>()));
      verify(mockClient.get(astaEvents)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });
  });

  group('[Caching]', () {
    final samleEventEntities = <Event>[emptyEvent(), emptyEvent(), emptyEvent()];
    test('Should return the same entities on read as writen befor', () async {
      when(mockCach.get('cnt')).thenAnswer((_) => 3);
      when(mockCach.get(0)).thenAnswer((_) => samleEventEntities[0]);
      when(mockCach.get(1)).thenAnswer((_) => samleEventEntities[1]);
      when(mockCach.get(2)).thenAnswer((_) => samleEventEntities[2]);

      // act: write sample entities to cach
      await calendarDatasource.writeEventsToCach(samleEventEntities);
      final testReturn = calendarDatasource.readEventsFromCach();

      // assert: is testElement expected object? -> List<Event> samleEventEntities
      identical(testReturn, samleEventEntities); // is the returned object the expected one?
    });

    test('Should return a list whith one saved events', () async {
      when(mockCach.get('saved')).thenAnswer((_) => <Event>[]);

      // act: write sample entities to cach
      final testReturn = await calendarDatasource.updateSavedEvents(event: emptyEvent());

      // assert: is testElement expected object? -> List<Event> samleEventEntities
      identical(testReturn, <Event>[emptyEvent()]); // is the returned object the expected one?
    });

    test('Should return a list with two saved events', () async {
      when(mockCach.get('saved')).thenAnswer((_) => <Event>[]);

      // act: write sample entities to cach
      await calendarDatasource.updateSavedEvents(event: emptyEvent(title: 'Test'));
      final testReturn = await calendarDatasource.updateSavedEvents(event: emptyEvent());

      // assert: is testElement expected object? -> List<Event> samleEventEntities
      identical(testReturn, <Event>[
        emptyEvent(title: 'Test'),
        emptyEvent(),
      ]); // is the returned object the expected one?
    });

    test('Should return a empty list of events', () async {
      final getResponses = [
        <Event>[],
        <Event>[emptyEvent()]
      ];
      when(mockCach.get('saved')).thenAnswer((_) => getResponses.removeAt(0));

      // act: write sample entities to cach
      await calendarDatasource.updateSavedEvents(event: emptyEvent());
      final testReturn = await calendarDatasource.updateSavedEvents(event: emptyEvent());

      // assert: is testElement expected object? -> List<Event> samleEventEntities
      expect(testReturn, <Event>[]); // is the returned object the expected one?
    });

    test('Should return a list with a single event', () async {
      final getResponses = [
        <Event>[],
        <Event>[emptyEvent()]
      ];
      when(mockCach.get('saved')).thenAnswer((_) => getResponses.removeAt(0));

      // act: write sample entities to cach
      await calendarDatasource.updateSavedEvents(event: emptyEvent());
      final testReturn = await calendarDatasource.updateSavedEvents();

      // assert: is testElement expected object? -> List<Event> samleEventEntities
      expect(testReturn, <Event>[emptyEvent()]); // is the returned object the expected one?
    });
  });
}
