import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';

/// This widget displays a button with a title, leading and trailing icon
/// in order to open external websites or services
class ExternalLinkButton extends StatelessWidget {
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

  const ExternalLinkButton({
    Key? key,
    required this.title,
    required this.leadingIconPath,
    this.trailingIconPath = 'assets/img/icons/external-link.svg',
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 330,
      height: 58,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 246, 250, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: const Color.fromRGBO(245, 246, 250, 1),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          splashColor: const Color.fromRGBO(0, 0, 0, 0.04),
          highlightColor: const Color.fromRGBO(0, 0, 0, 0.02),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                // Icon
                if (leadingIconPath.substring(leadingIconPath.length - 3) == 'svg')
                  SvgPicture.asset(
                    leadingIconPath,
                    color: Colors.black,
                    width: 22,
                  )
                else
                  Image.asset(
                    leadingIconPath,
                    color: Colors.black,
                    width: 20,
                    filterQuality: FilterQuality.high,
                  ),
                // Title
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    title,
                    style: Provider.of<ThemesNotifier>(context)
                        .currentThemeData
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.black),
                  ),
                ),
                // Link icon
                Expanded(
                  child: SvgPicture.asset(
                    trailingIconPath,
                    color: Colors.black,
                    height: 20,
                    alignment: Alignment.centerRight,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// This widget displays a button with only one centered icon.
/// It is usually used in a [Row] with multiple instances.
class SocialMediaButton extends StatelessWidget {
  /// The icon that should be displayed.
  ///
  /// ATTENTION: Must be a .svg-file.
  final String iconPath;

  /// The funciton that is called on button tap
  final VoidCallback onTap;

  const SocialMediaButton({
    Key? key,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 246, 250, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: const Color.fromRGBO(245, 246, 250, 1),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          splashColor: const Color.fromRGBO(0, 0, 0, 0.04),
          highlightColor: const Color.fromRGBO(0, 0, 0, 0.02),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: SvgPicture.asset(
                iconPath,
                height: 22,
                width: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
