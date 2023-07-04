import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:campus_app/core/failures.dart';
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

class _CalendarPageState extends State<CalendarPage> with AutomaticKeepAliveClientMixin<CalendarPage> {
  late List<Event> _events = [];
  late List<Event> _savedEvents = [];
  late List<Failure> _failures = [];

  final _calendarUsecase = sl<CalendarUsecases>();
  final _calendarUtils = sl<CalendarUtils>();

  late List<Widget> parsedEvents = [];
  late List<Widget> savedEvents = [];

  late final CampusSegmentedControl upcomingSavedSwitch;
  bool showSavedEvents = false;

  double eventWidgetOpacity = 0;
  double savedWidgetOpacity = 0;
  bool showUpcomingPlaceholder = false;
  bool showSavedPlaceholder = false;

  /// Function that calls usecase and parses widgets into the corresponding
  /// lists of events or failures.
  Future<List<Widget>> updateStateWithEvents() async {
    setState(() {
      eventWidgetOpacity = 0;
      savedWidgetOpacity = 0;
    });

    await _calendarUsecase.updateEventsAndFailures().then(
      (data) {
        setState(() {
          _events = data['events']! as List<Event>;
          _savedEvents = data['saved']! as List<Event>;
          _failures = data['failures']! as List<Failure>;

          parsedEvents = _calendarUtils.getEventWidgetList(events: _events);
          savedEvents = _calendarUtils.getEventWidgetList(events: _savedEvents);

          showUpcomingPlaceholder = _events.isEmpty;
          showSavedPlaceholder = _savedEvents.isEmpty;
          eventWidgetOpacity = 1;
          savedWidgetOpacity = 1;
        });
      },
      onError: (e) {
        throw Exception('Failed to load parsed Events: $e');
      },
    );

    return parsedEvents;
  }

  @override
  void initState() {
    super.initState();

    //FIXME: Needs to move out of initState for localization to work
    //TODO: Fix Localization
    upcomingSavedSwitch = CampusSegmentedControl(
      leftTitle: 'upcoming', //AppLocalizations.of(context)!.event_upcoming,
      rightTitle: 'followed', //AppLocalizations.of(context)!.event_followed,
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
    super.build(context);

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
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
                      ? EmptyStatePlaceholder(
                          title: AppLocalizations.of(context)!.event_noUpcomingEvents_title,
                          text: AppLocalizations.of(context)!.event_noUpcomingEvents_text,
                        )
                      : showSavedEvents && showSavedPlaceholder
                          // Placeholder for no saved events
                          ? EmptyStatePlaceholder(
                              title: AppLocalizations.of(context)!.event_noFollowedEvent_title,
                              text: AppLocalizations.of(context)!.event_noFollowedEvent_text,
                            )
                          : RefreshIndicator(
                              displacement: 55,
                              backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                              color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                              strokeWidth: 3,
                              onRefresh: updateStateWithEvents,
                              child: showSavedEvents
                                  ? ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      itemCount: savedEvents.length,
                                      itemBuilder: (context, index) => AnimatedOpacity(
                                        opacity: savedWidgetOpacity,
                                        duration: Duration(milliseconds: 50 + (index * 35)),
                                        child: savedEvents[index],
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      itemCount: parsedEvents.length,
                                      itemBuilder: (context, index) => AnimatedOpacity(
                                        opacity: eventWidgetOpacity,
                                        duration: Duration(milliseconds: 75 + (index * 40)),
                                        child: parsedEvents[index],
                                      ),
                                    ),
                            ),
                ),
                // Header
                Container(
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 10 : 0, bottom: 20),
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
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

  // Keep state alive
  @override
  bool get wantKeepAlive => true;
}
