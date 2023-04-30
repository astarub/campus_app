import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/onboarding_data.dart';

class CalendarFilterSelection extends StatefulWidget {
  /// Holds all available filters
  final List<String> filters;
  final List<bool> selections;

  final void Function(String) onSelected;

  const CalendarFilterSelection({
    Key? key,
    required this.filters,
    required this.onSelected,
    this.selections = const [],
  }) : super(key: key);

  @override
  State<CalendarFilterSelection> createState() => _CalendarFilterSelectionState();
}

class _CalendarFilterSelectionState extends State<CalendarFilterSelection> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.filters.length,
      itemBuilder: (context, index) => CalendarFilterSelectionItem(
        name: widget.filters[index],
        shortcut: widget.filters[index],
        onTap: widget.onSelected,
        isActive: widget.selections[index],
      ),
    );
  }
}

/// This widget displays one selectable option in a list
class CalendarFilterSelectionItem extends StatelessWidget {
  /// The displayed name
  final String name;

  /// The shortcut that is uesd and saved in the background
  final String shortcut;

  /// The function that should be called when tapped
  final void Function(String) onTap;

  /// Wether the widget is selected or not
  final bool isActive;

  const CalendarFilterSelectionItem({
    Key? key,
    required this.name,
    required this.shortcut,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 12, right: 12),
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
                          color: Colors.white,
                        )
                      : Container(),
                ),
                // Name
                Expanded(
                  child: Padding(
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
