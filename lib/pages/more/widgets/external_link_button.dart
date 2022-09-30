import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';

class ExternalLinkButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final String trailingIconPath;
  final VoidCallback onTap;

  const ExternalLinkButton({
    Key? key,
    required this.title,
    required this.iconPath,
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
                if (iconPath.substring(iconPath.length - 3) == 'svg')
                  SvgPicture.asset(
                    iconPath,
                    color: Colors.black,
                    width: 22,
                  )
                else
                  Image.asset(
                    iconPath,
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

class ButtonGroup extends StatelessWidget {
  final String headline;
  final List<ExternalLinkButton> buttons;

  const ButtonGroup({
    Key? key,
    required this.headline,
    required this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Links headline
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            headline,
            textAlign: TextAlign.left,
            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 246, 250, 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: buttons,
          ),
        ),
      ],
    );
  }
}
