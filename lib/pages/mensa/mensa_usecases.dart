import 'dart:async';
import 'package:dartz/dartz.dart';

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/mensa_repository.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';

class MensaUsecases {
  final MensaRepository mensaRepository;

  MensaUsecases({required this.mensaRepository});

  Future<Map<String, List<dynamic>>> updateDishesAndFailures() async {
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'dishes': <DishEntity>[],
    };

    // Get remote and cached dishes
    final Either<Failure, List<DishEntity>> remoteDishes = await mensaRepository.getRemoteDishes();
    final Either<Failure, List<DishEntity>> cachedDishes = mensaRepository.getCachedDishes();

    remoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['dishes'] = dishes,
    );

    cachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['dishes'] = dishes,
    );

    return data;
  }

  Map<String, List<dynamic>> getCachedDishesAndFailures() {
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'dishes': <DishEntity>[],
    };

    final Either<Failure, List<DishEntity>> cachedDishes = mensaRepository.getCachedDishes();

    cachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['dishes'] = dishes,
    );

    return data;
  }
}
