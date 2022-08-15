import 'package:flutter/material.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/calendar/widgets/calendar_error_message.dart';
import 'package:campus_app/utils/pages/calendar_utils.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = CalendarUtils();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
            //children: utils.getEventWidgetList(calendarState.events),
            ),
      ),
    );
  }
}
