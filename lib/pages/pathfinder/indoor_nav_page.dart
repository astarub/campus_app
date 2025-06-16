import 'dart:async';
import 'dart:io';
import 'dart:math';

//import 'package:campus_app/pages/pathfinder/compas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'package:campus_app/main.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/pathfinder/data.dart';
import 'package:campus_app/utils/pages/pathfinder_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/pages/pathfinder/pathfinder_page.dart';
import 'package:campus_app/pages/pathfinder/image_processing.dart';

class IndoorNavigation extends StatefulWidget {
  const IndoorNavigation({super.key});

  @override
  State<IndoorNavigation> createState() => _IndoorNavigationState();
}

class _IndoorNavigationState extends State<IndoorNavigation> {
  int currentIndex = 0;
  Timer? fieldTimer;
  (String, String, String) from = ('SH', '0', 'Haupteingang');
  List<Uint8List> images = [];
  List<List<Offset>> pointsList = [];
  List<String> suggestions = [];
  Map testkarte = {};
  (String, String, String) to = ('SH', '0', 'Kultur-Cafe');
  final double scaleFactor = 1 / 4; // Compression factr
  bool isLoading = false;
  int? rub0Index;
  List<String> fn = [];
  final List<List<Offset>> labelCoordinatesPerImage = [];

  double rotationOffset = 0.3927 * 8; // Replace approx.
  double? heading;

  double scale = 1.0;
  double previousScale = 1.0;
  Offset position = Offset.zero;
  Offset startFocalPoint = Offset.zero;
  Offset startPosition = Offset.zero;
  double rotation = 0.0;
  double previousRotation = 0.0;

  final TransformationController controller = TransformationController();
  final PathfinderUtils utils = sl<PathfinderUtils>();
  final TextEditingController startController = TextEditingController();
  final TextEditingController zielController = TextEditingController();

  String startText = '';
  String zielText = '';

  Matrix4 imageMatrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Provider.of<ThemesNotifier>(context)
              .currentThemeData
              .colorScheme
              .surface,
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
                          style: Provider.of<ThemesNotifier>(context)
                              .currentThemeData
                              .textTheme
                              .displayMedium,
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
                    color: Provider.of<ThemesNotifier>(context, listen: false)
                                .currentTheme ==
                            AppThemes.light
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
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
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
                                  ? Colors.black
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
                    color: Provider.of<ThemesNotifier>(context, listen: false)
                                .currentTheme ==
                            AppThemes.light
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
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
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
                                  ? Colors.black
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
                      final containerSize =
                          Size(constraints.maxWidth, constraints.maxHeight);

