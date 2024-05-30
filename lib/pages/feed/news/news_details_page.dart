import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/feed/widgets/video_player.dart';
import 'package:campus_app/utils/widgets/scroll_to_top_button.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:html/parser.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';

class NewsDetailsPage extends StatefulWidget {
  final String title;
  final DateTime date;
  final CachedNetworkImage? image;
  final String content;
  final bool isEvent;
  final String link;
  final String copyright;
  final int author;
  final String? videoUrl;

  const NewsDetailsPage({
    super.key,
    required this.title,
    required this.date,
    this.image,
    required this.link,
    required this.content,
    this.isEvent = false,
    this.copyright = '',
    this.author = 0,
    this.videoUrl,
  });

  @override
  State<NewsDetailsPage> createState() => NewsDetailsPageState();
}

class NewsDetailsPageState extends State<NewsDetailsPage> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final month = DateFormat('LLL').format(widget.date);
    final day = DateFormat('dd').format(widget.date);

    // Copyright for videos
    String authorName = 'AStA';
    if (widget.author != 0) {
      try {
        authorName = Provider.of<SettingsHandler>(context)
            .currentSettings
            .publishers
            .firstWhere((element) => element.id == widget.author)
            .name;
        // ignore: empty_catches
      } catch (e) {}
    }

    return Dismissible(
      dismissThresholds: const {DismissDirection.endToStart: 0.3},
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
        floatingActionButton: ScrollToTopButton(scrollController: scrollController),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CampusIconButton(
                      iconPath: 'assets/img/icons/arrow-left.svg',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    CampusIconButton(
                      iconPath: 'assets/img/icons/share.svg',
                      onTap: () {
                        // Required for iPad, otherwise the Ui crashes
                        final box = context.findRenderObject() as RenderBox?;

                        Share.share(
                          'Campus App Article: ${widget.title}\nURL: ${widget.link}',
                          subject: widget.title,
                          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Image & Date
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Image
                          if (widget.image != null || widget.videoUrl != null)
                            Hero(
                              tag: 'news_details_page_hero_tag',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: widget.videoUrl != null
                                    ? FeedVideoPlayer(
                                        url: widget.videoUrl!,
                                        autoplay: true,
                                      )
                                    : widget.image,
                              ),
                            ),
                          // Date
                          if (widget.isEvent)
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
                                    month,
                                    style: Provider.of<ThemesNotifier>(context)
                                        .currentThemeData
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontSize: 14),
                                  ),
                                  Text(
                                    day,
                                    style:
                                        Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.image != null && !widget.isEvent && widget.copyright != '')
                      // Copyright
                      Padding(
                        padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
                        child: Text(
                          widget.copyright,
                          style: const TextStyle(fontSize: 12.5),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    if (widget.videoUrl != null && widget.author != 0)
                      // Copyright for Videos
                      Padding(
                        padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
                        child: Text(
                          '© $authorName',
                          style: const TextStyle(fontSize: 12.5),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    // Title
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 20, right: 20),
                      child: Text(
                        parseFragment(widget.title).text != null ? parseFragment(widget.title).text! : '',
                        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                      child: StyledHTML(
                        context: context,
                        text: widget.content,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    // Credits
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
                      child: StyledHTML(
                        context: context,
                        text: 'Quelle: <a href="${widget.link}">${Uri.parse(widget.link).host}</a>',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
