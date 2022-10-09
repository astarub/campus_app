import 'package:campus_app/pages/calendar/calendar_event_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/utils/pages/calendar_utils.dart';
import 'package:campus_app/utils/widgets/campus_segmented_control.dart';
import 'package:campus_app/utils/widgets/empty_state_placeholder.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';

class CalendarPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const CalendarPage({
    Key? key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static List<Widget> parsedEvents = [
    // Spacing
    const SizedBox(height: 80),
    CalendarEventWidget(
      event: CalendarEventEntity(
        id: 0,
        title: 'E-Sports Meet & Greet',
        description:
            'Wir freuen uns auf euch und wollen euch bei ein paar Partien Mario Kart, Tekken, Street fighter etc. kennenlernen.',
        image: Image.asset('assets/img/AStA-Retro-Gaming.jpg'),
        startDate: DateTime(2022, 06, 20, 17),
        costs: 10.5,
        venue: 'Gaming Hub',
        organizers: ['AStA', 'E-Sports Referat'],
      ),
    ),
    CalendarEventWidget(
      event: CalendarEventEntity(
        id: 0,
        title: 'E-Sports Meet & Greet',
        image: Image.asset('assets/img/AStA-Retro-Gaming.jpg'),
        startDate: DateTime(2022, 06, 20, 17),
        costs: 0,
      ),
    ),
  ];

  static List<Widget> savedEvents = [];

  late final CampusSegmentedControl upcomingSavedSwitch;
  bool showSavedEvents = false;

  bool showUpcomingPlaceholder = false;
  bool showSavedPlaceholder = false;

  @override
  void initState() {
    super.initState();

    upcomingSavedSwitch = CampusSegmentedControl(
      leftTitle: 'Upcoming',
      rightTitle: 'Saved',
      onChanged: (int selected) {
        if (selected == 0) {
          setState(() => showSavedEvents = false);
        } else {
          setState(() => showSavedEvents = true);
        }
      },
    );

    if (parsedEvents.isEmpty) showUpcomingPlaceholder = true;
    if (savedEvents.isEmpty) showSavedPlaceholder = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: AnimatedExit(
          key: widget.pageExitAnimationKey,
          child: AnimatedEntry(
            key: widget.pageEntryAnimationKey,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Events
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: !showSavedEvents && showUpcomingPlaceholder
                      // Placeholder for no upcoming events
                      ? const EmptyStatePlaceholder(
                          title: 'No upcoming events',
                          text: 'There are no upcoming events at the moment. Try again later.',
                        )
                      : showSavedEvents && showSavedPlaceholder
                          // Placeholder for no saved events
                          ? const EmptyStatePlaceholder(
                              title: 'No saved events',
                              text: 'Start saving events ontheir page to see them here.',
                            )
                          : ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              physics: const BouncingScrollPhysics(),
                              children: showSavedEvents ? savedEvents : parsedEvents,
                            ),
                ),
                // Header
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          'Events',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                        ),
                      ),
                      // SegmentedControl
                      upcomingSavedSwitch,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
