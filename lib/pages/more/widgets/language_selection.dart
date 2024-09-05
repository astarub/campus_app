import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';

// ignore: must_be_immutable
class LanguageSelection extends StatefulWidget {
  final List<Locale> availableLocales;

  final Function(Locale) saveSelection;

  /// Can be given to show previously selected studies
  Locale selectedLocale;

  LanguageSelection({
    Key? key,
    required this.availableLocales,
    required this.saveSelection,
    this.selectedLocale = const Locale('de'),
  }) : super(key: key);

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  void selectItem(Locale selected) {
    setState(() {
      widget.selectedLocale = selected;
    });
    widget.saveSelection(selected);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.availableLocales.length,
      itemBuilder: (context, index) => LanguageSelectionItem(
        locale: widget.availableLocales[index],
        onTap: selectItem,
        isActive: widget.selectedLocale == widget.availableLocales[index],
      ),
    );
  }
}

/// This widget displays one selectable option in a list
class LanguageSelectionItem extends StatelessWidget {
  final Locale locale;

  /// The function that should be called when tapped
  final void Function(Locale) onTap;

  /// Wether the widget is selected or not
  final bool isActive;

  const LanguageSelectionItem({
    Key? key,
    required this.locale,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isActive
            ? Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                ? const Color.fromRGBO(245, 246, 250, 1)
                : const Color.fromRGBO(34, 40, 54, 1)
            : Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          splashColor: const Color.fromRGBO(0, 0, 0, 0.06),
          highlightColor: const Color.fromRGBO(0, 0, 0, 0.04),
          borderRadius: BorderRadius.circular(6),
          onTap: () => onTap(locale),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Checkbox
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? isActive
                            ? Colors.black
                            : Colors.white
                        : const Color.fromRGBO(18, 24, 38, 1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? isActive
                              ? Colors.black
                              : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color!
                          : const Color.fromRGBO(34, 40, 54, 1),
                    ),
                  ),
                  child: isActive
                      ? SvgPicture.asset(
                          'assets/img/icons/x.svg',
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )
                      : Container(),
                ),
                // Name
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      LocaleNames.of(context)!.nameOf(locale.languageCode)!,
                      style: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                                fontSize: 15,
                                color: Colors.black,
                              )
                          : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false,
                    ),
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
