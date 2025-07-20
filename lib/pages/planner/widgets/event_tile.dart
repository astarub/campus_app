import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';

Widget eventTile(
  List<CalendarEventData<PlannerEventEntity>> events,
  void Function(PlannerEventEntity event) onEventTap, {
  int maxVisible = 4,
}) {
  if (events.isEmpty) return const SizedBox.shrink();

  events.sort((a, b) => a.title.compareTo(b.title));

  final visible = events.take(maxVisible).toList();
  final hidden = events.length - visible.length;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final ev in visible)
        GestureDetector(
          onTap: () => onEventTap(ev.event!),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: ev.color.withOpacity(.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              ev.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
        ),
      if (hidden > 0)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text('+$hidden more', style: const TextStyle(fontSize: 10)),
        ),
    ],
  );
}
