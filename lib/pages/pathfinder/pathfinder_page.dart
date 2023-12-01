// ignore_for_file: avoid_dynamic_calls, avoid_print

//import 'dart:io';
//import 'dart:math';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

//import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
//import 'package:campus_app/utils/widgets/campus_icon_button.dart';
//import 'package:campus_app/utils/constants.dart';

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

  final Map<String, LatLng> predefinedLocations = {
    'UFO': const LatLng(51.448051, 7.259111),
    'U35-Haltestelle': const LatLng(51.447198, 7.259043),
    'UNICENTER': const LatLng(51.447985, 7.258623),
    'MZ': const LatLng(51.446053, 7.259574),
    'SH': const LatLng(51.445724, 7.259661),
    'SSC': const LatLng(51.446138, 7.260922),
    'UV': const LatLng(51.445772, 7.260552),
    'UB': const LatLng(51.445127, 7.260327),
    'GAMINGHUB': const LatLng(51.445211, 7.259726),
    'REPAIR CAFE': const LatLng(51.445029, 7.259882),
    'AUDIMAX': const LatLng(51.444118, 7.261505),
    'MENSA': const LatLng(51.443282, 7.262258),
    'VZ': const LatLng(51.442925, 7.262552),
    'CASPO': const LatLng(51.442723, 7.262436),
    'MA': const LatLng(51.444993, 7.258908),
    'MB/TZR': const LatLng(51.444652, 7.2577),
    'MC/VC': const LatLng(51.444214, 7.256587),
    'MAFO': const LatLng(51.444733, 7.259557),
    'MABF': const LatLng(51.445159, 7.258016),
    'HMA': const LatLng(51.444392, 7.258677),
    'KULTUR CAFE': const LatLng(51.445886, 7.259654),
    'FNO': const LatLng(51.445254, 7.261878),
    'HZO': const LatLng(51.44478, 7.262698),
    'IA': const LatLng(51.445949, 7.262607),
    'IB': const LatLng(51.446348, 7.263733),
    'IC': const LatLng(51.446741, 7.264835),
    'ID': const LatLng(51.447127, 7.266222),
    //'ZGH': const LatLng(),
    'HIA': const LatLng(51.445592, 7.263637),
    'ICFW': const LatLng(51.446185, 7.264557),
    'HIB': const LatLng(51.446009, 7.26471),
    'ICFO': const LatLng(51.446595, 7.265687),
    'HIC': const LatLng(51.446461, 7.26581),
    'HID': const LatLng(51.446809, 7.266467),
    'CC': const LatLng(51.443973, 7.259845),
    'Q-WEST': const LatLng(51.44403, 7.258903),
    'GA': const LatLng(51.443491, 7.25955),
    'GB': const LatLng(51.443106, 7.25845),
    'GC': const LatLng(51.442715, 7.257316),
    'GD': const LatLng(51.44226, 7.256181),
    'HGA': const LatLng(51.443737, 7.259958),
    'HGB': const LatLng(51.443342, 7.258866),
    'HGC': const LatLng(51.442974, 7.257662),
    'GCFW': const LatLng(51.442346, 7.256945),
    'GAFO': const LatLng(51.442847, 7.260564),
    'GABF': const LatLng(51.442539, 7.259553),
    'GBCF': const LatLng(51.442138, 7.258386),
    'UniKids': const LatLng(51.441977, 7.261644),
    'NB': const LatLng(51.444603, 7.264508),
    'NC': const LatLng(51.445032, 7.26556),
    'ND': const LatLng(51.445321, 7.266759),
    'HNA': const LatLng(51.444544, 7.263566),
    'HNB': const LatLng(51.445048, 7.265095),
    'HNC': const LatLng(51.445389, 7.266204),
    'NBCF': const LatLng(51.444019, 7.265737),
    'NCDF': const LatLng(51.444437, 7.266948),
    'NDEF': const LatLng(51.444832, 7.26814),
    'ZN': const LatLng(51.44509, 7.268653),
    'NT': const LatLng(51.443536, 7.265527),
    'RUBION': const LatLng(51.443657, 7.266155),
    'Isotopenlabor': const LatLng(51.444018, 7.267117),
    'ZEMOS': const LatLng(51.445633, 7.268131),
    'BMZ': const LatLng(51.444561, 7.255235),
    'ZKF': const LatLng(51.445523, 7.258071),
    'IAN': const LatLng(51.446647, 7.261938),
    'IBN': const LatLng(51.447, 7.262752),
    'ICN': const LatLng(51.447448, 7.263219),
    'IDN': const LatLng(51.447889, 7.263472),

    'Wahlurne: Fakultät für Mathematik': const LatLng(51.446348, 7.263733),
    'Wahlurne: Fakultät für Geowissenschaften': const LatLng(51.446348, 7.263733),
    'Wahlurne: Fakultät für Psychologie': const LatLng(51.446348, 7.263733),
    'Wahlurne: International Graduate School of Neuroscience (IGSN)': const LatLng(51.446348, 7.263733),

    'Wahlurne: Fakultät für Maschinenbau': const LatLng(51.446741, 7.264835),
    'Wahlurne: Fakultät für Bau- und Umweltingenieurwissenschaften': const LatLng(51.446741, 7.264835),
    'Wahlurne: Interdisciplinary Centre for Advanced Materials Simulation (ICAMS)': const LatLng(51.446741, 7.264835),

    'Wahlurne: Fakultät für Elektrotechnik und Informationstechnik': const LatLng(51.447127, 7.266222),

    'Wahlurne: Fakultät für Biologie und Biotechnologie': const LatLng(51.445032, 7.26556),
    'Wahlurne: Fakultät für Chemie und Biochemie': const LatLng(51.445032, 7.26556),
    'Wahlurne: Fakultät für Physik und Astronomie': const LatLng(51.445032, 7.26556),
    'Wahlurne: Institut für Arbeitswissenschaften (IAW)': const LatLng(51.445032, 7.26556),
    'Wahlurne: Institut für Neuroinformatik (INI)': const LatLng(51.445032, 7.26556),

    'Wahlurne: Fakultät für Informatik': const LatLng(51.444993, 7.258908),
    'Wahlurne: Medizinische Fakultät': const LatLng(51.444993, 7.258908),
    'Wahlurne: sonstigen Einrichtungen': const LatLng(51.444993, 7.258908),

    'Wahlurne: Evangelisch-Theologischen Fakultät': const LatLng(51.443491, 7.25955),
    'Wahlurne: Katholisch-Theologischen Fakultät': const LatLng(51.443491, 7.25955),
    'Wahlurne: Centrum für Religionswissenschaftliche Studien (CERES)': const LatLng(51.443491, 7.25955),
    'Wahlurne: Fakultät für Philosophie und Erziehungswissenschaften': const LatLng(51.443491, 7.25955),
    'Wahlurne: Fakultät für Geschichtswissenschaft': const LatLng(51.443491, 7.25955),

    'Wahlurne: Fakultät für Philologie': const LatLng(51.443106, 7.25845),
    'Wahlurne: Fakultät für Ostasienwissenschaften': const LatLng(51.443106, 7.25845),
    'Wahlurne: Institut für Entwicklungsforschung und Entwicklungspolitik (IEE)': const LatLng(51.443106, 7.25845),

    'Wahlurne: Juristischen Fakultät': const LatLng(51.44226, 7.256181),
    'Wahlurne: Institut für Friedenssicherungsrecht und Humanitäres Völkerrecht (IFHV)':
        const LatLng(51.44226, 7.256181),
    'Wahlurne: Fakultät für Wirtschaftswissenschaft': const LatLng(51.44226, 7.256181),
    'Wahlurne: Fakultät für Sozialwissenschaft': const LatLng(51.44226, 7.256181),

    'Wahlurne: Fakultät für Sportwissenschaft': const LatLng(51.446911, 7.246478),
    'Wahlurne: Studienkolleg': const LatLng(51.446911, 7.246478),
  };

  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _showDialog() {
    const Color customAccentColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Informationen zu den Wahlen',
          style: TextStyle(
            color: customAccentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Die Ruhr-Universität Bochum führt Wahlen zum 56. Studierendenparlament und zum 8. SHK-Rat sowie eine Urabstimmung der Studierendenschaft durch. Alle Studierenden sind wahlberechtigt. Die Studierendenparlamentswahl ist eine personalisierte Listenwahl, bei der Sitze den Wahllisten entsprechend der Stimmenanzahl zugeteilt werden. Das Studierendenparlament trifft grundlegende Entscheidungen für die Studierendenschaft, darunter Haushaltsbeschlüsse, Festsetzung von Teilen des Semesterbeitrags und die Wahl und Kontrolle des Allgemeinen Studierendenausschusses (AStA). Die Wahlen finden vom 4. bis 8. Dezember 2023 statt.\n \nThe Ruhr-University Bochum is conducting elections for the 56th Student Parliament and the 8th SHK Council, as well as a referendum for the student body. All students are eligible to vote. The Student Parliament election is a personalized list election, where seats are allocated to the election lists based on the number of votes received by their respective candidates. The Student Parliament makes fundamental decisions for the student body, including budget decisions, determining parts of the semester fee, and electing and overseeing the General Student Committee (AStA). The elections will take place from December 4th to December 8th, 2023.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Ok',
              style: TextStyle(
                color: customAccentColor,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    waypoints = [];
    final Location location = Location();

    try {
      currentLocation = await location.getLocation();
      setState(() {});
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
              final List<LatLng> coordinates =
                  PolylinePoints().decodePolyline(geometry).map((e) => LatLng(e.latitude, e.longitude)).toList();
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

/*
  void _updateSuggestions(String query) {
    suggestions = [];
    predefinedLocations.forEach((key, value) {
      if (key.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(key);
      }
    });

    if (suggestions.isEmpty && query.isNotEmpty) {
      final String mostProbableKey = _findMostProbableKey(query);
      suggestions.add(mostProbableKey);
    }

    setState(() {});
  }

  String _findMostProbableKey(String query) {
    String mostProbableKey = '';
    int minDistance = double.maxFinite.toInt();

    for (var key in predefinedLocations.keys) {
      final int distance = _calculateLevenshteinDistance(query.toLowerCase(), key.toLowerCase());
      if (distance < minDistance) {
        minDistance = distance;
        mostProbableKey = key;
      }
    }

    return mostProbableKey;
  }

  int _calculateLevenshteinDistance(String a, String b) {
    final List<List<int>> dp = List.generate(a.length + 1, (index) => List<int>.filled(b.length + 1, 0));

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
*/
  //int _min(int a, int b) => (a < b) ? a : b;

  void _displayInfo(BuildContext context) {}

  LatLng? symbolPosition;
  void _placeSymbol(String locationKey) {
    if (predefinedLocations.containsKey(locationKey)) {
      setState(() {
        symbolPosition = predefinedLocations[locationKey];
      });
    }
  }

/*
  bool _isVotingButtonVisible() {
    final DateTime currentDate = DateTime.now().toUtc().toLocal();
    final DateTime startDate = DateTime(2023, 11, 30).toUtc().toLocal();
    final DateTime endDate = DateTime(2023, 12, 8).toUtc().toLocal();

    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }
*/

  //bool _dialogShown = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /*
      if (!_dialogShown) {
        _dialogShown = true;
        _showDialog();
      }
      */
    });

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
                  accuracyCircleColor: const Color.fromARGB(255, 113, 143, 243).withOpacity(0.1),
                  headingSectorColor: const Color.fromARGB(255, 118, 221, 247).withOpacity(0.8),
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
                          (String option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()),
                        );
                      },
                      onSelected: (String selectedOption) {
                        _searchController.text = selectedOption;
                        final LatLng startLocation = LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        );
                        final LatLng endLocation = predefinedLocations[selectedOption]!;
                        _getShortestPath(startLocation, endLocation);
                        _placeSymbol(selectedOption);
                      },
                      optionsViewBuilder:
                          (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
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
                            //border: InputBorder.none,
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
                      final String enteredLocation = _searchController.text.trim();
                      if (predefinedLocations.containsKey(enteredLocation)) {
                        final LatLng startLocation = LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        );
                        final LatLng endLocation = predefinedLocations[enteredLocation]!;
                        _getShortestPath(startLocation, endLocation);
                      } /*else if (suggestions.isNotEmpty) {
                        final LatLng startLocation = LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        );
                        final LatLng endLocation = predefinedLocations[suggestions.first]!;
                        _getShortestPath(startLocation, endLocation);
                      } */
                      else {
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
          /*
          Positioned(
            bottom: 25,
            right: 20,
            child: _isVotingButtonVisible()
                ? ElevatedButton(
                    onPressed: () {
                      const String locationKey = "MA"; //Dummy 
                      getFaculties();
                      _placeVotingSymbol(locationKey);
                      final LatLng startLocation = LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      );
                      LatLng? endLocation = predefinedLocations[locationKey];
                      _getShortestPath(startLocation, endLocation!);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
                      primary: Colors.blue,
                      elevation: 10,
                      shadowColor: Colors.blue,
                    ),
                    child: Icon(
                      Icons.how_to_vote,
                      size: 30,
                    ),
                  )
                : SizedBox(),
          ),*/
        ],
      ),
    );
  }
}
