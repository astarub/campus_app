import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/guide/widgets/expandable_faq_item.dart';
import 'package:campus_app/pages/guide/guide_content.dart';
import 'package:campus_app/pages/guide/widgets/leitwarte_button.dart';

class GuidePage extends StatefulWidget {

  const GuidePage({ Key? key }) : super(key: key);

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  List<Widget> faqExpandables = [const LeitwarteButton()];

  @override
  void initState() {
    super.initState();

    faqExpandables.addAll(
      faqEntries
          .map((faqEntry) => ExpandableFaqItem(title: faqEntry['title']!, content: faqEntry['content']!))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
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
                children: faqExpandables,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
