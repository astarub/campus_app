import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/pages/rubnews/rubnews_datasource.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:xml/xml.dart';

import 'rubnews_datasource_test.mocks.dart';

@GenerateMocks([Dio, Box])
void main() {
  late RubnewsDatasource rubnewsRemoteDatasource;
  late Dio mockClient;
  late Box mockCach;

  setUp(() async {
    mockClient = MockDio();
    mockCach = MockBox();

    rubnewsRemoteDatasource = RubnewsDatasource(client: mockClient, rubnewsCach: mockCach);
  });

  group('[getNewsfeedAsXml]', () {
    /// The XmlDocumnet that is expected to be returned after succefully GET request
    final XmlDocument expectedReturn = XmlDocument.parse(rubnewsTestsDataSuccess);

    /// A Dio response on successfully request
    final resSuccess = Response(
      requestOptions: RequestOptions(path: rubNewsfeed),
      statusCode: 200,
      data: rubnewsTestsDataSuccess,
    );

    /// A Dio response on failed request thougth connection error (statuscode 404)
    final resFailure = Response(
      requestOptions: RequestOptions(path: rubNewsfeed),
      statusCode: 404,
    );

    test('Should return an XML Document on successful web request', () {
      // arrange: Dio respond with statuscode 200 and XML data
      when(mockClient.get(rubNewsfeed)).thenAnswer((_) async => resSuccess);

      // act: function call
      final testReturn = rubnewsRemoteDatasource.getNewsfeedAsXml();

      // assert: is testElement expected object? -> XmlDocument
      identical(testReturn, expectedReturn); // is the returned object the expected one?
      verify(mockClient.get(rubNewsfeed)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });

    test('Should throw a ServerException on failed web request', () {
      // arrange: Dio respond with statuscode 404
      when(mockClient.get(rubNewsfeed)).thenAnswer((_) async => resFailure);

      // assert: is ServerException thrown?
      expect(() => rubnewsRemoteDatasource.getNewsfeedAsXml(), throwsA(isA<ServerException>()));
      verify(mockClient.get(rubNewsfeed)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });
  });

  group('[getImageUrlsFromNewsUrl]', () {
    test('Should return a list with one URL to images on successfully web request', () {
      /// A Dio response on successfully request
      final resSuccess = Response(
        requestOptions: RequestOptions(path: rubnewsTestNewsurl1),
        statusCode: 200,
        data: rubnewsTestsNews1DataSuccess,
      );

      final List<String> expectedReturn = [
        'https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2021_08_16_km_biopsychologie_tauben-34-auswahl.jpg?itok=PBFSkZyP',
      ];

      // arrange: Dio respond with statuscode 200 and XML data
      when(mockClient.get(rubnewsTestNewsurl1)).thenAnswer((_) async => resSuccess);

      // act: function call
      final testReturn = rubnewsRemoteDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl1);

      // assert: is testElement expected object? -> XmlDocument
      identical(testReturn, expectedReturn); // is the returned object the expected one?
      verify(mockClient.get(rubnewsTestNewsurl1)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });

    test('Should throw a ServerException on failed web request', () {
      /// A Dio response on failed request thougth connection error (statuscode 404)
      final resFailure = Response(
        requestOptions: RequestOptions(path: rubnewsTestNewsurl1),
        statusCode: 404,
      );

      // arrange: Dio respond with statuscode 404
      when(mockClient.get(rubnewsTestNewsurl1)).thenAnswer((_) async => resFailure);

      // assert: is ServerException thrown?
      expect(
        () => rubnewsRemoteDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl1),
        throwsA(isA<ServerException>()),
      );
      verify(mockClient.get(rubnewsTestNewsurl1)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });

    test('Should return a list with five URLs to images on successfully web request', () {
      /// A Dio response on successfully request
      final resSuccess = Response(
        requestOptions: RequestOptions(path: rubnewsTestNewsurl2),
        statusCode: 200,
        data: rubnewsTestsNews2DataSuccess,
      );

      final List<String> expectedReturn = [
        'https://news.rub.de/sites/default/files/styles/nepo_teaser/public/07_kita.jpg?itok=zFSUaTtI',
        'https://news.rub.de/sites/default/files/styles/nepo_teaser/public/06_einkauf.jpg?itok=6xhxGfCN',
        'https://news.rub.de/sites/default/files/styles/nepo_teaser/public/03_baeckerei.jpg?itok=9NZg0XBl',
        'https://news.rub.de/sites/default/files/styles/nepo_teaser/public/09_schirme_0.jpg?itok=WpqghJOX',
        'https://news.rub.de/sites/default/files/styles/nepo_teaser/public/05_geburtstag.jpg?itok=z5N_Q2rC',
      ];

      // arrange: Dio respond with statuscode 200 and XML data
      when(mockClient.get(rubnewsTestNewsurl2)).thenAnswer((_) async => resSuccess);

      // act: function call
      final testReturn = rubnewsRemoteDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl2);

      // assert: is testElement expected object? -> XmlDocument
      identical(testReturn, expectedReturn); // is the returned object the expected one?
      verify(mockClient.get(rubnewsTestNewsurl2)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });
  });

  group('[Caching]', () {
    final samleNewsEntities = [
      NewsEntity(title: 'title1', pubDate: DateTime(0), imageUrls: ['']),
      NewsEntity(title: 'title2', pubDate: DateTime(1), imageUrls: ['0', '1'], description: 'description'),
      NewsEntity(title: 'title', pubDate: DateTime(0), imageUrls: ['imageUrls', ''], content: 'content'),
    ];
    test('Should return the same entities on read as writen befor', () async {
      when(mockCach.get('cnt')).thenAnswer((_) => 3);
      when(mockCach.get(0)).thenAnswer((_) => samleNewsEntities[0]);
      when(mockCach.get(1)).thenAnswer((_) => samleNewsEntities[1]);
      when(mockCach.get(2)).thenAnswer((_) => samleNewsEntities[2]);

      // act: write sample entities to cach
      await rubnewsRemoteDatasource.writeNewsEntitiesToCach(samleNewsEntities);
      final testReturn = rubnewsRemoteDatasource.readNewsEntitiesFromCach();

      // assert: is testElement expected object? -> List<NewsEntity> samleNewsEntities
      identical(testReturn, samleNewsEntities); // is the returned object the expected one?
    });
  });
}
