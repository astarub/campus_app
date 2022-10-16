import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_datasource.dart';
import 'package:intl/intl.dart';

class MensaRepository {
  final MensaDataSource mensaDatasource;

  MensaRepository({required this.mensaDatasource});

  /// Returns a list of [DishEntity] widgets or a failure
  Future<Either<Failure, List<DishEntity>>> getRemoteDishes(int restaurant) async {
    try {
      final List<DishEntity> entities = [];
      late Map<String, dynamic> categories;
      late List<Map<String, String>> dishes;

      final Map<String, dynamic> dishesJson = (await mensaDatasource.getRemoteData(restaurant))['data'];

      // Take a look at 'test/pages/mensa/samples/mensa_sample_json_response.dart' to understand remote data structure
      for (final String day in dishesJson.keys) {
        categories = dishesJson[day] as Map<String, dynamic>;
        for (final String category in categories.keys) {
          dishes = categories[category];
          for (final Map<String, String> dish in dishes) {
            entities.add(
              DishEntity.fromJSON(
                // Correct DateFormat is e.g. "Mo., 10.10." instead of "Mo, 10.10."
                date: DateFormat('E, d.M.', 'de_DE').parse(day.replaceRange(2, 3, '.,')),
                category: category,
                json: dish,
              ),
            );
          }
        }
      }

      // Write entities to cache
      unawaited(mensaDatasource.writeDishEntitiesToCache(entities, restaurant));

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

  /// Returns a list of [DishEntity] widgets or a failure
  Either<Failure, List<DishEntity>> getCachedDishes(int restaurant) {
    try {
      return Right(mensaDatasource.readDishEntitiesFromCache(restaurant));
    } catch (e) {
      return Left(CachFailure());
    }
  }
}
