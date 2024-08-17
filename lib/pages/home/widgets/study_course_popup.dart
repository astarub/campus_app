import 'dart:async';
import 'package:campus_app/utils/widgets/campus_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';

import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/backend/entities/study_course_entity.dart';
import 'package:campus_app/pages/home/widgets/study_selection.dart';
import 'package:campus_app/utils/pages/main_utils.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';

/// This widget allows to push a popup to the navigator-stack that is fully
/// animated, but can't be dragged outside the screen by the user.
///
/// The [SnappingSheet] package handles the animations and layout.
class StudyCoursePopup extends StatefulWidget {
  final Function(List<StudyCourse>)? callback;
  const StudyCoursePopup({super.key, this.callback});

  @override
  State<StudyCoursePopup> createState() => StudyCoursePopupState();
}

class StudyCoursePopupState extends State<StudyCoursePopup> {
  /// Controls the SnappingSheet
  late final SnappingSheetController popupController;

  /// Changed during widget lifetime in order to make the popup non-draggable
  List<SnappingPosition> snapPositions = [
    const SnappingPosition.pixels(
      positionPixels: 630,
    ),
    const SnappingPosition.pixels(
      positionPixels: -60,
      snappingCurve: Curves.easeOutExpo,
      snappingDuration: Duration(milliseconds: 350),
    ),
  ];

  /// Animated half-transparent background color
  Color backgroundColor = const Color.fromRGBO(0, 0, 0, 0);

  final MainUtils mainUtils = sl<MainUtils>();

  List<StudyCourse> availableCourses = [];
  // Selected study courses
  List<StudyCourse> selectedStudies = [];

  /// Starts the closing animation for the popup.
  void closePopup() {
    setState(
      () => snapPositions = [
        const SnappingPosition.pixels(
          positionPixels: 630,
        ),
        const SnappingPosition.pixels(
          positionPixels: -60,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 350),
        ),
      ],
    );

    popupController.snapToPosition(
      const SnappingPosition.pixels(
        positionPixels: -60,
        snappingCurve: Curves.easeOutExpo,
        snappingDuration: Duration(milliseconds: 350),
      ),
    );

    if (widget.callback != null) {
      // ignore: prefer_null_aware_method_calls
      widget.callback!(selectedStudies);
    }
    Navigator.pop(context);
  }

  /// Filters the feed based on the search input of the user
  void onSearch(String search) {
    List<StudyCourse> filteredCourses = [];

    if (search == '') {
      filteredCourses = Provider.of<SettingsHandler>(context, listen: false).currentSettings.studyCourses;
    } else {
      filteredCourses = Provider.of<SettingsHandler>(context, listen: false)
          .currentSettings
          .studyCourses
          .where((course) => course.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    setState(() {
      availableCourses = filteredCourses;
    });
  }

  void saveSelections() {
    final Settings newSettings = Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(
          studyCoursePopup: true,
          selectedStudyCourses: selectedStudies,
        );

    debugPrint('Saved study courses. Selected study-courses: ${newSettings.selectedStudyCourses.map((c) => c.name)}');

    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;

    mainUtils.setIntialStudyCoursePublishers(Provider.of<SettingsHandler>(context, listen: false), selectedStudies);
  }

  @override
  void initState() {
    super.initState();

    popupController = SnappingSheetController();

    availableCourses = Provider.of<SettingsHandler>(context, listen: false).currentSettings.studyCourses;
    selectedStudies = [];
    selectedStudies.addAll(Provider.of<SettingsHandler>(context, listen: false).currentSettings.selectedStudyCourses);

    // Let the SnappingSheet move into the screen after the controller is attached (after build was colled once)
    Timer(
      const Duration(milliseconds: 50),
      () => popupController.snapToPosition(
        const SnappingPosition.pixels(
          positionPixels: 630,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 350),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: popupController,
      lockOverflowDrag: true,
      onSheetMoved: (positionData) {
        if (positionData.relativeToSnappingPositions >= 0) {
          setState(
            () => backgroundColor = backgroundColor.withOpacity(0.3 * positionData.relativeToSnappingPositions),
          );
        }
      },
      initialSnappingPosition: const SnappingPosition.pixels(positionPixels: -60),
      snappingPositions: snapPositions,
      onSnapCompleted: (positionData, snappingPosition) {
        // Remove the popup from the navigation-stack when it's snapped outside the view
        if (positionData.pixels == -60) {
          saveSelections();
          closePopup();
        }
      },
      sheetBelow: SnappingSheetContent(
        child: Align(
          child: Container(
            width: MediaQuery.of(context).size.shortestSide < 600 ? double.infinity : 700,
            decoration: BoxDecoration(
              color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
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
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? const Color.fromRGBO(245, 246, 250, 1)
                        : const Color.fromRGBO(34, 40, 54, 1),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 18),
                        child: Text(
                          'Wähle deinen Studiengang',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displaySmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Material(
                          child: CampusSearchBar(
                            arrowHidden: true,
                            horizontalPadding: 0,
                            onBack: () {},
                            onChange: onSearch,
                          ),
                        ),
                      ),
                      if (Provider.of<SettingsHandler>(context, listen: false)
                          .currentSettings
                          .studyCourses
                          .isNotEmpty) ...[
                        SizedBox(
                          height: 370,
                          child: StudySelection(
                            availableStudies: availableCourses,
                            selectedStudies: selectedStudies,
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            height: 35,
                            child: CircularProgressIndicator(
                              backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                              color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Close button
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CampusButton(
                    text: 'Schließen',
                    onTap: () {
                      saveSelections();
                      closePopup();
                    },
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
      // Transparent background
      child: GestureDetector(
        onTap: () => popupController.snapToPosition(
          const SnappingPosition.pixels(
            positionPixels: -60,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: Duration(milliseconds: 350),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          color: backgroundColor,
        ),
      ),
    );
  }
}
