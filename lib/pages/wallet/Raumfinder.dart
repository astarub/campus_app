import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class RaumfinderPage extends StatefulWidget {
  const RaumfinderPage({Key? key}) : super(key: key);

  @override
  State<RaumfinderPage> createState() => _RaumfinderPageState();
}

class _RaumfinderPageState extends State<RaumfinderPage> {
  LocationData? currentLocation;
  List<LatLng> waypoints = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final Map<String, LatLng> predefinedLocations = {
    "UFO": LatLng(51.448051, 7.259111),
    "U35-Haltestelle": LatLng(51.447198, 7.259043),
    "UNICENTER": LatLng(51.447985, 7.258623),
    "MZ": LatLng(51.446053, 7.259574),
    "SH": LatLng(51.445724, 7.259661),
    "SSC": LatLng(51.446138, 7.260922),
    "UV": LatLng(51.445772, 7.260552),
    "UB": LatLng(51.445127, 7.260327),
    "GAMINGHUB": LatLng(51.445211, 7.259726),
    "REPAIR CAFE": LatLng(51.445029, 7.259882),
    "AUDIMAX": LatLng(51.444118, 7.261505),
    "MENSA": LatLng(51.443282, 7.262258),
    "VZ": LatLng(51.442925, 7.262552),
    "CASPO": LatLng(51.442723, 7.262436),
    "MA": LatLng(51.444993, 7.258908),
    "MB/TZR": LatLng(51.444652, 7.2577),
    "MC/VC": LatLng(51.444214, 7.256587),
    "MAFO": LatLng(51.444733, 7.259557),
    "MABF": LatLng(51.445159, 7.258016),
    "HMA": LatLng(51.444392, 7.258677),
    "KULTUR CAFE": LatLng(51.445886, 7.259654),
    "FNO": LatLng(51.445254, 7.261878),
    "HZO": LatLng(51.44478, 7.262698),
    "IA": LatLng(51.445949, 7.262607),
    "IB": LatLng(51.446348, 7.263733),
    "IC": LatLng(51.446741, 7.264835),
    "ID": LatLng(51.447127, 7.266222),
    //"ZGH": LatLng(),
    "HIA": LatLng(51.445592, 7.263637),
    "ICFW": LatLng(51.446185, 7.264557),
    "HIB": LatLng(51.446009, 7.26471),
    "ICFO": LatLng(51.446595, 7.265687),
    "HIC": LatLng(51.446461, 7.26581),
    "HID": LatLng(51.446809, 7.266467),
    "CC": LatLng(51.443973, 7.259845),
    "Q-WEST": LatLng(51.44403, 7.258903),
    "GA": LatLng(51.443491, 7.25955),
    "GB": LatLng(51.443106, 7.25845),
    "GC": LatLng(51.442715, 7.257316),
    "GD": LatLng(51.44226, 7.256181),
    "HGA": LatLng(51.443737, 7.259958),
    "HGB": LatLng(51.443342, 7.258866),
    "HGC": LatLng(51.442974, 7.257662),
    "GCFW": LatLng(51.442346, 7.256945),
    "GAFO": LatLng(51.442847, 7.260564),
    "GABF": LatLng(51.442539, 7.259553),
    "GBCF": LatLng(51.442138, 7.258386),
    "UniKids": LatLng(51.441977, 7.261644),
    "NB": LatLng(51.444603, 7.264508),
    "NC": LatLng(51.445032, 7.26556),
    "ND": LatLng(51.445321, 7.266759),
    "HNA": LatLng(51.444544, 7.263566),
    "HNB": LatLng(51.445048, 7.265095),
    "HNC": LatLng(51.445389, 7.266204),
    "NBCF": LatLng(51.444019, 7.265737),
    "NCDF": LatLng(51.444437, 7.266948),
    "NDEF": LatLng(51.444832, 7.26814),
    "ZN": LatLng(51.44509, 7.268653),
    "NT": LatLng(51.443536, 7.265527),
    "RUBION": LatLng(51.443657, 7.266155),
    "Isotopenlabor": LatLng(51.444018, 7.267117),
    "ZEMOS": LatLng(51.445633, 7.268131),
    "BMZ": LatLng(51.444561, 7.255235),
    "ZKF": LatLng(51.445523, 7.258071),
    "IAN": LatLng(51.446647, 7.261938),
    "IBN": LatLng(51.447, 7.262752),
    "ICN": LatLng(51.447448, 7.263219),
    "IDN": LatLng(51.447889, 7.263472),
  };

