import 'package:campus_app/core/backend/entities/publisher_entity.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_filter_selection.dart';
import 'package:campus_app/utils/widgets/popup_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';

/// This widget displays the filter options that are available for the
/// personal news feed and is used in the [SnappingSheet] widget
class FeedFilterPopup extends StatefulWidget {
  /// Can be given to show saved filters on build
  final List<Publisher> selectedFilters;

  /// The function that is called when the popup is closed by the user.
  /// Returns a List of Strings that represent the selected filters.
  final void Function(List<Publisher>) onClose;

  const FeedFilterPopup({
    Key? key,
    this.selectedFilters = const [],
    required this.onClose,
  }) : super(key: key);

  @override
  State<FeedFilterPopup> createState() => _FeedFilterPopupState();
}

class _FeedFilterPopupState extends State<FeedFilterPopup> {
  late List<Publisher> _selectedFilters;

  @override
  Widget build(BuildContext context) {
    final List<Publisher> publishers =
        Provider.of<SettingsHandler>(context).currentSettings.publishers.where((p) => !p.hidden).toList();

    final List<bool> selections = [];

    final List<String> filterNames = _selectedFilters.map((e) => e.name).toList();

    selections.add(filterNames.contains('RUB'));
    selections.add(filterNames.contains('AStA'));

    for (int i = 0; i < publishers.length; i++) {
      selections.add(filterNames.contains(publishers[i].name));
    }

    return PopupSheet(
      title: 'Feed Filter',
      onClose: () {
        widget.onClose(_selectedFilters);
        Navigator.pop(context);
      },
      openPositionFactor: 0.6,
      child: Container(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Expanded(
                child: CampusFilterSelection(
                  filters: [Publisher(id: 0, name: 'RUB'), Publisher(id: 0, name: 'AStA')] + publishers,
                  onSelected: onFilterSelected,
                  selections: selections,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _selectedFilters = widget.selectedFilters;
  }

  void onFilterSelected(Publisher selectedFilter) {
    if (_selectedFilters.map((e) => e.name).toList().contains(selectedFilter.name)) {
      setState(() => _selectedFilters.removeWhere((filter) => filter.name == selectedFilter.name));
    } else {
      setState(() => _selectedFilters.add(selectedFilter));
    }
  }
}
