// ignore_for_file: avoid_dynamic_calls, avoid_print, prefer_single_quotes, require_trailing_commas, unused_local_variable, use_super_parameters, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, prefer_final_locals, type_annotate_public_apis, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:campus_app/pages/pathfinder/maps/indoor_nav_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:flutter/services.dart';
import 'package:campus_app/pages/pathfinder/data.dart';

String? selectedLocationGlobal;

class RaumfinderPage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const RaumfinderPage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<RaumfinderPage> createState() => RaumfinderPageState();
}

class RaumfinderPageState extends State<RaumfinderPage> {
  LocationData? currentLocation;
  List<LatLng> waypoints = [];
  final TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<String> suggestions = [];
  bool showCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    _addGraphEntriesToPredefinedLocations();
    _getLocation();
  }

  void _addGraphEntriesToPredefinedLocations() {
    String _findClosestMatch(String target, List<String> candidates) {
      int computeSimilarity(String a, String b) {
        int minLength = a.length < b.length ? a.length : b.length;
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
        int similarity = computeSimilarity(target, candidate);
        if (similarity > maxSimilarity) {
          maxSimilarity = similarity;
          closest = candidate;
        }
      }

      return closest ?? '';
    }

    graph.forEach((key, value) {
      // Access individual parts of the key
      final building = key.$1; // First element
      final level = key.$2; // Second element
      final room = key.$3; // Third element

      // Skip entries where room contains "EN_"
      if (!room.contains('EN_')) {
        // Combine them into a single name to add to predefinedLocations
        final name = "$building $level/$room";

        // Find the closest predefined location key
        final closestMatchKey = _findClosestMatch(
          name,
          predefinedLocations.keys.toList(),
        );

        // If a closest match is found, use its LatLng value
        if (closestMatchKey.isNotEmpty) {
          predefinedLocations.putIfAbsent(
            name,
            () => predefinedLocations[closestMatchKey]!,
          );
        }
      }
    });

    // Print the final predefinedLocations after all updates
    print("Updated predefinedLocations: $predefinedLocations");

    setState(() {
      // Triggering setState ensures the UI is updated.
    });
  }

  Future<void> _getLocation() async {
    try {
      waypoints = [];
      final Location location = Location();
      final LocationData currentLocation2 = await location.getLocation();
      setState(() {
        currentLocation = currentLocation2;
        showCurrentLocation = true;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getShortestPath(LatLng start, LatLng end) async {
    const String apiUrl = 'https://osrm.app.asta-bochum.de/route/v1/';
    const String profile = 'walking';
    final String url =
        '$apiUrl$profile/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false&alternatives=false&steps=true';

    setState(() {
      waypoints = [];
    });

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
              final List<LatLng> coordinates = PolylinePoints()
                  .decodePolyline(geometry)
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList();
              newWaypoints.addAll(coordinates);
            }
          }
        }

        setState(() {
          waypoints = newWaypoints;
          _focusNode.unfocus();
        });

        _searchController.text = suggestions.first;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  LatLng? symbolPosition;
  void _placeSymbol(String locationKey) {
    if (predefinedLocations.containsKey(locationKey)) {
      setState(() {
        symbolPosition = predefinedLocations[locationKey];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TileLayer buildTileLayer() {
      try {
        return TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        );
      } catch (e) {
        print('An exception occurred: $e');

        return TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        );
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: currentLocation != null
                    ? LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      )
                    : const LatLng(51.442887, 7.262413),
                initialZoom: 15,
              ),
              children: [
                buildTileLayer(),
                if (waypoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: waypoints,
                        color: const Color.fromARGB(169, 33, 149, 243),
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                if (showCurrentLocation)
                  CurrentLocationLayer(
                    style: LocationMarkerStyle(
                      marker: const DefaultLocationMarker(
                        color: Color.fromARGB(255, 255, 255, 255),
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                      ),
                      markerSize: const Size.square(40),
                      accuracyCircleColor:
                          const Color.fromARGB(255, 113, 143, 243)
                              .withOpacity(0.1),
                      headingSectorColor:
                          const Color.fromARGB(255, 118, 221, 247)
                              .withOpacity(0.8),
                      headingSectorRadius: 120,
                    ),
                    moveAnimationDuration: Duration.zero,
                  ),
                MarkerLayer(
                  markers: [
                    if (symbolPosition != null)
                      Marker(
                        width: 50,
                        height: 50,
                        point: symbolPosition!,
                        rotate: true,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 0, 174, 255),
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 30,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 20, 20, 39),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return predefinedLocations.keys.where(
                            (String option) => option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()),
                          );
                        },
                        onSelected: (String selectedOption) {
                          _searchController.text = selectedOption;
                          selectedLocationGlobal =
                              selectedOption; // Store in the global variable
                          _placeSymbol(selectedOption);
                          try {
                            final LatLng startLocation = LatLng(
                              currentLocation!.latitude!,
                              currentLocation!.longitude!,
                            );
                            final LatLng endLocation =
                                predefinedLocations[selectedOption]!;
                            _getShortestPath(startLocation, endLocation);
                            setState(() {
                              showCurrentLocation = true;
                            });
                          } catch (e) {}
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          final int itemCount = options.length;
                          final double containerHeight = itemCount * 80.0;
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 300,
                                maxHeight: containerHeight,
                              ),
                              child: Material(
                                elevation: 4,
                                child: ListView(
                                  children: options
                                      .map(
                                        (String option) => GestureDetector(
                                          onTap: () {
                                            onSelected(option);
                                          },
                                          child: ListTile(
                                            title: Text(option),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          );
                        },
                        fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          _focusNode = focusNode;

                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              hintText: 'Search locations',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 252, 252),
                              ),
                            ),
                            onChanged: (value) {
                              //_updateSuggestions(value);
                            },
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                      icon: const Icon(Icons.search),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewPage()),
            );
          },
          backgroundColor: const Color.fromARGB(255, 20, 20, 39),
          child: const Icon(
            Icons.door_front_door_outlined,
            color: Colors.white,
          ),
        ));
  }
}

//-----------------------------------------------------------------------------------------------------------