  // Example for later date
  final Map data = {
    "Bib": const [
      "51.447105",
      "7.259231",
      "Bibiothek",
      "htps://www.rub.de/",
      "Description: Toller Ort",
      "xyz.jpeg",
    ],
  };

  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    waypoints = [];
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
      setState(() {});
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  // Add other methods from your original code here...
  Future<void> _getShortestPath(LatLng start, LatLng end) async {
    const String apiUrl = 'http://router.project-osrm.org/route/v1/';
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

        List<LatLng> newWaypoints = [];

        List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          List<dynamic> legs = routes[0]['legs'];
          for (var leg in legs) {
            List<dynamic> steps = leg['steps'];
            for (var step in steps) {
              String geometry = step['geometry'];
              List<LatLng> coordinates =
                  PolylinePoints().decodePolyline(geometry).map((e) => LatLng(e.latitude, e.longitude)).toList();
              newWaypoints.addAll(coordinates);
            }
          }
        }

        setState(() {
          waypoints = newWaypoints;
          _focusNode.unfocus();
        });

        // Update the text in the search controller with the most probable key
        _searchController.text = suggestions.first;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _updateSuggestions(String query) {
    suggestions = [];
    predefinedLocations.forEach((key, value) {
      if (key.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(key);
      }
    });

    if (suggestions.isEmpty && query.isNotEmpty) {
      String mostProbableKey = _findMostProbableKey(query);
      suggestions.add(mostProbableKey);
    }

    setState(() {});
  }

  String _findMostProbableKey(String query) {
    String mostProbableKey = '';
    int minDistance = double.maxFinite.toInt();

    for (var key in predefinedLocations.keys) {
      int distance = _calculateLevenshteinDistance(query.toLowerCase(), key.toLowerCase());
      if (distance < minDistance) {
        minDistance = distance;
        mostProbableKey = key;
      }
    }

    return mostProbableKey;
  }

  int _calculateLevenshteinDistance(String a, String b) {
    List<List<int>> dp = List.generate(a.length + 1, (index) => List<int>.filled(b.length + 1, 0));

    for (int i = 0; i <= a.length; i++) {
      for (int j = 0; j <= b.length; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else {
          dp[i][j] = _min(dp[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1), _min(dp[i - 1][j] + 1, dp[i][j - 1] + 1));
        }
      }
    }

    return dp[a.length][b.length];
  }

  int _min(int a, int b) => (a < b) ? a : b;

  void _displayInfo(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raumfinder'),
      ),
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
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              if (waypoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: waypoints,
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
              CurrentLocationLayer(
                style: LocationMarkerStyle(
                  marker: const DefaultLocationMarker(
                    color: Color.fromARGB(255, 48, 79, 182),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  markerSize: const Size.square(40),
                  accuracyCircleColor: const Color.fromARGB(255, 48, 79, 182).withOpacity(0.1),
                  headingSectorColor: const Color.fromARGB(255, 48, 79, 182).withOpacity(0.8),
                  headingSectorRadius: 120,
                ),
                moveAnimationDuration: Duration.zero,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: const LatLng(51.444444, 7.261321),
                    rotate: true,
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        _displayInfo(context);
                      },
                      child: const Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 255, 17, 0),
                        size: 20.0,
                      ),
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
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 20, 20, 39),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Search locations',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 252, 252), // Set your desired color here
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        _updateSuggestions(value);
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      String enteredLocation = _searchController.text.trim();
                      if (predefinedLocations.containsKey(enteredLocation)) {
                        LatLng startLocation = LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        );
                        LatLng endLocation = predefinedLocations[enteredLocation]!;
                        _getShortestPath(startLocation, endLocation);
                      } else if (suggestions.isNotEmpty) {
                        LatLng startLocation = LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        );
                        LatLng endLocation = predefinedLocations[suggestions.first]!;
                        _getShortestPath(startLocation, endLocation);
                      } else {
                        print('Invalid location entered');
                      }
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
    );
  }
}

/*
To-do:
1) Replace OSM and OSRM dummy Server with real ones
2) Optional: Add Explore-Markers
*/
