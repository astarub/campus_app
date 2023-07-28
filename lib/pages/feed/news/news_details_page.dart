import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:html/parser.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';

class RubnewsDetailsPage extends StatelessWidget {
  final String title;
  final DateTime date;
  final CachedNetworkImage? image;
  final String content;
  final bool isEvent;
  final String link;

  const RubnewsDetailsPage({
    Key? key,
    required this.title,
    required this.date,
    this.image,
    required this.link,
    required this.content,
    this.isEvent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final month = DateFormat('LLL').format(date);
    final day = DateFormat('dd').format(date);

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
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
                        'Article shared via Campus App: $link',
                        subject: 'Article shared via Campus App',
                        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  // Image & Date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // Image
                        if (image != null)
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
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 6, left: 20, right: 20),
                    child: Text(
                      parseFragment(title).text != null ? parseFragment(title).text! : '',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                    child: StyledHTML(
                      context: context,
                      text: content,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  // Credits
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
                    child: StyledHTML(
                      context: context,
                      text: 'Quelle: <a href="$link">${Uri.parse(link).host}</a>',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
