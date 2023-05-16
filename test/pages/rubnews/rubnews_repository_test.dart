import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/astafeed/astafeed_datasource.dart';
import 'package:campus_app/pages/feed/rubnews/news_entity.dart';
import 'package:campus_app/pages/feed/rubnews/rubnews_datasource.dart';
import 'package:campus_app/pages/feed/rubnews/rubnews_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:xml/xml.dart';

import '../calendar/calendar_datasource_test.mocks.dart';
import '../test_constants.dart';
import 'rubnews_repository_test.mocks.dart';
import 'samples/single_news_xmlitem.dart';

@GenerateMocks([RubnewsDatasource])
void main() {
  late RubnewsRepository rubnewsRepository;
  late MockRubnewsDatasource mockRubnewsDatasource;
  late AstaFeedDatasource astaFeedDatasource;

  setUp(() {
    mockRubnewsDatasource = MockRubnewsDatasource();
    astaFeedDatasource = AstaFeedDatasource(client: MockDio());
    rubnewsRepository = RubnewsRepository(rubnewsDatasource: mockRubnewsDatasource, astaFeedDatasource: astaFeedDatasource);
  });

  group('[getRemoteNewsfeed]', () {
    /// An example XmlDocument with empty content
    final testXmlDocument = XmlDocument.parse(rubnewsSampleSingleNewsXMLItem);

    test('Should return news list on successfully web request', () async {
      /// List of NewsEntity with one sample entity
      final expectedReturn = [
        NewsEntity(
          title: 'title',
          pubDate: DateFormat('E, d MMM yyyy hh:mm:ss Z', 'en_US').parse('Wed, 07 Sep 2022 09:31:00 +0200'),
          imageUrls: [rubnewsTestNewsUrlSingleImageUrl],
          description: 'description',
          content: 'content',
          url: rubnewsTestNewsUrlSingleImage,
        )
      ];

      // arrange: RubnewsRemoteDatasource respond with a XmlDocument
      when(mockRubnewsDatasource.getNewsfeedAsXml()).thenAnswer((_) async => testXmlDocument);

      // act: funtion call
      final testReturn = await rubnewsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> List<NewsEntity> of length one with specified entity
      identical(testReturn, expectedReturn);
      verify(mockRubnewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verify(
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // one element -> one function call
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });

    test('Should return a ServerFailure on failed web request inside getNewsfeedAsXml()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = ServerFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockRubnewsDatasource.getNewsfeedAsXml()).thenThrow(ServerException());

      // act: funtion call
      final testReturn = await rubnewsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockRubnewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verifyNever(
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // exception is thrown inside first funtion, so this function shouldn't called
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });

    test('Should return a ServerFailure on failed web request inside getImageUrlsFromNewsUrl()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = ServerFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockRubnewsDatasource.getNewsfeedAsXml()).thenAnswer((_) async => testXmlDocument);
      when(mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlSingleImage)).thenThrow(ServerException());

      // act: funtion call
      final testReturn = await rubnewsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockRubnewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verify(
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // one element -> one function call
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });

    test('Should return a GeneralFailure on unexpected Exception inside getNewsfeedAsXml()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = ServerFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockRubnewsDatasource.getNewsfeedAsXml()).thenThrow(Exception());

      // act: funtion call
      final testReturn = await rubnewsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockRubnewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verifyNever(
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // exception is thrown inside first funtion, so this function shouldn't called
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });

    test('Should return a GeneralFailure on unexpected Exception inside getImageUrlsFromNewsUrl()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = GeneralFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockRubnewsDatasource.getNewsfeedAsXml()).thenAnswer((_) async => testXmlDocument);
      when(mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlSingleImage)).thenThrow(Exception());

      // act: funtion call
      final testReturn = await rubnewsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockRubnewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verify(
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // one element -> one function call
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });
  });

  group('[getCachedNewsfeed]', () {
    final samleNewsEntities = [
      NewsEntity(title: 'title1', pubDate: DateTime(0), imageUrls: ['']),
      NewsEntity(title: 'title2', pubDate: DateTime(1), imageUrls: ['0', '1'], description: 'description'),
      NewsEntity(title: 'title', pubDate: DateTime(0), imageUrls: ['imageUrls', ''], content: 'content'),
    ];
    test("Should return list of news etities if datasource doesn't throw a exception", () {
      // arrange: datasource return a news entity list
      when(mockRubnewsDatasource.readNewsEntitiesFromCach()).thenAnswer((_) => samleNewsEntities);

      // act: function call
      final testReturn = rubnewsRepository.getCachedNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, samleNewsEntities);
      verify(mockRubnewsDatasource.readNewsEntitiesFromCach());
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });

    test('Should return a CachFailure on unexpected Exception inside readNewsEntitiesFromCach()', () async {
      /// CachFailure on unexpected Exception
      final expectedReturn = CachFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockRubnewsDatasource.readNewsEntitiesFromCach()).thenThrow(Exception());

      // act: funtion call
      final testReturn = rubnewsRepository.getCachedNewsfeed();

      // assert: is testElement expected object? -> CachFailure
      identical(testReturn, expectedReturn);
      verify(mockRubnewsDatasource.readNewsEntitiesFromCach());
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });
  });
}
