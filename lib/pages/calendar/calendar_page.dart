import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

//import 'package:campus_app/core/failures.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/utils/pages/calendar_utils.dart';
import 'package:campus_app/utils/widgets/campus_segmented_control.dart';
import 'package:campus_app/utils/widgets/empty_state_placeholder.dart';

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
  late List<Event> _events = [];
  late List<Event> _savedEvents = [];
  //late List<Failure> _failures = [];

  final _calendarUsecase = sl<CalendarUsecases>();
  final _calendarUtils = sl<CalendarUtils>();

  late List<Widget> parsedEvents = [];
  late List<Widget> savedEvents = [];

  late final CampusSegmentedControl upcomingSavedSwitch;
  bool showSavedEvents = false;

  bool showUpcomingPlaceholder = false;
  bool showSavedPlaceholder = false;

  /// Function that call usecase and parse widgets into the corresponding
  /// lists of events or failures.
  Future<void> updateStateWithEvents() async {
    await _calendarUsecase.updateEventsAndFailures().then((data) {
      setState(() {
        _events = data['events']! as List<Event>;
        _savedEvents = data['saved']! as List<Event>;
        //_failures = data['failures']! as List<Failure>;

        parsedEvents = _calendarUtils.getEventWidgetList(events: _events);
        savedEvents = _calendarUtils.getEventWidgetList(events: _savedEvents);

        showUpcomingPlaceholder = _events.isEmpty;
        showSavedPlaceholder = _savedEvents.isEmpty;
      });
    });
  }

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
        updateStateWithEvents();
      },
    );

    updateStateWithEvents();
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
                  margin: EdgeInsets.only(top: Platform.isAndroid ? 70 : 60),
                  child: !showSavedEvents && showUpcomingPlaceholder
                      // Placeholder for no upcoming events
                      ? const EmptyStatePlaceholder(
                          title: 'Keine Events in Sicht',
                          text: 'Es sind gerade keine Events geplant. Schau am besten später nochmal vorbei.',
                        )
                      : showSavedEvents && showSavedPlaceholder
                          // Placeholder for no saved events
                          ? const EmptyStatePlaceholder(
                              title: 'Keine gemerkten Events',
                              text: 'Merke dir Events, um sie hier zu sehen.',
                            )
                          : RefreshIndicator(
                              displacement: 55,
                              backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                              color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                              strokeWidth: 3,
                              onRefresh: updateStateWithEvents,
                              child: ListView(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                children: showSavedEvents ? savedEvents : parsedEvents,
                              ),
                            ),
                ),
                // Header
                Container(
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 10 : 0, bottom: 20),
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      SizedBox(
                        width: double.infinity,
                        child: Center(child: upcomingSavedSwitch),
                      ),
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
