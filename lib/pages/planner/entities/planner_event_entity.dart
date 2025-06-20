import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PlannerEventEntity {
  final String id;
  final String title;
  final String? description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Color color;
  final String? rrule;

  PlannerEventEntity({
    String? id,
    required this.title,
    this.description,
    required this.startDateTime,
    required this.endDateTime,
    this.color = Colors.blue,
    this.rrule,
  }) : id = id ?? const Uuid().v4();
}