                      if (isLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Provider.of<ThemesNotifier>(context)
                                          .currentTheme ==
                                      AppThemes.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        );
                      }

                      if (images.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: SvgPicture.asset(
                              'assets/img/icons/search.svg',
                              colorFilter: ColorFilter.mode(
                                Provider.of<ThemesNotifier>(context,
                                                listen: false)
                                            .currentTheme ==
                                        AppThemes.light
                                    ? Colors.black
                                    : const Color.fromRGBO(184, 186, 191, 1),
                                BlendMode.srcIn,
                              ),
                              width: 120,
                            ),
                          ),
                        );
                      }
                      // Extract dyn value later
                      final imageSize = Size(
                        1409 * scaleFactor,
                        1409 * scaleFactor,
                      );

                      final Offset dotPosition = getTransformedOriginPosition(
                          imageSize, containerSize);

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              color: Colors.black,
                              child: ClipRect(
                                child: GestureDetector(
                                  onScaleStart: (details) {
                                    previousScale = scale;
                                    previousRotation = rotation;
                                    startFocalPoint = details.focalPoint;
                                    startPosition = position;
                                  },
                                  onScaleUpdate: (details) {
                                    final Offset focalPointDelta =
                                        details.focalPoint - startFocalPoint;
                                    const double minScale = 1.0;
                                    const double maxScale = 8.0;
                                    const double baseTranslationLimit = 300.0;

                                    setState(() {
                                      scale = (previousScale * details.scale)
                                          .clamp(minScale, maxScale);
                                      rotation =
                                          previousRotation + details.rotation;

                                      final Offset potentialPosition =
                                          startPosition + focalPointDelta;
                                      final double adjustedLimit =
                                          baseTranslationLimit * scale;

                                      position = Offset(
                                        potentialPosition.dx.clamp(
                                            -adjustedLimit, adjustedLimit),
                                        potentialPosition.dy.clamp(
                                            -adjustedLimit, adjustedLimit),
                                      );
                                    });
                                  },
                                  child: Center(
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..translate(position.dx, position.dy)
                                        ..rotateZ(rotation)
                                        ..scale(scale),
                                      child: Stack(
                                        children: [
                                          Image.memory(
                                            images[currentIndex],
                                            fit: BoxFit.contain,
                                          ),
                                          /*
                                          Positioned(
                                            left: 380,
                                            top: 380,
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (images.isNotEmpty && heading == null)
                            Positioned(
                              top: 20,
                              left: 20,
                              right: 20,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        scale = 1.0;
                                        rotation = 0.0;
                                        position = Offset.zero;
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Transform.rotate(
                                          angle: rotation + rotationOffset,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ColorFiltered(
                                                colorFilter:
                                                    getInversionFilter(context),
                                                child: Container(
                                                  width: 125,
                                                  height: 125,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/img/compass.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Transform.translate(
                                                offset: const Offset(2, -25),
                                                child: Container(
                                                  width: 6,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          Provider.of<ThemesNotifier>(context)
                                              .currentThemeData
                                              .cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      fn.isNotEmpty
                                          ? transformFileName(fn[currentIndex])
                                          : 'Unknown',
                                      style: TextStyle(
                                        fontSize: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.fontSize ??
                                            16,
                                        color:
                                            Provider.of<ThemesNotifier>(context)
                                                        .currentTheme ==
                                                    AppThemes.light
                                                ? Colors.black
                                                : const Color.fromRGBO(
                                                    184, 186, 191, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (currentIndex > 0)
                FloatingActionButton(
                  backgroundColor: Provider.of<ThemesNotifier>(context)
                      .currentThemeData
                      .cardColor,
                  onPressed: () {
                    setState(() {
                      currentIndex = currentIndex - 1;
                    });
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Provider.of<ThemesNotifier>(context, listen: false)
                                .currentTheme ==
                            AppThemes.light
                        ? Colors.black
                        : const Color.fromRGBO(184, 186, 191, 1),
                  ),
                ),
              if (currentIndex < images.length - 1) const SizedBox(width: 10),
              if (currentIndex < images.length - 1)
                FloatingActionButton(
                  backgroundColor: Provider.of<ThemesNotifier>(context)
                      .currentThemeData
                      .cardColor,
                  onPressed: () async {
                    setState(() {
                      currentIndex = currentIndex + 1;
                      scale = 1.0;
                      rotation = 0.0;
                      position = Offset.zero;
                    });

                    if (rub0Index != null && currentIndex == rub0Index) {
                      Future.delayed(Duration(milliseconds: 1), () {
                        Navigator.of(context).pop();
                        selectedLocationGlobal = zielText;
                      });
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Provider.of<ThemesNotifier>(context, listen: false)
                                .currentTheme ==
                            AppThemes.light
                        ? Colors.black
                        : const Color.fromRGBO(184, 186, 191, 1),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> computeImagesForMapIncrementally(Map karte) async {
    setState(() {
      isLoading = true;
    });
    debugPrint('New page opened.');

    final stopwatch1 = Stopwatch()..start();
    final List<dynamic> shortestPath = await compute(
      findShortestPathIsolate,
      {
        'graph': karte,
        'from': [from.$1, from.$2, from.$3],
        'to': [to.$1, to.$2, to.$3],
      },
    );
    debugPrint('Dijkstra execution time: ${stopwatch1.elapsedMilliseconds}ms');

    final filenames = <String>[];
    final pointsListTemp = <List<Offset>>[];

    for (final step in shortestPath) {
      final (b, l, _) = step;
      final name = '$b$l.jpg';
      if (!filenames.contains(name)) {
        filenames.add(name);
        if (name == 'RUB0.jpg') {
          rub0Index = filenames.length - 1;
        }
      }
    }

    for (int i = 0; i < filenames.length; i++) {
      pointsListTemp.add([]);
    }

    for (final step in shortestPath) {
      final (b, l, _) = step;
      final name = '$b$l.jpg';
      final key = step;
      final coords = graph[key]!['Coordinates'];
      final Offset offset = Offset(
        coords[0].toDouble() * scaleFactor,
        coords[1].toDouble() * scaleFactor,
      );

      for (int i = 0; i < filenames.length; i++) {
        if (filenames[i] == name) {
          pointsListTemp[i].add(offset);
        }
      }
    }

    pointsList.clear();
    pointsList.addAll(pointsListTemp);

    for (int i = 0; i < filenames.length; i++) {
      final ByteData data =
          await rootBundle.load('assets/maps/${filenames[i]}');
      fn.add(filenames[i]);

      final Uint8List bytes = data.buffer.asUint8List();

      final labelList = <Offset>[];

      final labels = <MapEntry<Map<String, double>, String>>[];
      graph.forEach((key, value) {
        final (building, level, roomName) = key;
        if ('$building$level.jpg' == filenames[i]) {
          final coords = value['Coordinates'];
          final Offset pos = Offset(
            coords[0].toDouble() * scaleFactor,
            coords[1].toDouble() * scaleFactor,
          );
          labelList.add(pos);
        }
      });
      labelCoordinatesPerImage.add(labelList);

      final points = pointsList[i]
          .map((offset) => {'x': offset.dx, 'y': offset.dy})
          .toList();

      final ByteData markerData =
          await rootBundle.load('assets/img/destination_marker.png');
      final Uint8List markerBytes = markerData.buffer.asUint8List();
      final params = ImageProcessingParams(bytes, labels, points, markerBytes);

      final Uint8List modifiedImage =
          await compute(processImageInIsolate, params);

      if (!mounted) return;
      setState(() {
        images.add(modifiedImage);
        isLoading = false;
      });

      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  void fill() {
    for (final key in testkarte.keys) {
      final (x1, x2, x3) = key;
      final x4 = '$x1 $x2/$x3';
      if (!x4.contains('EN_')) {
        suggestions.add(x4);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeAfterUIShown();
    });
  }

  void initializeAfterUIShown() async {
    homeKey.currentState?.setSwipeDisabled(disableSwipe: true);

    await Future.delayed(Duration(milliseconds: 200));

    graph.keys.forEach((key) {
      final Map x = {};
      for (var i = 0; i < graph[key]?['Connections'].length; i++) {
        final (y, z) = graph[key]?['Connections'][i];
        x[y] = z;
      }
      testkarte[key] = x;
    });

    fill();

    final trimmed = selectedLocationGlobal?.trim();
    if (trimmed != null && trimmed.contains(' ')) {
      zielController.text = trimmed;
      zielText = trimmed;
    }
    setState(() {});
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
        images = [];
        pointsList = [];
        currentIndex = 0;
      });

      images = [];
      currentIndex = 0;
      await computeImagesForMapIncrementally(testkarte);
    } else {
      debugPrint('Both fields must be filled.');
    }
  }

  String buildHeadingFirstLetter(double direction) {
    if (direction >= 315 || direction < 45) {
      return 'N';
    } else if (direction >= 45 && direction < 135) {
      return 'E';
    } else if (direction >= 135 && direction < 225) {
      return 'S';
    } else if (direction >= 225 && direction < 315) {
      return 'W';
    }
    return '';
  }

  ColorFilter getInversionFilter(BuildContext context) {
    return const ColorFilter.matrix(<double>[
      -1, 0, 0, 0, 255, //
      0, -1, 0, 0, 255, //
      0, 0, -1, 0, 255, //
      0, 0, 0, 1, 0, //
    ]);
  }

  String transformFileName(String name) {
    if (!name.endsWith('.jpg')) return name;
    final baseName = name.substring(0, name.length - 4);
    final match = RegExp(r'^([A-Za-z]+)(\d+)$').firstMatch(baseName);
    if (match == null) return name;
    final letters = match.group(1);
    final digits = match.group(2);
    return '$letters-$digits';
  }

  Offset getTransformedOriginPosition(Size imageSize, Size containerSize) {
    final Offset imageOrigin = Offset(0, 0);
    final Offset imageCenter =
        Offset(imageSize.width / 2, imageSize.height / 2);
    Offset relativeOrigin = imageOrigin - imageCenter;

    relativeOrigin = relativeOrigin * scale;

    final double cosTheta = cos(rotation);
    final double sinTheta = sin(rotation);
    Offset rotated = Offset(
      relativeOrigin.dx * cosTheta - relativeOrigin.dy * sinTheta,
      relativeOrigin.dx * sinTheta + relativeOrigin.dy * cosTheta,
    );

    final Offset screenCenter =
        Offset(containerSize.width / 2, containerSize.height / 2);
    Offset finalPosition = screenCenter + rotated + position;

    return finalPosition;
  }
}
