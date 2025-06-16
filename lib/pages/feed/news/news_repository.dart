import 'dart:async';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/news/news_datasource.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:xml/xml.dart';

class NewsRepository {
  final NewsDatasource newsDatasource;

  NewsRepository({required this.newsDatasource});

  /// Return a list of cached news or a failure.
  Either<Failure, List<NewsEntity>> getCachedNewsfeed() {
    try {
      final cachedNewsfeed = newsDatasource.readNewsEntitiesFromCach();
      return Right(cachedNewsfeed);
    } catch (e) {
      return Left(CachFailure());
    }
  }

  /// Return a list of web news or a failure.
  Future<Either<Failure, List<NewsEntity>>> getRemoteNewsfeed() async {
    try {
      final newsXml = await newsDatasource.getNewsfeedAsXml();
      final astaFeed = await newsDatasource.getAStAFeedAsJson();
      final appFeed = await newsDatasource.getAppFeedAsJson();
      final newsXmlList = newsXml.findAllElements('item');

      final List<NewsEntity> entities = [];

      for (final e in astaFeed) {
        final entity = NewsEntity.fromJSON(json: e, copyright: ['© AStA']);
        final past = DateTime.now().subtract(const Duration(days: 21));

        if (entity.pubDate.compareTo(past) > 0) {
          entities.add(entity);
        }
      }

      for (final e in appFeed) {
        final entity = NewsEntity.fromJSON(json: e, copyright: ['© AStA']);
        final past = DateTime.now().subtract(const Duration(days: 21));

        if (entity.pubDate.compareTo(past) > 0) {
          entities.add(entity);
        }
      }

      await Future.forEach(newsXmlList.map((news) => news), (XmlElement e) async {
        final link = e.getElement('link')!.innerText;
        final imageData = await newsDatasource.getImageDataFromNewsUrl(link);

        entities.add(NewsEntity.fromXML(e, imageData));
      });

      // write entities to cache
      unawaited(newsDatasource.clearNewsEntityCache().then((_) => newsDatasource.writeNewsEntitiesToCache(entities)));

      return Right(entities);
    } catch (e) {
      switch (e.runtimeType) {
        case const (ServerException):
          return Left(ServerFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }
}
