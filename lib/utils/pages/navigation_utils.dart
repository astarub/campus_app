// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:campus_app/pages/navigation/data/room_graph.dart';
import 'package:campus_app/pages/navigation/models/room_label.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NavigationUtils {
  Map createDijkstraMapFromGraph(Map graph) {
    final Map dijkstraMap = {};

    for (final node in graph.keys) {
      final Map connectionsOfNode = {};

      for (var i = 0; i < graph[node]?['Connections'].length; i++) {
        final (connectionTo, distance) = graph[node]?['Connections'][i];
        connectionsOfNode[connectionTo] = distance;
      }

      dijkstraMap[node] = connectionsOfNode;
    }

    return dijkstraMap;
  }

  List findShortestPathIsolate(Map<String, dynamic> params) {
    final Map graph = params['graph'];
    final from = (params['from'][0], params['from'][1], params['from'][2]);
    final to = (params['to'][0], params['to'][1], params['to'][2]);

    return Dijkstra.findPathFromGraph(graph, from, to);
  }

  Future<List<LatLng>> getOutdoorPath(LatLng start, LatLng end) async {
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

  List<RoomLabel> getRoomLabelsFromGraph(String fn) {
    final labels = <RoomLabel>[];

    graph.forEach((key, value) {
      final (building, level, roomName) = key;
      if ('$building$level.png' == fn) {
        final coords = value['Coordinates'];

        // EN = Empty Node (just to draw the graph nicely)
        if (!roomName.contains('EN_')) {
          labels.add(
            RoomLabel(
              labelText: roomName,
              position: Offset(
                coords[0].toDouble(),
                coords[1].toDouble(),
              ),
            ),
          );
        }
      }
    });

    return labels;
  }

  String humanReadableRoomLabel(String labelText, {bool extended = false}) {
    String humanReadableRoomLabel;

    // Replace strokes with whitespaces
    humanReadableRoomLabel = labelText.replaceAll('-', ' ');

    // Remove direction and numbers for special rooms
    if (labelText.contains(RegExp('Aufzug|Treppe|WC|Durchgang')) && extended) {
      humanReadableRoomLabel = humanReadableRoomLabel.replaceAll(RegExp('Nord|Süd|Ost|West|Links|Rechts'), '');
      humanReadableRoomLabel = humanReadableRoomLabel.replaceAll(RegExp(r'\d'), '');
    }

    // Remove leading and trailing whitespaces
    return humanReadableRoomLabel.trim();
  }

  /// Transforms a floor file name into the human readable floor name.
  /// Example: IA04.png -> "IA 04"
  String transformFileName(String name) {
    if (!name.endsWith('.png')) return name;
    final baseName = name.substring(0, name.length - 4);
    final match = RegExp(r'^([A-Za-z]+)(\d+)$').firstMatch(baseName);
    if (match == null) return name;
    final letters = match.group(1);
    final digits = match.group(2);

    return '$letters $digits';
  }
}
