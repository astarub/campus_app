import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

class ButtonGroup extends StatelessWidget {
  final String headline;
  final List<Widget> buttons;

  const ButtonGroup({
    Key? key,
    required this.headline,
    required this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Links headline
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            headline,
            textAlign: TextAlign.left,
            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 246, 250, 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: buttons,
          ),
        ),
      ],
    );
  }
}
