import 'package:campus_app/pages/mensa/entities/moodle_course_entity.dart';
import 'package:campus_app/pages/moodle/widgets/moodle_course.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter/widgets.dart';

class MoodleUtils extends Utils {
  /// parse news entities to widget list
  List<Widget> getCourseWidgetList(
    List<MoodleCourseEntity> courses,
  ) {
    final List<Widget> widgets = [];

    for (final MoodleCourseEntity e in courses) {
      widgets.add(MoodleCourseWidget(course: e));
      widgets.add(const SizedBox(height: 20));
    }

    return widgets;
  }
}
