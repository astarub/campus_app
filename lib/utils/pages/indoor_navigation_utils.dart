// ignore_for_file: avoid_dynamic_calls

import 'package:campus_app/pages/navigation/data/room_graph.dart';
import 'package:campus_app/pages/navigation/models/room_label.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:flutter/material.dart';

class IndoorNavigationUtils {
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
