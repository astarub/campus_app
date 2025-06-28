import 'dart:math' as math;

import 'package:flutter/material.dart';

class DestinationWaypoint extends StatelessWidget {
  final Offset position;
  final double rotation;

  const DestinationWaypoint({
    super.key,
    required this.position,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    double textRot = -rotation;
    textRot = ((textRot + math.pi) % (2 * math.pi)) - math.pi;

    return Positioned(
      left: position.dx - 15,
      top: position.dy - 15,
      child: Transform.rotate(
        angle: textRot,
        child: const Icon(
          Icons.location_on_outlined,
          size: 30,
          color: Colors.red,
        ),
      ),
    );
  }
}
