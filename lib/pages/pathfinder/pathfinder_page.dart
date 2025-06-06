import 'package:campus_app/core/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/pathfinder/data.dart';
import 'package:campus_app/pages/pathfinder/indoor_nav_page.dart';
import 'package:campus_app/utils/pages/pathfinder_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/pages/pathfinder/pathfinder_onboarding.dart';

String? selectedLocationGlobal;

class RaumfinderPage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const RaumfinderPage({
    super.key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  });

  @override
  State<RaumfinderPage> createState() => RaumfinderPageState();
}

class RaumfinderPageState extends State<RaumfinderPage>
    with AutomaticKeepAliveClientMixin {
  LocationData? currentLocation;
  FocusNode focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  bool showCurrentLocation = false;
  List<String> suggestions = [];
  LatLng? symbolPosition;
  final PathfinderUtils utils = sl<PathfinderUtils>();
  List<LatLng> waypoints = [];
  bool isFirstTime = false;
  @override
  bool get wantKeepAlive => true;
  bool isSidebarOpen = false;
  bool hasProcessedGlobalLocation = false;
  bool _hasAutoUnfocused = false;

  @override
  Widget build(BuildContext context) {
    super.build(context); // <-- add this line
    if (!_hasAutoUnfocused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).unfocus();
      });
      _hasAutoUnfocused = true;
    }
    final double sidebarTop = MediaQuery.of(context).size.height / 2 - 100;
    final bool isLightTheme =
        Provider.of<ThemesNotifier>(context, listen: false).currentTheme ==
            AppThemes.light;
    final Color sidebarBackgroundColor = isLightTheme
        ? const Color.fromRGBO(245, 246, 250, 1)
        : const Color.fromRGBO(34, 40, 54, 1);
    final Color iconColor = isLightTheme ? Colors.black : Colors.white;

    // Display guide if first time use
    if (isFirstTime) {
      return PathfinderOnboardingPage(
        mainNavigatorKey: GlobalKey<NavigatorState>(),
        pageEntryAnimationKey: widget.pageEntryAnimationKey,
        pageExitAnimationKey: widget.pageExitAnimationKey,
        donePage: widget,
      );
    } else {
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
              top: 20,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Provider.of<ThemesNotifier>(context, listen: false)
                              .currentTheme ==
                          AppThemes.light
                      ? const Color.fromRGBO(245, 246, 250, 1)
                      : const Color.fromRGBO(34, 40, 54, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            return predefinedLocations.keys.where(
                              (String option) => option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  ),
                            );
                          },
                          onSelected: changeSelectedLocation,
                          optionsViewBuilder: (
                            BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options,
                          ) {
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
                            focusNode = focusNode;

                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Nach Gebäude Suchen',
                                hintStyle: TextStyle(
                                  color: Provider.of<ThemesNotifier>(
                                            context,
                                            listen: false,
                                          ).currentTheme ==
                                          AppThemes.light
                                      ? Colors.black
                                      : null,
                                ),
                              ),
                              onChanged: (value) {
                                //_updateSuggestions(value);
                              },
                              onSubmitted: changeSelectedLocation,
                            );
                          },
                        ),
                      ),
                      CampusIconButton(
                        iconPath: 'assets/img/icons/search.svg',
                        backgroundColorDark:
                            Provider.of<ThemesNotifier>(context, listen: false)
                                        .currentTheme ==
                                    AppThemes.light
                                ? const Color.fromRGBO(245, 246, 250, 1)
                                : const Color.fromRGBO(34, 40, 54, 1),
                        backgroundColorLight:
                            Provider.of<ThemesNotifier>(context, listen: false)
                                        .currentTheme ==
                                    AppThemes.light
                                ? const Color.fromRGBO(245, 246, 250, 1)
                                : const Color.fromRGBO(34, 40, 54, 1),
                        borderColorDark:
                            Provider.of<ThemesNotifier>(context, listen: false)
                                        .currentTheme ==
                                    AppThemes.light
                                ? const Color.fromRGBO(245, 246, 250, 1)
                                : const Color.fromRGBO(34, 40, 54, 1),
                        transparent: true,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: sidebarTop + 45,
              right: isSidebarOpen ? 50 : 0,
              child: GestureDetector(
                onTap: toggleSidebar,
                child: Container(
                  width: 20,
                  height: 60,
                  decoration: BoxDecoration(
                    color: sidebarBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isSidebarOpen ? Icons.arrow_right : Icons.arrow_left,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: sidebarTop,
              right: isSidebarOpen ? 0 : -50,
              child: Container(
                width: 50,
                height: 150,
                decoration: BoxDecoration(
                  color: sidebarBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.local_grocery_store,
                          color: iconColor, size: 30),
                      onPressed: () => calcNearestLoc(emergencyAssemblyPoints),
                      tooltip: 'Snackautomat',
                    ),
                    IconButton(
                      icon: Icon(Icons.restaurant, color: iconColor, size: 30),
                      onPressed: () => calcNearestLoc(vendingMachines),
                      tooltip: 'Restaurants',
                    ),
                    IconButton(
                      icon: Icon(Icons.local_hospital,
                          color: iconColor, size: 30),
                      onPressed: () => calcNearestLoc(vendingMachines),
                      tooltip: 'Notfall',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO: Move function call into indoorNav (and remove asnyc above)
            /*
            final graph2 = await ensureLatestGraph();
            graph = graph2;
            await syncMapImages();
            */
            //------
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IndoorNavigation()),
            );
          },
          backgroundColor:
              Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
          child: SvgPicture.asset(
            'assets/img/icons/door-closed.svg',
            colorFilter: ColorFilter.mode(
              Provider.of<ThemesNotifier>(context, listen: false)
                          .currentTheme ==
                      AppThemes.light
                  ? Colors.black
                  : const Color.fromRGBO(184, 186, 191, 1),
              BlendMode.srcIn,
            ),
            width: 24,
          ),
        ),
      );
    }
  }

  Future<void> changeSelectedLocation(String selectedOption) async {
    final String buildingName = selectedOption.split(' ')[0];

    searchController.text = selectedOption;
    selectedLocationGlobal = selectedOption;

    searchController.text = selectedOption;
    placeSymbol(buildingName);
    try {
      if (currentLocation == null) return;

      final LatLng startLocation = LatLng(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      );
      final LatLng endLocation = predefinedLocations[buildingName]!;

      await setShortestPath(startLocation, endLocation);

      setState(() {
        showCurrentLocation = true;
      });
    } catch (e, stacktrace) {
      debugPrint('Error $stacktrace');
    }
  }

  Future<void> checkFirstTimeUser() async {
    setState(() {
      isFirstTime = Provider.of<SettingsHandler>(context, listen: false)
          .currentSettings
          .firstTimePathfinder;
    });

    if (isFirstTime) {
      Provider.of<SettingsHandler>(context, listen: false).currentSettings =
          Provider.of<SettingsHandler>(context, listen: false)
              .currentSettings
              .copyWith(firstTimePathfinder: false);
    }
  }

  @override
  void initState() {
    super.initState();

    setInitialLocation();
    checkFirstTimeUser();
    addGraphEntriesToPredefinedLocations();

    predefinedLocations = Map.fromEntries(
      predefinedLocations.entries.toList()
        ..sort((e1, e2) => e1.key.compareTo(e2.key)),
    );
  }

  void placeSymbol(String locationKey) {
    if (predefinedLocations.containsKey(locationKey)) {
      setState(() {
        symbolPosition = predefinedLocations[locationKey];
        debugPrint('Position aktualisiert!');
      });
    }
  }

  Future<void> setInitialLocation() async {
    try {
      waypoints = [];

      final Location location = Location();

      final LocationData currentLocation2 = await location.getLocation();

      setState(() {
        currentLocation = currentLocation2;
        showCurrentLocation = true;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> setShortestPath(LatLng start, LatLng end) async {
    setState(() {
      waypoints = [];
    });

    final List<LatLng> newWaypoints = await utils.getShortestPath(start, end);

    setState(() {
      waypoints = newWaypoints;
      focusNode.unfocus();
    });

    if (suggestions.isNotEmpty) {
      searchController.text = suggestions.first;
    }
  }

  void addGraphEntriesToPredefinedLocations() {
    String findClosestMatch(String target, List<String> candidates) {
      int computeSimilarity(String a, String b) {
        final int minLength = a.length < b.length ? a.length : b.length;
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
        final int similarity = computeSimilarity(target, candidate);
        if (similarity > maxSimilarity) {
          maxSimilarity = similarity;
          closest = candidate;
        }
      }

      return closest ?? '';
    }

    graph.forEach((key, value) {
      final building = key.$1;
      final level = key.$2;
      final room = key.$3;

      if (!room.contains('EN_')) {
        final name = '$building $level/$room';
        final closestMatchKey = findClosestMatch(
          name,
          predefinedLocations.keys.toList(),
        );

        if (closestMatchKey.isNotEmpty) {
          predefinedLocations.putIfAbsent(
            name,
            () => predefinedLocations[closestMatchKey]!,
          );
        }
      }
    });
    setState(() {
      //todo
    });
  }

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  Future<void> calcNearestLoc(Map<String, LatLng> locations) async {
    if (currentLocation == null) {
      return;
    }
    final LatLng currentPos = LatLng(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );

    final Distance distance = const Distance();
    String? nearestKey;
    double minDistance = double.infinity;
    locations.forEach((key, loc) {
      final double dist = distance(currentPos, loc);
      if (dist < minDistance) {
        minDistance = dist;
        nearestKey = key;
      }
    });

    if (nearestKey != null) {
      final LatLng destination = locations[nearestKey]!;
      setState(() {
        symbolPosition = destination;
      });

      await setShortestPath(currentPos, destination);
      setState(() {
        showCurrentLocation = true;
      });
    } else {
      return;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasProcessedGlobalLocation &&
        selectedLocationGlobal != null &&
        selectedLocationGlobal!.isNotEmpty) {
      hasProcessedGlobalLocation = true;
      Future.delayed(Duration(milliseconds: 100), () {
        final location = selectedLocationGlobal!;
        searchController.text = location;
        final query = searchController.text.trim();
        if (query.isNotEmpty) {
          changeSelectedLocation(query);
        }
      });
    }
    print("Executed");
  }
}
