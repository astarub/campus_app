import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_selection.dart';

extension _IterableExtensions<T> on Iterable<T> {
  Iterable<List<T>> chunks(int chunkSize) sync* {
    final chunk = <T>[];
    for (T item in this) {
      chunk.add(item);
      if (chunk.length == chunkSize) {
        yield chunk;
        chunk.clear();
      }
    }
    if (chunk.isNotEmpty) yield chunk;
  }
}

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

  List<Widget> buildOptions() {
    final parts = selectionItemTitles.chunks(3);
    final List<Widget> rows = [];
    int select = 0;

    for (final chunk in parts) {
      final List<Widget> expanded = [];
      int i = 0;

      for (final selection in chunk) {
        switch(i) {
          case 0: {
            expanded.add(
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SelectionItem(
                    text: selection,
                    onTap: () => onSelected(selection),
                    isActive: selections[select],
                    paddingVertical: 25,
                  ),
                ),
              ),
            );
            break;
          }
          case 1: {
            expanded.add(
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SelectionItem(
                    text: selection,
                    onTap: () => onSelected(selection),
                    isActive: selections[select],
                    paddingVertical: 25,
                  ),
                ),
              ),
            );
            break;
          }
          case 2: {
            expanded.add(
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: SelectionItem(
                    text: selection,
                    onTap: () => onSelected(selection),
                    isActive: selections[select],
                    paddingVertical: 25,
                  ),
                ),
              ),
            );
            break;
          }
        }
        select++;
        i++;
      }
      for(int j = 1; chunk.length+j <= 3; j++) {
        expanded.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(),
            ),
          ),
        );
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: expanded,
          ),
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      child: Column(
        children: buildOptions(),
      ),
    );
  }
}
