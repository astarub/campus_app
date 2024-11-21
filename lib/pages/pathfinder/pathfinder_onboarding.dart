import 'dart:async';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/main.dart';
import 'package:campus_app/pages/home/widgets/animated_onboarding_entry.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:flutter_onboarding/flutter_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PathfinderOnboardingPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;
  final Widget donePage;

  PathfinderOnboardingPage({
    super.key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
    required this.donePage,
  });

  @override
  State<PathfinderOnboardingPage> createState() => _PathfinderOnboardingPageState();
}

class _PathfinderOnboardingPageState extends State<PathfinderOnboardingPage> {
  final GlobalKey onboardingSliderKey = GlobalKey();

  // Declare controllers for the onboarding videos
  late VideoPlayerController _coverVideoController;
  late Future<void> _initializeVideoPlayerFutureForCoverVideo;
  late VideoPlayerController _stepOneVideoController;
  late Future<void> _initializeVideoPlayerFutureForStepOneVideo;
  late VideoPlayerController _stepTwoVideoController;
  late Future<void> _initializeVideoPlayerFutureForStepTwoVideo;
  late VideoPlayerController _stepThreeVideoController;
  late Future<void> _initializeVideoPlayerFutureForStepThreeVideo;
  late VideoPlayerController _stepFourVideoController;
  late Future<void> _initializeVideoPlayerFutureForStepFourVideo;
  late List<String> paths;

  @override
  void initState() {
    super.initState();
    _hideBottomNavBar();
    paths = [
      'assets/videos/pathfinder_onboarding_cover_video.mp4',
      'assets/videos/pathfinder_onboarding_step_1.mp4',
      'assets/videos/pathfinder_onboarding_step_2.mp4',
      'assets/videos/pathfinder_onboarding_step_3.mp4',
      'assets/videos/pathfinder_onboarding_step_4.mp4',
    ];

    // Initialize the video controllers
    _coverVideoController = VideoPlayerController.asset(paths[0]);
    _initializeVideoPlayerFutureForCoverVideo = _coverVideoController.initialize();

    _stepOneVideoController = VideoPlayerController.asset(paths[1]);
    _initializeVideoPlayerFutureForStepOneVideo = _stepOneVideoController.initialize();

    _stepTwoVideoController = VideoPlayerController.asset(paths[2]);
    _initializeVideoPlayerFutureForStepTwoVideo = _stepTwoVideoController.initialize();

    _stepThreeVideoController = VideoPlayerController.asset(paths[3]);
    _initializeVideoPlayerFutureForStepThreeVideo = _stepThreeVideoController.initialize();

    _stepFourVideoController = VideoPlayerController.asset(paths[4]);
    _initializeVideoPlayerFutureForStepFourVideo = _stepFourVideoController.initialize();
  }

  @override
  void dispose() {
    _showBottomNavBar();
    _coverVideoController.dispose();
    _stepOneVideoController.dispose();
    _stepTwoVideoController.dispose();
    _stepThreeVideoController.dispose();
    _stepFourVideoController.dispose();
    super.dispose();
  }

