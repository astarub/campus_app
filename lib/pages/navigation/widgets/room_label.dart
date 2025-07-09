import 'dart:math' as math;

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/navigation/models/room_label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomLabelWidget extends StatelessWidget {
  final RoomLabel label;
  final double rotation;
  final bool isStart;
  final bool isDest;

  const RoomLabelWidget({
    super.key,
    required this.label,
    required this.rotation,
    required this.isStart,
    required this.isDest,
  });

  @override
  Widget build(BuildContext context) {
    final currentThemeData = Provider.of<ThemesNotifier>(context).currentThemeData;

    // Normalize angle to (-π, π)
    double textRot = -rotation;
    textRot = ((textRot + math.pi) % (2 * math.pi)) - math.pi;

    final isPOI = isStart || isDest;

    return Positioned(
      left: isPOI ? label.position.dx + 15 : label.position.dx,
      top: label.position.dy,
      child: Transform.rotate(
        angle: textRot,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isPOI
                ? (isStart ? currentThemeData.colorScheme.secondary : Colors.red)
                : currentThemeData.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(
            label.labelText,
            style: TextStyle(
              fontSize: isPOI ? 15 : 10,
              fontWeight: FontWeight.bold,
              color: currentThemeData.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
