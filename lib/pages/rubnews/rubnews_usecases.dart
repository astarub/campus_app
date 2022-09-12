import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/pages/rubnews/rubnews_repository.dart';
import 'package:dartz/dartz.dart';

class RubnewsUsecases {
  final RubnewsRepository rubnewsRepository;

  RubnewsUsecases({required this.rubnewsRepository});

  /// Return a JSON object `data` that contains failures and news.
  ///
  /// data := { 'failures': List\<Failure>, 'news': List\<NewsEntity> }
  Future<Map<String, List<dynamic>>> getFeedAndFailures() async {
    // return data
    final Map<String, List<dynamic>> data = {
      'failures': <Failure>[],
      'news': <NewsEntity>[],
    };

    // get remote and cached news feed
    final Either<Failure, List<NewsEntity>> remoteFeed = await rubnewsRepository.getRemoteNewsfeed();
    final Either<Failure, List<NewsEntity>> cachedFeed = rubnewsRepository.getCachedNewsfeed();

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
}
