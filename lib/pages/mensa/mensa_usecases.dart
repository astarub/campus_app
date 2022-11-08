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
      'mensa': <DishEntity>[],
      'roteBeete': <DishEntity>[],
      'qwest': <DishEntity>[],
      'henkelmann': <DishEntity>[],
    };

    // Get remote and cached dishes
    final Either<Failure, List<DishEntity>> mensaRemoteDishes = await mensaRepository.getRemoteDishes(1);
    final Either<Failure, List<DishEntity>> roteBeeteRemoteDishes = await mensaRepository.getRemoteDishes(2);
    final Either<Failure, List<DishEntity>> qwestRemoteDishes = await mensaRepository.getRemoteDishes(3);
    final Either<Failure, List<DishEntity>> henkelmannRemoteDishes = await mensaRepository.getRemoteDishes(4);

    final Either<Failure, List<DishEntity>> mensaCachedDishes = mensaRepository.getCachedDishes(1);
    final Either<Failure, List<DishEntity>> roteBeeteCachedDishes = mensaRepository.getCachedDishes(2);
    final Either<Failure, List<DishEntity>> qwestCachedDishes = mensaRepository.getCachedDishes(3);
    final Either<Failure, List<DishEntity>> henkelmannCachedDishes = mensaRepository.getCachedDishes(4);

    mensaCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['mensa'] = dishes,
    );

    roteBeeteCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['roteBeete'] = dishes,
    );

    qwestRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['qwest'] = dishes,
    );

    henkelmannRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['henkelmann'] = dishes,
    );

    mensaRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['mensa'] = dishes,
    );

    roteBeeteRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['roteBeete'] = dishes,
    );

    qwestCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['qwest'] = dishes,
    );

    henkelmannCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['henkelmann'] = dishes,
    );

    return data;
  }

  Map<String, List<dynamic>> getCachedDishesAndFailures() {
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'mensa': <DishEntity>[],
      'roteBeete': <DishEntity>[],
      'qwest': <DishEntity>[],
      'henkelmann': <DishEntity>[],
    };

    final Either<Failure, List<DishEntity>> mensaCachedDishes = mensaRepository.getCachedDishes(1);
    final Either<Failure, List<DishEntity>> roteBeeteCachedDishes = mensaRepository.getCachedDishes(2);
    final Either<Failure, List<DishEntity>> qwestCachedDishes = mensaRepository.getCachedDishes(2);
    final Either<Failure, List<DishEntity>> henkelmannCachedDishes = mensaRepository.getCachedDishes(2);

    mensaCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['mensa'] = dishes,
    );

    roteBeeteCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['roteBeete'] = dishes,
    );

    qwestCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['qwest'] = dishes,
    );

    henkelmannCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['henkelmann'] = dishes,
    );

    return data;
  }
}
