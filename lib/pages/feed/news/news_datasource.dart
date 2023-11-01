import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart' as html;
import 'package:xml/xml.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/utils/constants.dart';

class NewsDatasource {
  /// Key to identify count of news in Hive box / Cach
  static const String keyCnt = 'cnt';

  /// Dio client to perfrom network operations
  final Dio client;

  /// Hive.Box to store news entities inside
  final Box rubnewsCache;

  NewsDatasource({
    required this.client,
    required this.rubnewsCache,
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

  /// Request image url and copyright text from linked news
  /// Throws a server excpetion if respond code is not 200.
  Future<Map<String, dynamic>> getImageDataFromNewsUrl(String url) async {
    final Map<String, dynamic> data = {
      'copyright': <String>[],
      'imageUrls': <String>[],
    };

    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final document = html.parse(response.data);
      final htmlClass = document.getElementsByClassName('field-std-bild-artikel');

      // some news has multiple images with different HTML paths
      if (htmlClass.isEmpty) {
        // multiple image
        final images = document.getElementsByClassName('bst-bild');
        for (int i = 0; i < images.length; i++) {
          final copyright = document.getElementsByClassName('bildzeile-copyright')[i].text;

          List.castFrom(data['copyright']).add(copyright);
          List.castFrom(data['imageUrls']).add(images[i].getElementsByTagName('img')[0].attributes['src'].toString());
        }
      } else {
        final copyright = document.getElementsByClassName('bildzeile-copyright')[0].text;

        List.castFrom(data['copyright']).add(copyright);
        List.castFrom(data['imageUrls']).add(
          document
              .getElementsByClassName('field-std-bild-artikel')[0]
              .getElementsByTagName('img')[0]
              .attributes['src']
              .toString(),
        );
      }

      return data;
    }
  }

  /// Request posts from asta-bochum.de
  /// Throws a server exception if respond code is not 200.
  Future<List<dynamic>> getAStAFeedAsJson() async {
    final response = await client.get(astaFeed);

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return response.data;
    }
  }

  /// Request posts from app.asta-bochum.de
  /// Throws a server exception if respond code is not 200.
  Future<List<dynamic>> getAppFeedAsJson() async {
    final response = await client.get(appFeed);

    if (response.statusCode != 200) {
      throw ServerException();
    }
    final List<dynamic> data = response.data;

    // Fetch posts from multiple pages, if there are more than one page
    try {
      final int pages = int.parse(response.headers.value('x-wp-totalpages')!);

      if (pages > 1) {
        final List<Future<List<dynamic>>> futures = [];
        for (int i = 2; i <= pages; i++) {
          futures.add(getAppFeedPage(i));
        }

        final List<List<dynamic>> responses = await Future.wait(futures);

        final List<dynamic> allPosts =
            responses.fold<List<dynamic>>([], (responseList, response) => responseList..addAll(response));

        data.addAll(allPosts);
      }
    } catch (e) {
      throw ParseException();
    }

    return data;
  }

  /// Fetch a specific page from the app.asta-bochum.de JSON API
  Future<List<dynamic>> getAppFeedPage(int page) async {
    final List<dynamic> data = [];

    try {
      final responseForPage = await client.get('$appFeed?page=$page');

      if (responseForPage.statusCode != 200) throw ServerException();

      data.addAll(responseForPage.data);
    } catch (e) {
      throw ServerException();
    }

    return data;
  }

  /// Write given list of NewsEntity to Hive.Box 'rubnewsCach'.
  /// The put()-call is awaited to make sure that the write operations are successful.
  Future<void> writeNewsEntitiesToCache(List<NewsEntity> entities) async {
    final cntEntities = entities.length;
    await rubnewsCache.put(keyCnt, cntEntities);

    int index = 0; // use list index as identifier
    for (final entity in entities) {
      await rubnewsCache.put(index, entity);
      index++;
    }
  }

  /// Read cach of news entities and return them.
  List<NewsEntity> readNewsEntitiesFromCach() {
    final cntEntities = rubnewsCache.get(keyCnt) as int;
    final List<NewsEntity> entities = [];

    for (int i = 0; i < cntEntities; i++) {
      entities.add(rubnewsCache.get(i) as NewsEntity);
    }

    return entities;
  }
}
