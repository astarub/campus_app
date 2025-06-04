import 'dart:typed_data';
import 'dart:ui';

import 'package:image/image.dart' as img;
import 'package:campus_app/utils/pages/pathfinder_utils.dart';

class ImageProcessingParams {
  final Uint8List bytes;
  final List<MapEntry<Map<String, double>, String>> labels;
  final List<Map<String, double>> pathPoints;

  ImageProcessingParams(this.bytes, this.labels, this.pathPoints);
}

Uint8List processImageInIsolate(ImageProcessingParams params) {
  final img.Image baseImage = img.decodeImage(params.bytes)!;

  // Draw labels
  for (final entry in params.labels) {
    final Offset pos = Offset(entry.key['x']!, entry.key['y']!);
    final String label = entry.value;

    if (!label.contains("EN_")) {
      drawTextWithBox(baseImage, pos, label, img.ColorRgb8(0, 0, 0));
    }
  }

  // Draw path
  for (int i = 0; i < params.pathPoints.length - 1; i++) {
    final p1 = Offset(params.pathPoints[i]['x']!, params.pathPoints[i]['y']!);
    final p2 =
        Offset(params.pathPoints[i + 1]['x']!, params.pathPoints[i + 1]['y']!);

    drawLine(baseImage, p1, p2, img.ColorRgb8(0, 255, 255), 5);
  }

  // Draw endpoint
  if (params.pathPoints.isNotEmpty) {
    final last =
        Offset(params.pathPoints.last['x']!, params.pathPoints.last['y']!);
    drawPoint(baseImage, last, img.ColorRgb8(255, 0, 0), 20);
  }

  return Uint8List.fromList(img.encodePng(baseImage));
}
