// import 'dart:math';

import 'package:flutter/widgets.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/pages/feed/rubnews/news_entity.dart';
import 'package:campus_app/pages/feed/widgets/feed_item.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';

class FeedUtils extends Utils {
  /// Parse a list of NewsEntity and a list of Events to a widget list of type FeedItem sorted by date.
  /// For Padding insert at first position a SizedBox with heigth := 80 or given heigth.
  List<Widget> fromEntitiesToWidgetList({
    required List<NewsEntity> news,
    required List<Event> events,
    double? heigth,
    bool shuffle = false,
    bool mixInto = true,
  }) {
    final feedItemOrEventWidget = <dynamic>[];
    final widgets = <Widget>[];

    final tmpNews = <FeedItem>[];
    final tmpEvents = <dynamic>[];

    // generates a new Random object
    // final _random = Random();

    // parse news in widget
    for (final n in news) {
      // Removes empty lines and white spaces
      final String formattedDescription =
          n.description.replaceAll(RegExp('(?:[\t ]*(?:\r?\n|\r))+'), '').replaceAll(RegExp(' {2,}'), '');

      tmpNews.add(
        FeedItem(
          title: n.title,
          date: n.pubDate,
          image: CachedNetworkImage(
            imageUrl: n.imageUrls[0],
          ),
          content: n.content,
          link: n.url,
          description: formattedDescription,
        ),
      );
    }

    // parse events in widget
    for (final e in events) {
      // Removes empty lines and white spaces
      final String formattedDescription =
          e.description.replaceAll(RegExp('(?:[\t ]*(?:\r?\n|\r))+'), '').replaceAll(RegExp(' {2,}'), '');

      final startingTime = DateFormat('Hm').format(e.startDate);
      final endingTime = DateFormat('Hm').format(e.endDate);

      if (e.hasImage) {
        tmpEvents.add(
          FeedItem(
            title: e.title,
            date: e.startDate,
            image: CachedNetworkImage(
              imageUrl: e.imageUrl!,
            ),
            content: formattedDescription,
            link: e.url,
            event: e,
            description: e.venue.name == ''
                ? 'Von $startingTime Uhr bis $endingTime Uhr'
                : 'Von $startingTime Uhr bis $endingTime Uhr im ${e.venue.name}',
          ),
        );
      } else {
        tmpEvents.add(CalendarEventWidget(event: e));
      }
    }

    // sort news and events by date
    tmpEvents.sort(_sortFeed);
    tmpNews.sort(_sortFeed);

    if (shuffle) {
      // shuffle widgets random
      feedItemOrEventWidget.addAll(tmpEvents);
      feedItemOrEventWidget.addAll(tmpNews);
      feedItemOrEventWidget.shuffle();
    } else if (mixInto) {
      // mix events in feed, both are still sorted by date
      while (tmpNews.isNotEmpty || tmpEvents.isNotEmpty) {
        if (tmpNews.isNotEmpty && tmpEvents.isEmpty) {
          feedItemOrEventWidget.addAll(tmpNews);
          tmpNews.clear();
        } else if (tmpNews.isEmpty && tmpEvents.isNotEmpty) {
          feedItemOrEventWidget.addAll(tmpEvents);
          tmpEvents.clear();
        } else if (tmpNews.isEmpty && tmpEvents.isEmpty) {
          break;
        } else {
          feedItemOrEventWidget.addAll([tmpNews.first, tmpEvents.first]);
          tmpNews.removeAt(0);
          tmpEvents.removeAt(0);
        }
      }
    } else {
      // sort widgets according to date
      feedItemOrEventWidget.addAll(tmpEvents);
      feedItemOrEventWidget.addAll(tmpNews);
      feedItemOrEventWidget.sort(_sortFeed);
    }

    // add all FeedItems or CalendarEventWidgets to list of Widget
    for (final widget in feedItemOrEventWidget) {
      widgets.add(widget as Widget);
    }

    // add a SizedBox as padding
    widgets.insert(0, SizedBox(height: heigth ?? 80));

    return widgets;
  }

  int _sortFeed(a, b) {
    if (a is FeedItem && b is FeedItem) {
      return a.date.compareTo(b.date);
    } else if (a is FeedItem && b is CalendarEventWidget) {
      return a.date.compareTo(b.event.startDate);
    } else if (a is CalendarEventWidget && b is FeedItem) {
      return a.event.startDate.compareTo(b.date);
    } else if (a is CalendarEventWidget && b is CalendarEventWidget) {
      return a.event.startDate.compareTo(b.event.startDate);
    } else {
      return 0;
    }
  }
}
