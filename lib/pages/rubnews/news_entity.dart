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

  const NewsEntity({
    required this.title,
    this.description = '',
    required this.pubDate,
    required this.imageUrls,
    this.url = '',
    this.content = '',
  });

  /// Return a NewsEntity based on a single XML element given by the web server
  factory NewsEntity.fromXML(XmlElement xml, List<String> imageUrls) {
    final content = xml.getElement('content')!.text;
    final title = xml.getElement('title')!.text;
    final url = xml.getElement('link')!.text;
    final description = xml.getElement('description')!.text;
    final pubDate = DateFormat('E, d MMM yyyy hh:mm:ss Z', 'en_US').parse(xml.getElement('pubDate')!.text);

    /// Regular Expression to remove unwanted HTML-Tags
    RegExp htmlTags = RegExp(
      r'''(<a\s+(?:[^>]*?\s+)?href=(["'])(.*?)\>)|(<[^>]a>)|([^>]*])''',
      multiLine: true,
    );

    return NewsEntity(
      content: content.replaceAll(htmlTags, ''),
      title: title,
      url: url,
      description: description,
      pubDate: pubDate,
      imageUrls: imageUrls,
    );
  }
}
