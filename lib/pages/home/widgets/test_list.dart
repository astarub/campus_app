import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:campus_app/core/routes/router.gr.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final router = AutoRouter.of(context);

    return Scaffold(
      backgroundColor: themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.exit_to_app),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                TextButton(
                  onPressed: () => router.push(
                    const MoodlePageRoute(),
                  ),
                  child: const Text('Moodle'),
                ),
                /*TextButton(
                  onPressed: () => router.push(
                    const EcampusPageRoute(),
                  ),
                  child: const Text('Ecampus'),
                ),*/
                /*TextButton(
                  onPressed: () => router.push(
                    const FlexnowPageRoute(),
                  ),
                  child: const Text('Flexnow'),
                ),*/
                TextButton(
                  onPressed: () => router.push(
                    const RubnewsPageRoute(),
                  ),
                  child: const Text('RUB News'),
                ),
                TextButton(
                  onPressed: () => router.push(
                    const CalendarPageRoute(),
                  ),
                  child: const Text('Calendar'),
                ),
                TextButton(
                  onPressed: () => router.replace(
                    const HomePageRoute(),
                  ),
                  child: const Text('Home'),
                ),
                TextButton(
                  onPressed: () => {},
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
