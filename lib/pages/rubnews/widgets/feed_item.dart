import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

class FeedItem extends StatelessWidget {
  final String title;
  final String description;
  final DateTime date;
  final Image image;
  final String link;
  final String content;

  /// Creates a NewsFeed-item with an expandable content
  const FeedItem({
    Key? key,
    required this.title,
    this.description = '',
    required this.date,
    required this.image,
    this.link = '',
    required this.content,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: CustomButton(
        borderRadius: BorderRadius.circular(15),
        highlightColor: const Color.fromRGBO(0, 0, 0, 0.03),
        splashColor: const Color.fromRGBO(0, 0, 0, 0.04),
        tapHandler: () {},
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: image,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 6),
                child: Text(
                  title,
                  style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                ),
              ),
              Text(
                description,
                style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
