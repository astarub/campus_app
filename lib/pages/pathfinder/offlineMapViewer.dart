import 'package:campus_app/main.dart';
import 'package:flutter/material.dart';

class OfflineMapViewer extends StatefulWidget {
  final String imagePath;

  const OfflineMapViewer({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<OfflineMapViewer> createState() => _OfflineMapViewerState();
}

class _OfflineMapViewerState extends State<OfflineMapViewer> {
  double _scale = 2.0;
  double _previousScale = 1.0;
  Offset _position = Offset.zero;
  Offset _startFocalPoint = Offset.zero;
  Offset _startPosition = Offset.zero;
  double _rotation = 0.0;
  double _previousRotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _previousScale = _scale;
        _previousRotation = _rotation;
        _startFocalPoint = details.focalPoint;
        _startPosition = _position;
        homeKey.currentState!.setSwipeDisabled(disableSwipe: true);
      },
      onScaleUpdate: (details) {
        final Offset focalPointDelta = details.focalPoint - _startFocalPoint;
        const double minScale = 1.0;
        const double maxScale = 8.0;
        const double baseTranslationLimit = 300.0;

        setState(() {
          _scale = (_previousScale * details.scale).clamp(minScale, maxScale);
          _rotation = _previousRotation + details.rotation;

          final Offset potentialPosition = _startPosition + focalPointDelta;
          final double adjustedLimit = baseTranslationLimit * _scale;

          _position = Offset(
            potentialPosition.dx.clamp(-adjustedLimit, adjustedLimit),
            potentialPosition.dy.clamp(-adjustedLimit, adjustedLimit),
          );
        });
      },
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(_position.dx, _position.dy)
            ..rotateZ(_rotation)
            ..scale(_scale),
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
