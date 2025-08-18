import 'dart:async';
import 'dart:io';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/main.dart';
import 'package:campus_app/pages/navigation/data/room_graph.dart';
import 'package:campus_app/pages/navigation/models/floor_map.dart';
import 'package:campus_app/pages/navigation/navigation_page.dart';
import 'package:campus_app/pages/navigation/widgets/compass.dart';
import 'package:campus_app/pages/navigation/widgets/destination_waypoint.dart';
import 'package:campus_app/pages/navigation/widgets/navigation_buttons.dart';
import 'package:campus_app/pages/navigation/widgets/room_label.dart';
import 'package:campus_app/pages/navigation/widgets/start_waypoint.dart';
import 'package:campus_app/pages/navigation/widgets/waypoint_arrow.dart';
import 'package:campus_app/utils/pages/pathfinder_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class IndoorNavigation extends StatefulWidget {
  const IndoorNavigation({super.key});

  @override
  State<IndoorNavigation> createState() => _IndoorNavigationState();
}

class _IndoorNavigationState extends State<IndoorNavigation> {
  int currentIndex = 0;
  Timer? fieldTimer;
  (String, String, String) from = ('SH', '0', 'Haupteingang');
  List<List<Offset>> pointsList = [];
  List<String> suggestions = [];
  Map dijkstraMap = {};
  (String, String, String) to = ('SH', '0', 'Kultur-Cafe');
  bool isLoading = false;
  int? rub0Index;

  double rotationOffset = 0.3927 * 8; // Replace approx.
  double? heading;

  double scale = 1;
  double previousScale = 1;
  Offset position = Offset.zero;
  Offset startFocalPoint = Offset.zero;
  Offset startPosition = Offset.zero;
  double rotation = 0;
  double previousRotation = 0;

  final TransformationController controller = TransformationController();
  final PathfinderUtils utils = sl<PathfinderUtils>();
  final TextEditingController startController = TextEditingController();
  final TextEditingController zielController = TextEditingController();

  String startText = '';
  String zielText = '';

  List<FloorMap> floors = [];

