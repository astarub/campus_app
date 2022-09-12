import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/rubnews/rubnews_details_page.dart';
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
  final CachedNetworkImage image;

  /// A link of the news feed item that links to an external website, if no content is given
  final String link;

  /// The full text of the news feed item that is displayed in the detail page
  final String content;

  /// Wether the given news is an event announcement and should display an event date
  final bool isEvent;

  /// Creates a NewsFeed-item with an expandable content
  const FeedItem({
    Key? key,
    required this.title,
    this.description = '',
    required this.date,
    required this.image,
    this.link = '',
    required this.content,
    this.isEvent = false,
  }) : super(key: key);

  /// Creates a NewsFeed-item with an external link
  const FeedItem.link({
    Key? key,
    required this.title,
    this.description = '',
    required this.date,
    required this.image,
    required this.link,
    this.content = '',
    this.isEvent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final month = DateFormat('LLL').format(date);
    final day = DateFormat('dd').format(date);

    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 250),
      openBuilder: (context, _) =>
          RubnewsDetailsPage(title: title, date: date, image: image, content: content, isEvent: isEvent),
      closedBuilder: (context, VoidCallback openDetailsPage) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: CustomButton(
          borderRadius: BorderRadius.circular(15),
          highlightColor: const Color.fromRGBO(0, 0, 0, 0.03),
          splashColor: const Color.fromRGBO(0, 0, 0, 0.04),
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
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: image,
                    ),
                    // Date
                    if (isEvent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        margin: const EdgeInsets.only(right: 4, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              month.toString(),
                              style: Provider.of<ThemesNotifier>(context)
                                  .currentThemeData
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                            Text(
                              day.toString(),
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Text(
                    title,
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                  ),
                ),
                // Description
                Text(
                  description,
                  style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
