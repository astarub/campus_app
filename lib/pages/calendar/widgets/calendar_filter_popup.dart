import 'package:campus_app/pages/calendar/widgets/calendar_filter_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/popup_sheet.dart';

/// This widget displays the filter options that are available for the
/// personal news feed and is used in the [SnappingSheet] widget
class CalendarFilterPopup extends StatefulWidget {
  /// Can be given to show saved filters on build
  final List<String> selectedFilters;

  /// The function that is called when the popup is closed by the user.
  /// Returns a List of Strings that represent the selected filters.
  final void Function(List<String>) onClose;

  const CalendarFilterPopup({
    Key? key,
    this.selectedFilters = const [],
    required this.onClose,
  }) : super(key: key);

  @override
  State<CalendarFilterPopup> createState() => _CalendarFilterPopupState();
}

class _CalendarFilterPopupState extends State<CalendarFilterPopup> {
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
    final List<String> options = ['FSR Wirtschaftsingenieurswesen', 'Andere'];
    final List<bool> selections = [];

    for (int i = 0; i < options.length; i++) {
      selections.add(_selectedFilters.contains(options[i]));
    }

    return PopupSheet(
      title: 'Event Filter',
      onClose: () {
        widget.onClose(_selectedFilters);
        Navigator.pop(context);
      },
      child: Container(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Expanded(
                child: CalendarFilterSelection(
                  filters: ['AStA'] + options,
                  onSelected: onFilterSelected,
                  selections: [true] + selections,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
