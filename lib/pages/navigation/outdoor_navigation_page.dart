import 'dart:async';
import 'dart:io';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/main.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/navigation/data/assembly_points.dart';
import 'package:campus_app/pages/navigation/data/buildings.dart';
import 'package:campus_app/pages/navigation/data/room_graph.dart';
import 'package:campus_app/pages/navigation/data/vending_machines.dart';
import 'package:campus_app/pages/navigation/indoor_navigation_page.dart';
import 'package:campus_app/pages/navigation/navigation_onboarding.dart';
import 'package:campus_app/pages/navigation/widgets/error_bubble.dart';
import 'package:campus_app/utils/pages/outdoor_navigation_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:visibility_detector/visibility_detector.dart';

String? selectedLocationGlobal;

class NavigationPage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const NavigationPage({
    super.key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  });

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage>
    with AutomaticKeepAliveClientMixin {
  LocationData? currentLocation;
  FocusNode focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  bool showCurrentLocation = false;
  List<String> suggestions = [];
  LatLng? symbolPosition;
  final OutdoorNavigationUtils utils = sl<OutdoorNavigationUtils>();
  List<LatLng> waypoints = [];
  bool isFirstTime = false;
  bool isSidebarOpen = false;
  bool hasProcessedGlobalLocation = false;
  bool hasAutoUnfocused = false;
  bool hasInitializedOnVisible = false;
  bool isInitializingOnVisible = false;
  String? navigationMessage;
  Timer? navigationMessageTimer;
  final Location locationService = Location.instance;
  final MapController mapController = MapController();
  Future<VectorTileLayer>? tileLayerFuture;
  bool isTileLoading = true;
  @override
  bool get wantKeepAlive => true;

  Future<void> addGraphEntriesInIsolate() async {
    final result = await compute(
      OutdoorNavigationUtils.addGraphEntriesToPredefinedLocationsIsolate,
      {
        'graph': graph.map((k, v) => MapEntry([k.$1, k.$2, k.$3], v)),
        'predefined': predefinedLocations,
      },
    );

    setState(() {
      predefinedLocations = result;
    });
  }

  void addGraphEntriesToPredefinedLocations() {
    final mergedLocations =
        OutdoorNavigationUtils.addGraphEntriesToPredefinedLocations(
      graphData: graph,
      predefinedLocations: predefinedLocations,
    );
    setState(() {
      predefinedLocations = mergedLocations;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentThemeData =
        Provider.of<ThemesNotifier>(context).currentThemeData;

    super.build(context);
    if (!hasAutoUnfocused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).unfocus();
      });
      hasAutoUnfocused = true;
    }
    final bool isLightTheme =
        Provider.of<ThemesNotifier>(context, listen: false).currentTheme ==
            AppThemes.light;
    final bool isPhoneLayout = MediaQuery.of(context).size.shortestSide < 600;
    final double bottomNavHeight = Platform.isIOS ? 88 : 98;
    final double homePageBottomPadding = Platform.isIOS ? 80 : 60;
    final double fabBottomOffset =
        isPhoneLayout ? (bottomNavHeight - homePageBottomPadding + 12) : 0;
    final Color indoorButtonBackgroundColor = isLightTheme
        ? Color.alphaBlend(
            const Color.fromRGBO(165, 216, 255, 0.32),
            Colors.white,
          )
        : currentThemeData.colorScheme.surface;
    final Color indoorButtonTextColor = isLightTheme
        ? const Color.fromRGBO(128, 195, 255, 1)
        : currentThemeData.colorScheme.secondary;
    final Color indoorButtonIconColor = isLightTheme
        ? const Color.fromRGBO(128, 195, 255, 1)
        : currentThemeData.colorScheme.secondary;
    final Color indoorButtonIconHighlightColor = isLightTheme
        ? const Color.fromRGBO(165, 216, 255, 0.35)
        : Colors.transparent;

    // Display guide if first time use
    if (isFirstTime) {
      return PathfinderOnboardingPage(
        mainNavigatorKey: GlobalKey<NavigatorState>(),
        pageEntryAnimationKey: widget.pageEntryAnimationKey,
        pageExitAnimationKey: widget.pageExitAnimationKey,
        donePage: widget,
      );
    } else {
      Widget buildTileLayer() {
        return FutureBuilder<VectorTileLayer>(
          future: tileLayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      }

      return PopScope(
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          homeKey.currentState!.setSwipeDisabled();
          Navigator.of(context).pop();
        },
        child: VisibilityDetector(
          key: const Key('indoor-visibility-key'),
          onVisibilityChanged: (info) {
            final bool isVisible = info.visibleFraction > 0;

            if (isVisible) {
              initializeOnFirstVisible();
              if (homeKey.currentState != null) {
                homeKey.currentState!.setSwipeDisabled(disableSwipe: true);
              }
            }
          },
          child: Scaffold(
            backgroundColor: currentThemeData.colorScheme.surface,
            resizeToAvoidBottomInset: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.only(
                    top: Platform.isAndroid ? 20 : 0,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Align(
                      child: Text(
                        'Navigation',
                        style: currentThemeData.textTheme.displayMedium,
                      ),
                    ),
                  ),
                ),
                // Map
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Provider.of<ThemesNotifier>(context)
                          .currentThemeData
                          .cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: mapController,
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
                                    color:
                                        const Color.fromARGB(169, 33, 149, 243),
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
                                          .withValues(alpha: 0.1),
                                  headingSectorColor:
                                      const Color.fromARGB(255, 118, 221, 247)
                                          .withValues(alpha: 0.8),
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
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      size: 40,
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
                              color: Provider.of<ThemesNotifier>(context,
                                              listen: false)
                                          .currentTheme ==
                                      AppThemes.light
                                  ? const Color.fromRGBO(245, 246, 250, 1)
                                  : const Color.fromRGBO(34, 40, 54, 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Autocomplete<String>(
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        return predefinedLocations.keys.where(
                                          (String option) =>
                                              option.toLowerCase().contains(
                                                    textEditingValue.text
                                                        .toLowerCase(),
                                                  ),
                                        );
                                      },
                                      onSelected: selectDestination,
                                      optionsViewBuilder: (
                                        BuildContext context,
                                        AutocompleteOnSelected<String>
                                            onSelected,
                                        Iterable<String> options,
                                      ) {
                                        final int itemCount = options.length;
                                        final double containerHeight =
                                            itemCount * 80.0;
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
                                                      (String option) =>
                                                          GestureDetector(
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
                                        TextEditingController
                                            textEditingController,
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
                                              color:
                                                  Provider.of<ThemesNotifier>(
                                                            context,
                                                            listen: false,
                                                          ).currentTheme ==
                                                          AppThemes.light
                                                      ? Colors.black
                                                      : null,
                                            ),
                                          ),
                                          onChanged: (value) {},
                                          onSubmitted: selectDestination,
                                        );
                                      },
                                    ),
                                  ),
                                  CampusIconButton(
                                    iconPath: 'assets/img/icons/search.svg',
                                    backgroundColorDark: Provider.of<
                                                        ThemesNotifier>(context,
                                                    listen: false)
                                                .currentTheme ==
                                            AppThemes.light
                                        ? const Color.fromRGBO(245, 246, 250, 1)
                                        : const Color.fromRGBO(34, 40, 54, 1),
                                    backgroundColorLight: Provider.of<
                                                        ThemesNotifier>(context,
                                                    listen: false)
                                                .currentTheme ==
                                            AppThemes.light
                                        ? const Color.fromRGBO(245, 246, 250, 1)
                                        : const Color.fromRGBO(34, 40, 54, 1),
                                    borderColorDark: Provider.of<
                                                        ThemesNotifier>(context,
                                                    listen: false)
                                                .currentTheme ==
                                            AppThemes.light
                                        ? const Color.fromRGBO(245, 246, 250, 1)
                                        : const Color.fromRGBO(34, 40, 54, 1),
                                    transparent: true,
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color:
                                          Provider.of<ThemesNotifier>(context)
                                              .currentThemeData
                                              .colorScheme
                                              .surface,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Material(
                                      color: Provider.of<ThemesNotifier>(
                                                      context,
                                                      listen: false)
                                                  .currentTheme ==
                                              AppThemes.light
                                          ? const Color.fromRGBO(
                                              245, 246, 250, 1)
                                          : const Color.fromRGBO(34, 40, 54, 1),
                                      borderRadius: BorderRadius.circular(15),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(15),
                                        onTap:
                                            routeFromCurrentLocationToSelectedDestination,
                                        child: Icon(
                                          Icons.my_location_rounded,
                                          size: 22,
                                          color: Provider.of<ThemesNotifier>(
                                                          context,
                                                          listen: false)
                                                      .currentTheme ==
                                                  AppThemes.light
                                              ? Colors.black
                                              : const Color.fromRGBO(
                                                  184, 186, 191, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        NavigationErrorBubble(
                          message: navigationMessage,
                        ),
                        // TODO: Add data for emergencyAssemblyPoints, vendingMachines etc.
                        // AnimatedPositioned(
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeInOut,
                        //   top: sidebarTop + 45,
                        //   right: isSidebarOpen ? 50 : 0,
                        //   child: GestureDetector(
                        //     onTap: toggleSidebar,
                        //     child: Container(
                        //       width: 20,
                        //       height: 60,
                        //       decoration: BoxDecoration(
                        //         color: sidebarBackgroundColor,
                        //         borderRadius: const BorderRadius.only(
                        //           topLeft: Radius.circular(10),
                        //           bottomLeft: Radius.circular(10),
                        //         ),
                        //       ),
                        //       child: Center(
                        //         child: Icon(
                        //           isSidebarOpen ? Icons.arrow_right : Icons.arrow_left,
                        //           color: iconColor,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // AnimatedPositioned(
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.easeInOut,
                        //   top: sidebarTop,
                        //   right: isSidebarOpen ? 0 : -50,
                        //   child: Container(
                        //     width: 50,
                        //     height: 150,
                        //     decoration: BoxDecoration(
                        //       color: sidebarBackgroundColor,
                        //       borderRadius: const BorderRadius.only(
                        //         topLeft: Radius.circular(10),
                        //         bottomLeft: Radius.circular(10),
                        //       ),
                        //     ),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         IconButton(
                        //           icon: Icon(Icons.local_grocery_store, color: iconColor, size: 30),
                        //           onPressed: () => calcNearestLoc(emergencyAssemblyPoints),
                        //           tooltip: 'Snackautomat',
                        //         ),
                        //         IconButton(
                        //           icon: Icon(Icons.restaurant, color: iconColor, size: 30),
                        //           onPressed: () => calcNearestLoc(vendingMachines),
                        //           tooltip: 'Restaurants',
                        //         ),
                        //         IconButton(
                        //           icon: Icon(Icons.local_hospital, color: iconColor, size: 30),
                        //           onPressed: () => calcNearestLoc(vendingMachines),
                        //           tooltip: 'Notfall',
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        if (isTileLoading)
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Provider.of<ThemesNotifier>(context,
                                                listen: false)
                                            .currentTheme ==
                                        AppThemes.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: fabBottomOffset),
              child: FloatingActionButton.extended(
                onPressed: () {
                  //TODO: Move function call into indoorNav into async call to update graph and images
                  /*
              final graph2 = await ensureLatestGraph();
              graph = graph2;
              await syncMapImages();
              */
                  //------
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const IndoorNavigation()),
                  );
                },
                elevation: 9,
                highlightElevation: 12,
                extendedPadding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: indoorButtonBackgroundColor,
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: indoorButtonIconHighlightColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    'assets/img/icons/door-closed.svg',
                    colorFilter: ColorFilter.mode(
                      indoorButtonIconColor,
                      BlendMode.srcIn,
                    ),
                    width: 22,
                  ),
                ),
                label: Text(
                  'Raumfinder',
                  style: (currentThemeData.textTheme.labelMedium ??
                          const TextStyle())
                      .copyWith(
                    color: indoorButtonTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> calcNearestLoc(Map<String, LatLng> locations) async {
    final bool hasAccess = await ensureLocationAccess();
    if (!hasAccess) {
      return;
    }

    final LocationData? currentLocationData = await getUserLocation();
    if (currentLocationData?.latitude == null ||
        currentLocationData?.longitude == null) {
      showNavigationMessage('Aktuelle Position konnte nicht ermittelt werden.');
      return;
    }

    final LatLng currentPos = LatLng(
      currentLocationData!.latitude!,
      currentLocationData.longitude!,
    );

    const Distance distance = Distance();
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
        currentLocation = currentLocationData;
        showCurrentLocation = true;
      });
      focusMapToRouteOrDestination(destination);
    } else {
      return;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasProcessedGlobalLocation &&
        selectedLocationGlobal != null &&
        selectedLocationGlobal!.isNotEmpty) {
      hasProcessedGlobalLocation = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        final location = selectedLocationGlobal!;
        searchController.text = location;
        final query = searchController.text.trim();
        if (query.isNotEmpty) {
          selectDestination(query);
        }
      });
    }
  }

  @override
  void dispose() {
    navigationMessageTimer?.cancel();
    focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<bool> ensureLocationAccess({bool requestIfMissing = true}) async {
    try {
      bool serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        if (!requestIfMissing) return false;
        serviceEnabled = await locationService.requestService();
        if (!serviceEnabled) {
          showNavigationMessage(
              'Bitte aktiviere die Ortungsdienste auf deinem Gerät.');
          return false;
        }
      }

      PermissionStatus permission = await locationService.hasPermission();
      if (permission == PermissionStatus.denied && requestIfMissing) {
        permission = await locationService.requestPermission();
      }

      if (permission == PermissionStatus.deniedForever) {
        showNavigationMessage(
            'Standortzugriff ist dauerhaft blockiert. Bitte in den Systemeinstellungen aktivieren.');
        return false;
      }

      if (permission == PermissionStatus.denied) {
        showNavigationMessage(
            'Standortzugriff erforderlich, um eine Route von deinem Standort zu starten.');
        return false;
      }

      return permission == PermissionStatus.granted ||
          permission == PermissionStatus.grantedLimited;
    } catch (e) {
      debugPrint('Error ensuring location access: $e');
      showNavigationMessage(
          'Standortberechtigung konnte nicht geprüft werden.');
      return false;
    }
  }

  void focusMapToRouteOrDestination(LatLng destination) {
    if (waypoints.length >= 2) {
      mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: waypoints,
          padding: const EdgeInsets.fromLTRB(60, 160, 60, 80),
          maxZoom: 18,
        ),
      );
      return;
    }

    if (waypoints.length == 1) {
      mapController.move(waypoints.first, 18);
      return;
    }

    mapController.move(destination, 17);
  }

  Future<LocationData?> getUserLocation() async {
    try {
      return await locationService.getLocation();
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  Future<void> handleInitialLoading() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        isTileLoading = false;
      });
    }
  }

  Future<void> initializeOnFirstVisible() async {
    if (hasInitializedOnVisible || isInitializingOnVisible) return;
    isInitializingOnVisible = true;

    try {
      await checkFirstTimeUser();
      await initializePage();
    } finally {
      isInitializingOnVisible = false;
      if (mounted) {
        setState(() {
          hasInitializedOnVisible = true;
        });
      } else {
        hasInitializedOnVisible = true;
      }
    }
  }

  Future<void> initializePage() async {
    predefinedLocations = OutdoorNavigationUtils.sortPredefinedLocations(
      predefinedLocations,
    );
    tileLayerFuture = OutdoorNavigationUtils.buildTileLayerInIsolate();

    setState(() {
      isTileLoading = false;
    });
  }

  void placeSymbol(String locationKey) {
    if (predefinedLocations.containsKey(locationKey)) {
      setState(() {
        symbolPosition = predefinedLocations[locationKey];
        debugPrint('Position aktualisiert!');
      });
    }
  }

  Future<void> routeFromCurrentLocationToSelectedDestination() async {
    final String selectedOption = searchController.text.trim();

    if (selectedOption.isEmpty) {
      showNavigationMessage('Bitte wähle zuerst ein Ziel aus.');
      return;
    }

    final LatLng? endLocation = predefinedLocations[selectedOption];
    if (endLocation == null) {
      showNavigationMessage('Das ausgewählte Ziel wurde nicht gefunden.');
      return;
    }

    final bool hasAccess = await ensureLocationAccess();
    if (!hasAccess) {
      return;
    }

    final LocationData? userLocation = await getUserLocation();
    if (userLocation?.latitude == null || userLocation?.longitude == null) {
      showNavigationMessage('Aktuelle Position konnte nicht ermittelt werden.');
      return;
    }

    final LatLng startLocation = LatLng(
      userLocation!.latitude!,
      userLocation.longitude!,
    );

    try {
      await setShortestPath(startLocation, endLocation);

      setState(() {
        currentLocation = userLocation;
        showCurrentLocation = true;
      });
      focusMapToRouteOrDestination(endLocation);
    } catch (e, stacktrace) {
      debugPrint(
          'Error while routing to selected destination: $e\n$stacktrace');
      showNavigationMessage('Route konnte nicht berechnet werden.');
    }
  }

  Future<void> selectDestination(String selectedOption) async {
    searchController.text = selectedOption;
    selectedLocationGlobal = selectedOption;
    placeSymbol(selectedOption);

    final LatLng? endLocation = predefinedLocations[selectedOption];
    if (endLocation == null) return;

    setState(() {
      waypoints = [];
    });
    mapController.move(endLocation, 17);
  }

  Future<void> setInitialLocation() async {
    try {
      final bool hasAccess = await ensureLocationAccess();
      if (!hasAccess) return;
      waypoints = [];
      final LocationData? currentLocation2 = await getUserLocation();
      if (currentLocation2 == null) return;

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

    final List<LatLng> newWaypoints = await utils.getOutdoorPath(start, end);

    setState(() {
      waypoints = newWaypoints;
      focusNode.unfocus();
    });

    if (suggestions.isNotEmpty) {
      searchController.text = suggestions.first;
    }
  }

  //-----------------------------------------------------------------------------

  void showNavigationMessage(String message) {
    if (!mounted) return;
    navigationMessageTimer?.cancel();
    setState(() {
      navigationMessage = message;
    });
    navigationMessageTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        navigationMessage = null;
      });
    });
  }

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }
}
