import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:slugid/slugid.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollToTopButton({super.key, required this.scrollController});

  @override
  State<ScrollToTopButton> createState() => ScrollToTopButtonState();
}

class ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool showBacktoTopButton = false;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      if (widget.scrollController.offset > 20) {
        setState(() {
          showBacktoTopButton = true;
        });
      } else {
        setState(() {
          showBacktoTopButton = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: showBacktoTopButton ? 1 : 0,
      child: FloatingActionButton(
        heroTag: Slugid.v4(),
        onPressed: () {
          widget.scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
          );
        },
        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        child: Icon(
          Icons.arrow_upward,
          color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? Colors.black
              : const Color.fromRGBO(184, 186, 191, 1),
        ),
      ),
    );
  }
}
