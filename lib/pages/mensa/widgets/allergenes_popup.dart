// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/l10n/l10n.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/popup_sheet.dart';

class AllergenesPopup extends StatefulWidget {
  /// Can be given to show saved preferences on build
  final List<String> allergenes;

  /// The function that is called when the popup is closed by the user.
  /// Returns a List of Strings that represent the selected preferences.
  final void Function(List<String>) onClose;

  const AllergenesPopup({
    Key? key,
    this.allergenes = const [],
    required this.onClose,
  }) : super(key: key);

  @override
  State<AllergenesPopup> createState() => _AllergenesPopupState();
}

class _AllergenesPopupState extends State<AllergenesPopup> {
  late List<String> _selectedAllergenes;

  void selectItem(String selected) {
    if (_selectedAllergenes.contains(selected)) {
      setState(() => _selectedAllergenes.removeWhere((allergene) => allergene == selected));
    } else {
      setState(() => _selectedAllergenes.add(selected));
    }
  }

  @override
  void initState() {
    super.initState();

    _selectedAllergenes = widget.allergenes;
  }

  @override
  Widget build(BuildContext context) {
    return PopupSheet(
      title: AppLocalizations.of(context)!.allergens,
      openPositionFactor: 0.6,
      onClose: () {
        widget.onClose(_selectedAllergenes);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                AppLocalizations.of(context)!.allergensAvoid,
                textAlign: TextAlign.left,
                style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensGluten,
                      shortcut: 'a',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('a')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensWheat,
                      shortcut: 'a1',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('a1')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensRye,
                      shortcut: 'a2',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('a2')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensBarley,
                      shortcut: 'a3',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('a3')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensOats,
                      shortcut: 'a4',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('a4')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensSpelt,
                      shortcut: 'a5',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('a5')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensKamut,
                      shortcut: 'a6',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('a6')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensCrustaceans,
                      shortcut: 'b',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('b')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensEggs,
                      shortcut: 'c',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('c')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensFish,
                      shortcut: 'd',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('d')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensPeanuts,
                      shortcut: 'e',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('e')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensSoybeans,
                      shortcut: 'f',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('f')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensMilk,
                      shortcut: 'g',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('g')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensNuts,
                      shortcut: 'h',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensAlmond,
                      shortcut: 'h1',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h1')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensHazelnut,
                      shortcut: 'h2',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h2')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensWalnut,
                      shortcut: 'h3',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h3')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensCashewnut,
                      shortcut: 'h4',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h4')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensPecan,
                      shortcut: 'h5',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h5')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensBrazilNut,
                      shortcut: 'h6',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h6')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensPistachio,
                      shortcut: 'h7',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h7')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensMacadamia,
                      shortcut: 'h8',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h8')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensCelery,
                      shortcut: 'i',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('i')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensMustard,
                      shortcut: 'j',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('j')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensSesame,
                      shortcut: 'k',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('k')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensSulfur,
                      shortcut: 'l',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('l')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensLupins,
                      shortcut: 'm',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('m')),
                  AllergenesListItem(
                      name: AppLocalizations.of(context)!.allergensMolluscs,
                      shortcut: 'n',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('n')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllergenesListItem extends StatelessWidget {
  final String name;
  final String shortcut;
  final void Function(String) onTap;
  final bool isActive;

  const AllergenesListItem({
    Key? key,
    required this.name,
    required this.shortcut,
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
          onTap: () => onTap(shortcut),
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
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    name,
                    style: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                              fontSize: 15,
                              color: Colors.black,
                            )
                        : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '($shortcut)',
                    textAlign: TextAlign.end,
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
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
