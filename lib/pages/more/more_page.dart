import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/more/widgets/external_link_button.dart';

class MorePage extends StatelessWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const MorePage({
    Key? key,
    required this.mainNavigatorKey,
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
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Text(
                    'Einstellungen & Mehr',
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                  ),
                ),
                // Site content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ButtonGroup(
                        headline: 'AStA',
                        buttons: [
                          ExternalLinkButton(title: 'AStA Website', iconPath: 'assets/img/asta_logo.png', onTap: () {}),
                          ExternalLinkButton(title: 'Repair Café', iconPath: 'assets/img/asta_logo.png', onTap: () {}),
                          ExternalLinkButton(
                              title: 'Fahrrad Werkstatt', iconPath: 'assets/img/asta_logo.png', onTap: () {}),
                        ],
                      ),
                      ButtonGroup(
                        headline: 'Nützliche Links',
                        buttons: [
                          ExternalLinkButton(
                              title: 'RubMail', iconPath: 'assets/img/icons/mail-link.png', onTap: () {}),
                          ExternalLinkButton(
                              title: 'Moodle', iconPath: 'assets/img/icons/moodle-link.png', onTap: () {}),
                          ExternalLinkButton(title: 'eCampus', iconPath: 'assets/img/icons/filter.svg', onTap: () {}),
                          ExternalLinkButton(title: 'FlexNow', iconPath: 'assets/img/icons/filter.svg', onTap: () {}),
                        ],
                      ),
                      ButtonGroup(
                        headline: 'Sonstiges',
                        buttons: [
                          ExternalLinkButton(
                            title: 'Datenschutz',
                            iconPath: 'assets/img/icons/filter.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {},
                          ),
                          ExternalLinkButton(
                            title: 'Impressum',
                            iconPath: 'assets/img/icons/filter.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {},
                          ),
                          ExternalLinkButton(
                            title: 'Verwendete Ressourcen',
                            iconPath: 'assets/img/icons/filter.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {},
                          ),
                        ],
                      ),
                      // AStA logo at the bottom of the page
                      Expanded(
                        child: Image.asset(
                          'assets/img/asta_logo.png',
                          width: 50,
                          height: 50,
                          color: Colors.black.withOpacity(0.05),
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ],
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
