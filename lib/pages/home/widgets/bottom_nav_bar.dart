import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  int _prevShift = 0;

  @override
  void didUpdateWidget(covariant BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // prevShift will be updated in build after computing desiredShift. Keep
    // previous value so AnimatedSwitcher transition direction can be derived.
    // No-op here: _prevShift is updated in build to avoid extra setState.
  }

  @override
  Widget build(BuildContext context) {
    // Minimal change approach: render all items in a fixed-width row but clip to
    // show only 5 slots. Animate a horizontal translation so one end icon slides
    // off-screen depending on the active page.
    const horizontalPadding = 10.0; // matches previous symmetric horizontal padding
    const visibleCount = 5;
    const items = <PageItem>[
      PageItem.feed,
      PageItem.events,
      PageItem.mensa,
      PageItem.navigation,
      PageItem.wallet,
      PageItem.more,
    ];
    final totalItems = items.length;
    final maxShift = (totalItems - visibleCount).clamp(0, totalItems);
    final activeIndex = items.indexOf(widget.currentPage);
    // Aim to keep the active item roughly centered when possible; because
    // totalItems-visibleCount == 1 here, shift will be 0 or 1 which matches the
    // requested behavior: when on first page show first 5, when on last show last 5.
    final desiredShift = (activeIndex - 2).clamp(0, maxShift);

    // Compute height based on platform base and device bottom inset to avoid
    // overflow when system navigation/home bars reduce available height.
    final bottomInset = MediaQuery.of(context).padding.bottom;
    // 66 = 26 Icon + 2*8 Vertical Padding + 14 Label Text + 12 Active Animation
    const navbarHeight = 68;

    return Container(
      height: bottomInset + navbarHeight, // System UI + Campus App Navbar
      // keep left padding but add bottom padding equal to the system inset so
      // the visual content is above system UI while the container remains
      // flush at the page bottom.
      padding: Platform.isIOS
          ? EdgeInsets.only(left: 5, bottom: bottomInset)
          : EdgeInsets.only(left: 7, bottom: bottomInset),
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: ClipRect(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final navHeight = constraints.maxHeight;
              final effectiveContainerWidth = constraints.maxWidth;
              final computedSlotWidth = effectiveContainerWidth / visibleCount;

              // Determine which slice of items to show (no off-screen items)
              final startIndex = desiredShift;
              final visibleItems = items.sublist(startIndex, startIndex + visibleCount);

              // Decide animation direction based on previous shift
              final animateForward = desiredShift >= _prevShift;
              // Update prevShift for next frame
              _prevShift = desiredShift;

              return SizedBox(
                height: navHeight,
                width: effectiveContainerWidth,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: Offset(animateForward ? 1.0 : -1.0, 0),
                      end: Offset.zero,
                    ).animate(animation);
                    return SlideTransition(position: offsetAnimation, child: child);
                  },
                  child: SizedBox(
                    width: effectiveContainerWidth,
                    key: ValueKey<int>(desiredShift),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final p in visibleItems)
                          SizedBox(
                            width: computedSlotWidth,
                            child: (() {
                              switch (p) {
                                case PageItem.feed:
                                  return BottomNavBarItem(
                                    title: 'Feed',
                                    imagePathActive: 'assets/img/icons/home-filled.png',
                                    imagePathInactive: 'assets/img/icons/home-outlined.png',
                                    onTap: () => widget.onSelectedPage(PageItem.feed),
                                    isActive: widget.currentPage == PageItem.feed,
                                  );
                                case PageItem.events:
                                  return BottomNavBarItem(
                                    title: 'Events',
                                    imagePathActive: 'assets/img/icons/calendar-filled.png',
                                    imagePathInactive: 'assets/img/icons/calendar-outlined.png',
                                    onTap: () => widget.onSelectedPage(PageItem.events),
                                    isActive: widget.currentPage == PageItem.events,
                                    iconPaddingLeft: 14,
                                  );
                                case PageItem.mensa:
                                  return BottomNavBarItem(
                                    title: 'Mensa',
                                    imagePathActive: 'assets/img/icons/mensa-filled.png',
                                    imagePathInactive: 'assets/img/icons/mensa-outlined.png',
                                    onTap: () => widget.onSelectedPage(PageItem.mensa),
                                    isActive: widget.currentPage == PageItem.mensa,
                                  );
                                case PageItem.navigation:
                                  return BottomNavBarItem(
                                    title: 'Navigation',
                                    imagePathActive: 'assets/img/icons/map-filled.png',
                                    imagePathInactive: 'assets/img/icons/map-outlined.png',
                                    onTap: () => widget.onSelectedPage(PageItem.navigation),
                                    isActive: widget.currentPage == PageItem.navigation,
                                  );
                                case PageItem.wallet:
                                  return BottomNavBarItem(
                                    title: 'Wallet',
                                    imagePathActive: 'assets/img/icons/wallet-filled.png',
                                    imagePathInactive: 'assets/img/icons/wallet-outlined.png',
                                    onTap: () => widget.onSelectedPage(PageItem.wallet),
                                    isActive: widget.currentPage == PageItem.wallet,
                                  );
                                case PageItem.more:
                                  return BottomNavBarItem(
                                    title: 'Mehr',
                                    imagePathActive: 'assets/img/icons/more.png',
                                    imagePathInactive: 'assets/img/icons/more.png',
                                    onTap: () => widget.onSelectedPage(PageItem.more),
                                    isActive: widget.currentPage == PageItem.more,
                                    iconPaddingLeft: 5,
                                  );
                                default:
                                  return const SizedBox.shrink();
                              }
                            })(),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
