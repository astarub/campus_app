import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:campus_app/pages/calendar/calendar_event_entity.dart';

class CalendarEventWidget extends StatelessWidget {
  final CalendarEventEntity event;

  const CalendarEventWidget({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Html(data: event.title),
                      const SizedBox(height: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 175,
                          width: 350,
                          child: event.image,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Html(data: event.description),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
