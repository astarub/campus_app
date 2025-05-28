/*
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; //Added to dependencies
import 'package:firebase_storage/firebase_storage.dart'; //Added to dependencies
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:campus_app/pages/pathfinder/data.dart';

Future<void> syncFromBackend() async {
  try {
    final syncDoc =
        await FirebaseFirestore.instance.collection('sync').doc('data').get();

    if (!syncDoc.exists) {
      debugPrint('No sync data found in Firestore.');
      return;
    }

    final data = syncDoc.data()!;
    final Directory dir = await getApplicationDocumentsDirectory();

    // 1. Delete
    for (final filename in List<String>.from(data['delete'] ?? [])) {
      final file = File('${dir.path}/maps/$filename');
      if (await file.exists()) await file.delete();
    }

    // 2. Create
    final createMap = Map<String, dynamic>.from(data['create'] ?? {});
    for (final entry in createMap.entries) {
      final ref = FirebaseStorage.instance.ref(entry.value);
      final bytes = await ref.getData();
      final file = File('${dir.path}/maps/${entry.key}');
      await file.writeAsBytes(bytes!);
    }

    // 3. Overwrite
    final overwriteMap = Map<String, dynamic>.from(data['overwrite'] ?? {});
    for (final entry in overwriteMap.entries) {
      final ref = FirebaseStorage.instance.ref(entry.value);
      final bytes = await ref.getData();
      final file = File('${dir.path}/maps/${entry.key}');
      await file.writeAsBytes(bytes!, flush: true);
    }

    // 4. Locations
    predefinedLocations.clear();
    final locMap = Map<String, dynamic>.from(data['locations'] ?? {});
    for (final entry in locMap.entries) {
      predefinedLocations[entry.key] = LatLng(
        entry.value['lat'],
        entry.value['lng'],
      );
    }

    // 5. Graph
    graph.clear();
    final g = Map<String, dynamic>.from(data['graph'] ?? {});
    for (final entry in g.entries) {
      final key = jsonDecode(entry.key);
      graph[(key[0], key[1], key[2])] = Map<String, dynamic>.from(entry.value);
    }

    debugPrint('Firebase sync complete');
  } catch (e) {
    debugPrint('Firebase sync failed: $e');
  }
}
*/