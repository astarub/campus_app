import 'package:campus_app/pages/navigation/models/room_label.dart';
import 'package:flutter/material.dart';

class FloorMap {
  /// The display text of the floor.
  final String floorName;

  /// The floor labels with its positions.
  final List<RoomLabel> roomLabels;

  /// The floor image.
  final Image floorImage;

  /// The path to draw on map.
  final List<Offset> wayPoints;

  const FloorMap({
    required this.floorName,
    required this.roomLabels,
    required this.floorImage,
    required this.wayPoints,
  });
}
