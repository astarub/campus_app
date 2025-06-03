// lib/pages/planner/entities/planner_event_entity.dart
import 'package:flutter/material.dart';

class PlannerEventEntity {
  final String title;
  final String? description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;
  final Color color;

  PlannerEventEntity({
    required this.title,
    this.description,
    required this.date,
    required this.startTime,
    this.endTime,
    this.color = Colors.blue, // Default color
  });
}
