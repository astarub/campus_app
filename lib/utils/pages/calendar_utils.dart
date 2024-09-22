import 'package:campus_app/core/backend/entities/publisher_entity.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/utils/constants.dart';
import 'package:flutter/widgets.dart';

class CalendarUtils {
  List<Widget> filterEventWidgets(List<Publisher> filters, List<Widget> parsedEvents, List<Publisher> publishers) {
    final List<Widget> filteredEvents = [];

    for (final Widget e in parsedEvents) {
      if (e is CalendarEventWidget) {
        final categoryNames = e.event.categories.map((e) => e.name);

        if (e.event.url.startsWith('https://asta-bochum.de') && filters.map((e) => e.name).contains('AStA')) {
          filteredEvents.add(e);
        } else if (e.event.url.startsWith(appWordpressHost) &&
            (filters.map((e) => e.id).contains(int.parse(e.event.author)) || categoryNames.contains('Global'))) {
          filteredEvents.add(e);
        }
      } else {
        filteredEvents.add(e);
      }
    }
    return filteredEvents;
  }

  /// Parse a list of event entities to widget list of type CalendarEventWidget sorted by date.
  /// For Padding insert at first position a SizedBox with heigth := 80 or given heigth.
  List<Widget> getEventWidgetList({required List<Event> events, double heigth = 80}) {
    final eventWidgets = <CalendarEventWidget>[];
    final List<Event> pinnedEvents = events.where((e) => e.pinned).toList();
    final List<CalendarEventWidget> pinnedEventWidgets =
        pinnedEvents.map((e) => CalendarEventWidget(event: e)).toList();

    for (final Event e in events) {
      if (e.pinned) continue;
      eventWidgets.add(CalendarEventWidget(event: e));
    }

    // sort widgets according to date: new -> old
    eventWidgets.sort((a, b) => a.event.startDate.compareTo(b.event.startDate));
    pinnedEventWidgets.sort((a, b) => a.event.startDate.compareTo(b.event.startDate));

    // add SizedBox as padding
    final List<Widget> widgets = [SizedBox(height: heigth)];
    widgets.addAll(pinnedEventWidgets);
    widgets.addAll(eventWidgets);

    return widgets;
  }
}
