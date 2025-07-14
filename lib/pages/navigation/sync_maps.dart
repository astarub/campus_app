import 'dart:convert';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

// Appwrite configuration constants
const _endpoint = 'https://cloud.appwrite.io/v1'; //CHANGE to actual Appwrite Backend
const _projectId = '683738fe00196a8dc468'; //CHANGE
const _bucketId = 'graph'; //CHANGE
const _graphFileId = 'graph'; //CHANGE

// Type alias for a 3-part node key and the graph structure
typedef NodeKey = (String, String, String);
typedef Graph = Map<NodeKey, Map<String, dynamic>>;

// Initialize Appwrite client
Client _client() => Client()
  ..setEndpoint(_endpoint)
  ..setProject(_projectId);

// Ensures the graph is up to date by comparing local and remote versions
Future<Graph> fetchGraph() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/graph.json');
  final storage = Storage(_client());

  try {
    final meta = await storage.getFile(
      bucketId: _bucketId,
      fileId: _graphFileId,
    );
    final remoteSize = meta.sizeOriginal;

    if (await file.exists()) {
      final localSize = await file.length();

      // Compare file sizes to check for updates
      if (localSize == remoteSize) {
        return loadGraphFromFile();
      } else {}
    } else {}

    // Download and write updated graph file
    final bytes = await storage.getFileDownload(
      bucketId: _bucketId,
      fileId: _graphFileId,
    );
    await file.writeAsBytes(bytes, flush: true);
    return loadGraphFromString(utf8.decode(bytes));
  } catch (e) {
    if (await file.exists()) {
      return loadGraphFromFile();
    }

    throw Exception('No graph available locally or remotely.');
  }
}

// Serialize and save the graph to a local file
Future<void> saveGraph(Graph graph) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/graph.json');

  final Map<String, dynamic> serializable = {};

  graph.forEach((key, value) {
    final keyStr = '${key.$1}-${key.$2}-${key.$3}';
    final conns = value['Connections'] as List;

    final List<List<dynamic>> serializedConns = conns.map((conn) {
      final innerKey = conn.$1;
      final weight = conn.$2;
      final innerKeyStr = '${innerKey.$1}-${innerKey.$2}-${innerKey.$3}';
      return [innerKeyStr, weight];
    }).toList();

    serializable[keyStr] = {
      'Coordinates': value['Coordinates'],
      'Connections': serializedConns,
    };
  });

  final jsonString = jsonEncode(serializable);
  await file.writeAsString(jsonString);
}

// Load and parse the graph from local file
Future<Graph> loadGraphFromFile() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/graph.json');

  if (!await file.exists()) {
    throw Exception('Graph file not found at ${file.path}');
  }

  final jsonString = await file.readAsString();
  return loadGraphFromString(jsonString);
}

// Decode a JSON string and reconstruct the Graph structure
Graph loadGraphFromString(String jsonString) {
  final Map<String, dynamic> decoded = jsonDecode(jsonString);

  final Map<NodeKey, Map<String, dynamic>> graph = {};

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

//------------------------------------------

// Sync map images (JPGs) from remote Appwrite bucket to local storage
Future<void> syncMaps() async {
  final storage = Storage(_client());
  final dir = await getApplicationDocumentsDirectory();
  final mapsDir = Directory(path.join(dir.path, 'assets', 'maps'));

  if (!await mapsDir.exists()) {
    await mapsDir.create(recursive: true); // Ensure directory exists
  }

  final files = await storage.listFiles(bucketId: _bucketId);
  final remoteMap = <String, int>{};

  // Collect all remote .jpg filenames and their sizes
  for (final file in files.files) {
    if (file.name.endsWith('.png')) {
      remoteMap[file.name] = file.sizeOriginal;
    }
  }

  // Read existing local .jpg files
  final localFiles = mapsDir.listSync().whereType<File>().where((f) => f.path.endsWith('.png')).toList();

  final localMap = <String, File>{};
  for (final file in localFiles) {
    localMap[path.basename(file.path)] = file;
  }

  // Download missing or outdated files
  for (final entry in remoteMap.entries) {
    final name = entry.key;
    final remoteSize = entry.value;
    final localFile = localMap[name];

    if (localFile == null) {
      final bytes = await storage.getFileDownload(bucketId: _bucketId, fileId: name);
      final filePath = path.join(mapsDir.path, name);
      await File(filePath).writeAsBytes(bytes, flush: true);
    } else {
      final localSize = await localFile.length();
      if (localSize != remoteSize) {
        final bytes = await storage.getFileDownload(bucketId: _bucketId, fileId: name);
        await localFile.writeAsBytes(bytes, flush: true);
      }
    }
  }

  // Clean up local files that no longer exist remotely
  for (final entry in localMap.entries) {
    final name = entry.key;
    if (!remoteMap.containsKey(name)) {
      await entry.value.delete();
    }
  }
}
