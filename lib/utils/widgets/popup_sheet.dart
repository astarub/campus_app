import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:campus_app/core/themes.dart';

/// This widget allows to push a popup to the navigator-stack that is fully
/// animated and can be dragged outside the screen by the user.
///
/// The [SnappingSheet] package handles the animations.
class PopupSheet extends StatefulWidget {
  /// The title that should be displayed at the top of the popup
  final String title;

  /// The position factor that is used for the open state of the PopupSheet
  final double openPositionFactor;

  /// The function that should be executed when the popup is closed by the user.
  ///
  /// Must call at least `Navigator.pop(context)` to remove the popup from the
  /// navigation stack. Additional return values can be appended to the `pop()` method
  /// (like `pop(context, textController.vaue)`) in order to return them to the ancestor site.
  final VoidCallback onClose;

  /// The content inside the popup that is displayed below the title
  final Widget child;

  const PopupSheet({
    Key? key,
    this.title = 'Popup',
    this.openPositionFactor = 0.5,
    required this.onClose,
    required this.child,
  }) : super(key: key);

  @override
  State<PopupSheet> createState() => _PopupSheetState();
}

class _PopupSheetState extends State<PopupSheet> {
  /// Controls the SnappingSheet
  late final SnappingSheetController _popupController;

  /// Animated half-transparent background color
  Color _backgroundColor = Color.fromRGBO(0, 0, 0, 0.0);

  @override
  void initState() {
    super.initState();

    _popupController = SnappingSheetController();

    // Let the SnappingSheet move into the screen after the controller is attached (after build was colled once)
    Timer(
      const Duration(milliseconds: 50),
      () => _popupController.snapToPosition(SnappingPosition.factor(
        positionFactor: widget.openPositionFactor,
        snappingCurve: Curves.easeOutExpo,
        snappingDuration: const Duration(milliseconds: 350),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: _popupController,
      sheetBelow: SnappingSheetContent(child: widget.child),
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
                color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? const Color.fromRGBO(245, 246, 250, 1)
                    : const Color.fromRGBO(34, 40, 54, 1),
              ),
            ),
            // Headline
            Text(
              widget.title,
              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
            ),
          ],
        ),
      ),
      initialSnappingPosition: const SnappingPosition.pixels(positionPixels: -60),
      snappingPositions: [
        SnappingPosition.factor(
          positionFactor: widget.openPositionFactor,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: const Duration(milliseconds: 350),
        ),
        const SnappingPosition.pixels(
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
        if (positionData.pixels == -60) widget.onClose();
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
