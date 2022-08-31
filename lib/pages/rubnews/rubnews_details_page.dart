import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class RubnewsDetailsPage extends StatelessWidget {
  final String title;
  final DateTime date;
  final Image image;
  final String content;

  const RubnewsDetailsPage({
    Key? key,
    required this.title,
    required this.date,
    required this.image,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const placeholderContent =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nunc pulvinar sapien et ligula. Eu non diam phasellus vestibulum lorem sed risus ultricies. Etiam erat velit scelerisque in dictum. Turpis nunc eget lorem dolor sed viverra ipsum nunc. Fermentum dui faucibus in ornare quam viverra. Diam in arcu cursus euismod quis viverra nibh. Molestie at elementum eu facilisis sed odio morbi quis. Volutpat diam ut venenatis tellus. Quam viverra orci sagittis eu volutpat.';

    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    placeholderContent,
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
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
