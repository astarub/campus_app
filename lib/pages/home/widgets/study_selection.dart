import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/backend/entities/study_course_entity.dart';

class StudySelection extends StatefulWidget {
  final List<StudyCourse> availableStudies;

  /// Can be given to show previously selected studies
  final List<StudyCourse> selectedStudies;

  const StudySelection({
    super.key,
    required this.availableStudies,
    required this.selectedStudies,
  });

  @override
  State<StudySelection> createState() => _StudySelectionState();
}

class _StudySelectionState extends State<StudySelection> {
  void selectItem(StudyCourse selected) {
    if (widget.selectedStudies.map((e) => e.name).contains(selected.name)) {
      setState(() => widget.selectedStudies.removeWhere((preference) => preference.name == selected.name));
    } else {
      setState(() => widget.selectedStudies.add(selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.availableStudies.length,
      itemBuilder: (context, index) => StudySelectionItem(
        course: widget.availableStudies[index],
        onTap: selectItem,
        isActive: widget.selectedStudies.contains(widget.availableStudies[index]),
      ),
    );
  }
}

/// This widget displays one selectable option in a list
class StudySelectionItem extends StatelessWidget {
  final StudyCourse course;

  /// The function that should be called when tapped
  final void Function(StudyCourse) onTap;

  /// Wether the widget is selected or not
  final bool isActive;

  const StudySelectionItem({
    super.key,
    required this.course,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
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
          onTap: () => onTap(course),
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
                      course.name,
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
