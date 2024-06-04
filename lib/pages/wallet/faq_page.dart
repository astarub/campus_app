import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/l10n/l10n.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/pages/wallet/widgets/expandable_faq_item.dart';
import 'package:campus_app/pages/wallet/guide_content.dart';

class FaqPage extends StatelessWidget {
  final GlobalKey<NavigatorState> ourNavigatorKey = GlobalKey<NavigatorState>();
  final List<Widget> faqExpandables = [];

  FaqPage({Key? key}) : super(key: key) {
    // Sort the Entries Alphabetically before Adding them
    final List<Map<String, String>> faqList = _sortFaqList(List.from(faqEntries), 'title');

    faqExpandables.addAll(
      faqList.map((faqEntry) => ExpandableFaqItem(title: faqEntry['title']!, content: faqEntry['content']!)).toList(),
    );
  }

  List<Map<String, String>> _sortFaqList(List<Map<String, String>> sortList, String byPara, {bool reverse = false}) {
    if (!reverse) {
      sortList.sort((a, b) {
        return a[byPara]!.toLowerCase().compareTo(b[byPara]!.toLowerCase());
      });
    } else {
      sortList.sort((a, b) {
        return b[byPara]!.toLowerCase().compareTo(a[byPara]!.toLowerCase());
      });
    }

    return sortList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
      body: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 0),
        child: Column(
          children: [
            // Back button & page title
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    CampusIconButton(
                      iconPath: 'assets/img/icons/arrow-left.svg',
                      onTap: () => Navigator.pop(context),
                    ),
                    Align(
                      child: Text(
                        AppLocalizations.of(context)!.faqCampusABC,
                        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: faqExpandables.length,
                itemBuilder: (context, index) => faqExpandables[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
