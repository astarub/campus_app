import 'dart:math' as math;

import 'package:campus_app/core/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartWaypoint extends StatelessWidget {
  final Offset position;
  final double rotation;

  const StartWaypoint({
    super.key,
    required this.position,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    final currentThemeData = Provider.of<ThemesNotifier>(context).currentThemeData;

    double textRot = -rotation;
    textRot = ((textRot + math.pi) % (2 * math.pi)) - math.pi;

    return Positioned(
      left: position.dx - 15,
      top: position.dy - 15,
      child: Transform.rotate(
        angle: textRot,
        child: const Icon(
          Icons.my_location_outlined,
          size: 30,
          color: Colors.blue,
        ),
      ),
    );
  }
}
