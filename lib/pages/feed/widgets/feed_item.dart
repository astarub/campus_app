import 'dart:io';

import 'package:campus_app/pages/more/in_app_web_view_page.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_detail_page.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/feed/news/news_details_page.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

/// This widget displays a news item in the news feed page.

class FeedItem extends StatefulWidget {
  /// The title of the news feed item
  final String title;

  /// The short description of the news feed item that is displayed in the feed
  final String description;

  /// The date of the event that is referenced in the news feed item
  final DateTime date;

  /// The image of the news feed item that is displayed in the feed and detail apge
  final CachedNetworkImage? image;

  /// A link of the news feed item that links to an external website, if no content is given
  final String link;

  /// The full text of the news feed item that is displayed in the detail page
  final String content;

  /// Wether the given news is an event announcement and should display an event date
  final Event? event;

  /// If post contains a video, the URL to the media file
  final String? videoUrl;

  /// Author of the post
  final int author;

  /// WP Category ids
  final List<int> categoryIds;

  /// Copyright of the news image
  final String copyright;

  // Open a webview on click
  final bool webview;

  // Pinned items appear at the very top of the feed.
  final bool pinned;

  /// Creates a NewsFeed-item with an expandable content
  const FeedItem({
    super.key,
    required this.title,
    this.description = '',
    required this.date,
    this.image,
    this.link = '',
    required this.content,
    this.event,
    this.videoUrl,
    this.author = 0,
    this.categoryIds = const [],
    this.copyright = '',
    this.webview = false,
    this.pinned = false,
  });

  /// Creates a NewsFeed-item with an external link
  const FeedItem.link({
    super.key,
    required this.title,
    this.description = '',
    required this.date,
    this.image,
    required this.link,
    this.content = '',
    this.event,
    this.videoUrl,
    this.author = 0,
    this.categoryIds = const [],
    this.copyright = '',
    this.webview = false,
    this.pinned = false,
  });

  @override
  State<FeedItem> createState() => FeedItemState();
}

class FeedItemState extends State<FeedItem> with AutomaticKeepAliveClientMixin {
  File? videoThumbnailFile;

  /// Generate the thumbnail of a video
  Future<void> generateVideoThumbnail(String? videoUrl) async {
    if (videoUrl == null) return;

    final file = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      maxHeight: 250,
      quality: 80,
    );

    if (file != null) {
      setState(() {
        videoThumbnailFile = File(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final month = DateFormat('LLL').format(widget.date);
    final day = DateFormat('dd').format(widget.date);

    if (videoThumbnailFile == null) {
      generateVideoThumbnail(widget.videoUrl);
    }

    void openDetailsPage() {
      if (widget.webview) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InAppWebViewPage(url: widget.link)),
        );
      } else {
        if (widget.event != null) {
          context.pushTransparentRoute(CalendarDetailPage(event: widget.event!));
        } else {
          context.pushTransparentRoute(
            NewsDetailsPage(
              title: widget.title,
              date: widget.date,
              image: widget.image,
              link: widget.link,
              content: widget.content,
              copyright: widget.copyright,
              videoUrl: widget.videoUrl,
              author: widget.author,
            ),
          );
        }
      }
    }

    return CustomButton(
      borderRadius: BorderRadius.circular(15),
      highlightColor: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
          ? const Color.fromRGBO(0, 0, 0, 0.03)
          : const Color.fromRGBO(255, 255, 255, 0.03),
      splashColor: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
          ? const Color.fromRGBO(0, 0, 0, 0.04)
          : const Color.fromRGBO(255, 255, 255, 0.04),
      tapHandler: openDetailsPage,
      longPressHandler: openDetailsPage,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            // Image & Date
            Stack(
              alignment: Alignment.center,
              children: [
                if (widget.image != null || widget.videoUrl != null)
                  // Image
                  SizedBox(
                    height: widget.image == null && videoThumbnailFile != null ? 230 : null,
                    child: Hero(
                      tag: 'news_details_page_hero_tag',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: widget.image == null && videoThumbnailFile != null
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    videoThumbnailFile!,
                                    fit: BoxFit.cover,
                                  ),
                                  Align(
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                                            ? const Color.fromRGBO(245, 246, 250, 0.5)
                                            : const Color.fromRGBO(34, 40, 54, 0.5),
                                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                                      ),
                                      child: Icon(
                                        Icons.play_arrow_sharp,
                                        color: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                                            ? const Color.fromRGBO(34, 40, 54, 1)
                                            : const Color.fromRGBO(245, 246, 250, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : widget.image,
                      ),
                    ),
                  ),
                // Date
                if (widget.event != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineMedium,
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
                text: widget.title,
                textStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
              ),
            ),
            // Description
            StyledHTML(
              context: context,
              text: widget.description,
              textStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
