import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/routes/router.gr.dart';
import 'package:campus_app/utils/pages/moodle_utils.dart';

class MoodlePage extends StatelessWidget {
  const MoodlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    final utils = MoodleUtils();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
          //children: utils.getCourseWidgetList(moodleState.courses),
          ),
    );
  }
}
