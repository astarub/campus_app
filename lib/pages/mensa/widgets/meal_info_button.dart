import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MealInfoButton extends StatelessWidget {
  final String info;

  final VoidCallback onTap;

  late final String? iconPath;

  late final Color? iconColor;

  MealInfoButton({
    Key? key,
    required this.info,
    required this.onTap,
  }) : super(key: key) {
    switch (info) {
      case 'A':
        iconPath = 'assets/img/icons/mensa-alcohol.png';
        iconColor = Colors.black;
        break;
      case 'F':
        iconPath = 'assets/img/icons/mensa-fish.png';
        iconColor = const Color.fromARGB(255, 76, 138, 230);
        break;
      case 'G':
        iconPath = 'assets/img/icons/mensa-chicken.png';
        iconColor = const Color.fromARGB(255, 255, 173, 97);
        break;
      case 'H':
        iconPath = 'assets/img/icons/mensa-halal.png';
        iconColor = Colors.black;
        break;
      case 'L':
        iconPath = 'assets/img/icons/mensa-lamm.png';
        iconColor = const Color.fromARGB(255, 122, 80, 40);
        break;
      case 'R':
        iconPath = 'assets/img/icons/mensa-beef.png';
        iconColor = const Color.fromARGB(255, 167, 78, 51);
        break;
      case 'S':
        iconPath = 'assets/img/icons/mensa-pork.png';
        iconColor = const Color.fromARGB(255, 136, 36, 36);
        break;
      case 'V':
        iconPath = 'assets/img/icons/mensa-vegetarian.png';
        iconColor = const Color.fromARGB(255, 94, 187, 76);
        break;
      case 'VG':
        iconPath = 'assets/img/icons/mensa-vegan.png';
        iconColor = const Color.fromARGB(255, 94, 187, 76);
        break;
      case 'W':
        iconPath = 'assets/img/icons/mensa-wild.png';
        iconColor = const Color.fromARGB(255, 99, 56, 16);
        break;
      default:
        iconPath = null;
        iconColor = null;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      margin: const EdgeInsets.only(right: 5),
      child: (iconPath == null || iconColor == null)
          ? const SizedBox()
          : Material(
              color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
              borderRadius: BorderRadius.circular(3),
              child: InkWell(
                onTap: onTap,
                splashColor: const Color.fromRGBO(0, 0, 0, 0.04),
                highlightColor: const Color.fromRGBO(0, 0, 0, 0.02),
                borderRadius: BorderRadius.circular(3),
                child: Center(
                  child: iconPath!.substring(iconPath!.length - 3) == 'svg'
                      ? SvgPicture.asset(
                          iconPath!,
                          color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.dark &&
                                  (info == 'A' || info == 'H')
                              ? Colors.white70
                              : iconColor,
                        )
                      : Image.asset(
                          iconPath!,
                          width: 20,
                          color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.dark &&
                                  (info == 'A' || info == 'H')
                              ? Colors.white70
                              : iconColor,
                        ),
                ),
              ),
            ),
    );
  }
}
