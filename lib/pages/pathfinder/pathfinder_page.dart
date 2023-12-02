import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/backend/entities/study_course_entity.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/home/widgets/study_course_popup.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/constants.dart';

class RaumfinderPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const RaumfinderPage({
    Key? key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<RaumfinderPage> createState() => RaumfinderPageState();
}

class RaumfinderPageState extends State<RaumfinderPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<RaumfinderPage> {
  TextEditingController searchController = TextEditingController();
  FocusNode globalFocusNode = FocusNode();
  LocationData? currentLocation;
  LatLng? symbolPosition;
  List<LatLng> waypoints = [];
  List<String> suggestions = [];

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

  Future<void> getLocation() async {
    waypoints = [];
    final Location location = Location();

    try {
      currentLocation = await location.getLocation();
      setState(() {});
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> getShortestPath(LatLng start, LatLng end) async {
    const String apiUrl = '$osrmBackend/route/v1/';
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
          final List<dynamic> legs = Map<String, dynamic>.from(routes[0])['legs'];
          for (final leg in legs) {
            final List<dynamic> steps = Map<String, dynamic>.from(leg)['steps'];
            for (final step in steps) {
              final String geometry = Map<String, dynamic>.from(step)['geometry'];
              final List<LatLng> coordinates =
                  PolylinePoints().decodePolyline(geometry).map((e) => LatLng(e.latitude, e.longitude)).toList();
              newWaypoints.addAll(coordinates);
            }
          }
        }

        setState(() {
          waypoints = newWaypoints;
          globalFocusNode.unfocus();
        });
        searchController.text = suggestions.first;
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void placeSymbol(String locationKey) {
    if (predefinedLocations.containsKey(locationKey)) {
      setState(() {
        symbolPosition = predefinedLocations[locationKey];
      });
    }
  }

  String getFaculty() {
    final currentSettings = Provider.of<SettingsHandler>(context, listen: false).currentSettings;

    if (currentSettings.selectedStudyCourses.isNotEmpty) {
      return currentSettings.selectedStudyCourses.first.faculty;
    } else {
      widget.mainNavigatorKey.currentState?.push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) => StudyCoursePopup(
            callback: (List<StudyCourse> selectedCourse) {
              return currentSettings.studyCourses.first.faculty;
            },
          ),
        ),
      );
    }
    return '';
  }

  bool _isVotingButtonVisible() {
    final DateTime currentDate = DateTime.now().toUtc().toLocal();
    final DateTime startDate = DateTime(2023, 11, 30).toUtc().toLocal();
    final DateTime endDate = DateTime(2023, 12, 8).toUtc().toLocal();

    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }

  TileLayer buildTileLayer() {
    try {
      return TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      );
    } catch (e) {
      debugPrint('An exception occurred: $e');

      return TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
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
                        searchController.text = selectedOption;
                        final LatLng startLocation = LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        );
                        final LatLng endLocation = predefinedLocations[selectedOption]!;
                        getShortestPath(startLocation, endLocation);
                        placeSymbol(selectedOption);
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
                        globalFocusNode = focusNode;
                        searchController = textEditingController;

                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: 'Suche',
                            labelStyle: Provider.of<ThemesNotifier>(context)
                                .currentThemeData
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme ==
                                          AppThemes.light
                                      ? Colors.black
                                      : null,
                                ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.only(left: 17, bottom: 17),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          style: Provider.of<ThemesNotifier>(context)
                              .currentThemeData
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: 16,
                                color:
                                    Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                                        ? Colors.black
                                        : null,
                              ),
                          onEditingComplete: () {
                            final LatLng startLocation = LatLng(
                              currentLocation!.latitude!,
                              currentLocation!.longitude!,
                            );
                            final LatLng endLocation = predefinedLocations[textEditingController.text]!;
                            getShortestPath(startLocation, endLocation);
                            placeSymbol(textEditingController.text);
                          },
                          onChanged: (String value) {
                            searchController.text = value;
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 11),
                    child: CampusIconButton(
                      iconPath: 'assets/img/icons/search.svg',
                      onTap: () {
                        final String enteredLocation = searchController.text.trim();
                        if (predefinedLocations.containsKey(enteredLocation)) {
                          final LatLng startLocation = LatLng(
                            currentLocation!.latitude!,
                            currentLocation!.longitude!,
                          );
                          final LatLng endLocation = predefinedLocations[enteredLocation]!;
                          getShortestPath(startLocation, endLocation);
                          placeSymbol(searchController.text);
                        } else {
                          debugPrint('Invalid location entered');
                        }
                      },
                      transparent: true,
                      backgroundColorDark:
                          Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                              ? const Color.fromRGBO(245, 246, 250, 1)
                              : const Color.fromRGBO(34, 40, 54, 1),
                      backgroundColorLight:
                          Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                              ? const Color.fromRGBO(245, 246, 250, 1)
                              : const Color.fromRGBO(34, 40, 54, 1),
                      borderColorDark:
                          Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                              ? const Color.fromRGBO(245, 246, 250, 1)
                              : const Color.fromRGBO(34, 40, 54, 1),
                      borderColorLight:
                          Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                              ? const Color.fromRGBO(245, 246, 250, 1)
                              : const Color.fromRGBO(34, 40, 54, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 20,
            child: _isVotingButtonVisible()
                ? ElevatedButton(
                    onPressed: () {
                      String locationKey = getFaculty();

                      if (locationKey.isEmpty) return;

                      locationKey = 'Wahlurne: $locationKey';

                      searchController.text = locationKey;

                      placeSymbol(locationKey);

                      final LatLng startLocation = LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      );
                      final LatLng? endLocation = predefinedLocations[locationKey];

                      getShortestPath(startLocation, endLocation!);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.blue,
                      elevation: 10,
                      shadowColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.secondary,
                    ),
                    child: SvgPicture.asset(
                      'assets/img/icons/vote.svg',
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      width: 30,
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  // Keep state alive
  @override
  bool get wantKeepAlive => true;
}
