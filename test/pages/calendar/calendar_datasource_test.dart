import 'package:appwrite/appwrite.dart';
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

@GenerateMocks([Databases, Box])
void main() {
  late CalendarDatasource calendarDatasource;
  late Client mockClient;
  late Databases mockDatabases;
  late Box mockCach;

  setUp(() async {
    mockClient = MockDio();
    mockCach = MockBox();
    mockDatabases = MockDatabases();

    calendarDatasource = CalendarDatasource(appwriteClient: mockClient, eventCache: mockCach);
  });

  group('[getAStAEventsAsJsonArray]', () {
    test('Should return a list of JSON objects after successfully GET request', () {
      // arrange: Dio respond with statuscode 200 and correct JSON data
      when(mockDatabases.listDocuments(databaseId: 'calendar', collectionId: 'de'))
          .thenAnswer((_) async => calendarSampleAppwriteList);

      // act: function call
      final testReturn = calendarDatasource.getEvents('de');

      // assert: is testElement expected object? -> List of JSON
      identical(testReturn, calendarSampleAppwriteList); // is the returned object the expected one?
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
      await calendarDatasource.writeEventsToCache(samleEventEntities);
      final testReturn = calendarDatasource.readEventsFromCache();

      // assert: is testElement expected object? -> List<Event> samleEventEntities
      identical(testReturn, samleEventEntities); // is the returned object the expected one?
    });
  });
}
