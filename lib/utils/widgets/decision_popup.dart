import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_text_button.dart';

/// This widget allows to push a popup to the navigator-stack that is fully
/// animated, but can't be dragged outside the screen by the user.
///
/// The [SnappingSheet] package handles the animations and layout.
class DecisionPopup extends StatefulWidget {
  /// The leading title that should be displayed at the top of the popup
  final String leadingTitle;

  /// The title that should be displayed above the content
  final String title;

  /// The content that describes the dicision the user have to make
  final String content;

  /// The text that is displayed on the button that accepts
  final String acceptButtonText;

  /// The text that is displayed on the button that rejects
  final String declineButtonText;

  /// The height that the popup should have.
  final double height;

  /// The function that should be executed when the popup is closed with accepting.
  ///
  /// Must call at least `Navigator.pop(context)` to remove the popup from the
  /// navigation stack. Additional return values can be appended to the `pop()` method
  /// (like `pop(context, textController.vaue)`) in order to return them to the ancestor site.
  final VoidCallback onAccept;

  /// The function that should be executed when the popup is closed with declining.
  ///
  /// Must call at least `Navigator.pop(context)` to remove the popup from the
  /// navigation stack. Additional return values can be appended to the `pop()` method
  /// (like `pop(context, textController.vaue)`) in order to return them to the ancestor site.
  final VoidCallback onDecline;

  const DecisionPopup({
    Key? key,
    required this.leadingTitle,
    required this.title,
    required this.content,
    this.acceptButtonText = 'Annehmen',
    this.declineButtonText = 'Ablehnen',
    this.height = 420,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  State<DecisionPopup> createState() => _DecisionPopupState();
}

class _DecisionPopupState extends State<DecisionPopup> {
  /// Controls the SnappingSheet
  late final SnappingSheetController _popupController;

  /// Changed during widget lifetime in order to make the popup non-draggable
  List<SnappingPosition> snapPositions = [
    const SnappingPosition.pixels(
      positionPixels: 450,
    ),
    const SnappingPosition.pixels(
      positionPixels: -60,
      snappingCurve: Curves.easeOutExpo,
      snappingDuration: Duration(milliseconds: 350),
    ),
  ];

  /// Animated half-transparent background color
  Color _backgroundColor = Color.fromRGBO(0, 0, 0, 0.0);

  /// Starts the closing animation for the popup.
  void closePopup() {
    setState(
      () => snapPositions = [
        const SnappingPosition.pixels(
          positionPixels: 420,
        ),
        const SnappingPosition.pixels(
          positionPixels: -60,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 350),
        ),
      ],
    );

    _popupController.snapToPosition(
      const SnappingPosition.pixels(
        positionPixels: -60,
        snappingCurve: Curves.easeOutExpo,
        snappingDuration: Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _popupController = SnappingSheetController();

    // Let the SnappingSheet move into the screen after the controller is attached (after build was colled once)
    Timer(
      const Duration(milliseconds: 50),
      () => _popupController.snapToPosition(
        SnappingPosition.pixels(
          positionPixels: widget.height,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: const Duration(milliseconds: 350),
        ),
      ),
    );

    // Remove the second [SnappingPosition] after opening the popup
    Timer(
      const Duration(milliseconds: 500),
      () => setState(
        () => snapPositions = [
          SnappingPosition.pixels(
            positionPixels: widget.height,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: _popupController,
      lockOverflowDrag: true,
      onSheetMoved: (positionData) {
        if (positionData.relativeToSnappingPositions >= 0) {
          setState(
            () => _backgroundColor = _backgroundColor.withOpacity(0.3 * positionData.relativeToSnappingPositions),
          );
        }
      },
      initialSnappingPosition: const SnappingPosition.pixels(positionPixels: -100),
      snappingPositions: snapPositions,
      sheetBelow: SnappingSheetContent(
        child: Align(
          child: Container(
            width: MediaQuery.of(context).size.shortestSide < 600 ? double.infinity : 700,
            decoration: BoxDecoration(
              color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -1))],
            ),
            //padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                // Leading Title
                Text(
                  widget.leadingTitle,
                  style: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? Provider.of<ThemesNotifier>(context)
                          .currentThemeData
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.black)
                      : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium,
                ),
                // Title
                Text(
                  widget.title,
                  style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: SingleChildScrollView(
                    child: Text(
                      widget.content,
                      textAlign: TextAlign.center,
                      style: Provider.of<ThemesNotifier>(context)
                          .currentThemeData
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 15),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                // No button
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 16),
                  child: CampusTextButton(
                    buttonText: widget.declineButtonText,
                    onTap: () {
                      widget.onDecline();
                      closePopup();
                    },
                  ),
                ),
                // Yes button
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CampusButton(
                    text: widget.acceptButtonText,
                    onTap: () {
                      widget.onAccept();
                      closePopup();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Transparent background
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        color: _backgroundColor,
      ),
    );
  }
}
