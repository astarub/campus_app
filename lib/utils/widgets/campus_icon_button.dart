import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CampusIconButton extends StatelessWidget {
  final String iconPath;

  final VoidCallback onTap;

  final Color? backgroundColorLight;

  final Color? backgroundColorDark;

  final Color? borderColorLight;

  final Color? borderColorDark;

  final bool transparent;

  const CampusIconButton({
    Key? key,
    required this.iconPath,
    required this.onTap,
    this.backgroundColorLight,
    this.backgroundColorDark,
    this.borderColorLight,
    this.borderColorDark,
    this.transparent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
        borderRadius: BorderRadius.circular(15),
        border: !transparent
            ? Border.all(
                color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? borderColorLight != null
                        ? borderColorLight!
                        : const Color.fromRGBO(245, 246, 250, 1)
                    : borderColorDark != null
                        ? borderColorDark!
                        : const Color.fromRGBO(34, 40, 54, 1),
                width: 2,
              )
            : null,
      ),
      child: Material(
        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
            ? backgroundColorLight != null
                ? backgroundColorLight!
                : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor
            : backgroundColorDark != null
                ? backgroundColorDark!
                : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          splashColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? const Color.fromRGBO(0, 0, 0, 0.04)
              : const Color.fromRGBO(255, 255, 255, 0.04),
          highlightColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? const Color.fromRGBO(0, 0, 0, 0.02)
              : const Color.fromRGBO(255, 255, 255, 0.02),
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: iconPath.substring(iconPath.length - 3) == 'svg'
                ? SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(
                      Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? Colors.black
                          : const Color.fromRGBO(184, 186, 191, 1),
                      BlendMode.srcIn,
                    ),
                    width: 24,
                  )
                : Image.asset(
                    iconPath,
                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? Colors.black
                        : const Color.fromRGBO(184, 186, 191, 1),
                    width: 20,
                  ),
          ),
        ),
      ),
    );
  }
}
