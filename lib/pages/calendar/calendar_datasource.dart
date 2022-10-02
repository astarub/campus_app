import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/utils/constants.dart';

class CalendarDatasource {
  /// Key to identify count of events in Hive box / Cach
  static const String _keyCnt = 'cnt';

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
  Future<void> writeEventsToCach(List<Event> entities) async {
    final cntEntities = entities.length;
    await eventCach.put(_keyCnt, cntEntities);

    int index = 0; // use list index as identifier
    for (final entity in entities) {
      await eventCach.put(index, entity);
      index++;
    }
  }

  /// Read cach of event entities and return them.
  List<Event> readEventsFromCach() {
    final cntEntities = eventCach.get(_keyCnt) as int;
    final List<Event> entities = [];

    for (int i = 0; i < cntEntities; i++) {
      entities.add(eventCach.get(i) as Event);
    }

    return entities;
  }
}
