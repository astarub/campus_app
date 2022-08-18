import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

enum CampusButtonType { normal, light }

class CampusButton extends StatelessWidget {
  /// The displayed text inside the button
  final String text;

  /// The callback that should be executed when the button is tapped
  final VoidCallback onTap;

  /// Refers to the type of CampusButton in order to display it with a light or dark background
  late final CampusButtonType type;

  CampusButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key) {
    type = CampusButtonType.normal;
  }

  CampusButton.light({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key) {
    type = CampusButtonType.light;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: type == CampusButtonType.normal ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          splashColor: const Color.fromRGBO(255, 255, 255, 0.12),
          highlightColor: const Color.fromRGBO(255, 255, 255, 0.08),
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: Text(
              text,
              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.button,
            ),
          ),
        ),
      ),
    );
  }
}
