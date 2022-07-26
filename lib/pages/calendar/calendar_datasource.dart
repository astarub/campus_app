import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/utils/constants.dart';

class CalendarDatasource {
  /// Key to identify count of events in Hive box / Cach
  static const String _keyCnt = 'cnt';

  /// Key to identify savedEvents in Hive box / Cach
  static const String _keyCntSaved = 'cntSaved';

  /// Dio client to perfrom network operations
  final Dio client;

  /// Hive.Box to store news entities inside
  final Box eventCach;

  CalendarDatasource({
    required this.client,
    required this.eventCach,
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

      return responseBody['events'] as List<dynamic>;
    }
  }

  /// Write given list of Events to Hive.Box 'eventCach'.
  /// The put()-call is awaited to make sure that the write operations are successful.
  Future<void> writeEventsToCach(List<Event> entities, {bool saved = false}) async {
    final cntEntities = entities.length;

    if (saved) {
      await eventCach.put(_keyCntSaved, cntEntities);
    } else {
      await eventCach.put(_keyCnt, cntEntities);
    }

    int i = 0; // use list index as identifier
    for (final entity in entities) {
      if (saved) {
        await eventCach.put('saved$i', entity);
      } else {
        await eventCach.put(i, entity);
      }
      i++;
    }
  }

  /// Read cach of event entities and return them.
  List<Event> readEventsFromCach({bool saved = false}) {
    late int cntEntities;
    final List<Event> entities = [];

    if (saved) {
      cntEntities = eventCach.get(_keyCntSaved) ?? 0;
    } else {
      cntEntities = eventCach.get(_keyCnt) ?? 0;
    }

    for (int i = 0; i < cntEntities; i++) {
      if (saved) {
        entities.add(eventCach.get('saved$i') as Event);
      } else {
        entities.add(eventCach.get(i) as Event);
      }
    }

    return entities;
  }
}
