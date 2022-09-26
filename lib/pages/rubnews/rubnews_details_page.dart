import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class RubnewsDetailsPage extends StatelessWidget {
  final String title;
  final DateTime date;
  final CachedNetworkImage image;
  final String content;
  final bool isEvent;

  const RubnewsDetailsPage({
    Key? key,
    required this.title,
    required this.date,
    required this.image,
    required this.content,
    this.isEvent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final month = DateFormat('LLL').format(date);
    final day = DateFormat('dd').format(date);

    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CampusIconButton(
              iconPath: 'assets/img/icons/arrow-left.svg',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
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
                // Content
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  // child: Text(
                  //   content,
                  //   style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                  // ),
                  child: Html(
                    data: content,
                    style: {
                      'h4': Style(
                        fontSize: const FontSize(17),
                      ),
                      '*': Style(
                        color: const Color.fromARGB(255, 129, 129, 129),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
