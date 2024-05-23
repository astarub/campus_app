import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/l10n/l10n.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/popup_sheet.dart';
import 'package:campus_app/utils/widgets/campus_selection.dart';

/// This widget displays the preference options that are available for the mensa
/// page and is used in the [SnappingSheet] widget.
class PreferencesPopup extends StatefulWidget {
  /// Can be given to show saved preferences on build
  final List<String> preferences;

  /// The function that is called when the popup is closed by the user.
  /// Returns a List of Strings that represent the selected preferences.
  final void Function(List<String>) onClose;

  const PreferencesPopup({
    Key? key,
    this.preferences = const [],
    required this.onClose,
  }) : super(key: key);

  @override
  State<PreferencesPopup> createState() => _PreferencesPopupState();
}

class _PreferencesPopupState extends State<PreferencesPopup> {
  late List<String> _selectedPreferences;

  void selectItem(String selected) {
    if (_selectedPreferences.contains(selected)) {
      setState(() => _selectedPreferences.removeWhere((preference) => preference == selected));
    } else {
      setState(() => _selectedPreferences.add(selected));
    }
  }

  @override
  void initState() {
    super.initState();

    _selectedPreferences = widget.preferences;
  }

  @override
  Widget build(BuildContext context) {
    return PopupSheet(
      title: AppLocalizations.of(context)!.mealPreferences,
      onClose: () {
        widget.onClose(_selectedPreferences);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                AppLocalizations.of(context)!.preferencesExclusive,
                textAlign: TextAlign.left,
                style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
              ),
            ),
            SelectionItemRow(
              selectionItemTitles: [
                AppLocalizations.of(context)!.preferencesVegetarian,
                AppLocalizations.of(context)!.preferencesVegan,
                AppLocalizations.of(context)!.preferencesHalal,
              ],
              selectionItemShortcut: const ['V', 'VG', 'H'],
              selections: [
                _selectedPreferences.contains('V'),
                _selectedPreferences.contains('VG'),
                _selectedPreferences.contains('H'),
              ],
              onSelected: selectItem,
            ),
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Text(
                AppLocalizations.of(context)!.preferencesAvoid,
                textAlign: TextAlign.left,
                style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
              ),
            ),
            SelectionItemRow(
              selectionItemTitles: [
                AppLocalizations.of(context)!.preferencesAlcohol,
                AppLocalizations.of(context)!.preferencesFish,
                AppLocalizations.of(context)!.preferencesPoultry,
              ],
              selectionItemShortcut: const ['A', 'F', 'G'],
              selections: [
                _selectedPreferences.contains('A'),
                _selectedPreferences.contains('F'),
                _selectedPreferences.contains('G'),
              ],
              onSelected: selectItem,
            ),
            SelectionItemRow(
              selectionItemTitles: [
                AppLocalizations.of(context)!.preferencesLamb,
                AppLocalizations.of(context)!.preferencesBeef,
                AppLocalizations.of(context)!.preferencesPork,
              ],
              selectionItemShortcut: const ['L', 'R', 'S'],
              selections: [
                _selectedPreferences.contains('L'),
                _selectedPreferences.contains('R'),
                _selectedPreferences.contains('S'),
              ],
              onSelected: selectItem,
            ),
            SelectionItemRow(
              selectionItemTitles: [AppLocalizations.of(context)!.preferencesGame],
              selectionItemShortcut: const ['W'],
              selections: [_selectedPreferences.contains('W')],
              onSelected: selectItem,
            ),
          ],
        ),
      ),
    );
  }
}

/// This widget is similar to the [CampusSelection] widget and shows 3 buttons in a Row
/// that can be active at the same time.
///
/// Therefore it uses the [SelectionItem] widget of the [CampusSelection] widget.
class SelectionItemRow extends StatelessWidget {
  /// The titles for the 3 buttons
  final List<String> selectionItemTitles;

  /// The preference shortcuts for the 3 titles
  final List<String> selectionItemShortcut;

  /// Wether each of the selection-buttons is active or not.
  final List<bool> selections;

  /// The function that should be called whenever a button is tapped
  final void Function(String) onSelected;

  const SelectionItemRow({
    Key? key,
    required this.selectionItemTitles,
    required this.selectionItemShortcut,
    this.selections = const [false, false, false],
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // First selection item
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SelectionItem(
                text: selectionItemTitles[0],
                onTap: () => onSelected(selectionItemShortcut[0]),
                isActive: selections[0],
              ),
            ),
          ),
          // Second selection item
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: selectionItemTitles.length >= 2
                  ? SelectionItem(
                      text: selectionItemTitles[1],
                      onTap: () => onSelected(selectionItemShortcut[1]),
                      isActive: selections[1],
                    )
                  : Container(),
            ),
          ),
          // Third selection item
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: selectionItemTitles.length == 3
                  ? SelectionItem(
                      text: selectionItemTitles[2],
                      onTap: () => onSelected(selectionItemShortcut[2]),
                      isActive: selections[2],
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
