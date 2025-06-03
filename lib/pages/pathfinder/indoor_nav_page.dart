// ignore_for_file: deprecated_member_use, avoid_redundant_argument_values, avoid_dynamic_calls

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:image/image.dart' as img;
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import 'package:campus_app/main.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/pathfinder/data.dart';
import 'package:campus_app/utils/pages/pathfinder_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/pages/pathfinder/pathfinder_page.dart';

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

                        resetTimer();
                      },
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        startController.text = textEditingController.text;
                        // Ensure the controller reflects the default value
                        textEditingController.text = zielController.text;
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
                child: images.isNotEmpty
                    ? MatrixGestureDetector(
                        shouldRotate: true,
                        onMatrixUpdate: (m, tm, sm, rm) {
                          setState(() {
                            imageMatrix = m;
                          });
                        },
                        child: Transform(
                          transform: imageMatrix,
                          alignment: Alignment.center,
                          child: Image.memory(
                            images[currentIndex],
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: SvgPicture.asset(
                            'assets/img/icons/search.svg',
                            colorFilter: ColorFilter.mode(
                              Provider.of<ThemesNotifier>(
                                        context,
                                        listen: false,
                                      ).currentTheme ==
                                      AppThemes.light
                                  ? Colors.black
                                  : const Color.fromRGBO(184, 186, 191, 1),
                              BlendMode.srcIn,
                            ),
                            width: 120,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Provider.of<ThemesNotifier>(context)
                    .currentThemeData
                    .cardColor,
                onPressed: () {
                  setState(() {
                    if (currentIndex > 0) {
                      currentIndex = currentIndex - 1;
                    }
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
              const SizedBox(width: 10),
              FloatingActionButton(
                backgroundColor: Provider.of<ThemesNotifier>(context)
                    .currentThemeData
                    .cardColor,
                onPressed: () async {
                  setState(() {
                    if (currentIndex < images.length - 1) {
                      currentIndex = currentIndex + 1;
                    }
                  });
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
    debugPrint('New page opened.');

    final stopwatch1 = Stopwatch()..start();
    final List<dynamic> shortestPath =
        Dijkstra.findPathFromGraph(karte, from, to);
    debugPrint('Dijkstra execution time: ${stopwatch1.elapsedMilliseconds}ms');

    final filenames = <String>[];
    final pointsListTemp = <List<Offset>>[];

    for (final step in shortestPath) {
      final (b, l, _) = step;
      final name = '$b$l.jpg';
      if (!filenames.contains(name)) {
        filenames.add(name);
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
      final Offset offset = Offset(coords[0].toDouble() * scaleFactor,
          coords[1].toDouble() * scaleFactor);

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
      final Uint8List bytes = data.buffer.asUint8List();
      final img.Image baseImage = img.decodeImage(bytes)!;

      // Add room labels
      graph.forEach((key, value) {
        final (building, level, roomName) = key;
        if ('$building$level.jpg' == filenames[i]) {
          final coords = value['Coordinates'];
          final pos = Offset(coords[0].toDouble() * scaleFactor,
              coords[1].toDouble() * scaleFactor);
          utils.drawTextWithBox(
            baseImage,
            pos,
            roomName,
            img.ColorRgb8(0, 0, 0),
          );
        }
      });

      // Add path and points
      final points = pointsList[i];
      for (int j = 0; j < points.length - 1; j++) {
        utils.drawLine(
          baseImage,
          points[j],
          points[j + 1],
          img.ColorRgb8(0, 255, 255),
          5,
        );
      }
      if (points.isNotEmpty) {
        utils.drawPoint(baseImage, points.last, img.ColorRgb8(255, 0, 0), 20);
      }

      final Uint8List modifiedImage =
          Uint8List.fromList(img.encodePng(baseImage));

      setState(() {
        images.add(modifiedImage);
      });

      // Let the UI render the current image before continuing
      await Future.delayed(const Duration(milliseconds: 100));
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

    // Disable swiping when entering this page
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      homeKey.currentState!.setSwipeDisabled();
    });

    graph.keys.forEach((key) {
      final Map x = {};
      for (var i = 0; i < graph[key]?['Connections'].length; i++) {
        final (y, z) = graph[key]?['Connections'][i];
        x[y] = z;
      }
      testkarte[key] = x;
    });

    fill();

// Set the default value for zielController if selectedLocationGlobal is not empty
    if (selectedLocationGlobal != null && selectedLocationGlobal!.isNotEmpty) {
      zielController.text = selectedLocationGlobal!;
      zielText = selectedLocationGlobal!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      homeKey.currentState!.setSwipeDisabled(disableSwipe: true);
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
}
