import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/popup_sheet.dart';
import 'package:campus_app/utils/widgets/campus_selection.dart';

/// This widget displays the filter options that are available for the
/// personal news feed and is used in the [SnappingSheet] widget
class FeedFilterPopup extends StatefulWidget {
  const FeedFilterPopup({Key? key}) : super(key: key);

  @override
  State<FeedFilterPopup> createState() => _FeedFilterPopupState();
}

class _FeedFilterPopupState extends State<FeedFilterPopup> {
  @override
  Widget build(BuildContext context) {
    return PopupSheet(
      title: 'Feed Filter',
      onClose: () => Navigator.pop(context),
      child: Container(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CampusSelection(selectionItemTitles: ['AStA', 'AKAFÖ', 'FSR']),
        ),
      ),
    );
  }
}
