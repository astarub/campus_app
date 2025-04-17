import 'dart:io' show Platform;

import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/more/imprint_page.dart';
import 'package:campus_app/pages/more/in_app_web_view_page.dart';
import 'package:campus_app/pages/more/privacy_policy_page.dart';
import 'package:campus_app/pages/more/settings_page.dart';
import 'package:campus_app/pages/more/widgets/button_group.dart';
import 'package:campus_app/pages/more/widgets/external_link_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:campus_app/l10n/l10n.dart';

class MorePage extends StatefulWidget {
  static const String privacy = 'Tbd.';
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;

  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const MorePage({
    super.key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  });

  @override
  State<MorePage> createState() => MorePageState();
}

class MorePageState extends State<MorePage> with AutomaticKeepAliveClientMixin<MorePage> {
  // Keep state alive
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
      body: Center(
        child: AnimatedExit(
          key: widget.pageExitAnimationKey,
          child: AnimatedEntry(
            key: widget.pageEntryAnimationKey,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 10 : 0, bottom: 40),
                  child: Text(
                    AppLocalizations.of(context)!.morePageTitle,
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
                        headline: AppLocalizations.of(context)!.morePageAstaA,
                        buttons: [
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageKulturCafe,
                            leadingIconPath: 'assets/img/asta_logo.png',
                            onTap: () => openLink(context, 'https://asta-bochum.de/kulturcafe/'),
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageBikeWorkshop,
                            leadingIconPath: 'assets/img/asta_logo.png',
                            onTap: () => openLink(context, 'https://asta-bochum.de/fahrradwerkstatt/'),
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageRepairCafe,
                            leadingIconPath: 'assets/img/asta_logo.png',
                            onTap: () => openLink(context, 'https://asta-bochum.de/repair-cafe/'),
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageSocialCounseling,
                            leadingIconPath: 'assets/img/asta_logo.png',
                            onTap: () => openLink(context, 'https://asta-bochum.de/sozialberatung/'),
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageDancingGroup,
                            leadingIconPath: 'assets/img/asta_logo.png',
                            onTap: () => openLink(context, 'https://asta-bochum.de/tanzkreis/'),
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageGamingHub,
                            leadingIconPath: 'assets/img/asta-gaming-hub.png',
                            onTap: () => openLink(context, 'https://asta-bochum.de/gaming_hub/'),
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
                        headline: AppLocalizations.of(context)!.morePageUsefulLinks,
                        buttons: [
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageRubMail,
                            leadingIconPath: 'assets/img/icons/mail-link.png',
                            onTap: () => openLink(
                              context,
                              'https://mail.ruhr-uni-bochum.de/rubwebmail/',
                            ),
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageMoodle,
                            leadingIconPath: 'assets/img/icons/moodle-link.png',
                            onTap: () => openLink(
                              context,
                              'https://moodle.ruhr-uni-bochum.de/',
                            ),
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageECampus,
                            leadingIconPath: 'assets/img/icons/rub-link.png',
                            onTap: () => openLink(
                              context,
                              'https://www.ruhr-uni-bochum.de/ecampus/ecampus-webclient/login_studierende.html',
                            ),
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageFlexNow,
                            leadingIconPath: 'assets/img/icons/flexnow-link.png',
                            onTap: () => openLink(
                              context,
                              'https://www.flexnow.ruhr-uni-bochum.de/',
                            ),
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageUniSports,
                            leadingIconPath: 'assets/img/icons/hochschulsport_icon.png',
                            onTap: () => openLink(
                              context,
                              'https://buchung.hochschulsport.ruhr-uni-bochum.de/angebote/aktueller_zeitraum/m.html',
                            ),
                          ),
                        ],
                      ),
                      // Additional sites and links
                      ButtonGroup(
                        headline: AppLocalizations.of(context)!.morePageOther,
                        buttons: [
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageSettings,
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
                          // Privacy
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePagePrivacy,
                            leadingIconPath: 'assets/img/icons/info.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicyPage(),
                                ),
                              );
                            },
                          ),
                          // Imprint
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageLegalNotice,
                            leadingIconPath: 'assets/img/icons/info.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ImprintPage()),
                              );
                            },
                          ),
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageUsedResources,
                            leadingIconPath: 'assets/img/icons/info.svg',
                            trailingIconPath: 'assets/img/icons/chevron-right.svg',
                            onTap: () => showLicensePage(context: context),
                          ),
                          // Feedback
                          ExternalLinkButton(
                            title: AppLocalizations.of(context)!.morePageFeedback,
                            leadingIconPath: 'assets/img/icons/message-square.svg',
                            onTap: () =>
                                openLink(context, 'https://next.asta-bochum.de/index.php/apps/forms/jb2Z4mge9yj2z56E'),
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

  void openLink(BuildContext context, String url) {
    debugPrint('Opening external ressource: $url');

    // Enforces to open social links in external browser to let the system handle these
    // and open designated apps, if installed
    if (Provider.of<SettingsHandler>(context, listen: false).currentSettings.useExternalBrowser ||
        url.contains('instagram') ||
        url.contains('facebook') ||
        url.contains('twitch') ||
        url.contains('mailto:') ||
        url.contains('tel:')) {
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
}
