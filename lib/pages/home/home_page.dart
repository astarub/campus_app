import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/themes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: const Text(
        'Hello World',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
