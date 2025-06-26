// Prototyp - not in use anymore; positive test-user feedback

import 'dart:math';
import 'package:flutter/material.dart';

// Custom painter that draws a compass indicating the given angle
class CompassCustomPainter extends CustomPainter {
  // The angle in degrees representing the compass heading
  final double angle;

  const CompassCustomPainter({required this.angle});

  // Converts angle from degrees to radians in negative for rotation direction
  double get rotation => -angle * pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    // Move the canvas origin to the center
    canvas.translate(size.width / 2, size.height / 2);

    // Base white filled circle
    Paint circle = Paint()
      ..strokeWidth = 2
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Background shadow circle for subtle depth
    Paint shadowCircle = Paint()
      ..strokeWidth = 2
      ..color = Colors.grey.withOpacity(.2)
      ..style = PaintingStyle.fill;

    // Draw base compass circle
    canvas.drawCircle(Offset.zero, 50, circle);

    // Dark lines for cardinal directions (N E S W)
    Paint darkIndexLine = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Light lines for minor tick marks
    Paint lightIndexLine = Paint()
      ..color = Colors.grey
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Paint for north direction arrow
    Paint northTriangle = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    // Rotate the whole compass so that 0° is pointing up
    canvas.rotate(-pi / 2);

    // Draw 16 directional tick marks every 22.5 degrees
    for (int i = 1; i <= 16; i++) {
      canvas.drawLine(
        Offset.fromDirection(-(angle + 22.5 * i) * pi / 180, 30),
        Offset.fromDirection(-(angle + 22.5 * i) * pi / 180, 40),
        lightIndexLine,
      );
    }

    // Draw bold tick marks at cardinal points every 90 degrees
    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(
        Offset.fromDirection(-(angle + 90 * i) * pi / 180, 30),
        Offset.fromDirection(-(angle + 90 * i) * pi / 180, 40),
        darkIndexLine,
      );
    }

    // Create a triangle shape pointing toward current heading North
    Path path = Path();
    path.moveTo(
      Offset.fromDirection(rotation, 45).dx,
      Offset.fromDirection(rotation, 45).dy,
    );
    path.lineTo(
      Offset.fromDirection(-(angle + 15) * pi / 180, 30).dx,
      Offset.fromDirection(-(angle + 15) * pi / 180, 30).dy,
    );
    path.lineTo(
      Offset.fromDirection(-(angle - 15) * pi / 180, 30).dx,
      Offset.fromDirection(-(angle - 15) * pi / 180, 30).dy,
    );
    path.close();

    // Draw the north triangle pointer
    canvas.drawPath(path, northTriangle);

    // Draw inner shadow and highlight circles to complete styling
    canvas.drawCircle(Offset.zero, 34, shadowCircle);
    canvas.drawCircle(Offset.zero, 32, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
