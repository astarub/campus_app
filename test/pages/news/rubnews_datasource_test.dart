import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/pages/feed/news/news_datasource.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:xml/xml.dart';

import '../test_constants.dart';
import 'rubnews_datasource_test.mocks.dart';
import 'samples/news_html_single_image.dart';
import 'samples/newsfeed_response.dart';

@GenerateMocks([Dio, Box])
void main() {
  late NewsDatasource rubnewsRemoteDatasource;
  late Dio mockClient;
  late Box mockCach;

  setUp(() async {
    mockClient = MockDio();
    mockCach = MockBox();

    rubnewsRemoteDatasource = NewsDatasource(client: mockClient, rubnewsCache: mockCach);
  });

  group('[getNewsfeedAsXml]', () {
    /// The XmlDocumnet that is expected to be returned after succefully GET request
    final XmlDocument expectedReturn = XmlDocument.parse(rubnewsSamplesNewsfeedResponse);

    /// A Dio response on successfully request
    final resSuccess = Response(
      requestOptions: RequestOptions(path: rubNewsfeed),
      statusCode: 200,
      data: rubnewsSamplesNewsfeedResponse,
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
        requestOptions: RequestOptions(path: rubnewsTestNewsUrlSingleImage),
        statusCode: 200,
        data: rubnewsSampleNewsHTMLSingleImage,
      );

      final List<String> expectedReturn = [
        'https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2021_08_16_km_biopsychologie_tauben-34-auswahl.jpg?itok=PBFSkZyP',
      ];

      // arrange: Dio respond with statuscode 200 and XML data
      when(mockClient.get(rubnewsTestNewsUrlSingleImage)).thenAnswer((_) async => resSuccess);

      // act: function call
      final testReturn = rubnewsRemoteDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlSingleImage);

      // assert: is testElement expected object? -> XmlDocument
      identical(testReturn, expectedReturn); // is the returned object the expected one?
      verify(mockClient.get(rubnewsTestNewsUrlSingleImage)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });

    test('Should throw a ServerException on failed web request', () {
      /// A Dio response on failed request thougth connection error (statuscode 404)
      final resFailure = Response(
        requestOptions: RequestOptions(path: rubnewsTestNewsUrlSingleImage),
        statusCode: 404,
      );

      // arrange: Dio respond with statuscode 404
      when(mockClient.get(rubnewsTestNewsUrlSingleImage)).thenAnswer((_) async => resFailure);

      // assert: is ServerException thrown?
      expect(
        () => rubnewsRemoteDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlSingleImage),
        throwsA(isA<ServerException>()),
      );
      verify(mockClient.get(rubnewsTestNewsUrlSingleImage)); // was client function called?
      verifyNoMoreInteractions(mockClient); // no more interactions with client after get()?
    });

    test('Should return a list with five URLs to images on successfully web request', () {
      /// A Dio response on successfully request
      final resSuccess = Response(
        requestOptions: RequestOptions(path: rubnewsTestNewsUrlMultipleImages),
        statusCode: 200,
        data: rubnewsSampleNewsHTMLSingleImage,
      );

      // arrange: Dio respond with statuscode 200 and XML data
      when(mockClient.get(rubnewsTestNewsUrlMultipleImages)).thenAnswer((_) async => resSuccess);

      // act: function call
      final testReturn = rubnewsRemoteDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlMultipleImages);

      // assert: is testElement expected object? -> XmlDocument
      identical(testReturn, rubnewsTestNewsUrlMultipleImagesUrls); // is the returned object the expected one?
      verify(mockClient.get(rubnewsTestNewsUrlMultipleImages)); // was client function called?
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
      await rubnewsRemoteDatasource.writeNewsEntitiesToCache(samleNewsEntities);
      final testReturn = rubnewsRemoteDatasource.readNewsEntitiesFromCach();

      // assert: is testElement expected object? -> List<NewsEntity> samleNewsEntities
      identical(testReturn, samleNewsEntities); // is the returned object the expected one?
    });
  });
}
