import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

import 'package:campus_app/pages/pathfinder/data.dart';

class PathfinderUtils {
  /// Pathfinder Page

  Future<List<LatLng>> getShortestPath(LatLng start, LatLng end) async {
    const String apiUrl = 'https://osrm.app.asta-bochum.de/route/v1/';
    const String profile = 'walking';
    final String url =
        '$apiUrl$profile/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false&alternatives=false&steps=true';

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
            'Error while finding shortest path: ${response.statusCode}. ${response.body}');
      }
    } catch (e) {
      debugPrint('Error while finding shortest path: $e');
    }
    return [];
  }
  //------------------------------------------------------------------------------------------------------
  /// Indoor Navigation

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

  void drawLine(
      img.Image image, Offset p1, Offset p2, img.Color color, int thickness) {
    final double dx = p2.dx - p1.dx;
    final double dy = p2.dy - p1.dy;
    final double length = dx.abs() > dy.abs() ? dx.abs() : dy.abs();

    final double xIncrement = dx / length;
    final double yIncrement = dy / length;

    for (int i = 0; i < length; i++) {
      for (int j = 0; j < thickness; j++) {
        final int x = (p1.dx + i * xIncrement).toInt();
        final int y = (p1.dy + i * yIncrement).toInt();

        for (int k = 0; k < thickness; k++) {
          image.setPixel(x + k, y + j, color);
        }
      }
    }
  }

  void drawTextWithBox(
      img.Image image, Offset position, String text, img.Color textColor) {
    if (text.contains("EN_")) return;

    const int fontWidth = 7;
    const int fontHeight = 16;
    const int boxPadding = 8;
    const int borderRadius = 8;

    final int textWidth = fontWidth * text.length;
    const int textHeight = fontHeight;

    final int boxWidth = textWidth + boxPadding * 2;
    final int boxHeight = textHeight + boxPadding * 2;

    final int x = position.dx.toInt();
    final int y = position.dy.toInt();
    final int boxLeft = x - boxWidth ~/ 2;
    final int boxTop = y - boxHeight ~/ 2;

    for (int i = boxTop; i < boxTop + boxHeight; i++) {
      for (int j = boxLeft; j < boxLeft + boxWidth; j++) {
        final int dx = j - boxLeft;
        final int dy = i - boxTop;

        if ((dx < borderRadius &&
                dy < borderRadius &&
                (dx - borderRadius) * (dx - borderRadius) +
                        (dy - borderRadius) * (dy - borderRadius) >
                    borderRadius * borderRadius) ||
            (dx >= boxWidth - borderRadius &&
                dy < borderRadius &&
                (dx - (boxWidth - borderRadius)) *
                            (dx - (boxWidth - borderRadius)) +
                        (dy - borderRadius) * (dy - borderRadius) >
                    borderRadius * borderRadius) ||
            (dx < borderRadius &&
                dy >= boxHeight - borderRadius &&
                (dx - borderRadius) * (dx - borderRadius) +
                        (dy - (boxHeight - borderRadius)) *
                            (dy - (boxHeight - borderRadius)) >
                    borderRadius * borderRadius) ||
            (dx >= boxWidth - borderRadius &&
                dy >= boxHeight - borderRadius &&
                (dx - (boxWidth - borderRadius)) *
                            (dx - (boxWidth - borderRadius)) +
                        (dy - (boxHeight - borderRadius)) *
                            (dy - (boxHeight - borderRadius)) >
                    borderRadius * borderRadius)) {
          continue;
        }

        if (j >= 0 && j < image.width && i >= 0 && i < image.height) {
          image.setPixel(j, i, img.ColorRgba8(255, 255, 255, 200));
        }
      }
    }

    for (int i = boxTop - 1; i <= boxTop + boxHeight; i++) {
      for (int j = boxLeft - 1; j <= boxLeft + boxWidth; j++) {
        final int dx = j - boxLeft;
        final int dy = i - boxTop;

        if ((dx == 0 || dx == boxWidth || dy == 0 || dy == boxHeight) &&
            j >= 0 &&
            j < image.width &&
            i >= 0 &&
            i < image.height) {
          image.setPixel(j, i, img.ColorRgb8(0, 0, 0));
        }
      }
    }

    final int textX = boxLeft + boxPadding;
    final int textY = boxTop + boxPadding;
    img.drawString(image, text,
        font: img.arial14, x: textX, y: textY, color: textColor);
  }

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
          final List<int> coordinates = value["Coordinates"];
          final Offset position =
              Offset(coordinates[0].toDouble(), coordinates[1].toDouble());
          drawTextWithBox(
              image,
              position,
              roomName,
              img.ColorRgb8(0, 0,
                  0)); // #TODO: Replace with static approach later -> reduce time rendering 25%
        }
      });

      for (int j = 0; j < pointsList[i].length - 1; j++) {
        drawLine(image, pointsList[i][j], pointsList[i][j + 1],
            img.ColorRgb8(0, 255, 255), 10);
      }

      drawPoint(image, pointsList[i].last, img.ColorRgb8(255, 0, 0), 20);

      final Uint8List modifiedImage = Uint8List.fromList(img.encodePng(image));

      loadedImages.add(modifiedImage);
    }

    return loadedImages;
  }
}