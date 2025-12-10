import 'package:campus_app/utils/widgets/styled_html.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_state.dart';

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
    final bool isUserEvent = event.id.contains('-'); // user-created events

    return AlertDialog(
      title: Text(event.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("From: ${DateFormat.yMMMEd().add_jm().format(event.startDateTime)}"),
            Text("To:       ${DateFormat.yMMMEd().add_jm().format(event.endDateTime)}"),
            const SizedBox(height: 16),

            StyledHTML(
              context: context,
              text: (event.description?.isNotEmpty ?? false)
                  ? event.description!
                  : "No description.",
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),

      actions: [
        // 🔴 DELETE BUTTON (fix)
        TextButton.icon(
          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text("Delete", style: TextStyle(color: Colors.red)),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Confirm Delete"),
                content: const Text("Are you sure you want to delete this event?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(ctx, false),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text("Delete"),
                    onPressed: () => Navigator.pop(ctx, true),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              // ❗ KORREKTES LÖSCHEN
              await plannerState.deleteEvent(event.id);

              // Schließe Dialog
              if (context.mounted) Navigator.pop(context);
            }
          },
        ),

        if (isUserEvent)
          TextButton(
            child: const Text("Edit"),
            onPressed: () {
              Navigator.pop(context);
              onEdit();
            },
          ),

        TextButton(
          child: const Text("Close"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
