import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/pages/rubnews/rubnews_datasource.dart';
import 'package:campus_app/pages/rubnews/rubnews_repository.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:xml/xml.dart';

import 'rubnews_repository_test.mocks.dart';

@GenerateMocks([RubnewsDatasource])
void main() {
  late RubnewsRepository rubnewsRepository;
  late MockRubnewsDatasource mockRubnewsDatasource;

  setUp(() {
    mockRubnewsDatasource = MockRubnewsDatasource();
    rubnewsRepository = RubnewsRepository(rubnewsRemoteDatasource: mockRubnewsDatasource);
  });

  group('[getRemoteNewsfeed]', () {
    /// An example XmlDocument with empty content
    final testXmlDocument = XmlDocument.parse(
      '''
      <?xml version="1.0" encoding="utf-8" ?>
      <rss version="2.0" xml:base="https://news.rub.de/" xmlns:atom="http://www.w3.org/2005/Atom">
          <channel>
              <item>
                  <content>content</content>
                  <title>title</title>
                  <link>https://news.rub.de/wissenschaft/2022-09-09-biopsychologie-schlaue-voegel-denken-smart-und-sparsam</link>
                  <description>description</description>
                  <pubDate>Wed, 07 Sep 2022 09:31:00 +0200</pubDate>
              </item>
          </channel>
      </rss>
      ''',
    );

    test('Should return news list on successfully web request', () async {
      /// List of NewsEntity with one sample entity
      final expectedReturn = [
        NewsEntity(
          title: 'title',
          pubDate: DateFormat('E, d MMM yyyy hh:mm:ss Z', 'en_US').parse('Wed, 07 Sep 2022 09:31:00 +0200'),
          imageUrls: [
            'https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2021_08_16_km_biopsychologie_tauben-34-auswahl.jpg?itok=PBFSkZyP',
          ],
          description: 'description',
          content: 'content',
          url: rubnewsTestNewsurl1,
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
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl1),
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
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl1),
      ); // exception is thrown inside first funtion, so this function shouldn't called
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });

    test('Should return a ServerFailure on failed web request inside getImageUrlsFromNewsUrl()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = ServerFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockRubnewsDatasource.getNewsfeedAsXml()).thenAnswer((_) async => testXmlDocument);
      when(mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl1)).thenThrow(ServerException());

      // act: funtion call
      final testReturn = await rubnewsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockRubnewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verify(
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl1),
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
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl1),
      ); // exception is thrown inside first funtion, so this function shouldn't called
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });

    test('Should return a GeneralFailure on unexpected Exception inside getImageUrlsFromNewsUrl()', () async {
      /// ServerFailure on ServerException
      final expectedReturn = GeneralFailure();

      // arrange: RubnewsRemoteDatasource throws a ServerException
      when(mockRubnewsDatasource.getNewsfeedAsXml()).thenAnswer((_) async => testXmlDocument);
      when(mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl1)).thenThrow(Exception());

      // act: funtion call
      final testReturn = await rubnewsRepository.getRemoteNewsfeed();

      // assert: is testElement expected object? -> ServerFailure
      identical(testReturn, expectedReturn);
      verify(mockRubnewsDatasource.getNewsfeedAsXml()); // one element -> one function call
      verify(
        mockRubnewsDatasource.getImageUrlsFromNewsUrl(rubnewsTestNewsurl1),
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
      final testReturn = await rubnewsRepository.getCachedNewsfeed();

      // assert: is testElement expected object? -> CachFailure
      identical(testReturn, expectedReturn);
      verify(mockRubnewsDatasource.readNewsEntitiesFromCach());
      verifyNoMoreInteractions(mockRubnewsDatasource);
    });
  });
}
