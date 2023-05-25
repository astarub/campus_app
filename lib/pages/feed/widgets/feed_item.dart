import 'dart:math';

import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_detail_page.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/feed/rubnews/rubnews_details_page.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

/// This widget displays a news item in the news feed page.
class FeedItem extends StatelessWidget {
  /// The title of the news feed item
  final String title;

  /// The short description of the news feed item that is displayed in the feed
  final String description;

  /// The date of the event that is referenced in the news feed item
  final DateTime date;

  /// The image of the news feed item that is displayed in the feed and detail apge
  CachedNetworkImage? image;

  /// A link of the news feed item that links to an external website, if no content is given
  final String link;

  /// The full text of the news feed item that is displayed in the detail page
  final String content;

  /// Wether the given news is an event announcement and should display an event date
  final Event? event;

  /// Creates a NewsFeed-item with an expandable content
  FeedItem({
    Key? key,
    required this.title,
    this.description = '',
    required this.date,
    this.image,
    this.link = '',
    required this.content,
    this.event,
  }) : super(key: key);

  /// Creates a NewsFeed-item with an external link
  FeedItem.link({
    Key? key,
    required this.title,
    this.description = '',
    required this.date,
    this.image,
    required this.link,
    this.content = '',
    this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final month = DateFormat('LLL').format(date);
    final day = DateFormat('dd').format(date);

    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 250),
      openBuilder: (context, _) {
        if (event != null) {
          return CalendarDetailPage(event: event!);
        } else {
          return RubnewsDetailsPage(
            title: title,
            date: date,
            image: image,
            link: link,
            content: content,
          );
        }
      },
      middleColor: Provider.of<ThemesNotifier>(context, listen: false)
          .currentThemeData
          .colorScheme
          .background,
      closedColor: Provider.of<ThemesNotifier>(context, listen: false)
          .currentThemeData
          .colorScheme
          .background,
      closedElevation: 0,
      closedBuilder: (context, VoidCallback openDetailsPage) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: CustomButton(
          borderRadius: BorderRadius.circular(15),
          highlightColor: Provider.of<ThemesNotifier>(context, listen: false)
                      .currentTheme ==
                  AppThemes.light
              ? const Color.fromRGBO(0, 0, 0, 0.03)
              : const Color.fromRGBO(255, 255, 255, 0.03),
          splashColor: Provider.of<ThemesNotifier>(context, listen: false)
                      .currentTheme ==
                  AppThemes.light
              ? const Color.fromRGBO(0, 0, 0, 0.04)
              : const Color.fromRGBO(255, 255, 255, 0.04),
          tapHandler: openDetailsPage,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image & Date
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    if (image != null)
                      // Image
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: image,
                        ),
                      ),
                    // Date
                    if (event != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        margin: const EdgeInsets.only(right: 4, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              month,
                              style: Provider.of<ThemesNotifier>(context)
                                  .currentThemeData
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                            Text(
                              day,
                              style: Provider.of<ThemesNotifier>(context)
                                  .currentThemeData
                                  .textTheme
                                  .headlineMedium,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: StyledHTML(
                    context: context,
                    text: title,
                    textStyle: Provider.of<ThemesNotifier>(context)
                        .currentThemeData
                        .textTheme
                        .headlineSmall,
                  ),
                ),
                // Description
                StyledHTML(
                  context: context,
                  text: description,
                  textStyle: Provider.of<ThemesNotifier>(context)
                      .currentThemeData
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
