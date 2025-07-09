import 'package:campus_app/core/themes.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

/// Drawn Compass (replace the image)
class Compass extends StatelessWidget {
  final double rotation;
  final double rotationOffset;
  final VoidCallback onReset;

  const Compass({
    super.key,
    required this.rotation,
    required this.rotationOffset,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onReset,
      child: SizedBox(
        width: 125,
        height: 125,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: rotation + rotationOffset,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: CompassWidget(size: 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompassWidget extends StatelessWidget {
  final double size;

  const CompassWidget({super.key, this.size = 125});

  @override
  Widget build(BuildContext context) {
    final currentThemeData = Provider.of<ThemesNotifier>(context).currentThemeData;

    return CustomPaint(
      size: Size(size, size),
      painter: _ImprovedCompassPainter(theme: currentThemeData),
    );
  }
}

class _ImprovedCompassPainter extends CustomPainter {
  ThemeData theme;

  _ImprovedCompassPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    // Circle
    final center = size.center(Offset.zero);
    final radius = size.width * 0.35;

    final Paint circlePaint = Paint()
      ..color = theme.colorScheme.onSurface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, circlePaint);

    // North Needle
    final double nsNeedleHeight = radius * 1.6;
    final double nsNeedleWidth = radius * 0.25;

    final Path northNeedlePath = Path()
      ..moveTo(center.dx, center.dy - nsNeedleHeight) // tip
      ..lineTo(center.dx - nsNeedleWidth, center.dy)
      ..lineTo(center.dx + nsNeedleWidth, center.dy)
      ..close();
    final Path needlePath = Path()
      ..moveTo(center.dx, center.dy + nsNeedleHeight) // tip
      ..lineTo(center.dx - nsNeedleWidth, center.dy)
      ..lineTo(center.dx + nsNeedleWidth, center.dy)
      ..close();
    final Path northNeedleBorderPath = Path()
      ..moveTo(center.dx, center.dy - nsNeedleHeight - 8) // tip
      ..lineTo(center.dx - nsNeedleWidth - 5, center.dy)
      ..lineTo(center.dx + nsNeedleWidth + 5, center.dy)
      ..close();
    final Path needleBorderPath = Path()
      ..moveTo(center.dx, center.dy + nsNeedleHeight + 8) // tip
      ..lineTo(center.dx - nsNeedleWidth - 5, center.dy)
      ..lineTo(center.dx + nsNeedleWidth + 5, center.dy)
      ..close();
    final Path needleDecoPath = Path()
      ..moveTo(center.dx, center.dy + nsNeedleHeight + 8) // tip
      ..lineTo(center.dx - 5, center.dy)
      ..lineTo(center.dx, center.dy - nsNeedleHeight - 8)
      ..close();

    final Paint northNeedlePaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;
    final Paint normalNeedlePaint = Paint()
      ..color = theme.colorScheme.secondary
      ..style = PaintingStyle.fill;
    final Paint needleBoarderPaint = Paint()
      ..color = theme.colorScheme.surface
      ..style = PaintingStyle.fill;

    canvas.drawPath(northNeedleBorderPath, needleBoarderPaint);
    canvas.drawPath(needleBorderPath, needleBoarderPaint);
    canvas.drawPath(northNeedlePath, northNeedlePaint);
    canvas.drawPath(needlePath, normalNeedlePaint);
    canvas.drawPath(needleDecoPath, needleBoarderPaint);

    // N
    // TODO: Maybe use a pretty lettering
    // final textPainterN = TextPainter(
    //   text: TextSpan(
    //     text: 'N',
    //     style: TextStyle(
    //       color: theme.colorScheme.onSurface,
    //       fontSize: 24,
    //       fontWeight: FontWeight.w400,
    //     ),
    //   ),
    //   textAlign: TextAlign.center,
    //   textDirection: TextDirection.ltr,
    // )..layout();

    // final textPainterNOutline = TextPainter(
    //   text: TextSpan(
    //     text: 'N',
    //     style: TextStyle(
    //       color: theme.colorScheme.surface,
    //       fontSize: 24,
    //       fontWeight: FontWeight.w900,
    //     ),
    //   ),
    //   textAlign: TextAlign.center,
    //   textDirection: TextDirection.ltr,
    // )..layout();

    // final offsetN = Offset(
    //   center.dx - textPainterN.width / 2,
    //   center.dy - radius - textPainterN.height / 2,
    // );

    // final offsetNOutline = Offset(
    //   center.dx - textPainterNOutline.width / 2,
    //   center.dy - radius - textPainterNOutline.height / 2,
    // );

    // textPainterNOutline.paint(canvas, offsetNOutline);
    // textPainterN.paint(canvas, offsetN);

    // West and East
    final double weNeedleHeight = radius * 0.25;
    final double weNeedleWidth = radius * 0.25;

    final Path westNeedlePath = Path()
      ..moveTo(center.dx + radius, center.dy - weNeedleWidth / 2) // tip
      ..lineTo(center.dx + radius, center.dy + weNeedleWidth)
      ..lineTo(center.dx + radius + weNeedleHeight, center.dy)
      ..close();

    final Path eastNeedlePath = Path()
      ..moveTo(center.dx - radius, center.dy - weNeedleWidth / 2) // tip
      ..lineTo(center.dx - radius, center.dy + weNeedleWidth)
      ..lineTo(center.dx - radius - weNeedleHeight, center.dy)
      ..close();

    final Paint wePaint = Paint()
      ..color = theme.colorScheme.onSurface
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    canvas.drawPath(westNeedlePath, wePaint);
    canvas.drawPath(eastNeedlePath, wePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
