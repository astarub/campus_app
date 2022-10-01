import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/more/widgets/external_link_button.dart';
import 'package:campus_app/pages/more/widgets/button_group.dart';

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
                          ExternalLinkButton(
                              title: 'Kulturcafé', leadingIconPath: 'assets/img/asta_logo.png', onTap: () {}),
                          ExternalLinkButton(
                              title: 'Fahrrad Werkstatt', leadingIconPath: 'assets/img/asta_logo.png', onTap: () {}),
                          ExternalLinkButton(
                              title: 'Repair Café', leadingIconPath: 'assets/img/asta_logo.png', onTap: () {}),
                          Container(
                            decoration: const BoxDecoration(
                              //color: Colors.black,
                              borderRadius:
                                  BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                            ),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                /* Padding(
                                  padding: const EdgeInsets.only(left: 51),
                                  child: Text(
                                    'Social Media:',
                                    style: Provider.of<ThemesNotifier>(context)
                                        .currentThemeData
                                        .textTheme
                                        .labelMedium /* !
                                        .copyWith(color: Colors.black) */
                                    ,
                                  ),
                                ), */
                                Expanded(
                                  child: SocialMediaButton(
                                    iconPath: 'assets/img/icons/website.svg',
                                    onTap: () {},
                                  ),
                                ),
                                Expanded(
                                  child: SocialMediaButton(
                                    iconPath: 'assets/img/icons/instagram.svg',
                                    onTap: () {},
                                  ),
                                ),
                                Expanded(
                                  child: SocialMediaButton(
                                    iconPath: 'assets/img/icons/facebook.svg',
                                    onTap: () {},
                                  ),
                                ),
                                Expanded(
                                  child: SocialMediaButton(
                                    iconPath: 'assets/img/icons/twitch.svg',
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ButtonGroup(
                        headline: 'Nützliche Links',
                        buttons: [
                          ExternalLinkButton(
                              title: 'RubMail', leadingIconPath: 'assets/img/icons/mail-link.png', onTap: () {}),
                          ExternalLinkButton(
                              title: 'Moodle', leadingIconPath: 'assets/img/icons/moodle-link.png', onTap: () {}),
                          ExternalLinkButton(
                              title: 'eCampus', leadingIconPath: 'assets/img/icons/filter.svg', onTap: () {}),
                          ExternalLinkButton(
                              title: 'FlexNow', leadingIconPath: 'assets/img/icons/filter.svg', onTap: () {}),
                        ],
                      ),
                      ButtonGroup(
                        headline: 'Sonstiges',
                        buttons: [
                          ExternalLinkButton(
                            title: 'Datenschutz',
                            leadingIconPath: 'assets/img/icons/filter.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {},
                          ),
                          ExternalLinkButton(
                            title: 'Impressum',
                            leadingIconPath: 'assets/img/icons/filter.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {},
                          ),
                          ExternalLinkButton(
                            title: 'Verwendete Ressourcen',
                            leadingIconPath: 'assets/img/icons/filter.svg',
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
