import 'dart:convert';

import 'package:campus_app/pages/pathfinder/data.dart';
import 'package:campus_app/pages/pathfinder/models/room_label.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class PathfinderUtils {
  String buildHeadingFirstLetter(double direction) {
    if (direction >= 315 || direction < 45) {
      return 'N';
    } else if (direction >= 45 && direction < 135) {
      return 'E';
    } else if (direction >= 135 && direction < 225) {
      return 'S';
    } else if (direction >= 225 && direction < 315) {
      return 'W';
    }
    return '';
  }

// Placed outside of class scope in oder to be accesssable to isolates (currently 3)
  List findShortestPathIsolate(Map<String, dynamic> params) {
    // Dummy values
    final Map graph = params['graph'];
    final from = (params['from'][0], params['from'][1], params['from'][2]);
    final to = (params['to'][0], params['to'][1], params['to'][2]);
    // Calculate shortest path on campus
    return Dijkstra.findPathFromGraph(graph, from, to);
  }

  List<RoomLabel> getRoomLabelsFromGraph(String fn, {double scaleFactor = 0.25}) {
    final labels = <RoomLabel>[];

    graph.forEach((key, value) {
      final (building, level, roomName) = key;
      if ('$building$level.jpg' == fn) {
        final coords = value['Coordinates'];

        if (!roomName.contains('EN_')) {
          labels.add(
            RoomLabel(
              labelText: roomName,
              position: Offset(
                coords[0].toDouble() * scaleFactor,
                coords[1].toDouble() * scaleFactor,
              ),
            ),
          );
        }
      }
    });

    return labels;
  }

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
              final List<LatLng> coordinates =
                  PolylinePoints().decodePolyline(geometry).map((e) => LatLng(e.latitude, e.longitude)).toList();
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

  String transformFileName(String name) {
    if (!name.endsWith('.jpg')) return name;
    final baseName = name.substring(0, name.length - 4);
    final match = RegExp(r'^([A-Za-z]+)(\d+)$').firstMatch(baseName);
    if (match == null) return name;
    final letters = match.group(1);
    final digits = match.group(2);
    return '$letters $digits';
  }
}
