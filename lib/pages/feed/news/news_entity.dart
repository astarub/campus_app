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

  /// A list of urls to the news images.
  @HiveField(3)
  final String imageUrl;

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

  /// URL to Video if news has one
  @HiveField(9)
  final String? videoUrl;

  /// Pinned
  @HiveField(10, defaultValue: false)
  final bool pinned;

  /// URL for a webview
  @HiveField(11, defaultValue: null)
  final String? webViewUrl;

  const NewsEntity({
    required this.title,
    this.description = '',
    required this.pubDate,
    required this.imageUrl,
    this.url = '',
    this.content = '',
    this.author = 0,
    this.categoryIds = const [],
    this.copyright = const [],
    this.videoUrl,
    this.pinned = false,
    this.webViewUrl = '',
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
      imageUrl: List.castFrom(imageData['imageUrls'])[0],
      copyright: imageData['copyright'],
    );
  }

  /// Returns a NewsEntity from a JSON object provided by an external webserver
  factory NewsEntity.fromInternalJSON({required Map<String, dynamic> json}) {
    final pubDate = DateTime.parse(json['pubDate']);

    return NewsEntity(
      content: json['content'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      pubDate: pubDate,
      author: json['author'] ?? 0,
      categoryIds: List<int>.from(json['categoryIds']),
      copyright: List<String>.from(json['copyright']),
      imageUrl: json['imageUrl'] != null ? json['imageUrl'].toString() : 'false',
      videoUrl: json['videoUrl'] != null ? json['videoUrl'].toString() : 'false',
      pinned: json['pinned'] ?? false,
      webViewUrl: json['webview_url'] != null && json['webview_url'] != '' ? json['webview_url'] : null,
    );
  }
}
