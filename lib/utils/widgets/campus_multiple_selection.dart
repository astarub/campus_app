import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_selection.dart';

/// This widget is similar to the [CampusSelection] widget and shows 3 buttons in a Row
/// that can be active at the same time.
///
/// Therefore it uses the [SelectionItem] widget of the [CampusSelection] widget.
class CampusMultiSelection extends StatelessWidget {
  /// The titles for the 3 buttons
  final List<String> selectionItemTitles;

  /// Wether each of the selection-buttons is active or not.
  final List<bool> selections;

  /// The function that should be called whenever a button is tapped
  final void Function(String) onSelected;

  const CampusMultiSelection({
    Key? key,
    required this.selectionItemTitles,
    this.selections = const [false, false, false],
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
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
                onTap: () => onSelected(selectionItemTitles[0]),
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
                      onTap: () => onSelected(selectionItemTitles[1]),
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
                      onTap: () => onSelected(selectionItemTitles[2]),
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
