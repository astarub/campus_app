import 'package:flutter/material.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';

extension EventX on Event {
  PlannerEventEntity toPlannerEvent({Color fallbackColor = const Color.fromARGB(255, 160, 19, 9)}) {
    return PlannerEventEntity(
      id: id.toString(),
      title: title,
      description: description,
      startDateTime: startDate,
      endDateTime: endDate,
      color: fallbackColor,
    );
  }
}
