import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PlannerEventEntity {
  final String id;
  final String title;
  final String? description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Color color;

  PlannerEventEntity({
    String? id,
    required this.title,
    this.description,
    required this.startDateTime,
    required this.endDateTime,
    this.color = Colors.blue,
  }) : id = id ?? const Uuid().v4();

  // Helper method to create a copy of the entity with updated fields
  PlannerEventEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    Color? color,
  }) {
    return PlannerEventEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      color: color ?? this.color,
    );
  }
}
