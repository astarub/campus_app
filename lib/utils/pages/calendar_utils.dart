import 'package:campus_app/pages/calendar/calendar_event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter/widgets.dart';

class CalendarUtils extends Utils {
  /// parse news entities to widget list
  List<Widget> getEventWidgetList(List<CalendarEventEntity> events) {
    final List<Widget> widgets = [];

    for (final CalendarEventEntity e in events) {
      widgets.add(CalendarEventWidget(event: e));
      widgets.add(const SizedBox(height: 20));
    }

    return widgets;
  }
}
