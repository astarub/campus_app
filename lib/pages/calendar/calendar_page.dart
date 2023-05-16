import 'dart:io' show Platform;
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/utils/widgets/campus_search_bar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/core/failures.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/calendar_filter_popup.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/utils/pages/calendar_utils.dart';
import 'package:campus_app/utils/widgets/campus_segmented_control.dart';
import 'package:campus_app/utils/widgets/empty_state_placeholder.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

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

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin<CalendarPage> {
  late List<Event> _events = [];
  late List<Event> _savedEvents = [];
  late List<Failure> _failures = [];

  final _calendarUsecase = sl<CalendarUsecases>();
  final _calendarUtils = sl<CalendarUtils>();

  late List<Widget> parsedEvents = [];
  late List<Widget> savedEvents = [];
  late List<Widget> searchEvents = [];

  late final CampusSegmentedControl upcomingSavedSwitch;
  bool showSavedEvents = false;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  double eventWidgetOpacity = 0;
  double savedWidgetOpacity = 0;
  bool showUpcomingPlaceholder = false;
  bool showSavedPlaceholder = false;

  bool showSearchBar = false;
  String search = '';

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
        // Updates the list of searched events with potential new events
        onSearch(search);
      },
      onError: (e) {
        throw Exception('Failed to load parsed Events: $e');
      },
    );

    return parsedEvents;
  }

  void saveChangedFilters(List<String> newFilters) {
    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false)
            .currentSettings
            .copyWith(eventsFilter: newFilters);

    debugPrint('Saving new event filters: ${newSettings.eventsFilter}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings =
        newSettings;
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

    // Request an update for the calendar and show the refresh indicator
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      refreshIndicatorKey.currentState?.show();
    });
  }

  /// Filters the events based on the search input of the user
  void onSearch(String search) {
    final List<Widget> filteredWidgets = [];

    for (final Widget e in parsedEvents) {
      if (e is CalendarEventWidget) {
        if (e.event.title.toUpperCase().contains(search.toUpperCase())) {
          filteredWidgets.add(e);
        }
      } else {
        filteredWidgets.add(e);
      }
    }

    setState(() {
      searchEvents = filteredWidgets;
      this.search = search;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Filter the events based on the selected sources
    final filters = Provider.of<SettingsHandler>(context, listen: false)
        .currentSettings
        .eventsFilter;
    final List<Widget> filteredEvents = _calendarUtils.filterEventWidgets(
      filters,
      searchEvents.isNotEmpty ? searchEvents : parsedEvents,
    );

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context)
          .currentThemeData
          .colorScheme
          .background,
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
                          text:
                              'Es sind gerade keine Events geplant. Schau am besten später nochmal vorbei.',
                        )
                      : showSavedEvents && showSavedPlaceholder
                          // Placeholder for no saved events
                          ? const EmptyStatePlaceholder(
                              title: 'Keine gemerkten Events',
                              text: 'Merke dir Events, um sie hier zu sehen.',
                            )
                          : RefreshIndicator(
                              key: refreshIndicatorKey,
                              displacement: 67,
                              backgroundColor:
                                  Provider.of<ThemesNotifier>(context)
                                      .currentThemeData
                                      .cardColor,
                              color: Provider.of<ThemesNotifier>(context)
                                  .currentThemeData
                                  .primaryColor,
                              strokeWidth: 3,
                              onRefresh: updateStateWithEvents,
                              child: showSavedEvents
                                  ? ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      physics: const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      itemCount: savedEvents.length,
                                      itemBuilder: (context, index) =>
                                          AnimatedOpacity(
                                        opacity: savedWidgetOpacity,
                                        duration: Duration(
                                            milliseconds: 50 + (index * 35)),
                                        child: savedEvents[index],
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      physics: const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      itemCount: filteredEvents.length,
                                      itemBuilder: (context, index) =>
                                          AnimatedOpacity(
                                        opacity: eventWidgetOpacity,
                                        duration: Duration(
                                            milliseconds: 75 + (index * 40)),
                                        child: filteredEvents[index],
                                      ),
                                    ),
                            ),
                ),
                // Header
                Container(
                  padding: EdgeInsets.only(
                    top: Platform.isAndroid ? 10 : 0,
                    bottom: 18,
                  ),
                  color: Provider.of<ThemesNotifier>(context)
                      .currentThemeData
                      .colorScheme
                      .background,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Events',
                          style: Provider.of<ThemesNotifier>(context)
                              .currentThemeData
                              .textTheme
                              .displayMedium,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: showSearchBar
                            ? CampusSearchBar(
                                onChange: onSearch,
                                onBack: () {
                                  setState(() {
                                    searchEvents = parsedEvents;
                                    showSearchBar = false;
                                    search = '';
                                  });
                                },
                              )
                            : Container(
                                padding: const EdgeInsets.only(top: 8.2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Search button
                                    CampusIconButton(
                                      iconPath: 'assets/img/icons/search.svg',
                                      onTap: () {
                                        setState(() {
                                          showSearchBar = true;
                                        });
                                      },
                                    ),
                                    // FeedPicker
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: upcomingSavedSwitch),
                                    // Filter button
                                    CampusIconButton(
                                      iconPath: 'assets/img/icons/filter.svg',
                                      onTap: () {
                                        widget.mainNavigatorKey.currentState
                                            ?.push(
                                          PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder: (context, _, __) =>
                                                CalendarFilterPopup(
                                              selectedFilters:
                                                  Provider.of<SettingsHandler>(
                                                          context)
                                                      .currentSettings
                                                      .eventsFilter,
                                              onClose: saveChangedFilters,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
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
