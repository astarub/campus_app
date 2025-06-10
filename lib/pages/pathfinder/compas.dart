import 'dart:math';
import 'package:flutter/material.dart';

class CompassCustomPainter extends CustomPainter {
  final double angle;
  const CompassCustomPainter({required this.angle});

  double get rotation => -angle * pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    Paint circle = Paint()
      ..strokeWidth = 2
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint shadowCircle = Paint()
      ..strokeWidth = 2
      ..color = Colors.grey.withOpacity(.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, 50, circle);

    Paint darkIndexLine = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    Paint lightIndexLine = Paint()
      ..color = Colors.grey
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    Paint northTriangle = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    canvas.rotate(-pi / 2);

    for (int i = 1; i <= 16; i++) {
      canvas.drawLine(
        Offset.fromDirection(-(angle + 22.5 * i) * pi / 180, 30),
        Offset.fromDirection(-(angle + 22.5 * i) * pi / 180, 40),
        lightIndexLine,
      );
    }

    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(
        Offset.fromDirection(-(angle + 90 * i) * pi / 180, 30),
        Offset.fromDirection(-(angle + 90 * i) * pi / 180, 40),
        darkIndexLine,
      );
    }

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
    canvas.drawPath(path, northTriangle);

    canvas.drawCircle(Offset.zero, 34, shadowCircle);
    canvas.drawCircle(Offset.zero, 32, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
