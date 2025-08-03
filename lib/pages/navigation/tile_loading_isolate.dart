import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';

// Isolate responsible for providing map tiles using backend-server
Future<TileLayer> buildTileLayerInIsolate() async {
  return compute(_buildTileLayerWorker, null);
}

TileLayer _buildTileLayerWorker(dynamic _) {
  return TileLayer(
    // URL template
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );
}
