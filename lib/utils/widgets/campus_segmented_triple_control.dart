import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

/// This widget allows the user to pick between three options.
/// It is a linear set of three segments, each of which functions as a button.
class CampusSegmentedTripleControl extends StatefulWidget {
  /// The displayed text on the left button of the SegmentedControl
  final String leftTitle;

  /// The displayed text on the center button of the SegmentedControl
  final String centerTitle;

  /// The displayed text on the right button of the SegmentedControl
  final String rightTitle;

  /// Is executed whenever the switch changes its value.
  /// Returns the new selected value, which can be 0 or 1.
  final void Function(int) onChanged;

  const CampusSegmentedTripleControl({
    super.key,
    required this.leftTitle,
    required this.centerTitle,
    required this.rightTitle,
    required this.onChanged,
  });

  @override
  State<CampusSegmentedTripleControl> createState() => CampusSegmentedTripleControlState();
}

class CampusSegmentedTripleControlState extends State<CampusSegmentedTripleControl> {
  late AlignmentGeometry _hoverAligment;
  static const double _pickerWidth = 300;

  int selected = 0;

  void _picked(int newSelected) {
    if (newSelected != selected) {
      // Execute the `onChanged()` callback
      widget.onChanged(newSelected);

      // Update the visuals
      setState(() {
        selected = newSelected;

        switch (newSelected) {
          case 0:
            _hoverAligment = Alignment.centerLeft;
            break;
          case 1:
            _hoverAligment = Alignment.center;
            break;
          case 2:
            _hoverAligment = Alignment.centerRight;
            break;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // This does not apply the inital value from the settings correctly
    setState(() {
      switch (selected) {
        case 0:
          _hoverAligment = Alignment.centerLeft;
          break;
        case 1:
          _hoverAligment = Alignment.center;
          break;
        case 2:
          _hoverAligment = Alignment.centerRight;
          break;
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
              color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(245, 246, 250, 1)
                  : Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
              borderRadius: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? BorderRadius.circular(6)
                  : BorderRadius.circular(10),
              border: Border.all(
                color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? const Color.fromRGBO(245, 246, 250, 1)
                    : const Color.fromRGBO(34, 40, 54, 1),
                width: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.dark ? 2 : 0,
              ),
            ),
          ),
          // Selection
          AnimatedAlign(
            alignment: _hoverAligment,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: Container(
              width: (_pickerWidth / 3) - 4,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? Colors.white
                    : const Color.fromRGBO(34, 40, 54, 1),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
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
                  style: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? Provider.of<ThemesNotifier>(context)
                          .currentThemeData
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.black)
                      : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium,
                ),
              ),
              Expanded(
                child: Text(
                  widget.centerTitle,
                  textAlign: TextAlign.center,
                  style: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? Provider.of<ThemesNotifier>(context)
                          .currentThemeData
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.black)
                      : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium,
                ),
              ),
              Expanded(
                child: Text(
                  widget.rightTitle,
                  textAlign: TextAlign.center,
                  style: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? Provider.of<ThemesNotifier>(context)
                          .currentThemeData
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.black)
                      : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium,
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
              Expanded(
                child: GestureDetector(
                  onTap: () => _picked(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
