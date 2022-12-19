import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/guide/widgets/expandable_faq_item.dart';
import 'package:campus_app/pages/guide/guide_content.dart';
import 'package:campus_app/pages/guide/widgets/leitwarte_button.dart';

class GuidePage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const GuidePage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  List<Widget> faqExpandables = [const LeitwarteButton()];

  @override
  void initState() {
    super.initState();

    // Sort the Entries Alphabetically before Adding them

    List<Map<String, String>> tmpList;
    tmpList = sortListOfStringString(List.from(faqEntries), 'title');

    faqExpandables.addAll(
      tmpList.map((faqEntry) => ExpandableFaqItem(title: faqEntry['title']!, content: faqEntry['content']!)).toList(),
    );
  }

  List<Map<String, String>> sortListOfStringString(
    List<Map<String, String>> sortList,
    String byPara, {
    bool reverse = false,
  }) {
    if (!reverse) {
      sortList.sort(
        (a, b) {
          return a[byPara]!.toLowerCase().compareTo(b[byPara]!.toLowerCase());
        },
      );
    } else {
      sortList.sort(
        (a, b) {
          return b[byPara]!.toLowerCase().compareTo(a[byPara]!.toLowerCase());
        },
      );
    }

    return sortList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: AnimatedExit(
          key: widget.pageExitAnimationKey,
          child: AnimatedEntry(
            key: widget.pageEntryAnimationKey,
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
                            '''
                              Dieser Bereich wird in zukünftigen Versionen stetig ergänzt und um nützliche Hilfen wie 
                              bspw. einen interaktiven Raumfinder erweitert werden.
                            ''',
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
                    children: faqExpandables,
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
