import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/rubnews/rubnews_news_entity.dart';
import 'package:campus_app/pages/rubnews/rubnews_news_model.dart';
import 'package:campus_app/pages/rubnews/rubnews_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:xml/xml.dart';

abstract class RubnewsRepository {
  /// return a list of news or a failure.
  Future<Either<Failure, List<RubnewsNewsEntity>>> getNewsfeed();
}

class RubnewsRepositoryImpl implements RubnewsRepository {
  final RubnewsRemoteDatasource rubnewsRemoteDatasource;

  RubnewsRepositoryImpl({required this.rubnewsRemoteDatasource});

  @override
  Future<Either<Failure, List<RubnewsNewsEntity>>> getNewsfeed() async {
    try {
      final newsXml = await rubnewsRemoteDatasource.getNewsfeedAsXml();
      final newsXmlList = newsXml.findAllElements('item');

      final List<RubnewsNewsEntity> entities = [];

      await Future.forEach(newsXmlList.map((news) => news),
          (XmlElement e) async {
        final link = e.getElement('link')!.text;
        final image = await rubnewsRemoteDatasource.getImageFromNewsUrl(link);
        entities.add(RubnewsNewsModel.fromXML(e, image));
      });

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
}
