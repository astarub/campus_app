import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/page_navigator.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class NavigationSettingsPage extends StatefulWidget {
  const NavigationSettingsPage({super.key});

  @override
  State<NavigationSettingsPage> createState() => _NavigationSettingsPageState();
}

class _NavigationSettingsPageState extends State<NavigationSettingsPage> {
  late List<PageItem> _orderedPages;
  late PageItem _startPage;
  bool _didLoadInitialSettings = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didLoadInitialSettings) {
      return;
    }

    final settings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings;
    _orderedPages = sanitizeCustomizablePageOrder(settings.navbarPageOrder);
    _startPage =
        pageItemFromStorageId(settings.startPageId) ?? _orderedPages.first;

    if (!_orderedPages.contains(_startPage)) {
      _startPage = _orderedPages.first;
    }

    _didLoadInitialSettings = true;
  }

  void _saveSettings() {
    final settingsHandler =
        Provider.of<SettingsHandler>(context, listen: false);

    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
      startPageId: _startPage.storageId,
      navbarPageOrder: _orderedPages.map((page) => page.storageId).toList(),
    );
  }

  void _selectStartPage(PageItem pageItem) {
    setState(() {
      _startPage = pageItem;
    });
    _saveSettings();
  }

  void _reorderPages(int oldIndex, int newIndex) {
    final targetIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;

    setState(() {
      final page = _orderedPages.removeAt(oldIndex);
      _orderedPages.insert(targetIndex, page);
    });
    _saveSettings();
  }

  String _labelForPage(PageItem pageItem) {
    switch (pageItem) {
      case PageItem.feed:
        return 'Feed';
      case PageItem.events:
        return 'Events';
      case PageItem.coupons:
        return 'Coupons';
      case PageItem.navigation:
        return 'Navigation';
      case PageItem.mensa:
        return 'Mensa';
      case PageItem.wallet:
        return 'Wallet';
      case PageItem.more:
        return 'Mehr';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemesNotifier>(context);
    final theme = themeNotifier.currentThemeData;
    final isLightTheme = themeNotifier.currentTheme == AppThemes.light;
    final tileColor = isLightTheme
        ? const Color.fromRGBO(245, 246, 250, 1)
        : const Color.fromRGBO(34, 40, 54, 1);
    final selectedTileColor = isLightTheme
        ? theme.colorScheme.secondary.withValues(alpha: 0.12)
        : theme.colorScheme.secondary.withValues(alpha: 0.16);
    final secondaryTextColor = isLightTheme ? Colors.black54 : Colors.white70;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.only(
          top: Platform.isAndroid ? 20 : 0,
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
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
                        'Startseite & Navbar',
                        style: theme.textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ReorderableListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                buildDefaultDragHandles: false,
                onReorder: _reorderPages,
                header: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Lege die Reihenfolge der Tabs fest und markiere, welche Seite beim Start der App zuerst angezeigt werden soll.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Der Punkt markiert die Startseite. Halte den Griff rechts gedrueckt, um die Reihenfolge zu aendern.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                children: _orderedPages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final pageItem = entry.value;
                  final isSelected = _startPage == pageItem;

                  return Padding(
                    key: ValueKey(pageItem.storageId),
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: isSelected ? selectedTileColor : tileColor,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () => _selectStartPage(pageItem),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? theme.colorScheme.secondary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: theme.textTheme.titleMedium,
                            ),
                            title: Text(
                              _labelForPage(pageItem),
                              style: theme.textTheme.bodyMedium,
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: 16, right: 8),
                            minVerticalPadding: 12,
                            trailing: SizedBox(
                              width: 88,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    size: 16,
                                    color: isSelected
                                        ? theme.colorScheme.secondary
                                        : secondaryTextColor,
                                  ),
                                  const SizedBox(width: 8),
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: Icon(
                                      Icons.drag_handle,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
