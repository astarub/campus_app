import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PlannerEventEntity {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;
  final Color color;

  PlannerEventEntity({
    String? id,
    required this.title,
    this.description,
    required this.date,
    required this.startTime,
    this.endTime,
    this.color = Colors.blue,
  }) : id = id ?? const Uuid().v4();

  // Helper method to create a copy of the entity with updated fields
  PlannerEventEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Color? color,
  }) {
    return PlannerEventEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
    );
  }
}
