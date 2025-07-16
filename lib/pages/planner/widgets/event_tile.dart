import 'package:calendar_view/calendar_view.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:flutter/material.dart';

Widget eventTile(
  List<CalendarEventData<PlannerEventEntity>> events,
  VoidCallback onTap,
) {
  final ev = events.first;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ev.color.withAlpha(220),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        ev.title,
        maxLines: 2,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}
