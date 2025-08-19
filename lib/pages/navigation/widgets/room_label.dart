import 'dart:math' as math;

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/navigation/models/room_label.dart';
import 'package:campus_app/utils/pages/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomLabelWidget extends StatelessWidget {
  final RoomLabel label;
  final double rotation;
  final bool isStart;
  final bool isDest;
  final bool ashumanReadableRoomLabel;

  const RoomLabelWidget({
    super.key,
    required this.label,
    required this.rotation,
    required this.isStart,
    required this.isDest,
    this.ashumanReadableRoomLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final currentThemeData = Provider.of<ThemesNotifier>(context).currentThemeData;
    final NavigationUtils utils = sl<NavigationUtils>();

    // Normalize angle to (-π, π)
    double textRot = -rotation;
    textRot = ((textRot + math.pi) % (2 * math.pi)) - math.pi;

    final isPOI = isStart || isDest;

    final labelText = ashumanReadableRoomLabel
        ? utils.humanReadableRoomLabel(
            label.labelText,
            extended: true,
          )
        : label.labelText;

    final labelStyle = TextStyle(
      fontSize: isPOI ? 20 : 10,
      fontWeight: FontWeight.bold,
      color: currentThemeData.colorScheme.onSurface,
    );

    // measure text size
    final textSize = measureTextSize(labelText, labelStyle);

    return Positioned(
      left: isPOI ? label.position.dx + 15 : label.position.dx - textSize.width / 2,
      top: label.position.dy - textSize.height / 2,
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
            labelText,
            style: labelStyle,
          ),
        ),
      ),
    );
  }

  Size measureTextSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size;
  }
}
