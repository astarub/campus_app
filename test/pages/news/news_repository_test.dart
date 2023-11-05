import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/pages/feed/news/news_datasource.dart';
import 'package:campus_app/pages/feed/news/news_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:xml/xml.dart';

import '../test_constants.dart';
import 'news_repository_test.mocks.dart';
import 'samples/single_news_xmlitem.dart';

@GenerateMocks([NewsDatasource])
void main() {
  late NewsRepository newsRepository;
  late MockNewsDatasource mockNewsDatasource;

  setUp(() {
    mockNewsDatasource = MockNewsDatasource();
    newsRepository = NewsRepository(newsDatasource: mockNewsDatasource);
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
          imageUrl: rubnewsTestNewsUrlSingleImageUrl,
          videoUrl: rubnewsTestNewsUrlSingleImageUrl,
          description: 'description',
          content: 'content',
          url: rubnewsTestNewsUrlSingleImage,
        ),
      ];

      // arrange: RubnewsRemoteDatasource respond with a XmlDocument
      when(mockNewsDatasource.getNewsfeedAsXml()).thenAnswer((_) async => testXmlDocument);

      // act: funtion call
      final testReturn = await newsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> List<NewsEntity> of length one with specified entity
      identical(testReturn, expectedReturn);
      verify(mockNewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verify(
        mockNewsDatasource.getImageDataFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // one element -> one function call
      verifyNoMoreInteractions(mockNewsDatasource);
    });

    test('Should return a ServerFailure on failed web request inside getNewsfeedAsXml()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = ServerFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockNewsDatasource.getNewsfeedAsXml()).thenThrow(ServerException());

      // act: funtion call
      final testReturn = await newsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockNewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verifyNever(
        mockNewsDatasource.getImageDataFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // exception is thrown inside first funtion, so this function shouldn't called
      verifyNoMoreInteractions(mockNewsDatasource);
    });

    test('Should return a ServerFailure on failed web request inside getImageUrlsFromNewsUrl()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = ServerFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockNewsDatasource.getNewsfeedAsXml()).thenAnswer((_) async => testXmlDocument);
      when(mockNewsDatasource.getImageDataFromNewsUrl(rubnewsTestNewsUrlSingleImage)).thenThrow(ServerException());

      // act: funtion call
      final testReturn = await newsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockNewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verify(
        mockNewsDatasource.getImageDataFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // one element -> one function call
      verifyNoMoreInteractions(mockNewsDatasource);
    });

    test('Should return a GeneralFailure on unexpected Exception inside getNewsfeedAsXml()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = ServerFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockNewsDatasource.getNewsfeedAsXml()).thenThrow(Exception());

      // act: funtion call
      final testReturn = await newsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockNewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verifyNever(
        mockNewsDatasource.getImageDataFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // exception is thrown inside first funtion, so this function shouldn't called
      verifyNoMoreInteractions(mockNewsDatasource);
    });

    test('Should return a GeneralFailure on unexpected Exception inside getImageUrlsFromNewsUrl()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = GeneralFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockNewsDatasource.getNewsfeedAsXml()).thenAnswer((_) async => testXmlDocument);
      when(mockNewsDatasource.getImageDataFromNewsUrl(rubnewsTestNewsUrlSingleImage)).thenThrow(Exception());

      // act: funtion call
      final testReturn = await newsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockNewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verify(
        mockNewsDatasource.getImageDataFromNewsUrl(rubnewsTestNewsUrlSingleImage),
      ); // one element -> one function call
      verifyNoMoreInteractions(mockNewsDatasource);
    });
  });

  group('[getCachedNewsfeed]', () {
    final samleNewsEntities = [
      NewsEntity(title: 'title1', pubDate: DateTime(0), imageUrl: ''),
      NewsEntity(title: 'title2', pubDate: DateTime(1), imageUrl: '0', description: 'description'),
      NewsEntity(title: 'title', pubDate: DateTime(0), imageUrl: 'imageUrls', content: 'content'),
    ];
    test("Should return list of news etities if datasource doesn't throw a exception", () {
      // arrange: datasource return a news entity list
      when(mockNewsDatasource.readNewsEntitiesFromCach()).thenAnswer((_) => samleNewsEntities);

      // act: function call
      final testReturn = newsRepository.getCachedNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, samleNewsEntities);
      verify(mockNewsDatasource.readNewsEntitiesFromCach());
      verifyNoMoreInteractions(mockNewsDatasource);
    });

    test('Should return a CachFailure on unexpected Exception inside readNewsEntitiesFromCach()', () async {
      /// CachFailure on unexpected Exception
      final expectedReturn = CachFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockNewsDatasource.readNewsEntitiesFromCach()).thenThrow(Exception());

      // act: funtion call
      final testReturn = newsRepository.getCachedNewsfeed();

      // assert: is testElement expected object? -> CachFailure
      identical(testReturn, expectedReturn);
      verify(mockNewsDatasource.readNewsEntitiesFromCach());
      verifyNoMoreInteractions(mockNewsDatasource);
    });
  });
}
