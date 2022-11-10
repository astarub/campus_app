import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/guide/widgets/expandable_faq_item.dart';
import 'package:campus_app/pages/guide/guide_content.dart';

class GuidePage extends StatelessWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const GuidePage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: AnimatedExit(
          key: pageExitAnimationKey,
          child: AnimatedEntry(
            key: pageEntryAnimationKey,
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 14 : 0, bottom: 40),
                  child: Text(
                    'Guide',
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/img/icons/info-message.svg',
                        height: 24,
                        color: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            'Dieser Bereich wird in zukünftigen Versionen stetig ergänzt und um nützliche Hilfen wie bspw. einen interaktiven Raumfinder erweitert werden.',
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                    physics: const BouncingScrollPhysics(),
                    children: faqEntries
                        .map((faqEntry) => ExpandableFaqItem(title: faqEntry['title']!, content: faqEntry['content']!))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
