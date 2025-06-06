import 'dart:typed_data';
import 'dart:ui';

import 'package:image/image.dart' as img;
import 'package:campus_app/utils/pages/pathfinder_utils.dart';

class ImageProcessingParams {
  final Uint8List bytes;
  final List<MapEntry<Map<String, double>, String>> labels;
  final List<Map<String, double>> pathPoints;
  final Uint8List markerBytes;

  ImageProcessingParams(
      this.bytes, this.labels, this.pathPoints, this.markerBytes);
}

bool isPointNearLine(
    Offset point, Offset lineStart, Offset lineEnd, double threshold) {
  final dx = lineEnd.dx - lineStart.dx;
  final dy = lineEnd.dy - lineStart.dy;

  if (dx == 0 && dy == 0) {
    return (point - lineStart).distance <= threshold;
  }

  final t = ((point.dx - lineStart.dx) * dx + (point.dy - lineStart.dy) * dy) /
      (dx * dx + dy * dy);

  final closest = Offset(
    lineStart.dx + t.clamp(0.0, 1.0) * dx,
    lineStart.dy + t.clamp(0.0, 1.0) * dy,
  );

  return (point - closest).distance <= threshold;
}

Uint8List processImageInIsolate(ImageProcessingParams params) {
  final img.Image baseImage =
      img.decodeImage(params.bytes)!.convert(numChannels: 4);

  final List<Offset> pathOffsets =
      params.pathPoints.map((e) => Offset(e['x']!, e['y']!)).toList();

  // Draw path
  for (int i = 0; i < pathOffsets.length - 1; i++) {
    drawLine(baseImage, pathOffsets[i], pathOffsets[i + 1],
        img.ColorRgb8(0, 255, 255), 5);
  }

  if (pathOffsets.isNotEmpty && params.markerBytes.isNotEmpty) {
    final img.Image markerImage = img.decodeImage(params.markerBytes)!;
    final Offset end = pathOffsets.last;
    final int dstX = (end.dx - markerImage.width / 2).round();
    final int dstY = (end.dy - markerImage.height / 2).round();
    img.compositeImage(baseImage, markerImage, dstX: dstX, dstY: dstY);
  }

// Draw start point
  if (pathOffsets.isNotEmpty) {
    drawPoint(baseImage, pathOffsets.first, img.ColorRgb8(255, 0, 0), 20);
  }

  for (final entry in params.labels) {
    final Offset labelPos = Offset(entry.key['x']!, entry.key['y']!);
    final String label = entry.value;

    if (!label.contains("EN_")) {
      bool isClose = false;
      for (int i = 0; i < pathOffsets.length - 1; i++) {
        if (isPointNearLine(
            labelPos, pathOffsets[i], pathOffsets[i + 1], 200)) {
          // If all set to 2000 or perform rollback
          isClose = true;
          break;
        }
      }

      if (isClose) {
        drawTextWithBox(
            baseImage, labelPos, label, img.ColorRgb8(255, 255, 255));
      }
    }
  }

  return Uint8List.fromList(img.encodePng(baseImage));
}
