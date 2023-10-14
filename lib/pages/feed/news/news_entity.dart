import 'dart:math';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

part 'news_entity.g.dart';

@HiveType(typeId: 0)
class NewsEntity {
  /// The news title
  @HiveField(0)
  final String title;

  /// A short summary / description of the news content
  @HiveField(1)
  final String description;

  /// The date when the news was published
  @HiveField(2)
  final DateTime pubDate;

  /// A list of urls to the news images. Usally only one image per news but
  /// multiple images are possible.
  @HiveField(3)
  final List<String> imageUrls;

  /// The external url to the news.
  @HiveField(4)
  final String url;

  /// The actual content / article of the news
  @HiveField(5)
  final String content;

  /// Id of the author of the post
  @HiveField(6)
  final int author;

  /// Id of the author of the post
  @HiveField(7)
  final List<int> categoryIds;

  /// Copyright for the news images
  @HiveField(8)
  final List<String> copyright;

  const NewsEntity({
    required this.title,
    this.description = '',
    required this.pubDate,
    required this.imageUrls,
    this.url = '',
    this.content = '',
    this.author = 0,
    this.categoryIds = const [],
    this.copyright = const [],
  });

  /// Returns a NewsEntity based on a single XML element given by the web server
  factory NewsEntity.fromXML(XmlElement xml, Map<String, dynamic> imageData) {
    final content = xml.getElement('content')!.innerText;
    final title = xml.getElement('title')!.innerText;
    final url = xml.getElement('link')!.innerText;
    final description = xml.getElement('description')!.innerText;
    final pubDate = DateFormat('E, d MMM yyyy hh:mm:ss Z', 'en_US').parse(xml.getElement('pubDate')!.innerText);

    /// Regular Expression to remove unwanted HTML-Tags
    final RegExp htmlTags = RegExp(
      // r'''(<a\s+(?:[^>]*?\s+)?href=(["'])(.*?)\>)|(<[^>]a>)|([^>]*])''';
      '([^>]*])',
      multiLine: true,
    );

    return NewsEntity(
      content: content.replaceAll(htmlTags, ''),
      title: title,
      url: url,
      description: description,
      pubDate: pubDate,
      imageUrls: List.castFrom(imageData['imageUrls']),
      copyright: imageData['copyright'],
    );
  }

  /// Returns a NewsEntity from a JSON object provided by an external webserver
  factory NewsEntity.fromJSON({required Map<String, dynamic> json, required List<String> copyright}) {
    final title = Map<String, dynamic>.from(json['title'])['rendered'] as String;
    final pubDate = DateTime.parse(json['date']);
    final url = json['link'];
    final author = json['author'];
    final categories = json['categories'];
    final content = Bidi.stripHtmlIfNeeded(Map<String, dynamic>.from(json['content'])['rendered'] as String);
    String description = '';

    // Remove html and whitespaces from the content
    final String formattedContent = content
        .replaceAll(RegExp('(?:[\t ]*(?:\r?\n|\r))+'), '')
        .replaceAll(RegExp(' {2,}'), ' ')
        .replaceAll('\n', ' ');
    final List<String> descWords = formattedContent.split(' ');
    final List<String> descriptionList = [];

    // Get max 30 words in the description
    for (int i = 0; i <= min(30, RegExp(' ').allMatches(formattedContent).length); i++) {
      descriptionList.add(descWords[i]);
    }

    description = descriptionList.join(' ');

    // Add "..." to the description if it was cut off
    if (min(30, RegExp(' ').allMatches(formattedContent).length) == 30) {
      description = '$description...';
    }

    return NewsEntity(
      content: formattedContent,
      title: title,
      url: url,
      description: description,
      pubDate: pubDate,
      author: author,
      categoryIds: List<int>.from(categories),
      imageUrls: [if (json['fimg_url'] != null) json['fimg_url'].toString()],
      copyright: copyright,
    );
  }
}
