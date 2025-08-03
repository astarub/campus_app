import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'planner_event_entity.g.dart';

/// PlannerEventEntity data entity.
@HiveType(typeId: 6)
class PlannerEventEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime startDateTime;

  @HiveField(4)
  final DateTime endDateTime;

  @HiveField(5)
  final int colorValue;

  // Handle recurrence rule (RRULE).
  @HiveField(6)
  final String? rrule;

  PlannerEventEntity({
    String? id,
    required this.title,
    this.description,
    required this.startDateTime,
    required this.endDateTime,
    Color? color,
    int? colorValue,
    this.rrule,
  })  : id = id ?? const Uuid().v4(),
        colorValue = colorValue ?? (color ?? Colors.blue).toARGB32();
  Color get color => Color(colorValue);
}
