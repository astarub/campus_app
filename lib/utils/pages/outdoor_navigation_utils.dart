// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:campus_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OutdoorNavigationUtils {
  Future<List<LatLng>> getOutdoorPath(LatLng start, LatLng end) async {
    // Limit to "walking" profile
    const String profile = 'walking';
    final String url =
        '$osrmBackend$profile/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false&alternatives=false&steps=true';

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

  static Map<String, LatLng> addGraphEntriesToPredefinedLocations({
    required Map<dynamic, dynamic> graphData,
    required Map<String, LatLng> predefinedLocations,
  }) {
    final Map<String, LatLng> mergedLocations = Map<String, LatLng>.from(
      predefinedLocations,
    );

    graphData.forEach((key, value) {
      final building = key.$1.toString();
      final level = key.$2.toString();
      final room = key.$3.toString();

      if (!room.contains('EN_')) {
        final name = '$building $level/$room';
        final closestMatchKey = _findClosestMatch(
          name,
          mergedLocations.keys.toList(),
        );

        if (closestMatchKey.isNotEmpty) {
          mergedLocations.putIfAbsent(
            name,
            () => mergedLocations[closestMatchKey]!,
          );
        }
      }
    });

    return mergedLocations;
  }

  static Map<String, LatLng> addGraphEntriesToPredefinedLocationsIsolate(
    Map<String, dynamic> params,
  ) {
    final rawGraph = params['graph'] as Map<dynamic, dynamic>;
    final Map<List<String>, dynamic> normalizedGraph = {
      for (final entry in rawGraph.entries) (entry.key as List<dynamic>).map((e) => e.toString()).toList(): entry.value,
    };

    final Map<String, LatLng> predefined = Map<String, LatLng>.from(
      params['predefined'],
    );

    for (final entry in normalizedGraph.entries) {
      final key = entry.key;
      final building = key[0];
      final level = key[1];
      final room = key[2];

      if (!room.contains('EN_')) {
        final name = '$building $level/$room';
        final closestMatchKey = _findClosestMatch(
          name,
          predefined.keys.toList(),
        );

        if (closestMatchKey.isNotEmpty) {
          predefined.putIfAbsent(name, () => predefined[closestMatchKey]!);
        }
      }
    }

    return predefined;
  }

  static Future<TileLayer> buildTileLayerInIsolate() async {
    return compute(_buildTileLayerWorker, null);
  }

  static Map<String, LatLng> sortPredefinedLocations(
    Map<String, LatLng> locations,
  ) {
    final sortedEntries = locations.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return Map<String, LatLng>.fromEntries(sortedEntries);
  }

  static TileLayer _buildTileLayerWorker(dynamic _) {
    return TileLayer(
      urlTemplate: 'https://api-dev-app.asta-bochum.de/tile/{z}/{x}/{y}.png',
    );
  }

  static String _findClosestMatch(String target, List<String> candidates) {
    int computeSimilarity(String a, String b) {
      final int minLength = a.length < b.length ? a.length : b.length;
      int matches = 0;

      for (int i = 0; i < minLength; i++) {
        if (a[i] == b[i]) {
          matches++;
        }
      }
      return matches;
    }

    String? closest = candidates.isNotEmpty ? candidates.first : null;
    int maxSimilarity = 0;

    for (final candidate in candidates) {
      final int similarity = computeSimilarity(target, candidate);
      if (similarity > maxSimilarity) {
        maxSimilarity = similarity;
        closest = candidate;
      }
    }

    return closest ?? '';
  }
}
