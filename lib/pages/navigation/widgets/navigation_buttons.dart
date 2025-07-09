import 'package:campus_app/core/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloorNavigationButtons extends StatelessWidget {
  final int currentIndex;
  final int floorCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Color backgroundColor;

  const FloorNavigationButtons({
    super.key,
    required this.currentIndex,
    required this.floorCount,
    required this.onPrevious,
    required this.onNext,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemesNotifier>(context).currentTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (currentIndex > 0)
          FloatingActionButton(
            heroTag: 'btn_back',
            backgroundColor: backgroundColor,
            onPressed: onPrevious,
            child: Icon(
              Icons.arrow_back,
              color: currentTheme == AppThemes.light
                  ? const Color.fromRGBO(34, 40, 54, 1)
                  : const Color.fromRGBO(184, 186, 191, 1),
            ),
          ),
        if (currentIndex < floorCount - 1) const SizedBox(width: 10),
        if (currentIndex < floorCount - 1)
          FloatingActionButton(
            heroTag: 'btn_forward',
            backgroundColor: backgroundColor,
            onPressed: onNext,
            child: Icon(
              Icons.arrow_forward,
              color: currentTheme == AppThemes.light
                  ? const Color.fromRGBO(34, 40, 54, 1)
                  : const Color.fromRGBO(184, 186, 191, 1),
            ),
          ),
      ],
    );
  }
}
