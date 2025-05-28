import 'dart:convert';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

//Appwrite config 
const _endpoint  = 'https://cloud.appwrite.io/v1';
const _projectId = '683738fe00196a8dc468';
const _bucketId  = 'maps';        // bucket holds both jpgs and graph.json
const _graphFile = 'graph.json';

Client _client() => Client()
  ..setEndpoint(_endpoint)
  ..setProject(_projectId);

Future<void> syncMapsWithServer() async {
  print('Map-sync started…');
  final dir = await _localMapsDir();

  try {
    final storage = Storage(_client());

    final remote = await storage.listFiles(
      bucketId: _bucketId,
      queries: [Query.equal('mimeType', ['image/jpeg'])],
    );
    final wanted = <String, String>{
      for (var f in remote.files) f.name: f.$id
    };

    final localFiles = <String>{
      for (var f in await dir.list().toList())
        if (f is File) p.basename(f.path)
    };

    for (final entry in wanted.entries) {
      if (!localFiles.contains(entry.key)) {
        try {
          final bytes = await storage.getFileDownload(
            bucketId: _bucketId,
            fileId: entry.value,
          );
          final tmp = File(p.join(dir.path, '.tmp_${entry.key}'));
          await tmp.writeAsBytes(bytes, flush: true);
          await tmp.rename(p.join(dir.path, entry.key));
          print('${entry.key}');
        } catch (e) {
          print('Could not download ${entry.key}: $e');
        }
      }
    }

    for (final stray in localFiles.difference(wanted.keys.toSet())) {
      try {
        await File(p.join(dir.path, stray)).delete();
        print('$stray');
      } catch (e) {
        print('Could not delete $stray: $e');
      }
    }

    print('Map-sync finished (folder: ${dir.path})');
  } catch (e) {
    print('Map-sync failed, using existing images: $e');
  }
}



typedef NodeKey = (String, String, String);
typedef Graph   = Map<NodeKey, Map<String, dynamic>>;
Future<Graph> syncGraphWithServer(Graph localGraph) async {
  print('Graph-sync started…');

  try {
    final storage = Storage(_client());
    final bytes   = await storage.getFileDownload(
      bucketId: _bucketId,
      fileId:   _graphFile,
    );
    final serverJson = utf8.decode(bytes);

    final localJson = jsonEncode(_encodeGraph(localGraph));
    if (serverJson == localJson) {
      print('Graph already up-to-date.');
      return localGraph;
    }

    final Graph? serverGraph = _safeDecodeGraph(serverJson);
    if (serverGraph == null) {
      print('Server graph malformed → keeping local copy.');
      return localGraph;
    }

    final docs = await getApplicationDocumentsDirectory();
    final file = File(p.join(docs.path, _graphFile));
    await file.writeAsString(serverJson, flush: true);

    print('Graph updated (${serverGraph.length} nodes).');
    return serverGraph;
  } catch (e) {
    print('Graph-sync failed, keeping local copy: $e');
    return localGraph;                    
  }
}


dynamic _encodeGraph(dynamic value) {
  if (value is Map) {
    return value.map((k, v) {
      final keyStr = '${k.$1}|${k.$2}|${k.$3}';   
      return MapEntry(keyStr, _encodeGraph(v));
    });
  }
  if (value is List) return value.map(_encodeGraph).toList();
  if (value is NodeKey) return '${value.$1}|${value.$2}|${value.$3}';
  return value;
}

Graph? _safeDecodeGraph(String json) {
  try {
    final raw = jsonDecode(json);
    final decoded = _decodeGraph(raw);
    return Map<NodeKey, Map<String, dynamic>>.from(decoded);
  } catch (_) {
    return null;                             
  }
}

dynamic _decodeGraph(dynamic value) {
  if (value is Map) {
    return value.map((k, v) => MapEntry(_toKey(k), _decodeGraph(v)));
  }
  if (value is List) return value.map(_decodeGraph).toList();
  return value;
}

NodeKey _toKey(Object k) {
  if (k is String) {
    final p = k.split('|');
    if (p.length == 3) return (p[0], p[1], p[2]);
  }
  return ('', '', '');
}
