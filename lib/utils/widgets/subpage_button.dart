import 'package:campus_app/core/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// This widget displays a button with a title, leading and trailing icon
/// in order to open external websites or services
class SubPageButton extends StatelessWidget {
  /// The title that is displayed after the leading icon
  final String title;

  /// The icon that is displayed before the title
  final String leadingIconPath;

  /// The icon that is displayed on the right side of the button
  ///
  /// ATTENTION: Must be an .svg-file
  final String trailingIconPath;

  /// The funciton that is called on button tap
  final VoidCallback onTap;

  /// Wether or not the button should be disabled.
  /// Can be used (for example) to display a future feature.
  final bool disabled;

  const SubPageButton({
    super.key,
    required this.title,
    required this.leadingIconPath,
    this.trailingIconPath = 'assets/img/icons/external-link.svg',
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    /* final Color backgroundColor = Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
        ? const Color.fromRGBO(245, 246, 250, 1)
        : const Color.fromRGBO(34, 40, 54, 1); */
    final Color buttonContentColor = Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
        ? Colors.black
        : Colors.white;

    return Container(
      //width: 330,
      height: 58,
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: disabled ? null : onTap,
          splashColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? const Color.fromRGBO(0, 0, 0, 0.04)
              : const Color.fromRGBO(255, 255, 255, 0.06),
          highlightColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? const Color.fromRGBO(0, 0, 0, 0.02)
              : const Color.fromRGBO(255, 255, 255, 0.04),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                // Icon
                if (leadingIconPath.substring(leadingIconPath.length - 3) == 'svg')
                  SvgPicture.asset(
                    leadingIconPath,
                    colorFilter: ColorFilter.mode(
                      disabled ? buttonContentColor.withOpacity(0.5) : buttonContentColor,
                      BlendMode.srcIn,
                    ),
                    width: 22,
                  )
                else
                  Image.asset(
                    leadingIconPath,
                    color: disabled ? buttonContentColor.withOpacity(0.5) : buttonContentColor,
                    width: 20,
                    filterQuality: FilterQuality.high,
                  ),
                // Title
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    title,
                    style: Provider.of<ThemesNotifier>(context)
                        .currentThemeData
                        .textTheme
                        .labelMedium!
                        .copyWith(color: disabled ? buttonContentColor.withOpacity(0.5) : buttonContentColor),
                  ),
                ),
                // Link icon
                Expanded(
                  child: SvgPicture.asset(
                    trailingIconPath,
                    colorFilter: ColorFilter.mode(
                      Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? disabled
                              ? Colors.black.withOpacity(0.5)
                              : Colors.black
                          : disabled
                              ? Provider.of<ThemesNotifier>(context)
                                  .currentThemeData
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withOpacity(0.5)
                              : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color!,
                      BlendMode.srcIn,
                    ),
                    height: 20,
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
