import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

abstract class RubnewsRemoteDatasource {
  /// Request news feed from news.rub.de/newsfeed.
  /// Throws a server excpetion if respond code is not 200.
  Future<XmlDocument> getNewsfeedAsXml();

  /// Request image of linked news.
  /// Throws a server excpetion if respond code is not 200.
  Future<CachedNetworkImage> getImageFromNewsUrl(String url);
}

class RubnewsRemoteDatasourceImpl implements RubnewsRemoteDatasource {
  final http.Client client;

  RubnewsRemoteDatasourceImpl({required this.client});

  @override
  Future<XmlDocument> getNewsfeedAsXml() async {
    // return type is xml-v1.
    final response = await client.get(Uri.parse(rubNewsfeed));

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return XmlDocument.parse(response.body);
    }
  }

  @override
  Future<CachedNetworkImage> getImageFromNewsUrl(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final document = html.parse(response.body);
      final htmlClass =
          document.getElementsByClassName('field-std-bild-artikel');
      String? imgUrl;

      if (htmlClass.isEmpty) {
        imgUrl = document
            .getElementsByClassName('bst-bild')[0]
            .getElementsByTagName('img')[0]
            .attributes['src'];
      } else {
        imgUrl = document
            .getElementsByClassName('field-std-bild-artikel')[0]
            .getElementsByTagName('img')[0]
            .attributes['src'];
      }

      return CachedNetworkImage(
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: imgUrl.toString(),
        fit: BoxFit.cover,
      );
    }
  }
}
