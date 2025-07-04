import 'package:flutter/material.dart';

List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  final days = <DateTime>[];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(
      DateTime(
        startDate.year,
        startDate.month,
        startDate.day + i,
      ),
    );
  }
  return days;
}

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

  return DateTime.utc(date.year, date.month, date.day, time.hour, time.minute);
}
