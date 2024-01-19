import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_datasource.dart';

class MensaRepository {
  final MensaDataSource mensaDatasource;

  MensaRepository({required this.mensaDatasource});

  /// Returns a list of [DishEntity] widgets or a failure.
  /// Reataurant is 1 (Mensa) by default. Theire are the following possible values:
  ///   * 1: AKAFÖ Mensa
  ///   * 2: AKAFÖ Rote Beete
  ///   * 3: AKAFÖ Qwest
  ///   * 4: AKAFÖ Pfannengericht
  Future<Either<Failure, List<DishEntity>>> getRemoteDishes(int restaurant) async {
    try {
      final List<DishEntity> entities = [];

      final Map<String, dynamic> dishesJson = (await mensaDatasource.getRemoteData(restaurant))['data'];

      final DateTime lastDayOfWeek = DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));
      final DateTime firstDayOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday));

      // Take a look at 'test/pages/mensa/samples/mensa_sample_json_response.dart' to understand remote data structure
      for (final String day in dishesJson.keys) {
        // last key is an id
        if (day == 'id') continue;

        // Correct DateFormat is e.g. "Mo., 10.10." instead of "Mo, 10.10."
        final datetime = DateFormat('E, y.d.M.', 'de_DE').parse(day.replaceRange(2, 4, '., ${firstDayOfWeek.year}.'));

        late int date;
        switch (datetime.weekday) {
          case 1: // Monday
            if (datetime.compareTo(lastDayOfWeek) > 0) {
              date = 5;
            } else {
              date = 0;
            }
            break;
          case 2: // Tuesday
            if (datetime.compareTo(lastDayOfWeek) > 0) {
              date = 6;
            } else {
              date = 1;
            }
            break;
          case 3: // Wednesday
            if (datetime.compareTo(lastDayOfWeek) > 0) {
              date = 7;
            } else {
              date = 2;
            }
            break;
          case 4: // Thursday
            if (datetime.compareTo(lastDayOfWeek) > 0) {
              date = 8;
            } else {
              date = 3;
            }
            break;
          default: // Friday, Saturday or Sunday
            if (datetime.compareTo(lastDayOfWeek) > 0) {
              date = 9;
            } else {
              date = 4;
            }
            break;
        }

        if (restaurant == 3) {
          // restaurant == QWEST
          final dishes = dishesJson[day] as List<dynamic>;
          for (final dish in dishes) {
            entities.add(
              DishEntity.fromJSON(
                date: date,
                category: 'Speiseplan vom ${datetime.day}.${datetime.month}.${datetime.year}',
                json: dish,
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

      // if (restaurant == 3) {
      //   for (final element in entities) {
      //     print(element);
      //   }
      // }

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
