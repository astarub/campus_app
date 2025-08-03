import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/core/backend/entities/publisher_entity.dart';
import 'package:campus_app/pages/feed/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/pages/feed/widgets/feed_item.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:flutter/widgets.dart';

class FeedUtils {
  // Save the shuffeled list to prevent constant re-shuffeling
  List shuffeledItemOrEventWidgets = [];

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

  /// Parse a list of NewsEntity and a list of Events to a widget list of type FeedItem sorted by date.
  /// For Padding insert at first position a SizedBox with heigth := 80 or given heigth.
  List<Widget> fromEntitiesToWidgetList({
    required List<NewsEntity> news,
    required List<Event> events,
    double? heigth,
    bool shuffle = false,
  }) {
    // TODO: Add Events into feed (the old implementation doesn't match the current items / widgest)

    List<dynamic> feedItemOrEventWidget = <dynamic>[];

    List<Widget> widgets = <Widget>[];

    final List<Widget> pinnedWidgets = <Widget>[];

    final feedItems = <FeedItem>[];

    // parse news in widget
    for (final n in news) {
      // Removes empty lines and white spaces
      final String formattedDescription =
          n.description.replaceAll(RegExp('(?:[\t ]*(?:\r?\n|\r))+'), '').replaceAll(RegExp(' {2,}'), '');

      bool fotolia = false;

      for (final c in n.copyright) {
        if (c.toLowerCase().contains('fotolia')) {
          fotolia = true;
        }
      }

      feedItems.add(
        FeedItem(
          title: n.title,
          date: n.pubDate,
          image: n.imageUrl != 'false' && (n.copyright.isNotEmpty && !fotolia)
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
          webViewUrl: n.webViewUrl,
          pinned: n.pinned,
        ),
      );
    }

    feedItems.sort(sortFeedDesc);

    if (shuffle) {
      feedItemOrEventWidget.addAll(feedItems);

      // Remove all outdated feed items
      final List<String> feedItemLinks = feedItems.map((e) => e.link).toList();
      List tshuffeledFeedItems = [];

      for (final n in shuffeledItemOrEventWidgets) {
        if (n is FeedItem) {
          try {
            if (feedItemLinks.contains(n.link)) {
              tshuffeledFeedItems.add(n);
            }
            // ignore: empty_catches
          } catch (e) {}
        }
      }

      if (tshuffeledFeedItems.length < feedItemOrEventWidget.length) {
        feedItemOrEventWidget.shuffle();

        tshuffeledFeedItems = feedItemOrEventWidget;
        shuffeledItemOrEventWidgets = tshuffeledFeedItems;
      }

      feedItemOrEventWidget = tshuffeledFeedItems;
    } else {
      // sort widgets according to date
      feedItemOrEventWidget.addAll(feedItems);
      feedItemOrEventWidget.sort(sortFeedDesc);
    }

    // add all FeedItems or CalendarEventWidgets to list of Widget
    for (final widget in feedItemOrEventWidget) {
      if (widget is FeedItem && widget.pinned) {
        pinnedWidgets.add(widget as Widget);
      } else {
        widgets.add(widget as Widget);
      }
    }

    widgets = pinnedWidgets + widgets;

    // add a SizedBox as padding
    widgets.insert(0, SizedBox(height: heigth ?? 80));

    return widgets;
  }

  int sortFeedAsc(dynamic a, dynamic b) {
    if (a is FeedItem && b is FeedItem) {
      return a.date.compareTo(b.date);
    } else {
      return 0;
    }
  }

  int sortFeedDesc(dynamic a, dynamic b) {
    if (a is FeedItem && b is FeedItem) {
      return b.date.compareTo(a.date);
    } else {
      return 0;
    }
  }
}
