import 'package:campus_app/main.dart';
import 'package:flutter/material.dart';

class OfflineMapViewer extends StatefulWidget {
  final String imagePath;

  const OfflineMapViewer({super.key, required this.imagePath});

  @override
  State<OfflineMapViewer> createState() => OfflineMapViewerState();
}

class OfflineMapViewerState extends State<OfflineMapViewer> {
  // Hyperparameters to configure UI/UX interface
  double scale = 2;
  double previousScale = 1;
  Offset position = Offset.zero;
  Offset startFocalPoint = Offset.zero;
  Offset startPosition = Offset.zero;
  double rotation = 0;
  double previousRotation = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        // Store the initial starting position param.
        previousScale = scale;
        previousRotation = rotation;
        startFocalPoint = details.focalPoint;
        startPosition = position;

        // Disable swipe gestures
        homeKey.currentState!.setSwipeDisabled(disableSwipe: true);
      },
      onScaleUpdate: (details) {
        // Calculate gesture movement delta
        final Offset focalPointDelta = details.focalPoint - startFocalPoint;

        // Set min and max allowed zoom levels and pan limits
        const double minScale = 1;
        const double maxScale = 8;
        const double baseTranslationLimit = 300;

        setState(() {
          // Update scale and clamp to bounds
          scale = (previousScale * details.scale).clamp(minScale, maxScale);

          // Update rotation angle
          rotation = previousRotation + details.rotation;

          // Calculate new position and clamp to pan limits based on scale
          final Offset potentialPosition = startPosition + focalPointDelta;
          final double adjustedLimit = baseTranslationLimit * scale;

          position = Offset(
            potentialPosition.dx.clamp(-adjustedLimit, adjustedLimit),
            potentialPosition.dy.clamp(-adjustedLimit, adjustedLimit),
          );
        });
      },
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          // Apply Transformation: translation, rotation, and scaling
          transform: Matrix4.identity()
            ..translate(position.dx, position.dy)
            ..rotateZ(rotation)
            ..scale(scale),
          // Display static image using asset path as default solution
          // TODO: Replace using flutter package: flutter_map_mbtiles
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