  Matrix4 imageMatrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    final currentThemeData = Provider.of<ThemesNotifier>(context).currentThemeData;

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) return;

        homeKey.currentState!.setSwipeDisabled();
        Navigator.of(context).pop();
      },
      child: VisibilityDetector(
        key: const Key('indoor-visibility-key'),
        onVisibilityChanged: (info) {
          final bool isVisible = info.visibleFraction > 0;

          if (isVisible) {
            if (homeKey.currentState != null) {
              homeKey.currentState!.setSwipeDisabled(disableSwipe: true);
            }
          }
        },
        child: Scaffold(
          backgroundColor: currentThemeData.colorScheme.surface,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back button & page title
              Padding(
                padding: EdgeInsets.only(
                  top: Platform.isAndroid ? 20 : 0,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      CampusIconButton(
                        iconPath: 'assets/img/icons/arrow-left.svg',
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Align(
                        child: Text(
                          'Navigation',
                          style: currentThemeData.textTheme.displayMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 2),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? const Color.fromRGBO(245, 246, 250, 1)
                        : const Color.fromRGBO(34, 40, 54, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return suggestions;
                        }
                        return suggestions.where((String option) {
                          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        startController.text = selection;
                        setState(() {
                          startText = selection;
                        });
                        resetTimer();
                      },
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        startController.text = textEditingController.text;
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onSubmitted: (value) {
                            onFieldSubmitted();
                            validateAndPerformAction();
                          },
                          decoration: InputDecoration(
                            hintText: 'Start: zB. SH 0/05',
                            hintStyle: TextStyle(
                              color: Provider.of<ThemesNotifier>(
                                        context,
                                        listen: false,
                                      ).currentTheme ==
                                      AppThemes.light
                                  ? const Color.fromRGBO(34, 40, 54, 1)
                                  : null,
                            ),
                            border: InputBorder.none,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? const Color.fromRGBO(245, 246, 250, 1)
                        : const Color.fromRGBO(34, 40, 54, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return suggestions;
                        }
                        return suggestions.where((String option) {
                          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        zielController.text = selection;

                        setState(() {
                          zielText = selection;
                        });
                        zielController.text = selection;
                        resetTimer();
                      },
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        textEditingController.text = zielText;
                        zielController.text = zielText;

                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onSubmitted: (value) {
                            onFieldSubmitted();
                            validateAndPerformAction();
                          },
                          decoration: InputDecoration(
                            hintText: 'Ziel: zB. SH 0/81',
                            hintStyle: TextStyle(
                              color: Provider.of<ThemesNotifier>(
                                        context,
                                        listen: false,
                                      ).currentTheme ==
                                      AppThemes.light
                                  ? currentThemeData.colorScheme.surface
                                  : null,
                            ),
                            border: InputBorder.none,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      //* Loading Indicator
                      if (isLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              currentThemeData.colorScheme.primary,
                            ),
                          ),
                        );
                      }

                      //* Empty Search
                      if (floors.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: SvgPicture.asset(
                              'assets/img/icons/search.svg',
                              colorFilter: ColorFilter.mode(
                                Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                                    ? const Color.fromRGBO(34, 40, 54, 1)
                                    : const Color.fromRGBO(184, 186, 191, 1),
                                BlendMode.srcIn,
                              ),
                              width: 120,
                            ),
                          ),
                        );
                      }

                      //* Indoor Navigation
                      return Stack(
                        children: [
                          //* Map
                          Positioned.fill(
                            child: Container(
                              color: currentThemeData.colorScheme.surface,
                              child: ClipRect(
                                child: GestureDetector(
                                  onScaleStart: (details) {
                                    previousScale = scale;
                                    previousRotation = rotation;
                                    startFocalPoint = details.focalPoint;
                                    startPosition = position;
                                  },
                                  onScaleUpdate: (details) {
                                    final Offset focalPointDelta = details.focalPoint - startFocalPoint;
                                    const double minScale = 1;
                                    const double maxScale = 8;
                                    const double baseTranslationLimit = 500;

                                    setState(() {
                                      scale = (previousScale * details.scale).clamp(minScale, maxScale);
                                      rotation = previousRotation + details.rotation;

                                      final Offset potentialPosition = startPosition + focalPointDelta;
                                      final double adjustedLimit = baseTranslationLimit * scale;

                                      position = Offset(
                                        potentialPosition.dx.clamp(-adjustedLimit, adjustedLimit),
                                        potentialPosition.dy.clamp(-adjustedLimit, adjustedLimit),
                                      );
                                    });
                                  },
                                  child: FittedBox(
                                    child: Center(
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..translate(position.dx, position.dy)
                                          ..rotateZ(rotation)
                                          ..scale(scale),
                                        child: Stack(
                                          children: [
                                            //* Floor Image
                                            floors[currentIndex].floorImage,
                                            //* Path
                                            for (int i = 1; i < floors[currentIndex].wayPoints.length - 1; i++)
                                              WaypointArrow(
                                                current: floors[currentIndex].wayPoints[i],
                                                previous: floors[currentIndex].wayPoints[i - 1],
                                              ),
                                            //* Floor Labels
                                            for (final label in floors[currentIndex].roomLabels)
                                              RoomLabelWidget(
                                                label: label,
                                                rotation: rotation,
                                                isStart: label.position == floors[currentIndex].wayPoints.first,
                                                isDest: label.position == floors[currentIndex].wayPoints.last,
                                              ),
                                            StartWaypoint(
                                              position: floors[currentIndex].wayPoints.first,
                                              rotation: rotation,
                                            ),
                                            DestinationWaypoint(
                                              position: floors[currentIndex].wayPoints.last,
                                              rotation: rotation,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (floors.isNotEmpty && heading == null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //* Compass
                                Compass(
                                  rotation: rotation,
                                  rotationOffset: rotationOffset,
                                  onReset: () {
                                    setState(() {
                                      scale = 1.5;
                                      rotation = 0.0;
                                    });
                                  },
                                ),
                                //* Floor Label
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: currentThemeData.cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      floors[currentIndex].floorName,
                                      style: TextStyle(
                                        fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          //* Step Navigation Buttons
          floatingActionButton: FloorNavigationButtons(
            currentIndex: currentIndex,
            floorCount: floors.length,
            backgroundColor: currentThemeData.cardColor,
            onPrevious: () {
              setState(() {
                currentIndex = currentIndex - 1;
              });
            },
            onNext: () {
              setState(() {
                currentIndex = currentIndex + 1;
                scale = 1.5;
                rotation = 0.0;
                position = Offset.zero;
              });

              if (rub0Index != null && currentIndex == rub0Index) {
                Future.delayed(const Duration(milliseconds: 1), () {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  selectedLocationGlobal = zielText;
                });
              }
            },
          ),
        ),
      ),
    );
  }

//----------------------------------------

  Future<void> computeImagesForMapIncrementally(Map karte) async {
    setState(() {
      isLoading = true;
    });

    final stopwatch1 = Stopwatch()..start();
    final List<dynamic> shortestPath = await compute(
      utils.findShortestPathIsolate,
      {
        'graph': karte,
        'from': [from.$1, from.$2, from.$3],
        'to': [to.$1, to.$2, to.$3],
      },
    );
    debugPrint('Dijkstra execution time: ${stopwatch1.elapsedMilliseconds}ms');
    debugPrint('$shortestPath');

    final filenames = <String>[];
    final pointsListTemp = <List<Offset>>[];

    for (final step in shortestPath) {
      final (b, l, _) = step;
      final name = '$b$l.png';
      if (!filenames.contains(name)) {
        filenames.add(name);
        if (name == 'RUB0.jpg') {
          rub0Index = filenames.length - 1;
        }
      }
    }

    const double distanceThreshold = 30; // Adjust as needed

    for (int i = 0; i < filenames.length; i++) {
      pointsListTemp.add([]);
    }

    Offset? lastOffset;
    String? lastName;

    for (final step in shortestPath) {
      final (b, l, _) = step;
      final name = '$b$l.png';
      final key = step;
      final coords = graph[key]!['Coordinates'];
      final Offset offset = Offset(
        coords[0].toDouble(),
        coords[1].toDouble(),
      );

      for (int i = 0; i < filenames.length; i++) {
        if (filenames[i] == name) {
          if (lastOffset != null && lastName == name) {
            final double distance = (offset - lastOffset).distance;

            if (distance > distanceThreshold) {
              final int segments = (distance / distanceThreshold).floor();
              for (int s = 1; s < segments; s++) {
                final double t = s / segments;
                final interpolated = Offset.lerp(lastOffset, offset, t)!;
                pointsListTemp[i].add(interpolated);
              }
            }
          }

          pointsListTemp[i].add(offset);
        }
      }

      lastOffset = offset;
      lastName = name;
    }

    pointsList.clear();
    pointsList.addAll(pointsListTemp);

    for (int i = 0; i < filenames.length; i++) {
      final floorMap = FloorMap(
        floorName: utils.transformFileName(filenames[i]),
        roomLabels: utils.getRoomLabelsFromGraph(filenames[i]),
        floorImage: Image.asset('assets/maps/${filenames[i]}'),
        wayPoints: pointsList[i],
      );

      if (!mounted) return;
      setState(() {
        floors.add(floorMap);
        isLoading = false;
      });

      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  void fill() {
    for (final key in dijkstraMap.keys) {
      final (x1, x2, x3) = key;
      final x4 = '$x1 $x2/$x3';
      if (!x4.contains('EN_')) {
        suggestions.add(x4);
      }
    }
  }

  Future<void> initializeAfterUIShown() async {
    homeKey.currentState?.setSwipeDisabled(disableSwipe: true);

    await Future.delayed(const Duration(milliseconds: 200));

    for (final node in graph.keys) {
      final Map connectionsOfNode = {};

      for (var i = 0; i < graph[node]?['Connections'].length; i++) {
        final (connectionTo, distance) = graph[node]?['Connections'][i];
        connectionsOfNode[connectionTo] = distance;
      }

      dijkstraMap[node] = connectionsOfNode;
    }
    debugPrint('dijkstraMap = $dijkstraMap');

    fill();

    final trimmed = selectedLocationGlobal?.trim();
    if (trimmed != null && trimmed.contains(' ')) {
      zielController.text = trimmed;
      zielText = trimmed;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeAfterUIShown();
    });
  }

  void resetTimer() {
    fieldTimer?.cancel();
    startFieldTimer();
  }

  void startFieldTimer() {
    fieldTimer = Timer(const Duration(milliseconds: 200), () {
      validateAndPerformAction();
      FocusScope.of(context).unfocus();
    });
  }

  Future<void> validateAndPerformAction() async {
    if (startText.isNotEmpty && zielText.isNotEmpty) {
      final List<String> components = startText.split(' ');
      final String building = components[0];
      final String levelAndRoom = components[1];
      final List<String> levelAndRoomComponents = levelAndRoom.split('/');
      final String level = levelAndRoomComponents[0];
      final String room = levelAndRoomComponents[1];
      final start = (building, level, room);

      final List<String> components2 = zielText.split(' ');
      final String building2 = components2[0];
      final String levelAndRoom2 = components2[1];
      final List<String> levelAndRoomComponents2 = levelAndRoom2.split('/');
      final String level2 = levelAndRoomComponents2[0];
      final String room2 = levelAndRoomComponents2[1];
      final ziel = (building2, level2, room2);

      setState(() {
        from = start;
        to = ziel;
        floors = [];
        pointsList = [];
        currentIndex = 0;
      });

      floors = [];
      currentIndex = 0;
      await computeImagesForMapIncrementally(dijkstraMap);
    } else {
      debugPrint('Both fields must be filled.');
    }
  }
}
