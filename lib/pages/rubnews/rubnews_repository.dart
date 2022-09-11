import 'dart:async';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/pages/rubnews/rubnews_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:xml/xml.dart';

class RubnewsRepository {
  final RubnewsDatasource rubnewsRemoteDatasource;

  RubnewsRepository({required this.rubnewsRemoteDatasource});

  /// Return a list of web news or a failure.
  Future<Either<Failure, List<NewsEntity>>> getRemoteNewsfeed() async {
    try {
      final newsXml = await rubnewsRemoteDatasource.getNewsfeedAsXml();
      final newsXmlList = newsXml.findAllElements('item');

      final List<NewsEntity> entities = [];

      await Future.forEach(newsXmlList.map((news) => news), (XmlElement e) async {
        final link = e.getElement('link')!.text;
        final imageUrls = await rubnewsRemoteDatasource.getImageUrlsFromNewsUrl(link);
        entities.add(NewsEntity.fromXML(e, imageUrls));
      });

      // write entities to cach
      unawaited(rubnewsRemoteDatasource.writeNewsEntitiesToCach(entities));

      return Right(entities);
    } catch (e) {
      switch (e.runtimeType) {
        case ServerException:
          return Left(ServerFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }

  /// Return a list of cached news or a failure.
  Either<Failure, List<NewsEntity>> getCachedNewsfeed() {
    try {
      final cachedNewsfeed = rubnewsRemoteDatasource.readNewsEntitiesFromCach();
      return Right(cachedNewsfeed);
    } catch (e) {
      return Left(CachFailure());
    }
  }
}
