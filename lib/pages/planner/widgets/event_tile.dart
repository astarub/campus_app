import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';

Color getContrastingTextColor(Color backgroundColor) {
  final double brightness = backgroundColor.red * 0.299 + backgroundColor.green * 0.587 + backgroundColor.blue * 0.114;
  return brightness > 186 ? Colors.black : Colors.white;
}

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
                maxLines: 1,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: getContrastingTextColor(ev.color), // ↩️ automatische Kontrastfarbe
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
