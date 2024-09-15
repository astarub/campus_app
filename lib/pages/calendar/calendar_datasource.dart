import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';

class CalendarDatasource {
  /// Key to identify count of events in Hive box / Cach
  static const String keyCnt = 'cnt';

  /// Key to identify savedEvents in Hive box / Cach
  static const String keyCntSaved = 'cntSaved';

  /// Key to identify events of our own WP instance in Hive box / Cach
  static const String keyCntApp = 'cntApp';

  /// Dio client to perfrom network operations
  final Client appwriteClient;

  /// Hive.Box to store news entities inside
  final Box eventCache;

  CalendarDatasource({
    required this.appwriteClient,
    required this.eventCache,
  });

  /// Request events from tribe api.
  /// Throws a server excpetion if respond code is not 200.
  Future<List<dynamic>> getEvents(String locale) async {
    final databaseService = Databases(appwriteClient);

    models.DocumentList? list;

    final List<Map<String, dynamic>> result = [];

    try {
      list = await databaseService.listDocuments(
        databaseId: 'calendar',
        collectionId: locale,
        queries: [Query.limit(500)],
      );
    } catch (e) {
      debugPrint('Failed to list appwrite news documents. Exception: $e');
      throw ServerException();
    }

    for (final models.Document doc in list.documents) {
      Map<String, dynamic> decoded;

      try {
        decoded = jsonDecode(doc.data['json']);
      } catch (e) {
        debugPrint('Failed to decode appwrite news document data. Exception: $e');
        throw ParseException();
      }
      result.add(decoded);
    }

    return result;
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

  /// Clears the cache
  Future<void> clearEventEntityCache() async {
    await eventCache.clear();
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
