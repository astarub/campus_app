import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/utils/constants.dart';

class CalendarDatasource {
  /// Key to identify count of events in Hive box / Cach
  static const String keyCnt = 'cnt';

  /// Key to identify savedEvents in Hive box / Cach
  static const String keyCntSaved = 'cntSaved';

  /// Key to identify events of our own WP instance in Hive box / Cach
  static const String keyCntApp = 'cntApp';

  /// Dio client to perfrom network operations
  final Dio client;

  /// Hive.Box to store news entities inside
  final Box eventCache;

  CalendarDatasource({
    required this.client,
    required this.eventCache,
  });

  /// Request events from tribe api.
  /// Throws a server excpetion if respond code is not 200.
  Future<List<dynamic>> getAStAEventsAsJsonArray() async {
    final response = await client.get(astaEvents);
    late final Map<String, dynamic> responseBody;

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      try {
        responseBody = response.data as Map<String, dynamic>;
      } catch (e) {
        throw JsonException();
      }

      if ((responseBody['events'] as List<dynamic>).isEmpty) {
        throw EmptyResponseException();
      }

      final List<dynamic> events = responseBody['events'];

      // Fetch events from multiple pages, if there are more than one page
      try {
        final int pages = int.parse(response.headers.value('x-tec-totalpages')!);

        if (pages > 1) {
          for (int i = 2; i <= pages; i++) {
            final responseForPage = await client.get('$astaEvents?page=$i');

            if (responseForPage.statusCode != 200) continue;

            Map<String, dynamic> responsePageBody;

            try {
              responsePageBody = responseForPage.data as Map<String, dynamic>;
            } catch (e) {
              continue;
            }

            if ((responsePageBody['events'] as List<dynamic>).isEmpty) continue;

            events.addAll(responsePageBody['events']);
          }
        }
      } catch (e) {
        throw ParseException();
      }

      return events;
    }
  }

  /// Request events from the app's wordpress instance using the tribe api.
  /// Throws a server excpetion if respond code is not 200.
  Future<List<dynamic>> getAppEventsAsJsonArray() async {
    final response = await client.get(appEvents);
    late final Map<String, dynamic> responseBody;

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      try {
        responseBody = response.data as Map<String, dynamic>;
      } catch (e) {
        throw JsonException();
      }

      if ((responseBody['events'] as List<dynamic>).isEmpty) {
        throw EmptyResponseException();
      }

      final List<dynamic> events = responseBody['events'];

      // Fetch events from multiple pages, if there are more than one page
      try {
        final int pages = int.parse(response.headers.value('x-tec-totalpages')!);

        if (pages > 1) {
          for (int i = 2; i <= pages; i++) {
            final responseForPage = await client.get('$appEvents?page=$i');

            if (responseForPage.statusCode != 200) continue;

            Map<String, dynamic> responsePageBody;

            try {
              responsePageBody = responseForPage.data as Map<String, dynamic>;
            } catch (e) {
              continue;
            }

            if ((responsePageBody['events'] as List<dynamic>).isEmpty) continue;

            events.addAll(responsePageBody['events']);
          }
        }
      } catch (e) {
        throw ParseException();
      }

      return events;
    }
  }

  /// Write given list of Events to Hive.Box 'eventCache'.
  /// The put()-call is awaited to make sure that the write operations are successful.
  Future<void> writeEventsToCache(List<Event> entities, {bool saved = false, bool app = false}) async {
    final cntEntities = entities.length;

    if (saved) {
      await eventCache.put(keyCntSaved, cntEntities);
    } else if (app) {
      await eventCache.put(keyCntApp, cntEntities);
    } else {
      await eventCache.put(keyCnt, cntEntities);
    }

    int i = 0; // use list index as identifier
    for (final entity in entities) {
      if (saved) {
        await eventCache.put('saved$i', entity);
      } else if (app) {
        await eventCache.put('app$i', entity);
      } else {
        await eventCache.put(i, entity);
      }
      i++;
    }

    if (entities.isEmpty) {
      final int tempCntEntities = saved
          ? eventCache.get(keyCntSaved) ?? 0
          : app
              ? eventCache.get(keyCntApp) ?? 0
              : eventCache.get(keyCnt) ?? 0;

      for (int i = 0; i < tempCntEntities; i++) {
        if (saved) {
          await eventCache.delete('saved$i');
        } else if (app) {
          await eventCache.delete('app$i');
        } else {
          await eventCache.delete(i);
        }
      }
    }
  }

  /// Read cache of event entities and return them.
  List<Event> readEventsFromCache({bool saved = false, bool app = false}) {
    late int cntEntities;
    final List<Event> entities = [];

    if (saved) {
      cntEntities = eventCache.get(keyCntSaved) ?? 0;
    } else if (app) {
      cntEntities = eventCache.get(keyCntApp) ?? 0;
    } else {
      cntEntities = eventCache.get(keyCnt) ?? 0;
    }

    for (int i = 0; i < cntEntities; i++) {
      if (saved) {
        entities.add(eventCache.get('saved$i') as Event);
      } else if (app) {
        entities.add(eventCache.get('app$i') as Event);
      } else {
        entities.add(eventCache.get(i) as Event);
      }
    }

    return entities;
  }
}
