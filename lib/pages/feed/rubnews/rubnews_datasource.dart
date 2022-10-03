import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/feed/rubnews/news_entity.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart' as html;
import 'package:xml/xml.dart';

class RubnewsDatasource {
  /// Key to identify count of news in Hive box / Cach
  static const String _keyCnt = 'cnt';

  /// Dio client to perfrom network operations
  final Dio client;

  /// Hive.Box to store news entities inside
  final Box rubnewsCach;

  RubnewsDatasource({
    required this.client,
    required this.rubnewsCach,
  });

  /// Request news feed from news.rub.de/newsfeed.
  /// Throws a server excpetion if respond code is not 200.
  Future<XmlDocument> getNewsfeedAsXml() async {
    // return type is xml-v1.
    final response = await client.get(rubNewsfeed);

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return XmlDocument.parse(response.data);
    }
  }

  /// Request image url list of linked news.
  /// Throws a server excpetion if respond code is not 200.
  Future<List<String>> getImageUrlsFromNewsUrl(String url) async {
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final document = html.parse(response.data);
      final htmlClass = document.getElementsByClassName('field-std-bild-artikel');
      final List<String> imgageUrls = [];

      // some news has multiple images with different HTML paths
      if (htmlClass.isEmpty) {
        // multiple image
        final images = document.getElementsByClassName('bst-bild');
        for (final image in images) {
          imgageUrls.add(
            image.getElementsByTagName('img')[0].attributes['src'].toString(),
          );
        }
      } else {
        // single images
        imgageUrls.add(
          document
              .getElementsByClassName('field-std-bild-artikel')[0]
              .getElementsByTagName('img')[0]
              .attributes['src']
              .toString(),
        );
      }

      return imgageUrls;
    }
  }

  /// Write given list of NewsEntity to Hive.Box 'rubnewsCach'.
  /// The put()-call is awaited to make sure that the write operations are successful.
  Future<void> writeNewsEntitiesToCach(List<NewsEntity> entities) async {
    final cntEntities = entities.length;
    await rubnewsCach.put(_keyCnt, cntEntities);

    int index = 0; // use list index as identifier
    for (final entity in entities) {
      await rubnewsCach.put(index, entity);
      index++;
    }
  }

  /// Read cach of news entities and return them.
  List<NewsEntity> readNewsEntitiesFromCach() {
    final cntEntities = rubnewsCach.get(_keyCnt) as int;
    final List<NewsEntity> entities = [];

    for (int i = 0; i < cntEntities; i++) {
      entities.add(rubnewsCach.get(i) as NewsEntity);
    }

    return entities;
  }
}
