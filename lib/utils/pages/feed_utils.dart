import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/pages/rubnews/widgets/feed_item.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter/widgets.dart';

class FeedUtils extends Utils {
  /// Parse a list of NewsEntity to widget list of type FeedItem.
  /// For Padding insert at first position a SizedBox with heigth = 80 or given heigth.
  List<Widget> fromNewsEntityListToWidgetList({required List<NewsEntity> entities, double? heigth}) {
    final widgets = <Widget>[];

    // parse entities in widget
    for (final entity in entities) {
      widgets.add(
        FeedItem(
          title: entity.title,
          date: entity.pubDate,
          image: CachedNetworkImage(
            imageUrl: entity.imageUrls[0],
          ),
          content: entity.content,
          //link: entity.url,
        ),
      );
    }

    // add SizedBox as padding
    widgets.insert(0, SizedBox(height: heigth ?? 80));

    return widgets;
  }
}
