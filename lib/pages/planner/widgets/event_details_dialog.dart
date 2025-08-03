import 'package:campus_app/utils/widgets/styled_html.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_state.dart';

// EventDetailsDialog UI widget.
class EventDetailsDialog extends StatelessWidget {
  const EventDetailsDialog({
    super.key,
    required this.event,
    required this.onEdit,
  });

  final PlannerEventEntity event;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final plannerState = context.read<PlannerState>();
    final bool userEvent = event.id.contains('-');
    return AlertDialog(
      title: Text(event.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('From:     ${DateFormat.yMMMEd().add_jm().format(event.startDateTime.toLocal())}'),
            Text('To:           ${DateFormat.yMMMEd().add_jm().format(event.endDateTime.toLocal())}'),
            const SizedBox(height: 16),
            StyledHTML(
              context: context,
              text: (event.description?.isNotEmpty ?? false) ? event.description! : 'No description.',
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text('Delete', style: TextStyle(color: Colors.red)),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('Confirm Delete'),
                content: const Text('Are you sure you want to delete this event?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                    onPressed: () => Navigator.pop(c, true),
                  ),
                ],
              ),
            );
            if (!context.mounted) return;

            if (confirmed ?? false) {
              await plannerState.deleteEvent(event.id);
              if (!context.mounted) return;
              Navigator.pop(context);
            }
          },
        ),
        if (userEvent)
          TextButton(
            child: const Text('Edit'),
            onPressed: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
