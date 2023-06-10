import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

/// This widget adds 3 [SelectionItem] buttons and only one can be active at the same time.
/// Therefore this can be used to let the user decide between three different options.
///
/// The currently selected option can be accessed with [currentSelected].
class CampusSelection extends StatefulWidget {
  /// The title for each of the three options
  final List<String> selectionItemTitles;

  /// The currently selected option
  int currentSelected;

  CampusSelection({
    Key? key,
    required this.selectionItemTitles,
    this.currentSelected = 0,
  }) : super(key: key);

  @override
  State<CampusSelection> createState() => _CampusSelectionState();
}

class _CampusSelectionState extends State<CampusSelection> {
  void selectItem(int newSelected) {
    setState(() => widget.currentSelected = newSelected);
  }

  @override
  void initState() {
    super.initState();

    widget.currentSelected = widget.currentSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Publisher',
              textAlign: TextAlign.left,
              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SelectionItem(
                    text: widget.selectionItemTitles[0],
                    onTap: () => selectItem(0),
                    isActive: widget.currentSelected == 0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: SelectionItem(
                    text: widget.selectionItemTitles[1],
                    onTap: () => selectItem(1),
                    isActive: widget.currentSelected == 1,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: SelectionItem(
                    text: widget.selectionItemTitles[2],
                    onTap: () => selectItem(2),
                    isActive: widget.currentSelected == 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SelectionItem extends StatelessWidget {
  final String text;

  final VoidCallback onTap;

  bool isActive;

  SelectionItem({
    Key? key,
    required this.text,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
            ? isActive
                ? Colors.black
                : const Color.fromRGBO(245, 246, 250, 1)
            : isActive
                ? const Color.fromRGBO(34, 40, 54, 1)
                : const Color.fromRGBO(18, 24, 38, 1),
        borderRadius: BorderRadius.circular(12),
        border: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.dark
            ? Border.all(color: const Color.fromRGBO(34, 40, 54, 1))
            : null,
      ),
      child: Material(
        color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
            ? isActive
                ? Colors.black
                : const Color.fromRGBO(245, 246, 250, 1)
            : isActive
                ? const Color.fromRGBO(34, 40, 54, 1)
                : const Color.fromRGBO(18, 24, 38, 1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          splashColor: isActive ? const Color.fromRGBO(255, 255, 255, 0.12) : const Color.fromRGBO(0, 0, 0, 0.06),
          highlightColor: isActive ? const Color.fromRGBO(255, 255, 255, 0.08) : const Color.fromRGBO(0, 0, 0, 0.04),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                text,
                style: isActive
                    ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.white,
                        )
                    : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                              ? Colors.black
                              : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium?.color,
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
