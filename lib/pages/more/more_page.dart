import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/more/widgets/external_link_button.dart';
import 'package:campus_app/pages/more/widgets/button_group.dart';
import 'package:campus_app/pages/more/in_app_web_view_page.dart';
import 'package:campus_app/pages/more/static_info_page.dart';
import 'package:campus_app/pages/more/settings_page.dart';

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

  static const String imprint = 'dfkajödslkf';
  static const String privacy = 'dföjköaldf';

  void openLink(BuildContext context, String url) {
    debugPrint('Opening external ressource: $url');

    // Enforces to open social links in external browser to let the system handle these
    // and open designated apps, if installed
    if (Provider.of<SettingsHandler>(context, listen: false).currentSettings.useExternalBrowser ||
        url.contains('instagram') ||
        url.contains('facebook') ||
        url.contains('twitch')) {
      // Open in external browser
      launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      // Open in InAppView
      Navigator.push(context, MaterialPageRoute(builder: (context) => InAppWebViewPage(url: url)));
    }
  }

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
                      // AStA links
                      ButtonGroup(
                        headline: 'AStA',
                        buttons: [
                          ExternalLinkButton(
                            title: 'Kulturcafé',
                            leadingIconPath: 'assets/img/asta_logo.png',
                            onTap: () => openLink(context, 'https://kulturcafe.asta-bochum.de/'),
                          ),
                          ExternalLinkButton(
                            title: 'Fahrrad Werkstatt',
                            leadingIconPath: 'assets/img/asta_logo.png',
                            onTap: () => openLink(context, 'https://asta-bochum.de/fahrradwerkstatt/'),
                          ),
                          ExternalLinkButton(
                            title: 'Repair Café',
                            leadingIconPath: 'assets/img/asta_logo.png',
                            onTap: () => openLink(context, 'https://asta-bochum.de/repair-cafe/'),
                          ),
                          Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: SocialMediaButton(
                                  iconPath: 'assets/img/icons/website.svg',
                                  onTap: () => openLink(context, 'https://asta-bochum.de/'),
                                ),
                              ),
                              Expanded(
                                child: SocialMediaButton(
                                  iconPath: 'assets/img/icons/instagram.svg',
                                  onTap: () => openLink(context, 'https://www.instagram.com/astarub/'),
                                ),
                              ),
                              Expanded(
                                child: SocialMediaButton(
                                  iconPath: 'assets/img/icons/facebook.svg',
                                  onTap: () => openLink(context, 'https://www.facebook.com/AStA.Bochum/'),
                                ),
                              ),
                              Expanded(
                                child: SocialMediaButton(
                                  iconPath: 'assets/img/icons/twitch.svg',
                                  onTap: () => openLink(context, 'https://www.twitch.tv/asta_rub'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // RUB links
                      ButtonGroup(
                        headline: 'Nützliche Links',
                        buttons: [
                          ExternalLinkButton(
                            title: 'RubMail',
                            leadingIconPath: 'assets/img/icons/mail-link.png',
                            onTap: () => openLink(context, 'https://mail.ruhr-uni-bochum.de/rubwebmail/'),
                          ),
                          ExternalLinkButton(
                            title: 'Moodle',
                            leadingIconPath: 'assets/img/icons/moodle-link.png',
                            onTap: () => openLink(context, 'https://moodle.ruhr-uni-bochum.de/'),
                          ),
                          ExternalLinkButton(
                            title: 'eCampus',
                            leadingIconPath: 'assets/img/icons/rub-link.png',
                            onTap: () => openLink(context,
                                'https://www.ruhr-uni-bochum.de/ecampus/ecampus-webclient/login_studierende.html'),
                          ),
                          ExternalLinkButton(
                            title: 'FlexNow',
                            leadingIconPath: 'assets/img/icons/flexnow-link.png',
                            onTap: () => openLink(context, 'https://www.flexnow.ruhr-uni-bochum.de/'),
                          ),
                        ],
                      ),
                      // Additional sites and links
                      ButtonGroup(
                        headline: 'Sonstiges',
                        buttons: [
                          ExternalLinkButton(
                            title: 'Einstellungen',
                            leadingIconPath: 'assets/img/icons/settings.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            },
                          ),
                          ExternalLinkButton(
                            title: 'Datenschutz',
                            leadingIconPath: 'assets/img/icons/info.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StaticInfoPage(title: 'Datenschutz', content: privacy),
                                ),
                              );
                            },
                          ),
                          ExternalLinkButton(
                            title: 'Impressum',
                            leadingIconPath: 'assets/img/icons/info.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StaticInfoPage.external(
                                    title: 'Impressum',
                                    url: 'https://asta-bochum.de/impressum/',
                                  ),
                                ),
                              );
                            },
                          ),
                          ExternalLinkButton(
                            title: 'Verwendete Ressourcen',
                            leadingIconPath: 'assets/img/icons/info.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () => showLicensePage(context: context),
                          ),
                        ],
                      ),
                      // AStA logo at the bottom of the page
                      Image.asset(
                        'assets/img/asta_logo.png',
                        width: 50,
                        height: 50,
                        color: Colors.black.withOpacity(0.05),
                        alignment: Alignment.bottomCenter,
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
