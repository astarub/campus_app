import 'package:campus_app/pages/planner/planner_page.dart';
import 'package:flutter/material.dart';

// ViewModeSwitch UI widget.
class ViewModeSwitch extends StatelessWidget {
  const ViewModeSwitch({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final CalendarViewMode mode;
  final ValueChanged<CalendarViewMode> onChanged;

  MapEntry<IconData, CalendarViewMode> get _next {
    switch (mode) {
      case CalendarViewMode.month:
        return const MapEntry(Icons.view_week, CalendarViewMode.week);
      case CalendarViewMode.week:
        return const MapEntry(Icons.view_day, CalendarViewMode.day);
      case CalendarViewMode.day:
        return const MapEntry(Icons.calendar_month, CalendarViewMode.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Switch view',
      icon: Icon(_next.key),
      onPressed: () => onChanged(_next.value),
    );
  }
}
