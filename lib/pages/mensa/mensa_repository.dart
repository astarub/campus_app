import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_datasource.dart';
import 'package:campus_app/utils/pages/mensa_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

class MensaRepository {
  // Datasource for Scrapping
  final MensaDataSource mensaDatasource;

  // AppWrite Datasource
  final Client awClient;

  // Mensa Utils
  final MensaUtils utils;

  MensaRepository({required this.mensaDatasource, required this.awClient, required this.utils});

  /// Returns a list of [DishEntity] widgets or a failure.
  /// Calls AppWrite instance to get list of dishes from database.
  /// Theire are the following possible values:
  ///   * 1: AKAFÖ Mensa (default)
  ///   * 2: AKAFÖ Rote Beete
  ///   * 3: AKAFÖ Qwest
  ///   * 4: AKAFÖ Pfannengericht
  ///   * 5: AKAFÖ Unikids / Unizwerge
  Future<Either<Failure, List<DishEntity>>> getAWDishes(int restaurant) async {
    try {
      final List<DishEntity> dishes = [];
      final today = DateTime.now();

      final dbServ = Databases(awClient);
      final mensaDocs = await dbServ.listDocuments(
        databaseId: 'data',
        collectionId: 'mensa',
        queries: [
          // Limit is set to 250 to ensure downloading the full collection.
          // In production, the value should be far less than this value for
          // a single restaurant call.
          Query.limit(250),
          // Search only for the specified restaurant
          Query.equal('restaurant', utils.getAWRestaurantId(restaurant)),
          // Request only dishes that should displayed inside the app (2 weeks)
          Query.between(
            'date',
            today.subtract(Duration(days: today.weekday - 1)),
            today.add(Duration(days: 14 - today.weekday)),
          )
        ],
      );

      for (final dishDoc in mensaDocs.documents) {
        final dishData = dishDoc.data;
        dishes.add(
          DishEntity(
            date: utils.dishDateToInt(DateTime.parse(dishData['date'])),
            category: dishData['menuName'],
            title: dishData['dishName'],
            price: dishData['dishPrice'] ?? 'Preis vor Ort',
            infos: utils.readListOfAdditives(dishData['dishAdditives']),
            // Difference between these three lists is
            // not present in XML / AppWrite data
            // allergenes: utils.readListOfAdditives(dishData['dishAdditives']),
            // additives: utils.readListOfAdditives(dishData['dishAdditives']),
          ),
        );
      }

      // Write entities to cache
      unawaited(
        mensaDatasource.writeDishEntitiesToCache(dishes, restaurant),
      );

      return Right(dishes);
    } catch (e) {
      switch (e.runtimeType) {
        case AppwriteException:
          return Left(ServerFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }

  /// Returns a list of [DishEntity] widgets or a failure
  Either<Failure, List<DishEntity>> getCachedDishes(int restaurant) {
    try {
      return Right(mensaDatasource.readDishEntitiesFromCache(restaurant));
    } catch (e) {
      return Left(CachFailure());
    }
  }

  /// Returns a list of [DishEntity] widgets or a failure.
  /// Calls the mensa scrapper API to get the data.
  /// Theire are the following possible values:
  ///   * 1: AKAFÖ Mensa
  ///   * 2: AKAFÖ Rote Beete
  ///   * 3: AKAFÖ Qwest
  ///   * 4: AKAFÖ Pfannengericht
  Future<Either<Failure, List<DishEntity>>> getScrappedDishes(int restaurant) async {
    try {
      final List<DishEntity> entities = [];

      final Map<String, dynamic> dishesJson = (await mensaDatasource.getRemoteData(restaurant))['data'];

      final DateTime firstDayOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday));

      // Take a look at 'test/pages/mensa/samples/mensa_sample_json_response.dart' to understand remote data structure
      for (final String day in dishesJson.keys) {
        // last key is an id
        if (day == 'id') continue;

        // Correct DateFormat is e.g. "Mo., 10.10." instead of "Mo, 10.10."
        final dishDate = DateFormat('E, y.d.M.', 'de_DE').parse(day.replaceRange(2, 4, '., ${firstDayOfWeek.year}.'));
        final int date = utils.dishDateToInt(dishDate);

        if (restaurant == 3) {
          // restaurant == QWEST
          final dishes = dishesJson[day] as List<dynamic>;
          for (final dish in dishes) {
            entities.add(
              DishEntity.fromJSON(
                date: date,
                category: 'Speiseplan vom ${dishDate.day}.${dishDate.month}.${dishDate.year}',
                json: dish,
                utils: utils,
              ),
            );
          }
        } else {
          final categories = dishesJson[day] as Map<String, dynamic>;
          for (final String category in categories.keys) {
            final dishes = categories[category];
            for (final Map<String, dynamic> dish in dishes) {
              entities.add(
                DishEntity.fromJSON(
                  date: date,
                  category: category,
                  json: dish,
                  utils: utils,
                ),
              );
            }
          }
        }
      }

      // Write entities to cache
      unawaited(
        mensaDatasource.writeDishEntitiesToCache(entities, restaurant),
      );

      return Right(entities);
    } catch (e) {
      switch (e.runtimeType) {
        case ServerException:
          return Left(ServerFailure());

        case JsonException:
          return Left(ServerFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }
}
