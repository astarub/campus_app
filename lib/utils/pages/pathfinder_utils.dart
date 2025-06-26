import 'dart:convert';
import 'dart:math' as math;

import 'package:dijkstra/dijkstra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';
import 'package:campus_app/pages/pathfinder/data.dart';

// Placed outside of class scope in oder to be accesssable to isolates (currently 3)
List findShortestPathIsolate(Map<String, dynamic> params) {
  // Dummy values
  final Map graph = params['graph'];
  final from = (params['from'][0], params['from'][1], params['from'][2]);
  final to = (params['to'][0], params['to'][1], params['to'][2]);
  // Calculate shortest path on campus
  return Dijkstra.findPathFromGraph(graph, from, to);
}

// GUI func: modify img directly; add simple Marker Icon at target location
Future<Uint8List> drawMarkerAtEndpoint(
  Uint8List baseImageBytes,
  List<Offset> pathPoints,
  String markerAssetPath,
) async {
  final img.Image baseImage = img.decodeImage(baseImageBytes)!;

  final ByteData markerData = await rootBundle.load(markerAssetPath);
  final Uint8List markerBytes = markerData.buffer.asUint8List();
  final img.Image markerImage = img.decodeImage(markerBytes)!;

  if (pathPoints.isEmpty) return baseImageBytes;

  final Offset endpoint = pathPoints.last;
  final int dstX = (endpoint.dx - markerImage.width / 2).round();
  final int dstY = (endpoint.dy - markerImage.height / 2).round();
  img.compositeImage(baseImage, markerImage, dstX: dstX, dstY: dstY);

  return Uint8List.fromList(img.encodePng(baseImage));
}

// GUI sub-func: modify img directly; place simple circle using pixel position
void drawPoint(img.Image image, Offset point, img.Color color, int radius) {
  final int centerX = point.dx.toInt();
  final int centerY = point.dy.toInt();
  int x = radius;
  int y = 0;
  int radiusError = 1 - x;

  while (x >= y) {
    for (int i = -x; i <= x; i++) {
      image.setPixel(centerX + i, centerY + y, color);
      image.setPixel(centerX + i, centerY - y, color);
    }
    for (int i = -y; i <= y; i++) {
      image.setPixel(centerX + i, centerY + x, color);
      image.setPixel(centerX + i, centerY - x, color);
    }
    y++;

    if (radiusError < 0) {
      radiusError += 2 * y + 1;
    } else {
      x--;
      radiusError += 2 * (y - x + 1);
    }
  }
}

// GUI func: modify img directly; add line inbetween points
void drawLine(
  img.Image image,
  Offset p1,
  Offset p2,
  img.Color color,
  int thickness,
) {
  final double dx = p2.dx - p1.dx;
  final double dy = p2.dy - p1.dy;
  final double length = dx.abs() > dy.abs() ? dx.abs() : dy.abs();

  final double xIncrement = dx / length;
  final double yIncrement = dy / length;
  final int radius = (thickness / 2).round();

  for (int i = 0; i < length; i++) {
    final double x = p1.dx + i * xIncrement;
    final double y = p1.dy + i * yIncrement;

    img.drawCircle(
      image,
      x: x.toInt(),
      y: y.toInt(),
      radius: radius,
      color: color,
      antialias: true,
    );
  }
}

// Calculate and dynamically place labels using extracted information from graph
List<Rect> _drawnLabelRects = [];
void drawTextWithBox(
  img.Image image,
  Offset position,
  String text,
  img.Color textColor,
) {
  if (text.contains('EN_')) return;

  const int fontWidth = 12;
  const int fontHeight = 24;
  const int boxPadding = 5;
  const int maxRadiusSteps = 5;
  const double radiusIncrement = 15;

  final int textWidth = fontWidth * text.length;
  const int textHeight = fontHeight;
  final int boxWidth = textWidth + boxPadding;
  const int boxHeight = textHeight + boxPadding;

  Offset adjustedPosition = position;
  Rect? newLabelRect;
  bool placed = false;

  for (int r = 0; r <= maxRadiusSteps && !placed; r++) {
    final double radius = r * radiusIncrement;

    for (int angle = 0; angle < 360; angle += 45) {
      final double dx = radius * math.cos(angle * (math.pi / 180));
      final double dy = radius * math.sin(angle * (math.pi / 180));
      final Offset testPosition = position.translate(dx, dy);

      final int x = testPosition.dx.toInt();
      final int y = testPosition.dy.toInt();
      final int boxLeft = x - boxWidth ~/ 2;
      final int boxTop = y - boxHeight ~/ 2;

      final Rect candidateRect = Rect.fromLTWH(
        boxLeft.toDouble(),
        boxTop.toDouble(),
        boxWidth.toDouble(),
        boxHeight.toDouble(),
      );

      if (!_drawnLabelRects.any((r) => r.overlaps(candidateRect))) {
        newLabelRect = candidateRect;
        adjustedPosition = testPosition;
        placed = true;
        break;
      }
    }
  }

  newLabelRect ??= Rect.fromLTWH(
    position.dx - boxWidth / 2,
    position.dy - boxHeight / 2,
    boxWidth.toDouble(),
    boxHeight.toDouble(),
  );

  _drawnLabelRects.add(newLabelRect);

  final int boxLeft = adjustedPosition.dx.toInt() - boxWidth ~/ 2;
  final int boxTop = adjustedPosition.dy.toInt() - boxHeight ~/ 2;
  final int textX = boxLeft + boxPadding;
  final int textY = boxTop + boxPadding;

  const int strokeWidth = 3;
  for (int dx = -strokeWidth; dx <= strokeWidth; dx++) {
    for (int dy = -strokeWidth; dy <= strokeWidth; dy++) {
      if (dx != 0 || dy != 0) {
        img.drawString(
          image,
          text,
          font: img.arial24,
          x: textX + dx,
          y: textY + dy,
          color: img.ColorRgb8(0, 0, 0),
        );
      }
    }
  }

  // Draw main text
  img.drawString(
    image,
    text,
    font: img.arial24,
    x: textX,
    y: textY,
    color: textColor,
  );
}

