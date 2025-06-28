import 'dart:ui';

class RoomLabel {
  /// The display text of the room.
  final String labelText;

  /// The position in image coordinates (pixels from top-left).
  final Offset position;

  const RoomLabel({
    required this.labelText,
    required this.position,
  });
}
