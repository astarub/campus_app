import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/pages/rubnews/news_entity.dart';
import 'package:campus_app/pages/rubnews/widgets/feed_item.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter/widgets.dart';

class FeedUtils extends Utils {
  /// Parse a list of NewsEntity to widget list of type FeedItem.
  List<Widget> fromNewsEntityListToFeedItemList(List<NewsEntity> entities) {
    final widgets = <FeedItem>[];

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

    return widgets;
  }
}
