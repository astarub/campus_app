import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

  final TransformationController controller = TransformationController();
  final PathfinderUtils utils = sl<PathfinderUtils>();
  final TextEditingController startController = TextEditingController();
  final TextEditingController zielController = TextEditingController();

  String startText = '';
  String zielText = '';

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
                    bottom: 20),
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
                              color: Provider.of<ThemesNotifier>(context,
                                              listen: false)
                                          .currentTheme ==
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
                              color: Provider.of<ThemesNotifier>(context,
                                              listen: false)
                                          .currentTheme ==
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
                child: GestureDetector(
                  onScaleStart: (details) {
                    controller.value = Matrix4.identity();
                  },
                  /*
                  onHorizontalDragUpdate: (details) {
                    if (controller.value.getMaxScaleOnAxis() == 1.0) {
                      if (details.delta.dx > 0) {
                        // Swiped right
                        setState(() {
                          if (currentIndex > 0) {
                            currentIndex--;
                            controller.value = Matrix4.identity();
                          }
                        });
                      } else if (details.delta.dx < 0) {
                        setState(() {
                          if (currentIndex < images.length - 1) {
                            currentIndex++;
                            controller.value = Matrix4.identity();
                          }
                        });
                      }
                    }
                  },*/
                  child: images.isNotEmpty
                      ? InteractiveViewer(
                          transformationController: controller,
                          boundaryMargin: const EdgeInsets.all(20),
                          minScale: 0.1,
                          maxScale: 4,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Image.memory(images[currentIndex],
                                fit: BoxFit.contain),
                          ),
                        )
                      : Center(
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

  Future<List<Uint8List>> computeImagesForMap(Map karte) async {
    debugPrint('New page opened.');

    final List<dynamic> shortestPath =
        Dijkstra.findPathFromGraph(karte, from, to);

    final List<Uint8List> loadedImages = await utils.loadImages(
      context: context,
      shortestPath: shortestPath,
      pointsList: pointsList,
    );

    return loadedImages;
  }

  void fill() {
    for (final key in testkarte.keys) {
      final (x1, x2, x3) = key;
      final x4 = '$x1 $x2/$x3';
      suggestions.add(x4);
    }
  }

  @override
  void initState() {
    super.initState();

    // Disable swiping when entering this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

      final List<Uint8List> images2 = await computeImagesForMap(testkarte);

      setState(() {
        images = images2;
      });
    } else {
      debugPrint('Both fields must be filled.');
    }
  }
}
