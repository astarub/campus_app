import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaypointArrow extends StatelessWidget {
  final Offset current;
  final Offset previous;

  const WaypointArrow({
    super.key,
    required this.current,
    required this.previous,
  });

  @override
  Widget build(BuildContext context) {
    final dx = previous.dx - current.dx;
    final dy = previous.dy - current.dy;
    final angle = math.atan2(dy, dx);

    return Positioned(
      left: current.dx,
      top: current.dy,
      child: Transform.rotate(
        angle: angle - math.pi / 2,
        child: CustomPaint(
          size: const Size(10, 10),
          painter: _WayPointArrowPainter(),
        ),
      ),
    );
  }
}

class _WayPointArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height); // Bottom left
    path.lineTo(size.width / 2, 0); // Top center
    path.lineTo(size.width, size.height); // Bottom right

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
