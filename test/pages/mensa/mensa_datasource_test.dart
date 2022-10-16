import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/mensa/dish_entity.dart';
import 'package:campus_app/pages/mensa/mensa_datasource.dart';
import 'package:campus_app/utils/constants.dart';

import 'mensa_datasource_test.mocks.dart';
import 'samples/mensa_server_response.dart';
import 'samples/mensa_dish_entities.dart';

@GenerateMocks([Dio, Box])
void main() {
  late MensaDataSource mensaDataSource;
  late Dio mockClient;
  late Box mockCach;

  setUp(() async {
    mockCach = MockBox();
    mockClient = MockDio();

    mensaDataSource = MensaDataSource(client: mockClient, mensaCache: mockCach);
  });

  group('[getRemoteData]', () {
    /// The JSON that is expected to be returned after succefully GET request
    final expectedReturn = json.decode(mensaSampleServerData);

    /// A Dio response on successfully request
    final resSuccess = Response(
      requestOptions: RequestOptions(path: '$mensaData/1'),
      statusCode: 200,
      data: mensaSampleServerData,
    );

    /// A Dio response on failed request thougth connection error (statuscode 404)
    final resFailure = Response(
      requestOptions: RequestOptions(path: '$mensaData/1'),
      statusCode: 404,
    );

    test('Should return a JSON Document on successful web request', () async {
      when(mockClient.get('$mensaData/1', options: anyNamed('options'))).thenAnswer((_) async => resSuccess);

      final testReturn = await mensaDataSource.getRemoteData(1);

      identical(testReturn, expectedReturn);
      verify(mockClient.get('$mensaData/1', options: anyNamed('options')));
      verifyNoMoreInteractions(mockClient);
    });

    test('Should throw a ServerException on failed web request', () {
      when(mockClient.get('$mensaData/1', options: anyNamed('options'))).thenAnswer((_) async => resFailure);

      expect(() => mensaDataSource.getRemoteData(1), throwsA(isA<ServerException>()));
      verify(mockClient.get('$mensaData/1', options: anyNamed('options')));
      verifyNoMoreInteractions(mockClient);
    });
  });

  group('[Caching]', () {
    final samleNewsEntities = [
      DishEntity.fromJSON(date: DateTime(0), category: 'Aktion', json: mensaSampleDish1),
      DishEntity.fromJSON(date: DateTime(1), category: 'Beilage', json: mensaSampleDish2),
      DishEntity.fromJSON(date: DateTime(2), category: 'Falafel Teller', json: mensaSampleDish3),
    ];
    test('Should return the same entities on read as writen befor', () async {
      when(mockCach.get('cnt1')).thenAnswer((_) => 3);
      when(mockCach.get('10')).thenAnswer((_) => samleNewsEntities[0]);
      when(mockCach.get('11')).thenAnswer((_) => samleNewsEntities[1]);
      when(mockCach.get('12')).thenAnswer((_) => samleNewsEntities[2]);

      await mensaDataSource.writeDishEntitiesToCache(samleNewsEntities, 1);
      final testReturn = mensaDataSource.readDishEntitiesFromCache(1);

      identical(testReturn, samleNewsEntities);
    });
  });
}
