import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

/// This widget adds a custom Button that uses the CampusApp design language
class LeadingButton extends StatelessWidget {
  /// The displayed text inside the button
  final String text;

  final String buttonText;

  final double? width;

  final double height;

  /// The callback that should be executed when the button is tapped
  final VoidCallback onTap;

  const LeadingButton({
    super.key,
    required this.text,
    required this.buttonText,
    this.width = 330,
    this.height = 58,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
          ),
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Material(
              color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(245, 246, 250, 1)
                  : const Color.fromRGBO(34, 40, 54, 1),
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: onTap,
                splashColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? const Color.fromRGBO(255, 255, 255, 0.12)
                    : const Color.fromRGBO(255, 255, 255, 0.06),
                highlightColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? const Color.fromRGBO(255, 255, 255, 0.08)
                    : const Color.fromRGBO(255, 255, 255, 0.04),
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Text(
                    buttonText,
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
