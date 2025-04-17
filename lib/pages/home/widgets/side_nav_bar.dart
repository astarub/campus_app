import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/l10n/l10n.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:campus_app/pages/home/widgets/side_nav_bar_item.dart';

class SideNavBar extends StatefulWidget {
  /// Needs the currently active page in order to highlight it
  final PageItem currentPage;

  /// Calls this function when an item of the navigation bar is selected.
  final Function(PageItem) onSelectedPage;

  const SideNavBar({
    super.key,
    required this.currentPage,
    required this.onSelectedPage,
  });

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.only(top: 40, bottom: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
            ? const Color.fromRGBO(245, 246, 250, 1)
            : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
      ),
      child: Column(
        children: [
          // News Feed
          SideNavBarItem(
            title: AppLocalizations.of(context)!.navBarFeed,
            imagePathActive: 'assets/img/icons/home-filled.png',
            imagePathInactive: 'assets/img/icons/home-outlined.png',
            onTap: () => widget.onSelectedPage(PageItem.feed),
            isActive: widget.currentPage == PageItem.feed,
          ),
          // Calendar
          SideNavBarItem(
            title: AppLocalizations.of(context)!.navBarEvents,
            imagePathActive: 'assets/img/icons/calendar-filled.png',
            imagePathInactive: 'assets/img/icons/calendar-outlined.png',
            onTap: () => widget.onSelectedPage(PageItem.events),
            isActive: widget.currentPage == PageItem.events,
          ),
          // Mensa
          SideNavBarItem(
            title: AppLocalizations.of(context)!.navBarMensa,
            imagePathActive: 'assets/img/icons/mensa-filled.png',
            imagePathInactive: 'assets/img/icons/mensa-outlined.png',
            onTap: () => widget.onSelectedPage(PageItem.mensa),
            isActive: widget.currentPage == PageItem.mensa,
          ),
          // Wallet
          SideNavBarItem(
            title: AppLocalizations.of(context)!.navBarWallet,
            imagePathActive: 'assets/img/icons/wallet-filled.png',
            imagePathInactive: 'assets/img/icons/wallet-outlined.png',
            onTap: () => widget.onSelectedPage(PageItem.wallet),
            isActive: widget.currentPage == PageItem.wallet,
          ),
          const Expanded(child: SizedBox()),
          // More
          SideNavBarItem(
            title: AppLocalizations.of(context)!.navBarMore,
            imagePathActive: 'assets/img/icons/more.png',
            imagePathInactive: 'assets/img/icons/more.png',
            onTap: () => widget.onSelectedPage(PageItem.more),
            isActive: widget.currentPage == PageItem.more,
          ),
        ],
      ),
    );
  }
}
