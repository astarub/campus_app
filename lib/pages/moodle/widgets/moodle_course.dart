import 'package:campus_app/pages/moodle/entities/moodle_course_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MoodleCourseWidget extends StatelessWidget {
  final MoodleCourseEntity course;

  const MoodleCourseWidget({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 350,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 300,
              width: 350,
              child: course.image,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    child: Html(data: course.shortname),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    child: Html(data: course.summary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
