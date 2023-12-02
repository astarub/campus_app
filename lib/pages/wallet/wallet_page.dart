import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/wallet/faq_page.dart';
import 'package:campus_app/pages/wallet/mensa_balance_page.dart';
import 'package:campus_app/utils/widgets/subpage_button.dart';
import 'package:campus_app/pages/wallet/widgets/leitwarte_button.dart';
import 'package:campus_app/pages/wallet/widgets/wallet.dart';

class WalletPage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const WalletPage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<WalletPage> {
  List<Widget> faqExpandables = [const LeitwarteButton()];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
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
                    'Wallet',
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                  ),
                ),
                const SizedBox(
                  height: 265,
                  child: CampusWallet(),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      // Leitwarte button
                      const Padding(
                        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                        child: LeitwarteButton(),
                      ),
                      // Other useful features
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            // AKAFÖ card balance
                            SubPageButton(
                              title: 'Mensa Guthaben',
                              leadingIconPath: 'assets/img/icons/euro.svg',
                              trailingIconPath: 'assets/img/icons/chevron-right.svg',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MensaBalancePage(),
                                  ),
                                );
                              },
                            ),
                            // FAQ
                            SubPageButton(
                              title: 'Campus ABC',
                              leadingIconPath: 'assets/img/icons/help-circle.svg',
                              trailingIconPath: 'assets/img/icons/chevron-right.svg',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FaqPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Future features info
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 60, left: 20, right: 20),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/img/icons/info-message.svg',
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color!,
                                BlendMode.srcIn,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  'Dieser Bereich wird in zukünftigen Versionen stetig ergänzt und um nützliche Hilfen in die App zu integrieren.',
                                  style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ],
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

  // Keep state alive
  @override
  bool get wantKeepAlive => true;
}
