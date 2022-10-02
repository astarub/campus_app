import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

enum CampusButtonType { normal, light }

/// This widget adds a custom TextButton that uses the CampusApp design language
class CampusButton extends StatelessWidget {
  /// The displayed text inside the button
  final String text;

  final double? width;

  final double height;

  /// The callback that should be executed when the button is tapped
  final VoidCallback onTap;

  /// Refers to the type of CampusButton in order to display it with a light or dark background
  late final CampusButtonType type;

  CampusButton({
    Key? key,
    required this.text,
    this.width = 330,
    this.height = 58,
    required this.onTap,
  }) : super(key: key) {
    type = CampusButtonType.normal;
  }

  CampusButton.light({
    Key? key,
    required this.text,
    this.width = 330,
    this.height = 58,
    required this.onTap,
  }) : super(key: key) {
    type = CampusButtonType.light;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: type == CampusButtonType.normal ? Colors.black : const Color.fromRGBO(245, 246, 250, 1),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          splashColor: type == CampusButtonType.normal
              ? const Color.fromRGBO(255, 255, 255, 0.12)
              : const Color.fromRGBO(0, 0, 0, 0.06),
          highlightColor: type == CampusButtonType.normal
              ? const Color.fromRGBO(255, 255, 255, 0.08)
              : const Color.fromRGBO(0, 0, 0, 0.04),
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: Text(
              text,
              style: type == CampusButtonType.normal
                  ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium
                  : Provider.of<ThemesNotifier>(context)
                      .currentThemeData
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: const Color.fromARGB(255, 146, 146, 146)),
            ),
          ),
        ),
      ),
    );
  }
}
