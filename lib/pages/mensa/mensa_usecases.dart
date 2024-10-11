import 'dart:async';
import 'dart:ui';

import 'package:dartz/dartz.dart';

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_repository.dart';

class MensaUsecases {
  final MensaRepository mensaRepository;

  MensaUsecases({required this.mensaRepository});

  Map<String, List<dynamic>> getCachedDishesAndFailures() {
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'mensa': <DishEntity>[],
      'roteBeete': <DishEntity>[],
      'qwest': <DishEntity>[],
      'henkelmann': <DishEntity>[],
      'unikids': <DishEntity>[],
      'bochult': <DishEntity>[],
      'whs_mensa': <DishEntity>[],
    };

    final Either<Failure, List<DishEntity>> mensaCachedDishes = mensaRepository.getCachedDishes(1);
    final Either<Failure, List<DishEntity>> roteBeeteCachedDishes = mensaRepository.getCachedDishes(2);
    final Either<Failure, List<DishEntity>> qwestCachedDishes = mensaRepository.getCachedDishes(3);
    final Either<Failure, List<DishEntity>> henkelmannCachedDishes = mensaRepository.getCachedDishes(4);
    final Either<Failure, List<DishEntity>> unikidsCachedDishes = mensaRepository.getCachedDishes(5);
    final Either<Failure, List<DishEntity>> whsCachedDishes = mensaRepository.getCachedDishes(6);
    final Either<Failure, List<DishEntity>> bocholtCachedDishes = mensaRepository.getCachedDishes(7);
    final Either<Failure, List<DishEntity>> recklinghausenCachedDishes = mensaRepository.getCachedDishes(8);

    // Q-West
    qwestCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['qwest'] = dishes,
    );

    // RUB Mensa
    mensaCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['mensa'] = dishes,
    );

    // Rote Beete
    roteBeeteCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['roteBeete'] = dishes,
    );

    // Henkelmann
    henkelmannCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['henkelmann'] = dishes,
    );

    // Unikids
    unikidsCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['unikids'] = dishes,
    );

    // WHS Mensa Gelsenkirchen
    whsCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['whs_mensa'] = dishes,
    );

    // WHS Bocholt
    bocholtCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['whs_mensa'] = dishes,
    );

    // WHS Recklinghausen
    recklinghausenCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['whs_mensa'] = dishes,
    );

    return data;
  }

  Future<Map<String, List<dynamic>>> updateDishesAndFailures({Locale locale = const Locale('de')}) async {
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'mensa': <DishEntity>[],
      'roteBeete': <DishEntity>[],
      'qwest': <DishEntity>[],
      'henkelmann': <DishEntity>[],
      'unikids': <DishEntity>[],
      'bochult': <DishEntity>[],
      'whs_mensa': <DishEntity>[],
    };

    // Get remote and cached dishes
    // TODO: Use scrapped dishes as fallback
    // final Either<Failure, List<DishEntity>> mensaRemoteDishes = await mensaRepository.getScrappedDishes(1);
    // final Either<Failure, List<DishEntity>> roteBeeteRemoteDishes = await mensaRepository.getScrappedDishes(2);
    // final Either<Failure, List<DishEntity>> qwestRemoteDishes = await mensaRepository.getScrappedDishes(3);

    final Either<Failure, List<DishEntity>> mensaRemoteDishes = await mensaRepository.getAWDishes(locale: locale);
    final Either<Failure, List<DishEntity>> roteBeeteRemoteDishes = await mensaRepository.getAWDishes(
      restaurant: 2,
      locale: locale,
    );
    final Either<Failure, List<DishEntity>> qwestRemoteDishes = await mensaRepository.getAWDishes(
      restaurant: 3,
      locale: locale,
    );
    final Either<Failure, List<DishEntity>> henkelmannRemoteDishes = await mensaRepository.getAWDishes(
      restaurant: 4,
      locale: locale,
    );
    final Either<Failure, List<DishEntity>> unikidsRemoteDishes = await mensaRepository.getAWDishes(
      restaurant: 5,
      locale: locale,
    );
    final Either<Failure, List<DishEntity>> whsRemoteDishes = await mensaRepository.getAWDishes(
      restaurant: 6,
      locale: locale,
    );
    final Either<Failure, List<DishEntity>> bocholtRemoteDishes = await mensaRepository.getAWDishes(
      restaurant: 7,
      locale: locale,
    );
    final Either<Failure, List<DishEntity>> recklinghausenRemoteDishes = await mensaRepository.getAWDishes(
      restaurant: 8,
      locale: locale,
    );

    final Either<Failure, List<DishEntity>> mensaCachedDishes = mensaRepository.getCachedDishes(1);
    final Either<Failure, List<DishEntity>> roteBeeteCachedDishes = mensaRepository.getCachedDishes(2);
    final Either<Failure, List<DishEntity>> qwestCachedDishes = mensaRepository.getCachedDishes(3);
    final Either<Failure, List<DishEntity>> henkelmannCachedDishes = mensaRepository.getCachedDishes(4);
    final Either<Failure, List<DishEntity>> unikidsCachedDishes = mensaRepository.getCachedDishes(5);
    final Either<Failure, List<DishEntity>> whsCachedDishes = mensaRepository.getCachedDishes(6);
    final Either<Failure, List<DishEntity>> bocholtCachedDishes = mensaRepository.getCachedDishes(7);
    final Either<Failure, List<DishEntity>> recklinghausenCachedDishes = mensaRepository.getCachedDishes(8);

    // Q-West
    qwestCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['qwest'] = dishes,
    );

    qwestRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['qwest'] = dishes,
    );

    // RUB Mensa
    mensaCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['mensa'] = dishes,
    );

    mensaRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['mensa'] = dishes,
    );

    // Rote Beete
    roteBeeteCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['roteBeete'] = dishes,
    );

    roteBeeteRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['roteBeete'] = dishes,
    );

    // Henkelmann
    henkelmannCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['henkelmann'] = dishes,
    );

    henkelmannRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['henkelmann'] = dishes,
    );

    // Unikids
    unikidsCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['unikids'] = dishes,
    );

    unikidsRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['unikids'] = dishes,
    );

    // WHS Mensa Gelsenkirchen
    whsCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['whs_mensa'] = dishes,
    );

    whsRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['whs_mensa'] = dishes,
    );

    // WHS Bocholt
    bocholtCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['bocholt'] = dishes,
    );

    bocholtRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['bocholt'] = dishes,
    );

    // WHS Recklinghausen
    recklinghausenCachedDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['recklinghausen'] = dishes,
    );

    recklinghausenRemoteDishes.fold(
      (failure) => data['failures']!.add(failure),
      (dishes) => data['recklinghausen'] = dishes,
    );

    // Add Henkelmann to Mensa
    // TODO: Add Henekelmannn to cafeteria as soon it is implemented
    data['mensa']!.addAll(data['henkelmann']!);

    return data;
  }
}
