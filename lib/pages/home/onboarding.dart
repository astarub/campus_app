import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_onboarding/flutter_onboarding.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/home_page.dart';

class OnboardingPage extends StatelessWidget {
  final GlobalKey<HomePageState> homePageKey;

  final GlobalKey<NavigatorState> mainNavigatorKey;

  const OnboardingPage({
    Key? key,
    required this.homePageKey,
    required this.mainNavigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: OnboardingSlider(
        donePage: HomePage(key: homePageKey, mainNavigatorKey: mainNavigatorKey),
        doneButtonText: 'Abschließen',
        nextButtonIcon: SvgPicture.asset(
          'assets/img/icons/arrow-right.svg',
          color: Colors.white,
        ),
        items: [
          // Welcome screen with logo
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Image.asset('assets/img/SplashScreen-logo.png', height: 300),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 10),
                  child: Text(
                    'Campus App',
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                  ),
                ),
                Text(
                  'Präsentiert von deinem AStA',
                  style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                )
              ],
            ),
          ),
          // Choose study area
          Center(child: Text('tbd')),
          // Accept or decline use of Firebase
          Center(child: Text('tbd')),
          // Choose theme
          Center(child: Text('tbd')),
          // Done
          Center(child: Text('tbd')),
        ],
      ),
    );
  }
}
