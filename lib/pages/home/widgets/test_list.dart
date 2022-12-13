import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

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
                  onPressed: () {},
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
                  onPressed: () {},
                  child: const Text('RUB News'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Calendar'),
                ),
                TextButton(
                  onPressed: () {},
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
