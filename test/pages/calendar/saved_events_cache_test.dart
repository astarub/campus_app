import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:campus_app/pages/calendar/calendar_datasource.dart';
import 'package:campus_app/pages/calendar/entities/category_entity.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/entities/organizer_entity.dart';
import 'package:campus_app/pages/calendar/entities/venue_entity.dart';

Event event(int id, {String url = 'https://asta-bochum.de/event'}) {
  return Event(
    id: id,
    url: url,
    title: 'Event $id',
    description: 'Description',
    slug: 'slug-$id',
    hasImage: false,
    startDate: DateTime(2026),
    endDate: DateTime(2026, 1, 2),
    venue: const Venue(id: 0, name: '', slug: '', url: ''),
    organizers: const [Organizer(id: 0, url: '', name: '', slug: '')],
  );
}

/// Regression test for #173: saved events were lost because refreshing the
/// event list cleared the whole Hive box, including the saved events.
void main() {
  late Directory tempDir;
  late Box box;
  late CalendarDatasource datasource;

  setUpAll(() {
    Hive.registerAdapter(EventAdapter());
    Hive.registerAdapter(VenueAdapter());
    Hive.registerAdapter(OrganizerAdapter());
    Hive.registerAdapter(CategoryAdapter());
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('events_cache_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox('eventsCache');
    datasource = CalendarDatasource(client: Dio(), eventCache: box);
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('Saved events survive a refresh of the event list and an app restart', () async {
    await datasource.writeEventsToCache([event(1), event(2)]);
    await datasource.writeEventsToCache([event(2)], saved: true);
    await datasource.writeEventsToCache([event(3)], app: true);

    // Refresh as done in CalendarRepository.getAStAEvents
    await datasource.clearEventEntityCache();
    await datasource.writeEventsToCache([event(1), event(4)]);

    // Simulate an app restart by reopening the box from disk
    await Hive.close();
    Hive.init(tempDir.path);
    box = await Hive.openBox('eventsCache');
    datasource = CalendarDatasource(client: Dio(), eventCache: box);

    expect(datasource.readEventsFromCache(saved: true).map((e) => e.id), [2]);
    expect(datasource.readEventsFromCache(app: true).map((e) => e.id), [3]);
    expect(datasource.readEventsFromCache().map((e) => e.id), [1, 4]);
  });
}
