import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/pages/rubnews/rubnews_repository.dart';
import 'package:dartz/dartz.dart';

class RubnewsUsecases {
  final RubnewsRepository rubnewsRepository;

  RubnewsUsecases({required this.rubnewsRepository});

  Future<Either<Failure, List<NewsEntity>>> getNewsList() async {
    //? Add validation of returned object
    return rubnewsRepository.getNewsfeed();
  }
}
