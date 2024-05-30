import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

/// This widget adds a custom TextButton that uses the CampusApp design language
class CampusTextButton extends StatefulWidget {
  /// The displayed text
  final String buttonText;

  /// The width of the button
  final double? width;

  /// The height of the button
  final double height;

  /// The callback that should be executed when the button is tapped
  final VoidCallback onTap;

  const CampusTextButton({
    super.key,
    required this.buttonText,
    this.width = 330,
    this.height = 58,
    required this.onTap,
  });

  @override
  State<CampusTextButton> createState() => CampusTextButtonState();
}

class CampusTextButtonState extends State<CampusTextButton> {
  late Color buttonTextColor;

  @override
  void initState() {
    super.initState();

    buttonTextColor = Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
        ? Colors.black
        : Provider.of<ThemesNotifier>(context, listen: false).currentThemeData.textTheme.labelMedium!.color!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light) {
          setState(() => buttonTextColor = const Color.fromRGBO(62, 62, 62, 1));
        } else {
          setState(
            () => buttonTextColor = Provider.of<ThemesNotifier>(context, listen: false)
                .currentThemeData
                .textTheme
                .labelMedium!
                .color!
                .withOpacity(0.6),
          );
        }
      },
      onTapUp: (_) {
        if (Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light) {
          setState(() => buttonTextColor = Colors.black);
        } else {
          setState(
            () => buttonTextColor =
                Provider.of<ThemesNotifier>(context, listen: false).currentThemeData.textTheme.labelMedium!.color!,
          );
        }

        widget.onTap();
      },
      child: Text(
        widget.buttonText,
        style: Provider.of<ThemesNotifier>(context)
            .currentThemeData
            .textTheme
            .labelMedium
            ?.copyWith(color: buttonTextColor),
      ),
    );
  }
}
