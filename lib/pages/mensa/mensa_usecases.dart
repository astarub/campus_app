import 'dart:async';

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_repository.dart';
import 'package:dartz/dartz.dart';

class MensaUsecases {
  final MensaRepository mensaRepository;

  MensaUsecases({required this.mensaRepository});

  Map<String, List<dynamic>> getCachedDishesAndFailures() {
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'mensa': <DishEntity>[],
      'roteBeete': <DishEntity>[],
      'qwest': <DishEntity>[],
    };

    final Either<Failure, List<DishEntity>> mensaCachedDishes = mensaRepository.getCachedDishes(1);
    final Either<Failure, List<DishEntity>> roteBeeteCachedDishes = mensaRepository.getCachedDishes(2);
    final Either<Failure, List<DishEntity>> qwestCachedDishes = mensaRepository.getCachedDishes(3);

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

    return data;
  }

  Future<Map<String, List<dynamic>>> updateDishesAndFailures() async {
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'mensa': <DishEntity>[],
      'roteBeete': <DishEntity>[],
      'qwest': <DishEntity>[],
      'henkelmann': <DishEntity>[],
      'unikids': <DishEntity>[],
    };

    // Get remote and cached dishes
    // TODO: Use scrapped dishes as fallback
    // final Either<Failure, List<DishEntity>> mensaRemoteDishes = await mensaRepository.getScrappedDishes(1);
    // final Either<Failure, List<DishEntity>> roteBeeteRemoteDishes = await mensaRepository.getScrappedDishes(2);
    // final Either<Failure, List<DishEntity>> qwestRemoteDishes = await mensaRepository.getScrappedDishes(3);

    final Either<Failure, List<DishEntity>> mensaRemoteDishes = await mensaRepository.getAWDishes(1);
    final Either<Failure, List<DishEntity>> roteBeeteRemoteDishes = await mensaRepository.getAWDishes(2);
    final Either<Failure, List<DishEntity>> qwestRemoteDishes = await mensaRepository.getAWDishes(3);
    final Either<Failure, List<DishEntity>> henkelmannRemoteDishes = await mensaRepository.getAWDishes(4);
    final Either<Failure, List<DishEntity>> unikidsRemoteDishes = await mensaRepository.getAWDishes(5);

    final Either<Failure, List<DishEntity>> mensaCachedDishes = mensaRepository.getCachedDishes(1);
    final Either<Failure, List<DishEntity>> roteBeeteCachedDishes = mensaRepository.getCachedDishes(2);
    final Either<Failure, List<DishEntity>> qwestCachedDishes = mensaRepository.getCachedDishes(3);
    final Either<Failure, List<DishEntity>> henkelmannCachedDishes = mensaRepository.getCachedDishes(4);
    final Either<Failure, List<DishEntity>> unikidsCachedDishes = mensaRepository.getCachedDishes(5);

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

    qwestRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['qwest'] = dishes,
    );

    mensaRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['mensa'] = dishes,
    );

    roteBeeteRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['roteBeete'] = dishes,
    );

    henkelmannCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['henkelmann'] = dishes,
    );

    henkelmannRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['henkelmann'] = dishes,
    );

    unikidsCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['unikids'] = dishes,
    );

    unikidsRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['unikids'] = dishes,
    );

    // Add Henkelmann to Mensa
    // TODO: Add Henekelmannn to cafeteria as soon it is implemented
    data['mensa']!.addAll(data['henkelmann']!);

    return data;
  }
}
