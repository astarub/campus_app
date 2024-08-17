import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/backend/entities/publisher_entity.dart';

class CampusFilterSelection extends StatefulWidget {
  /// Holds all available filters
  final List<Publisher> filters;
  final List<bool> selections;

  final void Function(Publisher) onSelected;

  const CampusFilterSelection({
    super.key,
    required this.filters,
    required this.onSelected,
    this.selections = const [],
  });

  @override
  State<CampusFilterSelection> createState() => _CampusFilterSelectionState();
}

class _CampusFilterSelectionState extends State<CampusFilterSelection> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.filters.length,
      itemBuilder: (context, index) => CampusFilterSelectionItem(
        publisher: widget.filters[index],
        onTap: widget.onSelected,
        isActive: widget.selections[index],
      ),
    );
  }
}

/// This widget displays one selectable option in a list
class CampusFilterSelectionItem extends StatelessWidget {
  final Publisher publisher;

  /// The function that should be called when tapped
  final void Function(Publisher) onTap;

  /// Wether the widget is selected or not
  final bool isActive;

  const CampusFilterSelectionItem({
    super.key,
    required this.publisher,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 12, right: 12),
      child: Material(
        color: isActive
            ? Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                ? const Color.fromRGBO(245, 246, 250, 1)
                : const Color.fromRGBO(34, 40, 54, 1)
            : Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          splashColor: const Color.fromRGBO(0, 0, 0, 0.06),
          highlightColor: const Color.fromRGBO(0, 0, 0, 0.04),
          borderRadius: BorderRadius.circular(6),
          onTap: () => onTap(publisher),
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
                      publisher.name,
                      style: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                          ? Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                                fontSize: 15,
                                color: Colors.black,
                              )
                          : Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                      overflow: TextOverflow.ellipsis,
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
