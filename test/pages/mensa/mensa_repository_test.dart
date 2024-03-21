// ignore_for_file: avoid_dynamic_calls

import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_datasource.dart';
import 'package:campus_app/pages/mensa/mensa_repository.dart';

import 'mensa_repository_test.mocks.dart';
import 'samples/mensa_sample_json_response.dart';

@GenerateMocks([MensaDataSource, Client])
void main() {
  late MensaRepository mensaRepository;
  late MockMensaDataSource mockMensaDataSource;
  late List<DishEntity> samleDishEntities;

  setUp(() {
    mockMensaDataSource = MockMensaDataSource();
    mensaRepository = MensaRepository(
      mensaDatasource: mockMensaDataSource,
      awClient: MockClient(),
    );

    //initializeDateFormatting('de_DE').then((_) {
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
    //});
  });

  group('[getRemoteData]', () {
    test('Should return a list of [DishEntity] on successfully web reuest', () async {
      when(mockMensaDataSource.getRemoteData(1)).thenAnswer((_) async => mensaSampleTestData);

      final testReturn = await mensaRepository.getScrappedDishes(1);

      identical(testReturn, samleDishEntities);
      verify(mockMensaDataSource.getRemoteData(1));
      verify(mockMensaDataSource.writeDishEntitiesToCache(any, 1));
      verifyNoMoreInteractions(mockMensaDataSource);
    });

    test('Should return a [ServerFailure] on failed web request', () async {
      /// ServerFailure on ServerException
      final expectedReturn = ServerFailure();

      when(mockMensaDataSource.getRemoteData(1)).thenThrow(ServerException());

      final testReturn = await mensaRepository.getScrappedDishes(1);

      identical(testReturn, expectedReturn);
      verify(mockMensaDataSource.getRemoteData(1));
      verifyNoMoreInteractions(mockMensaDataSource);
    });

    test('Should return a [GeneralFailure] on unexpected Exception', () async {
      /// GeneralFailure on any Exception
      final expectedReturn = GeneralFailure();

      when(mockMensaDataSource.getRemoteData(1)).thenThrow(Exception());

      final testReturn = await mensaRepository.getScrappedDishes(1);

      identical(testReturn, expectedReturn);
      verify(mockMensaDataSource.getRemoteData(1));
      verifyNoMoreInteractions(mockMensaDataSource);
    });
  });

  group('[getCachedDishes]', () {
    test("Should return list of dish etities if datasource doesn't throw a exception", () {
      when(mockMensaDataSource.readDishEntitiesFromCache(1)).thenAnswer((_) => samleDishEntities);

      final testReturn = mensaRepository.getCachedDishes(1);

      identical(testReturn, samleDishEntities);
      verify(mockMensaDataSource.readDishEntitiesFromCache(1));
      verifyNoMoreInteractions(mockMensaDataSource);
    });

    test('Should return a CachFailure on unexpected Exception inside readDishEntitiesFromCache()', () async {
      /// CachFailure on unexpected Exception
      final expectedReturn = CachFailure();

      when(mockMensaDataSource.readDishEntitiesFromCache(1)).thenThrow(Exception());

      final testReturn = mensaRepository.getCachedDishes(1);

      identical(testReturn, expectedReturn);
      verify(mockMensaDataSource.readDishEntitiesFromCache(1));
      verifyNoMoreInteractions(mockMensaDataSource);
    });
  });
}
