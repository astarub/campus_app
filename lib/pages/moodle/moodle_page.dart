import 'package:flutter/material.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/utils/pages/moodle_utils.dart';

class MoodlePage extends StatelessWidget {
  const MoodlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = MoodleUtils();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
          //children: utils.getCourseWidgetList(moodleState.courses),
          ),
    );
  }
}
