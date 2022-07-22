import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return

      Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: themeData.colorScheme.secondary,
          ),
        ),
      );
  }
}
