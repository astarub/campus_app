import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class CampusSearchBar extends StatefulWidget {
  final void Function() onBack;
  final void Function(String) onChange;

  const CampusSearchBar({
    Key? key,
    required this.onBack,
    required this.onChange,
  }) : super(key: key);

  @override
  State<CampusSearchBar> createState() => _CampusSearchBarState();
}

class _CampusSearchBarState extends State<CampusSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 55,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Provider.of<ThemesNotifier>(context, listen: false)
                      .currentTheme ==
                  AppThemes.light
              ? const Color.fromRGBO(245, 246, 250, 1)
              : const Color.fromRGBO(34, 40, 54, 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: CampusIconButton(
                iconPath: 'assets/img/icons/arrow-left.svg',
                onTap: widget.onBack,
                transparent: true,
                backgroundColorDark:
                    Provider.of<ThemesNotifier>(context, listen: false)
                                .currentTheme ==
                            AppThemes.light
                        ? const Color.fromRGBO(245, 246, 250, 1)
                        : const Color.fromRGBO(34, 40, 54, 1),
                backgroundColorLight:
                    Provider.of<ThemesNotifier>(context, listen: false)
                                .currentTheme ==
                            AppThemes.light
                        ? const Color.fromRGBO(245, 246, 250, 1)
                        : const Color.fromRGBO(34, 40, 54, 1),
                borderColorDark:
                    Provider.of<ThemesNotifier>(context, listen: false)
                                .currentTheme ==
                            AppThemes.light
                        ? const Color.fromRGBO(245, 246, 250, 1)
                        : const Color.fromRGBO(34, 40, 54, 1),
                borderColorLight:
                    Provider.of<ThemesNotifier>(context, listen: false)
                                .currentTheme ==
                            AppThemes.light
                        ? const Color.fromRGBO(245, 246, 250, 1)
                        : const Color.fromRGBO(34, 40, 54, 1),
              ),
            ),
            Expanded(
              child: TextField(
                style: Provider.of<ThemesNotifier>(context)
                    .currentThemeData
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 17),
                onChanged: widget.onChange,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 12, right: 15, bottom: 21.6),
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
