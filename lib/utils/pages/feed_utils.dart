import 'package:flutter/widgets.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/core/backend/entities/publisher_entity.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/pages/feed/widgets/feed_item.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:campus_app/utils/constants.dart';

class FeedUtils extends Utils {
  // Save the shuffeled list to prevent constant re-shuffeling
  List shuffeledItemOrEventWidgets = [];

  /// Parse a list of NewsEntity and a list of Events to a widget list of type FeedItem sorted by date.
  /// For Padding insert at first position a SizedBox with heigth := 80 or given heigth.
  List<Widget> fromEntitiesToWidgetList({
    required List<NewsEntity> news,
    double? heigth,
    bool shuffle = false,
  }) {
    List<dynamic> feedItemOrEventWidget = <dynamic>[];
    final widgets = <Widget>[];

    final feedItems = <FeedItem>[];

    // parse news in widget
    for (final n in news) {
      // Removes empty lines and white spaces
      final String formattedDescription =
          n.description.replaceAll(RegExp('(?:[\t ]*(?:\r?\n|\r))+'), '').replaceAll(RegExp(' {2,}'), '');

      feedItems.add(
        FeedItem(
          title: n.title,
          date: n.pubDate,
          image: n.imageUrl != 'false' &&
                  (n.copyright.isNotEmpty && !n.copyright.map((e) => e.toLowerCase()).toList().contains('fotolia'))
              ? CachedNetworkImage(
                  imageUrl: n.imageUrl,
                )
              : null,
          content: n.content,
          link: n.url,
          description: formattedDescription,
          author: n.author,
          categoryIds: n.categoryIds,
          copyright: n.copyright.isNotEmpty ? n.copyright[0] : '',
          videoUrl: n.videoUrl != 'false' ? n.videoUrl : null,
        ),
      );
    }

    feedItems.sort(sortFeedDesc);

    if (shuffle) {
      feedItemOrEventWidget.addAll(feedItems);

      if (shuffeledItemOrEventWidgets.length < feedItemOrEventWidget.length) {
        feedItemOrEventWidget.shuffle();

        shuffeledItemOrEventWidgets = feedItemOrEventWidget;
      }

      feedItemOrEventWidget = shuffeledItemOrEventWidgets;
    } else {
      // sort widgets according to date
      feedItemOrEventWidget.addAll(feedItems);
      feedItemOrEventWidget.sort(sortFeedDesc);
    }

    // add all FeedItems or CalendarEventWidgets to list of Widget
    for (final widget in feedItemOrEventWidget) {
      widgets.add(widget as Widget);
    }

    // add a SizedBox as padding
    widgets.insert(0, SizedBox(height: heigth ?? 80));

    return widgets;
  }

  List<Widget> filterFeedWidgets(List<Publisher> filters, List<Widget> parsedFeedItems) {
    final List<Widget> filteredFeedItems = [];

    final List<String> filterNames = filters.map((e) => e.name).toList();

    for (final Widget f in parsedFeedItems) {
      if (f is FeedItem) {
        if (f.link.startsWith('https://news.rub.de') && filterNames.contains('RUB')) {
          filteredFeedItems.add(f);
        }
        if (f.link.startsWith('https://asta-bochum.de') && filterNames.contains('AStA')) {
          filteredFeedItems.add(f);
        }

        if (f.link.startsWith(appWordpressHost) && (f.author != 0 && filters.map((e) => e.id).contains(f.author)) ||
            f.categoryIds.contains(66)) {
          filteredFeedItems.add(f);
        }
      } else {
        filteredFeedItems.add(f);
      }
    }
    return filteredFeedItems;
  }

  int sortFeedDesc(dynamic a, dynamic b) {
    if (a is FeedItem && b is FeedItem) {
      return b.date.compareTo(a.date);
    } else {
      return 0;
    }
  }

  int sortFeedAsc(dynamic a, dynamic b) {
    if (a is FeedItem && b is FeedItem) {
      return a.date.compareTo(b.date);
    } else {
      return 0;
    }
  }
}
