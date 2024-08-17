import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

/// This widget displays a search bar that can be hidden via a button
/// and is used to search the news feed and events.
class CampusSearchBar extends StatelessWidget {
  final bool arrowHidden;
  final double horizontalPadding;
  final void Function() onBack;
  final void Function(String) onChange;

  const CampusSearchBar({
    super.key,
    this.arrowHidden = false,
    this.horizontalPadding = 20,
    required this.onBack,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        height: 55,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? const Color.fromRGBO(245, 246, 250, 1)
              : const Color.fromRGBO(34, 40, 54, 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!arrowHidden) ...[
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: CampusIconButton(
                  iconPath: 'assets/img/icons/arrow-left.svg',
                  onTap: onBack,
                  transparent: true,
                  backgroundColorDark:
                      Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? const Color.fromRGBO(245, 246, 250, 1)
                          : const Color.fromRGBO(34, 40, 54, 1),
                  backgroundColorLight:
                      Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? const Color.fromRGBO(245, 246, 250, 1)
                          : const Color.fromRGBO(34, 40, 54, 1),
                  borderColorDark: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? const Color.fromRGBO(245, 246, 250, 1)
                      : const Color.fromRGBO(34, 40, 54, 1),
                  borderColorLight: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? const Color.fromRGBO(245, 246, 250, 1)
                      : const Color.fromRGBO(34, 40, 54, 1),
                ),
              ),
            ],
            Expanded(
              child: TextField(
                style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineMedium?.copyWith(
                      fontSize: 17,
                      color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? Colors.black
                          : null,
                    ),
                onChanged: onChange,
                decoration: InputDecoration(
                  labelText: 'Suche',
                  labelStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: !arrowHidden ? 12 : 20, right: 15, bottom: 21.6),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
