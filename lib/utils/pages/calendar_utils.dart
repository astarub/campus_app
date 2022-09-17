import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter/widgets.dart';

class CalendarUtils extends Utils {
  /// Parse a list of event entities to widget list of type CalendarEventWidget sorted by date.
  /// For Padding insert at first position a SizedBox with heigth := 80 or given heigth.
  List<Widget> getEventWidgetList({required List<Event> events, double heigth = 80}) {
    final eventWidgets = <CalendarEventWidget>[];

    for (final Event e in events) {
      eventWidgets.add(CalendarEventWidget(event: e));
    }

    // sort widgets according to date: new -> old
    eventWidgets.sort((a, b) => a.event.startDate.compareTo(b.event.startDate));

    // add SizedBox as padding
    final List<Widget> widgets = [SizedBox(height: heigth)];
    widgets.addAll(eventWidgets);

    return widgets;
  }
}
