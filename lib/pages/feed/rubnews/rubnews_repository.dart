import 'dart:async';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/rubnews/news_entity.dart';
import 'package:campus_app/pages/feed/rubnews/rubnews_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:xml/xml.dart';

class RubnewsRepository {
  final RubnewsDatasource rubnewsDatasource;

  RubnewsRepository({required this.rubnewsDatasource});

  /// Return a list of web news or a failure.
  Future<Either<Failure, List<NewsEntity>>> getRemoteNewsfeed() async {
    try {
      final newsXml = await rubnewsDatasource.getNewsfeedAsXml();
      final newsXmlList = newsXml.findAllElements('item');

      final List<NewsEntity> entities = [];

      await Future.forEach(newsXmlList.map((news) => news), (XmlElement e) async {
        final link = e.getElement('link')!.text;
        final imageUrls = await rubnewsDatasource.getImageUrlsFromNewsUrl(link);
        entities.add(NewsEntity.fromXML(e, imageUrls));
      });

      // write entities to cach
      unawaited(rubnewsDatasource.writeNewsEntitiesToCach(entities));

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
      final cachedNewsfeed = rubnewsDatasource.readNewsEntitiesFromCach();
      return Right(cachedNewsfeed);
    } catch (e) {
      return Left(CachFailure());
    }
  }
}
