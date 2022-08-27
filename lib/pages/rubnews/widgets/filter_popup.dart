import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:campus_app/core/themes.dart';

/// This widget displays the filter options that are available for the
/// personal news feed and is used in the [SnappingSheet] widget
class FeedFilterPopup extends StatefulWidget {
  const FeedFilterPopup({Key? key}) : super(key: key);

  @override
  State<FeedFilterPopup> createState() => _FeedFilterPopupState();
}

class _FeedFilterPopupState extends State<FeedFilterPopup> {
  /// Controls the SnappingSheet
  late final SnappingSheetController _popupController;

  /// Animated half-transparent background color
  Color _backgroundColor = Color.fromRGBO(0, 0, 0, 0.3);

  @override
  void initState() {
    super.initState();

    _popupController = SnappingSheetController();

    // Let the SnappingSheet move into the screen after the controller is attached (after build was colled once)
    Timer(
      const Duration(milliseconds: 50),
      () => _popupController.snapToPosition(const SnappingPosition.factor(
        positionFactor: 0.5,
        snappingCurve: Curves.easeOutExpo,
        snappingDuration: Duration(milliseconds: 350),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: _popupController,
      sheetBelow: SnappingSheetContent(
        child: Container(
          color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
        ),
      ),
      grabbingHeight: 80,
      grabbing: Container(
        decoration: BoxDecoration(
          color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -1))],
        ),
        child: Column(
          children: [
            // Grabber
            Container(
              height: 5,
              width: 40,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.grey,
              ),
            ),
            // Headline
            Text(
              'Feed Filter',
              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
            ),
          ],
        ),
      ),
      initialSnappingPosition: const SnappingPosition.pixels(positionPixels: -60),
      snappingPositions: const [
        SnappingPosition.factor(
          positionFactor: 0.5,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 350),
        ),
        SnappingPosition.pixels(
          positionPixels: -60,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 350),
        ),
      ],
      lockOverflowDrag: true,
      onSheetMoved: (positionData) {
        setState(() => _backgroundColor = _backgroundColor.withOpacity(0.3 * positionData.relativeToSnappingPositions));
      },
      onSnapCompleted: (positionData, snappingPosition) {
        // Remove the popup from the navigation-stack when it's snapped outside the view
        if (positionData.pixels == -60) Navigator.pop(context);
      },
      child: GestureDetector(
        onTap: () => _popupController.snapToPosition(
          const SnappingPosition.pixels(
            positionPixels: -60,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: Duration(milliseconds: 350),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          color: _backgroundColor,
        ),
      ),
    );
  }
}