  void _hideBottomNavBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeKey.currentState?.setBottomNavBarVisibility(false);
    });
  }

  void _showBottomNavBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeKey.currentState?.setBottomNavBarVisibility(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingSlider(
          key: onboardingSliderKey,
          items: [
            // Welcome screen with logo
            SafeArea(
                child: Column(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      AnimatedOnboardingLogo(
                        offsetDuration: const Duration(milliseconds: 600),
                        logo: Container(
                          height: 300,
                          width: 300,
                          margin: const EdgeInsets.only(top: 80, bottom: 50),
                          child: Image.asset('assets/img/SplashScreen-logo.png', height: 300),
                        ),
                      ),
                      AnimatedOnboardingEntry(
                        offsetDuration: const Duration(milliseconds: 2000),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Raumfinder',
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                          ),
                        ),
                      ),
                      AnimatedOnboardingEntry(
                        offsetDuration: const Duration(milliseconds: 2000),
                        interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Willkommen beim Raumfinder -\ndie einfachste Art, dich auf dem Uni-Campus zurechtzufinden',
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            // pathfinder cover page
            SafeArea(
                child: Column(
              children: [
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                    child: Text(
                      'Die RUB auf einen Blick',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Deine RUB-Karte: Orientierung leicht gemacht',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedOnboardingEntry(
                      offsetDuration: const Duration(milliseconds: 2000),
                      interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                      child: VisibilityDetector(
                        key: const Key('pathfinder_onboarding_cover_video'),
                        onVisibilityChanged: (VisibilityInfo info) async {
                          var temp = await _coverVideoController.position;
                          if (info.visibleFraction > 0.5 && temp == Duration.zero) {
                            await _coverVideoController.play();
                          } else {
                            unawaited(_coverVideoController.seekTo(_coverVideoController.value.duration));
                          }
                        },
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFutureForCoverVideo,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              // If the VideoPlayerController has finished initialization, use
                              // the data it provides to limit the aspect ratio of the video.
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
                                child: AspectRatio(
                                  aspectRatio: _coverVideoController.value.aspectRatio,
                                  // Use the VideoPlayer widget to display the video.
                                  child: VideoPlayer(_coverVideoController),
                                ),
                              );
                            } else {
                              // If the VideoPlayerController is still initializing, show a
                              // loading spinner.
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      )),
                )
              ],
            )),
            // Guide to building finder
            SafeArea(
                child: Column(
              children: [
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Text(
                      'Schritt 1: Gebäude suchen',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                    child: Text(
                      'Gib den Namen des Gebäudes in die Suchleiste ein',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedOnboardingEntry(
                      offsetDuration: const Duration(milliseconds: 2000),
                      interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                      child: VisibilityDetector(
                        key: Key('pathfinder_onboarding_step_1_video'),
                        onVisibilityChanged: (VisibilityInfo info) async {
                          var temp = await _stepOneVideoController.position;
                          if (info.visibleFraction > 0.5 && temp == Duration.zero) {
                            unawaited(_stepOneVideoController.play());
                          } else {
                            unawaited(_stepOneVideoController.seekTo(_stepOneVideoController.value.duration));
                          }
                        },
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFutureForStepOneVideo,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              // If the VideoPlayerController has finished initialization, use
                              // the data it provides to limit the aspect ratio of the video.
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
                                child: AspectRatio(
                                  aspectRatio: _stepOneVideoController.value.aspectRatio,
                                  // Use the VideoPlayer widget to display the video.
                                  child: VideoPlayer(_stepOneVideoController),
                                ),
                              );
                            } else {
                              // If the VideoPlayerController is still initializing, show a
                              // loading spinner.
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      )),
                )
              ],
            )),
            // Guide for transitioning to room finder
            SafeArea(
                child: Column(
              children: [
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Text(
                      'Schritt 2: Wegbeschreibung',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                    child: Text(
                      'Die App zeigt dir die beste Route zum gewünschten Gebäude',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedOnboardingEntry(
                      offsetDuration: const Duration(milliseconds: 2000),
                      interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                      child: VisibilityDetector(
                        key: Key('pathfinder_onboarding_step_2_video'),
                        onVisibilityChanged: (VisibilityInfo info) async {
                          var temp = await _stepTwoVideoController.position;
                          if (info.visibleFraction > 0.5 && temp == Duration.zero) {
                            unawaited(_stepTwoVideoController.play());
                          } else {
                            unawaited(_stepTwoVideoController.seekTo(_stepTwoVideoController.value.duration));
                          }
                        },
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFutureForStepTwoVideo,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              // If the VideoPlayerController has finished initialization, use
                              // the data it provides to limit the aspect ratio of the video.
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
                                child: AspectRatio(
                                  aspectRatio: _stepTwoVideoController.value.aspectRatio,
                                  // Use the VideoPlayer widget to display the video.
                                  child: VideoPlayer(_stepTwoVideoController),
                                ),
                              );
                            } else {
                              // If the VideoPlayerController is still initializing, show a
                              // loading spinner.
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      )),
                )
              ],
            )),
            // Guide for room finder
            SafeArea(
                child: Column(
              children: [
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Text(
                      'Schritt 3: Indoor-Navigation',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                    child: Text(
                      'Klicke auf das Symbol unten rechts, um die detaillierte Wegführung zu starten',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedOnboardingEntry(
                      offsetDuration: const Duration(milliseconds: 2000),
                      interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                      child: VisibilityDetector(
                        key: Key('pathfinder_onboarding_step_3_video'),
                        onVisibilityChanged: (VisibilityInfo info) async {
                          var temp = await _stepThreeVideoController.position;
                          if (info.visibleFraction > 0.5 && temp == Duration.zero) {
                            unawaited(_stepThreeVideoController.play());
                          } else {
                            unawaited(_stepThreeVideoController.seekTo(_stepThreeVideoController.value.duration));
                          }
                        },
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFutureForStepThreeVideo,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              // If the VideoPlayerController has finished initialization, use
                              // the data it provides to limit the aspect ratio of the video.
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
                                child: AspectRatio(
                                  aspectRatio: _stepThreeVideoController.value.aspectRatio,
                                  // Use the VideoPlayer widget to display the video.
                                  child: VideoPlayer(_stepThreeVideoController),
                                ),
                              );
                            } else {
                              // If the VideoPlayerController is still initializing, show a
                              // loading spinner.
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      )),
                )
              ],
            )),
            // Guide to reach attended room
            SafeArea(
                child: Column(
              children: [
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Text(
                      'Schritt 4: Ziel auswählen',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AnimatedOnboardingEntry(
                  offsetDuration: const Duration(milliseconds: 2000),
                  interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                    child: Text(
                      'Wähle den gewünschten Eingang oder Startraum sowie den Zielraum aus, um die Navigation abzuschließen',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedOnboardingEntry(
                      offsetDuration: const Duration(milliseconds: 2000),
                      interval: const Interval(0.08, 1, curve: Curves.easeOutCubic),
                      child: VisibilityDetector(
                        key: Key('pathfinder_onboarding_step_4_video'),
                        onVisibilityChanged: (VisibilityInfo info) async {
                          var temp = await _stepFourVideoController.position;
                          if (info.visibleFraction > 0.5 && temp == Duration.zero) {
                            unawaited(_stepFourVideoController.play());
                          } else {
                            unawaited(_stepFourVideoController.seekTo(_stepFourVideoController.value.duration));
                          }
                        },
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFutureForStepFourVideo,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              // If the VideoPlayerController has finished initialization, use
                              // the data it provides to limit the aspect ratio of the video.
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
                                child: AspectRatio(
                                  aspectRatio: _stepFourVideoController.value.aspectRatio,
                                  // Use the VideoPlayer widget to display the video.
                                  child: VideoPlayer(_stepFourVideoController),
                                ),
                              );
                            } else {
                              // If the VideoPlayerController is still initializing, show a
                              // loading spinner.
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      )),
                )
              ],
            )),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    AnimatedOnboardingEntry(
                      offsetDuration: const Duration(milliseconds: 0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 20),
                        child: Text(
                          'Hinweis zu Fehlern',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium ??
                              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Description
                    AnimatedOnboardingEntry(
                      offsetDuration: const Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Die App befindet sich in der Entwicklung. Falls du auf Fehler stößt, teile uns diese bitte mit.',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall ??
                              const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Email Information
                    AnimatedOnboardingEntry(
                      offsetDuration: const Duration(milliseconds: 1000),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Schreibe uns eine E-Mail an:\n\ndev@asta-bochum.de',
                          style: (Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium ??
                                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Bug Icon
                    AnimatedOnboardingEntry(
                      offsetDuration: const Duration(milliseconds: 1500),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Icon(
                          Icons.bug_report,
                          size: 60,
                          color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          donePage: widget.donePage,
          doneButtonText: 'Zum Raumfinder',
          buttonTextStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium,
          backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
          buttonColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? Colors.black
              : const Color.fromRGBO(34, 40, 54, 1),
          pageIndicatorColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
              ? Colors.black
              : const Color.fromRGBO(184, 186, 191, 1),
          inactivePageIndicatorColor:
              Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromARGB(255, 228, 228, 228)
                  : const Color.fromRGBO(34, 40, 54, 1),
          nextButtonIcon: SvgPicture.asset(
            'assets/img/icons/arrow-right.svg',
            colorFilter: ColorFilter.mode(
              Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? Colors.white
                  : const Color.fromRGBO(184, 186, 191, 1),
              BlendMode.srcIn,
            ),
          )),
    );
  }
}
