import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';

Future<TileLayer> buildTileLayerInIsolate() async {
  return compute(_buildTileLayerWorker, null);
}

TileLayer _buildTileLayerWorker(dynamic _) {
  return TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );
}
