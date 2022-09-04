import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

/// This widget allows the user to pick between two options.
/// It is a linear set of two segments, each of which functions as a button.
class CampusSegmentedControl extends StatefulWidget {
  /// The displayed text on the left button of the SegmentedControl
  final String leftTitle;

  /// The displayed text on the right button of the SegmentedControl
  final String rightTitle;

  /// Defined in order to be accessable from the outside and control
  /// the initial state
  int selected;

  CampusSegmentedControl({
    Key? key,
    required this.leftTitle,
    required this.rightTitle,
    this.selected = 0,
  }) : super(key: key);

  @override
  State<CampusSegmentedControl> createState() => _CampusSegmentedControlState();
}

class _CampusSegmentedControlState extends State<CampusSegmentedControl> {
  AlignmentGeometry _hoverAligment = Alignment.centerLeft;
  static const double _pickerWidth = 200;

  void _picked(int newSelected) {
    setState(() {
      widget.selected = newSelected;
      if (newSelected == 0) {
        _hoverAligment = Alignment.centerLeft;
      } else {
        _hoverAligment = Alignment.centerRight;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      width: _pickerWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(245, 246, 250, 1),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          // Selection
          AnimatedAlign(
            alignment: _hoverAligment,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: Container(
              width: (_pickerWidth / 2) - 4,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 0))],
              ),
            ),
          ),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.leftTitle,
                  textAlign: TextAlign.center,
                  style: Provider.of<ThemesNotifier>(context)
                      .currentThemeData
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.black),
                ),
              ),
              Expanded(
                child: Text(
                  widget.rightTitle,
                  textAlign: TextAlign.center,
                  style: Provider.of<ThemesNotifier>(context)
                      .currentThemeData
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
          // GestureDetector
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _picked(0),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _picked(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
