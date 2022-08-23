import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

enum FeedFilter { personal, explore }

/// This widget allows the user to pick between the personal
/// filtered feed and the "explore"-feed, which shows all postings
class FeedPicker extends StatefulWidget {
  /// Defined in order to be accessable from the outside and filter
  /// the feed when the user interacts with the FeedPicker
  FeedFilter currentFilter;

  FeedPicker({
    Key? key,
    this.currentFilter = FeedFilter.personal,
  }) : super(key: key);

  @override
  State<FeedPicker> createState() => _FeedPickerState();
}

class _FeedPickerState extends State<FeedPicker> {
  AlignmentGeometry _hoverAligment = Alignment.centerLeft;
  static const double _pickerWidth = 200;

  void _picked(FeedFilter pickedFilter) {
    setState(() {
      widget.currentFilter = pickedFilter;
      if (pickedFilter == FeedFilter.personal) {
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
                  'Feed',
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
                  'Explore',
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
                  onTap: () => _picked(FeedFilter.personal),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _picked(FeedFilter.explore),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