class PathfinderUtils {
  /// Pathfinder Page

  Future<List<LatLng>> getShortestPath(LatLng start, LatLng end) async {
    // AStA server to request tiles from docker contained osm instance
    const String apiUrl = 'https://osrm.app.asta-bochum.de/route/v1/';
    // Limit to "walking" profile
    const String profile = 'walking';
    final String url =
        '$apiUrl$profile/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false&alternatives=false&steps=true';

    // Logic providing geo-coord to receive shortest osm route; Mode: walking; no wheelchair support available?
    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<LatLng> newWaypoints = [];

        final List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          final List<dynamic> legs = routes[0]['legs'];
          for (final leg in legs) {
            final List<dynamic> steps = leg['steps'];
            for (final step in steps) {
              final String geometry = step['geometry'];
              final List<LatLng> coordinates = PolylinePoints()
                  .decodePolyline(geometry)
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList();
              newWaypoints.addAll(coordinates);
            }
          }
        }

        return newWaypoints;
      } else {
        debugPrint(
          'Error while finding shortest path: ${response.statusCode}. ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error while finding shortest path: $e');
    }
    return [];
  }

  //------------------------------------------------------------------------------------------------------
  /// Indoor Navigation
  // Lazy-Loader developed by intern; resopnsible to load images sequentially to speed up loading time
  Future<List<Uint8List>> loadImages({
    List<dynamic> shortestPath = const [],
    List<List<Offset>> pointsList = const [],
    BuildContext? context,
  }) async {
    final List<String> filenames = [];
    final List<Uint8List> loadedImages = [];

    for (int i = 0; i < shortestPath.length; i++) {
      final (first1, first2, _) = shortestPath[i];
      final String filename = '$first1$first2.jpg';
      if (!filenames.contains(filename)) {
        filenames.add(filename);
      }
    }

    for (int i = 0; i < filenames.length; i++) {
      pointsList.add([]);
    }

    for (int i = 0; i < shortestPath.length; i++) {
      final (x1, x2, _) = shortestPath[i];
      final String name = '$x1$x2.jpg';

      for (int j = 0; j < filenames.length; j++) {
        if (filenames[j] == name) {
          final dynamic key = shortestPath[i];
          final List<int> coordinates = graph[key]!['Coordinates'];
          final Offset offset =
              Offset(coordinates[0].toDouble(), coordinates[1].toDouble());
          pointsList[j].add(offset);
        }
      }
    }

    for (int i = 0; i < filenames.length; i++) {
      final ByteData data = await DefaultAssetBundle.of(context!)
          .load('assets/maps/${filenames[i]}');
      final Uint8List bytes = data.buffer.asUint8List();
      final img.Image image = img.decodeImage(bytes)!;

      graph.forEach((key, value) {
        final (building, level, roomName) = key;
        if (filenames[i] == '$building$level.jpg') {
          final List<int> coordinates = value['Coordinates'];
          final Offset position =
              Offset(coordinates[0].toDouble(), coordinates[1].toDouble());
          drawTextWithBox(
            image,
            position,
            roomName,
            img.ColorRgb8(
              0,
              0,
              0,
            ),
          );
        }
      });

      for (int j = 0; j < pointsList[i].length - 1; j++) {
        drawLine(
          image,
          pointsList[i][j],
          pointsList[i][j + 1],
          img.ColorRgb8(0, 255, 255),
          10,
        );
      }

      drawPoint(image, pointsList[i].last, img.ColorRgb8(255, 0, 0), 20);

      final Uint8List modifiedImage = Uint8List.fromList(img.encodePng(image));

      loadedImages.add(modifiedImage);
    }

    return loadedImages;
  }
}
