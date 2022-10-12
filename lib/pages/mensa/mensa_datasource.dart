import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';

class MensaDataSource {
  /// Key to identify count of news in Hive box / Cach
  static const String _keyCnt = 'cnt';

  /// Dio client to perform network operations
  final Dio client;

  /// Hive.Box to store mensa entities inside
  final Box mensaCache;

  MensaDataSource({
    required this.client,
    required this.mensaCache,
  });

  /// Request mensa dishes from database
  Future<Map<String, dynamic>> getMensaData(int restaurant) async {
    final headers = {'Authorization': 'Bearer mensa_secret_api_key_1337'};

    final response = await client.get("https://80.240.25.142/get_meal/$restaurant", options: Options(headers: headers));

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return json.decode(response.data);
    }
  }

  /// Write given list of DishEntities to Hive.Box
  /// The `put()`-call is awaited to make sure that the write operations are successful.
  Future<void> writeDishEntitiesToCache(List<DishEntity> entities) async {
    final int cntEntities = entities.length;
    await mensaCache.put(_keyCnt, cntEntities);

    int index = 0;
    for (final entity in entities) {
      await mensaCache.put(index, entity);
      index++;
    }
  }

  /// Read cache of DishEntities and return them
  List<DishEntity> readDishEntitiesFromCache() {
    final cntEntities = mensaCache.get(_keyCnt) as int;
    List<DishEntity> entities = [];

    for (int i = 0; i < cntEntities; i++) {
      entities.add(mensaCache.get(i) as DishEntity);
    }

    return entities;
  }
}
