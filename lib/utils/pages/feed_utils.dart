import 'dart:math';

import 'package:flutter/widgets.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/pages/feed/rubnews/news_entity.dart';
import 'package:campus_app/pages/feed/widgets/feed_item.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';

class FeedUtils extends Utils {
  // Save the shuffeled list to prevent constant re-shuffeling
  List shuffeledItemOrEventWidgets = [];

  /// Parse a list of NewsEntity and a list of Events to a widget list of type FeedItem sorted by date.
  /// For Padding insert at first position a SizedBox with heigth := 80 or given heigth.
  List<Widget> fromEntitiesToWidgetList({
    required List<NewsEntity> news,
    required List<Event> events,
    double? heigth,
    bool shuffle = false,
    bool mixInto = true,
  }) {
    List<dynamic> feedItemOrEventWidget = <dynamic>[];
    final widgets = <Widget>[];

    final _news = <FeedItem>[];
    final _events = <dynamic>[];

    // generates a new Random object
    final _random = Random();

    // parse news in widget
    for (final n in news) {
      // Removes empty lines and white spaces
      final String formattedDescription =
          n.description.replaceAll(RegExp('(?:[\t ]*(?:\r?\n|\r))+'), '').replaceAll(RegExp(' {2,}'), '');

      _news.add(
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
        _events.add(
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
                ? 'Von $startingTime Uhr bis $endingTime Uhr' /*TODO: Add localization*/
                : 'Von $startingTime Uhr bis $endingTime Uhr im ${e.venue.name}', /*TODO: Add localization*/
          ),
        );
      } else {
        _events.add(CalendarEventWidget(event: e));
      }
    }

    // sort news and events by date
    _events.sort(_sortFeed);
    _news.sort(_sortFeed);

    if (shuffle) {
      feedItemOrEventWidget.addAll(_events);
      feedItemOrEventWidget.addAll(_news);

      if (shuffeledItemOrEventWidgets.length < feedItemOrEventWidget.length) {
        feedItemOrEventWidget.shuffle();

        shuffeledItemOrEventWidgets = feedItemOrEventWidget;
      }

      feedItemOrEventWidget = shuffeledItemOrEventWidgets;
    } else if (mixInto) {
      // mix events in feed, both are still sorted by date
      while (_news.isNotEmpty || _events.isNotEmpty) {
        if (_news.isNotEmpty && _events.isEmpty) {
          feedItemOrEventWidget.addAll(_news);
          _news.clear();
        } else if (_news.isEmpty && _events.isNotEmpty) {
          feedItemOrEventWidget.addAll(_events);
          _events.clear();
        } else if (_news.isEmpty && _events.isEmpty) {
          break;
        } else {
          feedItemOrEventWidget.addAll([_news.first, _events.first]);
          _news.removeAt(0);
          _events.removeAt(0);
        }
      }
    } else {
      // sort widgets according to date
      feedItemOrEventWidget.addAll(_news);
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
      return b.date.compareTo(a.date);
    } else if (a is FeedItem && b is CalendarEventWidget) {
      return b.event.startDate.compareTo(a.date);
    } else if (a is CalendarEventWidget && b is FeedItem) {
      return b.date.compareTo(a.event.startDate);
    } else if (a is CalendarEventWidget && b is CalendarEventWidget) {
      return b.event.startDate.compareTo(a.event.startDate);
    } else {
      return 0;
    }
  }
}
