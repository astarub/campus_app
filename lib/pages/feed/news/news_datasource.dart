import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';

class NewsDatasource {
  /// Key to identify count of news in Hive box / Cach
  static const String keyCnt = 'cnt';

  final Client appwriteClient;

  /// Hive.Box to store news entities inside
  final Box rubnewsCache;

  NewsDatasource({
    required this.appwriteClient,
    required this.rubnewsCache,
  });

  /// Load the news documents from the appwrite backend, by the corresponding locale
  Future<List<Map<String, dynamic>>> getNewsFeed(String locale) async {
    final databaseService = Databases(appwriteClient);

    models.DocumentList? list;

    final List<Map<String, dynamic>> result = [];

    try {
      list = await databaseService.listDocuments(
        databaseId: 'feed',
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

  /// Write given list of NewsEntity to Hive.Box 'rubnewsCach'.
  /// The put()-call is awaited to make sure that the write operations are successful.
  Future<void> writeNewsEntitiesToCache(List<NewsEntity> entities) async {
    final cntEntities = entities.length;
    await rubnewsCache.put(keyCnt, cntEntities);

    int index = 0; // use list index as identifier
    for (final entity in entities) {
      await rubnewsCache.put(index, entity);
      index++;
    }
  }

  /// Clears the cache
  Future<void> clearNewsEntityCache() async {
    await rubnewsCache.clear();
  }

  /// Read cach of news entities and return them.
  List<NewsEntity> readNewsEntitiesFromCach() {
    final cntEntities = rubnewsCache.get(keyCnt) as int;
    final List<NewsEntity> entities = [];

    for (int i = 0; i < cntEntities; i++) {
      entities.add(rubnewsCache.get(i) as NewsEntity);
    }

    return entities;
  }
}
