import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/l10n/l10n.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:campus_app/pages/home/widgets/bottom_nav_bar_item.dart';

/// Creates the bottom navigation bar that lets the user switch between different pages.
class BottomNavBar extends StatefulWidget {
  /// Needs the currently active page in order to highlight it
  final PageItem currentPage;

  /// Calls this function when an item of the navigation bar is selected.
  final Function(PageItem) onSelectedPage;

  const BottomNavBar({
    super.key,
    required this.currentPage,
    required this.onSelectedPage,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isIOS ? 88 : 68,
      padding: Platform.isIOS ? const EdgeInsets.only(bottom: 20, left: 5) : const EdgeInsets.only(left: 7),
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -1))],
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Feed
            BottomNavBarItem(
              title: AppLocalizations.of(context)!.navBarFeed,
              imagePathActive: 'assets/img/icons/home-filled.png',
              imagePathInactive: 'assets/img/icons/home-outlined.png',
              onTap: () => widget.onSelectedPage(PageItem.feed),
              isActive: widget.currentPage == PageItem.feed,
            ),
            // Calendar
            BottomNavBarItem(
              title: AppLocalizations.of(context)!.navBarEvents,
              imagePathActive: 'assets/img/icons/calendar-filled.png',
              imagePathInactive: 'assets/img/icons/calendar-outlined.png',
              onTap: () => widget.onSelectedPage(PageItem.events),
              isActive: widget.currentPage == PageItem.events,
            ),
            // Mensa
            BottomNavBarItem(
              title: AppLocalizations.of(context)!.navBarMensa,
              imagePathActive: 'assets/img/icons/mensa-filled.png',
              imagePathInactive: 'assets/img/icons/mensa-outlined.png',
              onTap: () => widget.onSelectedPage(PageItem.mensa),
              isActive: widget.currentPage == PageItem.mensa,
            ),
            // Wallet
            BottomNavBarItem(
              title: AppLocalizations.of(context)!.navBarWallet,
              imagePathActive: 'assets/img/icons/wallet-filled.png',
              imagePathInactive: 'assets/img/icons/wallet-outlined.png',
              onTap: () => widget.onSelectedPage(PageItem.wallet),
              isActive: widget.currentPage == PageItem.wallet,
            ),
            // More
            BottomNavBarItem(
              title: AppLocalizations.of(context)!.navBarMore,
              imagePathActive: 'assets/img/icons/more.png',
              imagePathInactive: 'assets/img/icons/more.png',
              onTap: () => widget.onSelectedPage(PageItem.more),
              isActive: widget.currentPage == PageItem.more,
            ),
          ],
        ),
      ),
    );
  }
}
