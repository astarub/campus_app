import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/news/news_datasource.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';

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
  Future<Either<Failure, List<NewsEntity>>> getRemoteNewsFeed({
    Locale appLocale = const Locale('de'),
  }) async {
    try {
      final feed = await newsDatasource.getNewsFeed(appLocale.languageCode);

      final List<NewsEntity> entities = [];

      for (final e in feed) {
        final entity = NewsEntity.fromInternalJSON(json: e);

        entities.add(entity);
      }

      unawaited(newsDatasource.clearNewsEntityCache().then((_) => newsDatasource.writeNewsEntitiesToCache(entities)));

      return Right(entities);
    } catch (e) {
      switch (e.runtimeType) {
        case const (ServerException):
          return Left(ServerFailure());
        case const (HandshakeException):
          return Left(TranslationFailure());
        default:
          return Left(GeneralFailure());
      }
    }
  }
}
