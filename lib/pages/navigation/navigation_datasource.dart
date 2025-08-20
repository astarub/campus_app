//! Important: This Datasource is currently NOT used!!
// TODO: Implement working synchronisation & update mechanism.

// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:campus_app/pages/navigation/data/room_graph.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class NavigationDatasource {
  final Client appwriteClient;

  static const bucketId = 'campus_navigation_graph';
  static const jsonGraphId = 'graph_data';
  static const localGraphFilename = 'campus_navigation_graph.json';

  NavigationDatasource({required this.appwriteClient});

  // Ensures the graph is up to date by comparing local and remote versions
  Future<NavigationGraph> syncGraphOnUpdate() async {
    final appDir = await getApplicationDocumentsDirectory();
    final graphFile = File(path.join(appDir.path, localGraphFilename));
    final storage = Storage(appwriteClient);

    try {
      final meta = await storage.getFile(
        bucketId: bucketId,
        fileId: jsonGraphId,
      );
      final remoteSize = meta.sizeOriginal;

      if (graphFile.existsSync()) {
        final localSize = await graphFile.length();

        // Compare graphFile sizes to check for updates
        if (localSize == remoteSize) {
          return loadGraphFromFile();
        }
      }

      // Download and write updated graph graphFile
      final bytes = await storage.getFileDownload(
        bucketId: bucketId,
        fileId: jsonGraphId,
      );

      await graphFile.writeAsBytes(bytes, flush: true);
      return loadGraphFromString(utf8.decode(bytes));
    } catch (e) {
      // Fallback: Use existing local graph
      if (graphFile.existsSync()) {
        return loadGraphFromFile();
      }

      throw Exception('No graph available locally or remotely.');
    }
  }

  // Load and parse the graph from local graphFile
  Future<NavigationGraph> loadGraphFromFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final graphFile = File('${dir.path}/$localGraphFilename');

    if (!graphFile.existsSync()) {
      throw Exception('Graph graphFile not found at ${graphFile.path}');
    }

    final jsonString = await graphFile.readAsString();
    return loadGraphFromString(jsonString);
  }

  // Decode a JSON string and reconstruct the Graph structure
  NavigationGraph loadGraphFromString(String jsonString) {
    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    final Map<NodeId, Map<String, dynamic>> graph = {};

    decoded.forEach((keyStr, value) {
      final parts = keyStr.split('-');
      final tupleKey = (parts[0], parts[1], parts[2]);

      final coords = value['Coordinates'];
      final connsRaw = value['Connections'];

      final conns = connsRaw.map<((String, String, String), int)>((conn) {
        final innerParts = (conn[0] as String).split('-');
        final innerTuple = (innerParts[0], innerParts[1], innerParts[2]);
        return (innerTuple, conn[1]);
      }).toList();

      graph[tupleKey] = {
        'Coordinates': coords,
        'Connections': conns,
      };
    });

    return graph;
  }

  // Sync map images (PNGs) from remote Appwrite bucket to local storage
  Future<void> syncMaps() async {
    final storage = Storage(appwriteClient);
    final dir = await getApplicationDocumentsDirectory();
    final mapsDir = Directory(path.join(dir.path, 'assets', 'maps'));

    if (!mapsDir.existsSync()) {
      await mapsDir.create(recursive: true); // Ensure directory exists
    }

    final bucketFiles = await storage.listFiles(bucketId: bucketId);
    final remoteMaps = <String, int>{};

    // Collect all remote .png filenames and their sizes
    for (final file in bucketFiles.files) {
      if (file.name.endsWith('.png')) {
        remoteMaps[file.name] = file.sizeOriginal;
      }
    }

    // Read existing local .png files
    final localFiles = mapsDir.listSync().whereType<File>().where((f) => f.path.endsWith('.png')).toList();

    final localMap = <String, File>{};
    for (final file in localFiles) {
      localMap[path.basename(file.path)] = file;
    }

    // Download missing or outdated files
    for (final entry in remoteMaps.entries) {
      final name = entry.key;
      final remoteSize = entry.value;
      final localFile = localMap[name];

      if (localFile == null) {
        final bytes = await storage.getFileDownload(bucketId: bucketId, fileId: name);
        final filePath = path.join(mapsDir.path, name);
        await File(filePath).writeAsBytes(bytes, flush: true);
      } else {
        final localSize = await localFile.length();
        if (localSize != remoteSize) {
          final bytes = await storage.getFileDownload(bucketId: bucketId, fileId: name);
          await localFile.writeAsBytes(bytes, flush: true);
        }
      }
    }

    // Clean up local files that no longer exist remotely
    for (final entry in localMap.entries) {
      final name = entry.key;
      if (!remoteMaps.containsKey(name)) {
        await entry.value.delete();
      }
    }
  }
}
