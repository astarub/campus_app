import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/pages/feed/news/news_repository.dart';
import 'package:campus_app/pages/feed/news/news_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'news_usecases_test.mocks.dart';

@GenerateMocks([RubnewsRepository])
void main() {
  late RubnewsUsecases rubnewsUsecases;
  late MockRubnewsRepository mockRubnewsRepository;

  setUp(() {
    mockRubnewsRepository = MockRubnewsRepository();
    rubnewsUsecases = RubnewsUsecases(rubnewsRepository: mockRubnewsRepository);
  });

  group('[updateFeedAndFailures]', () {
    final samleNewsEntities = [
      NewsEntity(title: 'title1', pubDate: DateTime(0), imageUrls: ['']),
      NewsEntity(title: 'title2', pubDate: DateTime(1), imageUrls: ['0', '1'], description: 'description'),
      NewsEntity(title: 'title', pubDate: DateTime(0), imageUrls: ['imageUrls', ''], content: 'content'),
    ];

    test('Should return a JSON object with list of failures and list of news', () async {
      final expectedReturn = {
        'failure': [CachFailure()],
        'news': samleNewsEntities,
      };

      // arrange: remoteFeed contains news entities and localFeed contains a CachFailure
      when(mockRubnewsRepository.getRemoteNewsfeed()).thenAnswer((_) => Future.value(Right(samleNewsEntities)));
      when(mockRubnewsRepository.getCachedNewsfeed()).thenAnswer((_) => Left(CachFailure()));

      // act: function call
      final testReturn = await rubnewsUsecases.updateFeedAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verify(mockRubnewsRepository.getRemoteNewsfeed());
      verify(mockRubnewsRepository.getCachedNewsfeed());
      verifyNoMoreInteractions(mockRubnewsRepository);
    });
    test('Should return a JSON object with empty list of failures and list of news', () async {
      final expectedReturn = {
        'failure': [],
        'news': samleNewsEntities,
      };

      // arrange: remoteFeed contains news entities and localFeed contains a CachFailure
      when(mockRubnewsRepository.getRemoteNewsfeed()).thenAnswer((_) => Future.value(Right(samleNewsEntities)));
      when(mockRubnewsRepository.getCachedNewsfeed()).thenAnswer((_) => Right(samleNewsEntities));

      // act: function call
      final testReturn = await rubnewsUsecases.updateFeedAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verify(mockRubnewsRepository.getRemoteNewsfeed());
      verify(mockRubnewsRepository.getCachedNewsfeed());
      verifyNoMoreInteractions(mockRubnewsRepository);
    });

    test('Should return a JSON object with empty list of news and list of failures', () async {
      final expectedReturn = {
        'failure': [CachFailure(), ServerFailure()],
        'news': [],
      };

      // arrange: remoteFeed contains news entities and localFeed contains a CachFailure
      when(mockRubnewsRepository.getRemoteNewsfeed()).thenAnswer((_) => Future.value(Left(ServerFailure())));
      when(mockRubnewsRepository.getCachedNewsfeed()).thenAnswer((_) => Left(CachFailure()));

      // act: function call
      final testReturn = await rubnewsUsecases.updateFeedAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verify(mockRubnewsRepository.getRemoteNewsfeed());
      verify(mockRubnewsRepository.getCachedNewsfeed());
      verifyNoMoreInteractions(mockRubnewsRepository);
    });

    test('Should return a JSON object with list of news and ServerFailure', () async {
      final expectedReturn = {
        'failure': [ServerFailure()],
        'news': samleNewsEntities,
      };

      // arrange: remoteFeed contains news entities and localFeed contains a CachFailure
      when(mockRubnewsRepository.getRemoteNewsfeed()).thenAnswer((_) => Future.value(Left(ServerFailure())));
      when(mockRubnewsRepository.getCachedNewsfeed()).thenAnswer((_) => Right(samleNewsEntities));

      // act: function call
      final testReturn = await rubnewsUsecases.updateFeedAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verify(mockRubnewsRepository.getRemoteNewsfeed());
      verify(mockRubnewsRepository.getCachedNewsfeed());
      verifyNoMoreInteractions(mockRubnewsRepository);
    });
  });

  group('[getCachedFeedAndFailures]', () {
    final samleNewsEntities = [
      NewsEntity(title: 'title1', pubDate: DateTime(0), imageUrls: ['']),
      NewsEntity(title: 'title2', pubDate: DateTime(1), imageUrls: ['0', '1'], description: 'description'),
      NewsEntity(title: 'title', pubDate: DateTime(0), imageUrls: ['imageUrls', ''], content: 'content'),
    ];

    test('Should return a JSON object with empty list of failures and list of news', () {
      final expectedReturn = {
        'failure': [],
        'news': samleNewsEntities,
      };

      // arrange: localFeed contains news entities
      when(mockRubnewsRepository.getCachedNewsfeed()).thenAnswer((_) => Right(samleNewsEntities));

      // act: function call
      final testReturn = rubnewsUsecases.getCachedFeedAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verifyNever(mockRubnewsRepository.getRemoteNewsfeed());
      verify(mockRubnewsRepository.getCachedNewsfeed());
      verifyNoMoreInteractions(mockRubnewsRepository);
    });

    test('Should return a JSON object with empty list of news and list of failures', () {
      final expectedReturn = {
        'failure': [CachFailure()],
        'news': [],
      };

      // arrange: localFeed contains a CachFailure
      when(mockRubnewsRepository.getCachedNewsfeed()).thenAnswer((_) => Left(CachFailure()));

      // act: function call
      final testReturn = rubnewsUsecases.getCachedFeedAndFailures();

      // assert: is expected result the actual return
      identical(testReturn, expectedReturn);
      verifyNever(mockRubnewsRepository.getRemoteNewsfeed());
      verify(mockRubnewsRepository.getCachedNewsfeed());
      verifyNoMoreInteractions(mockRubnewsRepository);
    });
  });
}
