import 'dart:async';
import 'dart:io' show Platform;

import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:campus_app/core/backend/entities/publisher_entity.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/calendar_filter_popup.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/utils/pages/calendar_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/campus_search_bar.dart';
import 'package:campus_app/utils/widgets/campus_segmented_control.dart';
import 'package:campus_app/utils/widgets/empty_state_placeholder.dart';
import 'package:campus_app/utils/widgets/scroll_to_top_button.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  final GlobalKey<NavigatorState> mainNavigatorKey;
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const CalendarPage({
    super.key,
    required this.mainNavigatorKey,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with AutomaticKeepAliveClientMixin<CalendarPage> {
  final BackendRepository backendRepository = sl<BackendRepository>();
  final calendarRepository = sl<CalendarRepository>();
  final calendarUsecases = sl<CalendarUsecases>();
  final calendarUtils = sl<CalendarUtils>();

  late List<Event> events = [];
  late List<Event> savedEvents = [];
  late List<Failure> failures = [];

  late List<Widget> parsedEventWidgets = [];
  late List<Widget> savedEventWidgets = [];
  late List<Widget> searchEventWidgets = [];

  late final CampusSegmentedControl upcomingSavedSwitch;
  bool showsavedEventWidgets = false;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  ScrollController scrollController = ScrollController();

  double eventWidgetOpacity = 0;
  double savedWidgetOpacity = 0;
  bool showUpcomingPlaceholder = false;
  bool showSavedPlaceholder = false;

  bool showSearchBar = false;
  String search = '';

  // Keep state alive
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Filter the events based on the selected sources
    final filters = Provider.of<SettingsHandler>(context).currentSettings.eventsFilter;
    final publishers = Provider.of<SettingsHandler>(context).currentSettings.publishers;
    final List<Widget> filteredEvents = calendarUtils.filterEventWidgets(
      filters,
      searchEventWidgets.isNotEmpty ? searchEventWidgets : parsedEventWidgets,
      publishers,
    );

    // Update the saved events list in case a user just saved an event
    if (showsavedEventWidgets) unawaited(updateSavedEventWidgets());

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
      floatingActionButton: ScrollToTopButton(scrollController: scrollController),
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
                  child: !showsavedEventWidgets && showUpcomingPlaceholder
                      // Placeholder for no upcoming events
                      ? const EmptyStatePlaceholder(
                          title: 'Keine Events in Sicht',
                          text: 'Es sind gerade keine Events geplant. Schau am besten später nochmal vorbei.',
                        )
                      : showsavedEventWidgets && showSavedPlaceholder
                          // Placeholder for no saved events
                          ? const EmptyStatePlaceholder(
                              title: 'Keine gemerkten Events',
                              text: 'Merke dir Events, um sie hier zu sehen.',
                            )
                          : RefreshIndicator(
                              key: refreshIndicatorKey,
                              displacement: 75,
                              backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                              color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                              strokeWidth: 3,
                              onRefresh: updateStateWithEvents,
                              child: showsavedEventWidgets
                                  ? ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      controller: scrollController,
                                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      itemCount: savedEventWidgets.length,
                                      itemBuilder: (context, index) => AnimatedOpacity(
                                        opacity: savedWidgetOpacity,
                                        duration: Duration(milliseconds: 50 + (index * 35)),
                                        child: savedEventWidgets[index],
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      controller: scrollController,
                                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      itemCount: filteredEvents.length,
                                      itemBuilder: (context, index) => AnimatedOpacity(
                                        opacity: eventWidgetOpacity,
                                        duration: Duration(milliseconds: 75 + (index * 40)),
                                        child: filteredEvents[index],
                                      ),
                                    ),
                            ),
                ),
                // Header
                Container(
                  padding: EdgeInsets.only(top: Platform.isAndroid ? 10 : 0, bottom: 20),
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Events',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.displayMedium,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: showSearchBar
                            ? CampusSearchBar(
                                onChange: onSearch,
                                onBack: () {
                                  setState(() {
                                    searchEventWidgets = parsedEventWidgets;
                                    showSearchBar = false;
                                    search = '';
                                  });
                                },
                              )
                            : Container(
                                padding: const EdgeInsets.only(top: 8),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      child: upcomingSavedSwitch,
                                    ),
                                    // Filter button
                                    CampusIconButton(
                                      iconPath: 'assets/img/icons/filter.svg',
                                      onTap: () {
                                        widget.mainNavigatorKey.currentState?.push(
                                          PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder: (context, _, __) => CalendarFilterPopup(
                                              selectedFilters: List.from(
                                                Provider.of<SettingsHandler>(
                                                  context,
                                                ).currentSettings.eventsFilter,
                                              ),
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

  @override
  void initState() {
    super.initState();

    upcomingSavedSwitch = CampusSegmentedControl(
      leftTitle: 'Upcoming',
      rightTitle: 'Saved',
      onChanged: (int selected) async {
        if (selected == 0) {
          setState(() => showsavedEventWidgets = false);
        } else {
          // Update the saved events list when changing tabs
          await updateSavedEventWidgets();

          setState(() => showsavedEventWidgets = true);
        }
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

    for (final Widget e in parsedEventWidgets) {
      if (e is CalendarEventWidget) {
        if (e.event.title.toUpperCase().contains(search.toUpperCase())) {
          filteredWidgets.add(e);
        }
      } else {
        filteredWidgets.add(e);
      }
    }

    setState(() {
      searchEventWidgets = filteredWidgets;
      this.search = search;
    });
  }

  void saveChangedFilters(List<Publisher> newFilters) {
    final Settings newSettings =
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.copyWith(eventsFilter: newFilters);

    debugPrint('Saving new event filters: ${newSettings.eventsFilter.map((e) => e.name).toList()}');
    Provider.of<SettingsHandler>(context, listen: false).currentSettings = newSettings;
  }

  /// Checks for events that were saved locally or removed from the server-side
  Future<void> syncSavedEventWidgets() async {
    if (Provider.of<SettingsHandler>(context, listen: false).currentSettings.useFirebase == FirebaseStatus.forbidden ||
        Provider.of<SettingsHandler>(context, listen: false).currentSettings.useFirebase ==
            FirebaseStatus.uncofigured) {
      return;
    }
    final SettingsHandler settingsHandler = Provider.of<SettingsHandler>(context, listen: false);

    // Copy the list of saved events in order to remove elements from the original list while iterating over the cloned one
    final List<Map<String, dynamic>> accountSavedEvents = settingsHandler.currentSettings.backendAccount.savedEvents;
    final List<Map<String, dynamic>> tempAccountSavedEvents = [];
    tempAccountSavedEvents.addAll(accountSavedEvents);

    // Get all saved events identified by the device's FCM token
    final List<Map<String, dynamic>> remoteSavedEvents = await backendRepository.getSavedEvents(settingsHandler);

    for (final Map<String, dynamic> accountEvent in tempAccountSavedEvents) {
      // Remove events that were removed without an internet connection
      if (!savedEvents.map((e) => e.id).toList().contains(accountEvent['eventId'])) {
        await backendRepository.removeSavedEvent(settingsHandler, accountEvent['eventId'], accountEvent['host']);
      }

      // Remove events that were removed on the backend
      try {
        remoteSavedEvents.firstWhere(
          (remoteEvent) =>
              remoteEvent['eventId'] == accountEvent['eventId'] && remoteEvent['host'] == accountEvent['host'],
        );
      } catch (e) {
        // Remove the event from the saved events widget list
        try {
          final Event savedEvent = savedEvents.firstWhere(
            (event) => event.id == accountEvent['eventId'] && Uri.parse(event.url).host == accountEvent['host'],
          );

          await updateSavedEventWidgets(
            event: savedEvent,
          );
          // ignore: empty_catches
        } catch (e) {}

        // Remove the event from the mirrored local saved events list
        try {
          accountSavedEvents.removeWhere((element) => element['documentId'] == accountEvent['documentId']);
          // ignore: empty_catches
        } catch (e) {}
      }
    }

    // Update the local saved events list
    settingsHandler.currentSettings = settingsHandler.currentSettings.copyWith(
      backendAccount: settingsHandler.currentSettings.backendAccount.copyWith(savedEvents: accountSavedEvents),
    );

    // Add events to the backend that were added without an internet connection
    for (final Event event in savedEvents) {
      try {
        accountSavedEvents.firstWhere(
          (element) => element['eventId'] == event.id && element['host'] == Uri.parse(event.url).host,
        );
      } catch (e) {
        await backendRepository.addSavedEvent(
          settingsHandler,
          event,
        );
      }
    }
  }

  /// Update the saved event widget list
  Future<void> updateSavedEventWidgets({Event? event}) async {
    final dartz.Either<Failure, List<Event>> updatedsavedEventWidgets =
        await calendarRepository.updateSavedEvents(event: event);

    List<Event> saved = [];

    updatedsavedEventWidgets.fold(
      (failure) => failures.add(failure),
      (events) => saved = events,
    );

    setState(() {
      savedEventWidgets = calendarUtils.getEventWidgetList(events: saved);
      savedEvents = saved;
      showSavedPlaceholder = saved.isEmpty;
    });
  }

  /// Function that calls usecase and parses widgets into the corresponding
  /// lists of events or failures.
  Future<List<Widget>> updateStateWithEvents() async {
    setState(() {
      eventWidgetOpacity = 0;
      savedWidgetOpacity = 0;
    });

    try {
      await backendRepository.loadPublishers(Provider.of<SettingsHandler>(context, listen: false));
      // ignore: empty_catches
    } catch (e) {}

    try {
      await calendarUsecases.updateEventsAndFailures().then(
        (data) async {
          setState(() {
            events = data['events']! as List<Event>;
            savedEvents = data['saved']! as List<Event>;
            failures = data['failures']! as List<Failure>;

            parsedEventWidgets = calendarUtils.getEventWidgetList(events: events);
            savedEventWidgets = calendarUtils.getEventWidgetList(events: savedEvents);

            showUpcomingPlaceholder = events.isEmpty;
            showSavedPlaceholder = savedEvents.isEmpty;
            eventWidgetOpacity = 1;
            savedWidgetOpacity = 1;
          });

          // Sync saved events
          await syncSavedEventWidgets();
        },
        onError: (e) {
          throw Exception('Failed to load parsed Events: $e');
        },
      );
    } catch (e) {
      debugPrint('Error: $e');
    }

    debugPrint('Events aktualisiert.');

    return parsedEventWidgets;
  }
}
