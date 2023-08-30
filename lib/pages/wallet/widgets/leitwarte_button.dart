import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:campus_app/core/themes.dart';

/// This widget displays a button to quickly call the emergency number of the university
class LeitwarteButton extends StatelessWidget {
  const LeitwarteButton({Key? key}) : super(key: key);

  void call() {
    final Uri parsedLink = Uri.parse('tel:+492343223333');
    launchUrl(parsedLink, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          // Button
          Container(
            //width: 330,
            height: 58,
            decoration: BoxDecoration(
              color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(255, 0, 0, 0.19)
                  : const Color.fromRGBO(214, 40, 40, 0.19),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Material(
              color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(255, 0, 0, 0.19)
                  : const Color.fromRGBO(214, 40, 40, 0.19),
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: call,
                splashColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? const Color.fromRGBO(0, 0, 0, 0.06)
                    : const Color.fromRGBO(255, 255, 255, 0.06),
                highlightColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                    ? const Color.fromRGBO(255, 255, 255, 0.08)
                    : const Color.fromRGBO(255, 255, 255, 0.04),
                borderRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        'assets/img/icons/siren.svg',
                        colorFilter: ColorFilter.mode(
                          Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                              ? const Color.fromRGBO(207, 0, 0, 1)
                              : const Color.fromRGBO(255, 72, 72, 1),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Text(
                      'Leitwarte der RUB',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium?.copyWith(
                            color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                                ? const Color.fromRGBO(207, 0, 0, 1)
                                : const Color.fromRGBO(255, 72, 72, 1),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Subtitle
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              ' 24/7 besetzt, für jegliche Notfälle',
              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium?.copyWith(
                    fontSize: 12,
                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? const Color.fromRGBO(207, 0, 0, 0.6)
                        : const Color.fromRGBO(255, 72, 72, 0.5),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
