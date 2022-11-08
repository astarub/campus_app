import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/popup_sheet.dart';
import 'package:campus_app/utils/widgets/campus_multiple_selection.dart';

/// This widget displays the filter options that are available for the
/// personal news feed and is used in the [SnappingSheet] widget
class FeedFilterPopup extends StatefulWidget {
  /// Can be given to show saved filters on build
  final List<String> selectedFilters;

  /// The function that is called when the popup is closed by the user.
  /// Returns a List of Strings that represent the selected filters.
  final void Function(List<String>) onClose;

  const FeedFilterPopup({
    Key? key,
    this.selectedFilters = const [],
    required this.onClose,
  }) : super(key: key);

  @override
  State<FeedFilterPopup> createState() => _FeedFilterPopupState();
}

class _FeedFilterPopupState extends State<FeedFilterPopup> {
  late List<String> _selectedFilters;

  void onFilterSelected(String selectedFilter) {
    if (_selectedFilters.contains(selectedFilter)) {
      setState(() => _selectedFilters.removeWhere((filter) => filter == selectedFilter));
    } else {
      setState(() => _selectedFilters.add(selectedFilter));
    }
  }

  @override
  void initState() {
    super.initState();

    _selectedFilters = widget.selectedFilters;
  }

  @override
  Widget build(BuildContext context) {
    return PopupSheet(
      title: 'Feed Filter',
      onClose: () {
        widget.onClose(_selectedFilters);
        Navigator.pop(context);
      },
      child: Container(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              CampusMultiSelection(
                selectionItemTitles: ['RUB', 'Events'],
                onSelected: onFilterSelected,
                selections: [
                  //_selectedFilters.contains('RUB'),
                  true, // hardcoded, as the rub news-feed should not be deactivateable at this moment
                  _selectedFilters.contains('Events'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
