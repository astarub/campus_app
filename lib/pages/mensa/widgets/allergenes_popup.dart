import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      title: 'Allergene',
      openPositionFactor: 0.6,
      onClose: () {
        widget.onClose(_selectedAllergenes);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Vermeiden von',
                textAlign: TextAlign.left,
                style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  AllergenesListItem(
                      name: 'Gluten', shortcut: 'a', onTap: selectItem, isActive: _selectedAllergenes.contains('a')),
                  AllergenesListItem(
                      name: 'Weizen', shortcut: 'a1', onTap: selectItem, isActive: _selectedAllergenes.contains('a1')),
                  AllergenesListItem(
                      name: 'Roggen', shortcut: 'a2', onTap: selectItem, isActive: _selectedAllergenes.contains('a2')),
                  AllergenesListItem(
                      name: 'Gerste', shortcut: 'a3', onTap: selectItem, isActive: _selectedAllergenes.contains('a3')),
                  AllergenesListItem(
                      name: 'Hafer', shortcut: 'a4', onTap: selectItem, isActive: _selectedAllergenes.contains('a4')),
                  AllergenesListItem(
                      name: 'Dinkel', shortcut: 'a5', onTap: selectItem, isActive: _selectedAllergenes.contains('a5')),
                  AllergenesListItem(
                      name: 'Kamut', shortcut: 'a6', onTap: selectItem, isActive: _selectedAllergenes.contains('a6')),
                  AllergenesListItem(
                      name: 'Krebstiere',
                      shortcut: 'b',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('b')),
                  AllergenesListItem(
                      name: 'Eier', shortcut: 'c', onTap: selectItem, isActive: _selectedAllergenes.contains('c')),
                  AllergenesListItem(
                      name: 'Fisch', shortcut: 'd', onTap: selectItem, isActive: _selectedAllergenes.contains('d')),
                  AllergenesListItem(
                      name: 'Erdnüsse', shortcut: 'e', onTap: selectItem, isActive: _selectedAllergenes.contains('e')),
                  AllergenesListItem(
                      name: 'Sojabohnen',
                      shortcut: 'f',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('f')),
                  AllergenesListItem(
                      name: 'Milch', shortcut: 'g', onTap: selectItem, isActive: _selectedAllergenes.contains('g')),
                  AllergenesListItem(
                      name: 'Schalenfrüchte',
                      shortcut: 'h',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h')),
                  AllergenesListItem(
                      name: 'Mandel', shortcut: 'h1', onTap: selectItem, isActive: _selectedAllergenes.contains('h1')),
                  AllergenesListItem(
                      name: 'Haselnuss',
                      shortcut: 'h2',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h2')),
                  AllergenesListItem(
                      name: 'Walnuss', shortcut: 'h3', onTap: selectItem, isActive: _selectedAllergenes.contains('h3')),
                  AllergenesListItem(
                      name: 'Cashewnuss',
                      shortcut: 'h4',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h4')),
                  AllergenesListItem(
                      name: 'Pecanuss',
                      shortcut: 'h5',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h5')),
                  AllergenesListItem(
                      name: 'Paranuss',
                      shortcut: 'h6',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h6')),
                  AllergenesListItem(
                      name: 'Pistazie',
                      shortcut: 'h7',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h7')),
                  AllergenesListItem(
                      name: 'Macadamia/Quennslandnuss',
                      shortcut: 'h8',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('h8')),
                  AllergenesListItem(
                      name: 'Sellerie', shortcut: 'i', onTap: selectItem, isActive: _selectedAllergenes.contains('i')),
                  AllergenesListItem(
                      name: 'Senf', shortcut: 'j', onTap: selectItem, isActive: _selectedAllergenes.contains('j')),
                  AllergenesListItem(
                      name: 'Sesamsamen',
                      shortcut: 'k',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('k')),
                  AllergenesListItem(
                      name: 'Schwefeldioxis',
                      shortcut: 'l',
                      onTap: selectItem,
                      isActive: _selectedAllergenes.contains('l')),
                  AllergenesListItem(
                      name: 'Lupinen', shortcut: 'm', onTap: selectItem, isActive: _selectedAllergenes.contains('m')),
                  AllergenesListItem(
                      name: 'Weichtiere',
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
        color: isActive ? const Color.fromRGBO(245, 246, 250, 1) : Colors.white,
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
                    color: isActive ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isActive
                          ? Colors.black
                          : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color!,
                    ),
                  ),
                  child: isActive
                      ? SvgPicture.asset(
                          'assets/img/icons/x.svg',
                          color: Colors.white,
                        )
                      : Container(),
                ),
                // Name
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    name,
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                          fontSize: 15,
                          color: Colors.black,
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
