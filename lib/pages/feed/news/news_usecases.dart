import 'dart:ui';

import 'package:dartz/dartz.dart';

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/pages/feed/news/news_repository.dart';

class NewsUsecases {
  final NewsRepository newsRepository;

  NewsUsecases({required this.newsRepository});

  /// Return a JSON object `data` that contains failures and news.
  ///
  /// data := { 'failures': List\<Failure>, 'news': List\<NewsEntity> }
  Future<Map<String, List<dynamic>>> updateFeedAndFailures({Locale appLocale = const Locale('de')}) async {
    // return data
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'news': <NewsEntity>[],
    };

    // get remote and cached news feed
    final Either<Failure, List<NewsEntity>> remoteFeed = await newsRepository.getRemoteNewsFeed(appLocale: appLocale);

    final Either<Failure, List<NewsEntity>> cachedFeed = newsRepository.getCachedNewsfeed();

    // fold cachedFeed
    cachedFeed.fold(
      (failure) => data['failures']!.add(failure),
      (news) => data['news'] = news,
    );

    // fold remoteFeed
    remoteFeed.fold(
      (failure) => data['failures']!.add(failure),
      (news) => data['news'] = news, // overwrite cached feed
    );

    return data;
  }

  /// Return a JSON object `data` that contains failures and news.
  ///
  /// data := { 'failures': List\<Failure>, 'news': List\<NewsEntity> }
  Map<String, List<dynamic>> getCachedFeedAndFailures() {
    // return data
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'news': <NewsEntity>[],
    };

    // get only cached news feed
    final Either<Failure, List<NewsEntity>> cachedFeed = newsRepository.getCachedNewsfeed();

    // fold cachedFeed
    cachedFeed.fold(
      (failure) => data['failures']!.add(failure),
      (news) => data['news'] = news,
    );

    return data;
  }
}
