// ignore_for_file: avoid_dynamic_calls, avoid_print, prefer_single_quotes, require_trailing_commas, unused_local_variable, use_super_parameters, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, prefer_final_locals, type_annotate_public_apis, no_leading_underscores_for_local_identifiers

import 'dart:developer';
import 'package:campus_app/main.dart';
import 'package:campus_app/pages/pathfinder/pathfinder_page.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:campus_app/pages/pathfinder/data.dart';

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
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
    log(testkarte.toString());
    fill();
  }

  List<Uint8List> _images = [];
  List<List<Offset>> _pointsList = [];
  int _currentIndex = 0;
  Map testkarte = {};
  var from = ('SH', '0', 'Haupteingang');
  var to = ('SH', '0', 'Kultur-Cafe');

  void _drawTextWithBox(
      img.Image image, Offset position, String text, img.Color textColor) {
    if (text.contains("EN_")) return;
    // Static font settings (you can adjust these values)
    const int fontWidth = 10; // Adjust this value based on text length
    const int fontHeight = 20; // Adjust this value based on font size
    const int boxPadding = 4; // Padding inside the box

    // Calculate box dimensions
    final int textWidth = fontWidth * text.length; // Rough approximation
    const int textHeight = fontHeight;

    final int boxWidth = textWidth + boxPadding * 2;
    const int boxHeight = textHeight + boxPadding * 2;

    // Box position based on the node's position
    final int x = position.dx.toInt();
    final int y = position.dy.toInt();
    final int boxLeft = x - boxWidth ~/ 2;
    final int boxTop = y - boxHeight ~/ 2;
    final int boxRight = boxLeft + boxWidth;
    final int boxBottom = boxTop + boxHeight;

    // Draw white background for the box
    for (int i = boxTop; i < boxBottom; i++) {
      for (int j = boxLeft; j < boxRight; j++) {
        if (j >= 0 && j < image.width && i >= 0 && i < image.height) {
          image.setPixel(j, i, img.ColorRgb8(255, 255, 255));
        }
      }
    }

    // Draw black border around the box
    for (int i = boxTop; i < boxBottom; i++) {
      if (boxLeft >= 0 && boxLeft < image.width && i >= 0 && i < image.height) {
        image.setPixel(boxLeft, i, img.ColorRgb8(0, 0, 0));
      }
      if (boxRight - 1 >= 0 &&
          boxRight - 1 < image.width &&
          i >= 0 &&
          i < image.height) {
        image.setPixel(boxRight - 1, i, img.ColorRgb8(0, 0, 0));
      }
    }
    for (int j = boxLeft; j < boxRight; j++) {
      if (j >= 0 && j < image.width && boxTop >= 0 && boxTop < image.height) {
        image.setPixel(j, boxTop, img.ColorRgb8(0, 0, 0));
      }
      if (j >= 0 &&
          j < image.width &&
          boxBottom - 1 >= 0 &&
          boxBottom - 1 < image.height) {
        image.setPixel(j, boxBottom - 1, img.ColorRgb8(0, 0, 0));
      }
    }

    // Draw the text centered inside the box
    final int textX = boxLeft + boxPadding;
    final int textY = boxTop + boxPadding;

    img.drawString(image, text,
        font: img.arial14, x: textX, y: textY, color: textColor);
  }

  void _drawPoint(img.Image image, Offset point, img.Color color, int radius) {
    int centerX = point.dx.toInt();
    int centerY = point.dy.toInt();
    int x = radius;
    int y = 0;
    int radiusError = 1 - x;

    while (x >= y) {
      for (int i = -x; i <= x; i++) {
        image.setPixel(centerX + i, centerY + y, color);
        image.setPixel(centerX + i, centerY - y, color);
      }
      for (int i = -y; i <= y; i++) {
        image.setPixel(centerX + i, centerY + x, color);
        image.setPixel(centerX + i, centerY - x, color);
      }
      y++;

      if (radiusError < 0) {
        radiusError += 2 * y + 1;
      } else {
        x--;
        radiusError += 2 * (y - x + 1);
      }
    }
  }

  void _drawLine(
      img.Image image, Offset p1, Offset p2, img.Color color, int thickness) {
    final double dx = p2.dx - p1.dx;
    final double dy = p2.dy - p1.dy;
    final double length = dx.abs() > dy.abs() ? dx.abs() : dy.abs();

    final double xIncrement = dx / length;
    final double yIncrement = dy / length;

    for (int i = 0; i < length; i++) {
      for (int j = 0; j < thickness; j++) {
        final int x = (p1.dx + i * xIncrement).toInt();
        final int y = (p1.dy + i * yIncrement).toInt();

        for (int k = 0; k < thickness; k++) {
          image.setPixel(x + k, y + j, color);
        }
      }
    }
  }

  Future<void> _loadImages(List<dynamic> shortestPath) async {
    final List<String> filenames = [];
    final List<Uint8List> loadedImages = [];

    for (int i = 0; i < shortestPath.length; i++) {
      final (first1, first2, first3) = shortestPath[i];
      final String filename = '$first1$first2.jpg';
      if (!filenames.contains(filename)) {
        filenames.add(filename);
        print(filename);
      }
    }
    print(filenames);

    for (int i = 0; i < filenames.length; i++) {
      setState(() {
        _pointsList.add([]);
      });
    }
    print(_pointsList);

    for (int i = 0; i < shortestPath.length; i++) {
      final (x1, x2, x3) = shortestPath[i];
      final String name = '$x1$x2.jpg';

      for (int j = 0; j < filenames.length; j++) {
        if (filenames[j] == name) {
          final dynamic key = shortestPath[i];
          final List<int> coordinates = graph[key]!["Coordinates"];
          final Offset offset =
              Offset(coordinates[0].toDouble(), coordinates[1].toDouble());
          _pointsList[j].add(offset);
        }
      }
    }

    print(_pointsList);

    for (int i = 0; i < filenames.length; i++) {
      final ByteData data = await DefaultAssetBundle.of(context)
          .load("lib/pages/pathfinder/maps/${filenames[i]}");
      final Uint8List bytes = data.buffer.asUint8List();
      final img.Image image = img.decodeImage(bytes)!;

      // DAS IST NEU
      graph.forEach((key, value) {
        final (building, level, roomName) = key;

        // Check if the node belongs to the current image
        if (filenames[i] == '$building$level.jpg') {
          final List<int> coordinates = value["Coordinates"];
          final Offset position =
              Offset(coordinates[0].toDouble(), coordinates[1].toDouble());

          // Label the node with a boxed room name
          _drawTextWithBox(image, position, roomName, img.ColorRgb8(0, 0, 0));
        }
      });

      for (int j = 0; j < _pointsList[i].length - 1; j++) {
        _drawLine(image, _pointsList[i][j], _pointsList[i][j + 1],
            img.ColorRgb8(0, 255, 255), 10);
      }

      _drawPoint(image, _pointsList[i].last, img.ColorRgb8(255, 0, 0), 20);

      //_drawText(
      //image, _pointsList[i].last, "RoomRoom", img.ColorRgb8(255, 0, 0));

      final Uint8List modifiedImage = Uint8List.fromList(img.encodePng(image));

      _images.add(modifiedImage);
    }

    setState(() {
      _images.addAll(loadedImages);
    });
    print(filenames);
    print(_pointsList);
  }

  List<dynamic> test(Map karte) {
    final testweg = Dijkstra.findPathFromGraph(karte, from, to);
    print(testweg);

    return testweg;
  }

  Future<List> yourFunction(Map karte) async {
    final List<dynamic> shortestPath = test(karte);
    print(shortestPath);
    await _loadImages(shortestPath);
    print(_images);
    return _images;
  }

  final TransformationController _controller = TransformationController();

  //-------------------------------------------------------------------------

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _zielController = TextEditingController();

  Future<void> _validateAndPerformAction() async {
    final String startText = _startController.text;
    final String zielText = _zielController.text;

    if (startText.isEmpty || zielText.isEmpty) {
      print('Both fields must be filled.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both fields must be filled.')),
      );
      return;
    }

    try {
      // Extract start location
      final List<String> startComponents = startText.split(" ");
      if (startComponents.length < 2) throw Exception("Invalid Start Format");

      final String startBuilding = startComponents[0];
      final String startLevelAndRoom = startComponents[1];
      final List<String> startLevelAndRoomComponents =
          startLevelAndRoom.split("/");
      if (startLevelAndRoomComponents.length < 2) {
        throw Exception("Invalid Start Format");
      }

      final String startLevel = startLevelAndRoomComponents[0];
      final String startRoom = startLevelAndRoomComponents[1];
      final start = (startBuilding, startLevel, startRoom);

      // Extract target location
      final List<String> zielComponents = zielText.split(" ");
      if (zielComponents.length < 2) throw Exception("Invalid Ziel Format");

      final String zielBuilding = zielComponents[0];
      final String zielLevelAndRoom = zielComponents[1];
      final List<String> zielLevelAndRoomComponents =
          zielLevelAndRoom.split("/");
      if (zielLevelAndRoomComponents.length < 2) {
        throw Exception("Invalid Ziel Format");
      }

      final String zielLevel = zielLevelAndRoomComponents[0];
      final String zielRoom = zielLevelAndRoomComponents[1];
      final ziel = (zielBuilding, zielLevel, zielRoom);

      // Check if locations exist in the graph
      if (!testkarte.containsKey(start)) {
        throw Exception("Start location not found: $startText");
      }
      if (!testkarte.containsKey(ziel)) {
        throw Exception("Ziel location not found: $zielText");
      }

      // Update state and process pathfinding
      setState(() {
        from = start;
        to = ziel;
        _images = [];
        _pointsList = [];
        _currentIndex = 0;
      });

      final List<Uint8List> _images2 =
          await yourFunction(testkarte) as List<Uint8List>;

      setState(() {
        _images = _images2;
      });
    } catch (e) {
      // Show error message if input is invalid or not found
      print(e);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  List<String> suggestions = [];
  void fill() {
    suggestions.clear(); // Ensure no duplicates
    testkarte.keys.forEach((key) {
      final (x1, x2, x3) = key;
      if (!x3.contains("EN_")) {
        // Skip entries with "EN_"
        final x4 = "$x1 $x2/$x3";
        suggestions.add(x4);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gebäude Interne Navigation'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
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
                _startController.text = selection;
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                _startController.text = textEditingController.text;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: (value) {
                    onFieldSubmitted();
                    _validateAndPerformAction();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Start:       zB. SSC 0/112',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 5),
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
                _zielController.text = selection;
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                // Initialize the textEditingController with the global variable value
                if (selectedLocationGlobal != null &&
                    textEditingController.text.isEmpty) {
                  textEditingController.text = selectedLocationGlobal!;
                }
                _zielController.text =
                    textEditingController.text; // Keep the controller in sync
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: (value) {
                    onFieldSubmitted();
                    _validateAndPerformAction();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Ziel:         zB. SSC 1/432',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (_) {}, // Disables horizontal swipes
              onScaleStart: (details) {
                _controller.value = Matrix4.identity();
              },
              child: _images.isNotEmpty
                  ? InteractiveViewer(
                      transformationController: _controller,
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 0.1,
                      maxScale: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Image.memory(_images[_currentIndex],
                            fit: BoxFit.contain),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.search, // Choose the maze icon you prefer
                        size: 150, // Adjust the size as needed
                        color: Colors.grey, // Adjust the color as needed
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
            backgroundColor: const Color.fromARGB(255, 216, 216, 216),
            onPressed: () {
              setState(() {
                if (_currentIndex > 0) {
                  _currentIndex = _currentIndex - 1;
                }
              });
            },
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 216, 216, 216),
            onPressed: () async {
              setState(() {
                if (_currentIndex < _images.length - 1) {
                  _currentIndex = _currentIndex + 1;
                }
              });
            },
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
