import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_datasource.dart';

class MensaRepository {
  final MensaDataSource mensaDatasource;

  MensaRepository({required this.mensaDatasource});

  /// Returns a list of [DishEntity] widgets or a failure
  Future<Either<Failure, List<DishEntity>>> getRemoteDishes(int restaurant) async {
    try {
      final List<DishEntity> entities = [];

      final dishesJson = await mensaDatasource.getRemoteData(restaurant);

      // Write entities to cache
      unawaited(mensaDatasource.writeDishEntitiesToCache(entities));

      return Right(entities);
    } catch (e) {
      switch (e.runtimeType) {
        case ServerException:
          return Left(ServerFailure());
        default:
          return Left(GeneralFailure());
      }
    }
  }

  Either<Failure, List<DishEntity>> getCachedDishes() {
    try {
      return Right(mensaDatasource.readDishEntitiesFromCache());
    } catch (e) {
      return Left(CachFailure());
    }
  }
}
