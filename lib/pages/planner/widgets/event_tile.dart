import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';

// EventTile UI widget.
class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.events,
    required this.onEventTap,
  });

  final List<CalendarEventData<PlannerEventEntity>> events;
  final ValueChanged<PlannerEventEntity> onEventTap;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final ev in events)
          GestureDetector(
            onTap: () => onEventTap(ev.event!),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 1),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: ev.color,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                ev.title,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor, fontSize: 12),
                maxLines: 1,
              ),
            ),
          ),
      ],
    );
  }
}
