import 'package:campus_app/pages/planner/widgets/recurrence_options_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_state.dart';
import 'package:campus_app/utils/pages/planner_utils.dart';

class AddEditEventDialog extends StatefulWidget {
  const AddEditEventDialog({
    super.key,
    required this.focusedDay,
    this.event,
  });

  final DateTime focusedDay;
  final PlannerEventEntity? event;

  @override
  State<AddEditEventDialog> createState() => _AddEditEventDialogState();
}

class _AddEditEventDialogState extends State<AddEditEventDialog> {
  late final bool _isEditing = widget.event != null;
  late final PlannerState _plannerState = context.read<PlannerState>();

  late final TextEditingController _titleController = TextEditingController(text: widget.event?.title ?? '');
  late final TextEditingController _descController = TextEditingController(text: widget.event?.description ?? '');

  late final ValueNotifier<DateTime> _startDateTimeNotifier =
      ValueNotifier<DateTime>(widget.event?.startDateTime ?? _suggestStart(widget.focusedDay));

  late final ValueNotifier<DateTime> _endDateTimeNotifier =
      ValueNotifier<DateTime>(widget.event?.endDateTime ?? _startDateTimeNotifier.value.add(const Duration(hours: 2)));

  late final ValueNotifier<String?> _rruleNotifier = ValueNotifier<String?>(widget.event?.rrule);

  late final ValueNotifier<Color> _colorNotifier = ValueNotifier<Color>(widget.event?.color ?? Colors.blue);
  static const TextStyle _textStyle = TextStyle(fontSize: 16);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Event' : 'Add New Event'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title', labelStyle: theme.textTheme.bodyMedium),
              style: _textStyle,
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description (Optional)', labelStyle: theme.textTheme.bodyMedium),
              style: _textStyle,
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<Color>(
              valueListenable: _colorNotifier,
              builder: (context, currentColor, child) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundColor: currentColor),
                  title: const Text(
                    'Event Color',
                    style: _textStyle,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (pickerContext) => AlertDialog(
                        title: const Text(
                          'Pick a color',
                          style: TextStyle(fontSize: 20),
                        ),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: currentColor,
                            onColorChanged: (color) {
                              _colorNotifier.value = color;
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Done'),
                            onPressed: () => Navigator.pop(pickerContext),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder<DateTime>(
              valueListenable: _startDateTimeNotifier,
              builder: (context, currentStart, child) => TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  'Starts: ${DateFormat('dd/MM/yyyy').add_jm().format(currentStart.toLocal())}',
                  style: _textStyle,
                ),
                onPressed: () async {
                  final picked = await pickDateTime(context, initialDate: currentStart);
                  if (picked != null) {
                    _startDateTimeNotifier.value = picked;
                    if (picked.isAfter(_endDateTimeNotifier.value)) {
                      _endDateTimeNotifier.value = picked.add(const Duration(hours: 2));
                    }
                  }
                },
              ),
            ),
            ValueListenableBuilder<DateTime>(
              valueListenable: _endDateTimeNotifier,
              builder: (context, currentEnd, child) => TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  'Ends: ${DateFormat('dd/MM/yyyy').add_jm().format(currentEnd.toLocal())}',
                  style: _textStyle,
                ),
                onPressed: () async {
                  final picked = await pickDateTime(context, initialDate: currentEnd);
                  if (picked != null && picked.isAfter(_startDateTimeNotifier.value)) {
                    _endDateTimeNotifier.value = picked;
                  }
                },
              ),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: _rruleNotifier,
              builder: (context, currentRrule, child) {
                final isRecurring = currentRrule?.isNotEmpty ?? false;
                return TextButton.icon(
                  icon: const Icon(Icons.repeat),
                  label: Text(
                    isRecurring ? 'Repeats' : "Don't repeat",
                    style: _textStyle,
                  ),
                  onPressed: () async {
                    final newRrule = await showDialog<String?>(
                      context: context,
                      builder: (_) => RecurrenceOptionsDialog(
                        initialRrule: currentRrule,
                        eventStartDate: _startDateTimeNotifier.value,
                      ),
                    );
                    if (newRrule != null) {
                      _rruleNotifier.value = newRrule == 'clear' ? null : newRrule;
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveEvent,
          child: Text(_isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  Future<void> _saveEvent() async {
    if (_titleController.text.isEmpty) return;

    if (_isEditing) {
      await _plannerState.updateEvent(
        PlannerEventEntity(
          id: widget.event!.id,
          title: _titleController.text,
          description: _descController.text.isNotEmpty ? _descController.text : null,
          startDateTime: _startDateTimeNotifier.value.toUtc(),
          endDateTime: _endDateTimeNotifier.value.toUtc(),
          rrule: _rruleNotifier.value,
          color: _colorNotifier.value,
        ),
      );
    } else {
      await _plannerState.addEvent(
        PlannerEventEntity(
          title: _titleController.text,
          description: _descController.text.isNotEmpty ? _descController.text : null,
          startDateTime: _startDateTimeNotifier.value.toUtc(),
          endDateTime: _endDateTimeNotifier.value.toUtc(),
          rrule: _rruleNotifier.value,
          color: _colorNotifier.value,
        ),
      );
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  DateTime _suggestStart(DateTime seed) {
    if (seed.hour != 0 || seed.minute != 0 || seed.second != 0) return seed;
    final now = DateTime.now().toLocal();
    return DateTime(seed.year, seed.month, seed.day, now.hour, now.minute);
  }
}
