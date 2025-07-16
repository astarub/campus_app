import 'package:flutter/material.dart';

Future<DateTime?> pickDateTime(BuildContext context, {required DateTime initialDate}) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initialDate.toLocal(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
  );
  if (date == null) return null;

  if (!context.mounted) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate.toLocal()),
  );
  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
