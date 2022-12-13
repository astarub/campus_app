// ignore_for_file: avoid_dynamic_calls

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_repository.dart';
import 'package:campus_app/pages/mensa/mensa_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'mensa_usecases_test.mocks.dart';
import 'samples/mensa_sample_json_response.dart';

@GenerateMocks([MensaRepository])
void main() {
  late MockMensaRepository mockMensaRepository;
  late MensaUsecases mensaUsecases;
  late List<DishEntity> samleDishEntities;

  setUp(() {
    mockMensaRepository = MockMensaRepository();
    mensaUsecases = MensaUsecases(mensaRepository: mockMensaRepository);

    initializeDateFormatting('de_DE').then((_) {
      samleDishEntities = [
        DishEntity.fromJSON(
          date: 0,
          category: 'Nudeltheke',
          json: mensaSampleTestData['data']['Mo, 10.10.']['Nudeltheke'][0],
        ),
        DishEntity.fromJSON(
          date: 0,
          category: 'Sprinter',
          json: mensaSampleTestData['data']['Mo, 10.10.']['Sprinter'][0],
        ),
        DishEntity.fromJSON(
          date: 1,
          category: 'Komponentenessen',
          json: mensaSampleTestData['data']['Di, 11.10.']['Komponentenessen'][0],
        ),
        DishEntity.fromJSON(
          date: 1,
          category: 'Dessert',
          json: mensaSampleTestData['data']['Di, 11.10.']['Dessert'][0],
        ),
        DishEntity.fromJSON(
          date: 1,
          category: 'Dessert',
          json: mensaSampleTestData['data']['Di, 11.10.']['Dessert'][1],
        ),
      ];
    });
  });

  group('[updateDishesAndFailures]', () {
    test('Should return a JSON object with list of failures and two lists of dishes', () async {
      final expectedReturn = {
        'failure': [CachFailure(), CachFailure()],
        'mensa': samleDishEntities,
        'roteBeete': samleDishEntities,
      };

      when(mockMensaRepository.getRemoteDishes(1)).thenAnswer((_) async => Right(samleDishEntities));
      when(mockMensaRepository.getRemoteDishes(2)).thenAnswer((_) async => Right(samleDishEntities));
      when(mockMensaRepository.getCachedDishes(1)).thenAnswer((_) => Left(CachFailure()));
      when(mockMensaRepository.getCachedDishes(2)).thenAnswer((_) => Left(CachFailure()));

      final testReturn = await mensaUsecases.updateDishesAndFailures();

      identical(testReturn, expectedReturn);
      verifyInOrder([
        mockMensaRepository.getRemoteDishes(1),
        mockMensaRepository.getRemoteDishes(2),
        mockMensaRepository.getCachedDishes(1),
        mockMensaRepository.getCachedDishes(2),
      ]);
      verifyNoMoreInteractions(mockMensaRepository);
    });

    test('Should return a JSON object with empty list of failures and two list of dishes', () async {
      final expectedReturn = {
        'failure': [],
        'mensa': samleDishEntities,
        'roteBeete': samleDishEntities,
      };

      when(mockMensaRepository.getRemoteDishes(1)).thenAnswer((_) async => Right(samleDishEntities));
      when(mockMensaRepository.getRemoteDishes(2)).thenAnswer((_) async => Right(samleDishEntities));
      when(mockMensaRepository.getCachedDishes(1)).thenAnswer((_) => Right(samleDishEntities));
      when(mockMensaRepository.getCachedDishes(2)).thenAnswer((_) => Right(samleDishEntities));

      // act: function call
      final testReturn = await mensaUsecases.updateDishesAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verifyInOrder([
        mockMensaRepository.getRemoteDishes(1),
        mockMensaRepository.getRemoteDishes(2),
        mockMensaRepository.getCachedDishes(1),
        mockMensaRepository.getCachedDishes(2),
      ]);
      verifyNoMoreInteractions(mockMensaRepository);
    });

    test('Should return a JSON object with empty lists of dishes and list of failures', () async {
      final expectedReturn = {
        'failure': [ServerFailure(), GeneralFailure(), CachFailure(), GeneralFailure()],
        'mensa': [],
        'roteBeete': [],
      };

      when(mockMensaRepository.getRemoteDishes(1)).thenAnswer((_) async => Left(ServerFailure()));
      when(mockMensaRepository.getRemoteDishes(2)).thenAnswer((_) async => Left(GeneralFailure()));
      when(mockMensaRepository.getCachedDishes(1)).thenAnswer((_) => Left(CachFailure()));
      when(mockMensaRepository.getCachedDishes(2)).thenAnswer((_) => Left(GeneralFailure()));

      // act: function call
      final testReturn = await mensaUsecases.updateDishesAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verifyInOrder([
        mockMensaRepository.getRemoteDishes(1),
        mockMensaRepository.getRemoteDishes(2),
        mockMensaRepository.getCachedDishes(1),
        mockMensaRepository.getCachedDishes(2),
      ]);
      verifyNoMoreInteractions(mockMensaRepository);
    });
  });

  group('[getCachedDishesAndFailures]', () {
    test('Should return a JSON object with empty list of failures and two lists of dishes', () {
      final expectedReturn = {
        'failure': [],
        'mensa': samleDishEntities,
        'roteBeete': samleDishEntities,
      };

      when(mockMensaRepository.getCachedDishes(1)).thenAnswer((_) => Right(samleDishEntities));
      when(mockMensaRepository.getCachedDishes(2)).thenAnswer((_) => Right(samleDishEntities));

      final testReturn = mensaUsecases.getCachedDishesAndFailures();

      identical(testReturn, expectedReturn);
      verifyInOrder([
        mockMensaRepository.getCachedDishes(1),
        mockMensaRepository.getCachedDishes(2),
      ]);
      verifyNever(mockMensaRepository.getRemoteDishes(1));
      verifyNever(mockMensaRepository.getRemoteDishes(2));
      verifyNoMoreInteractions(mockMensaRepository);
    });

    test('Should return a JSON object with one empty list of dishes and list of failures', () {
      final expectedReturn = {
        'failure': [CachFailure()],
        'mensa': samleDishEntities,
        'roteBeete': [],
      };
      // arrange: localFeed contains a CachFailure
      when(mockMensaRepository.getCachedDishes(1)).thenAnswer((_) => Left(CachFailure()));
      when(mockMensaRepository.getCachedDishes(2)).thenAnswer((_) => Right(samleDishEntities));

      // act: function call
      final testReturn = mensaUsecases.getCachedDishesAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verifyInOrder([
        mockMensaRepository.getCachedDishes(1),
        mockMensaRepository.getCachedDishes(2),
      ]);
      verifyNever(mockMensaRepository.getRemoteDishes(1));
      verifyNever(mockMensaRepository.getRemoteDishes(2));
      verifyNoMoreInteractions(mockMensaRepository);
    });
  });
}
