import 'package:campus_app/pages/planner/calendar_event_mapper.dart';
import 'package:campus_app/pages/planner/widgets/add_edit_event_dialog.dart';
import 'package:campus_app/pages/planner/widgets/add_event_fab.dart';
import 'package:campus_app/pages/planner/widgets/event_details_dialog.dart';
import 'package:campus_app/pages/planner/widgets/view_mode_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_view/calendar_view.dart';

import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_state.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:campus_app/pages/planner/widgets/month_view_calendar.dart';
import 'package:campus_app/pages/planner/widgets/week_view_calendar.dart';
import 'package:campus_app/pages/planner/widgets/day_view_calendar.dart';

enum CalendarViewMode { month, week, day }

class PlannerPage extends StatefulWidget {
  final GlobalKey<NavigatorState>? mainNavigatorKey;
  final GlobalKey<AnimatedEntryState>? pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState>? pageExitAnimationKey;

  const PlannerPage({
    super.key,
    this.mainNavigatorKey,
    this.pageEntryAnimationKey,
    this.pageExitAnimationKey,
  });

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  final EventController<PlannerEventEntity> _eventController = EventController();

  CalendarViewMode _currentView = CalendarViewMode.week;
  DateTime _focusedDay = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _showAddOrEditEventDialog({PlannerEventEntity? event}) async {
    await showDialog(
      context: context,
      builder: (_) => AddEditEventDialog(
        focusedDay: _focusedDay,
        event: event,
      ),
    );
  }

  Future<void> _showEventDetailsDialog(PlannerEventEntity event) async {
    await showDialog(
      context: context,
      builder: (_) => EventDetailsDialog(
        event: event,
        onEdit: () => _showAddOrEditEventDialog(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themesNotifier = Provider.of<ThemesNotifier>(context);
    final plannerState = context.watch<PlannerState>();
    final List<CalendarEventData<PlannerEventEntity>> calendarEvents = mapPlannerEvents(plannerState.events);

    _eventController.removeWhere((element) => true);
    _eventController.addAll(calendarEvents);

    return Scaffold(
      backgroundColor: themesNotifier.currentThemeData.colorScheme.surface,
      appBar: AppBar(
        title: Text('Planner', style: themesNotifier.currentThemeData.textTheme.displayMedium),
        backgroundColor: themesNotifier.currentThemeData.colorScheme.surface,
        elevation: 0,
        actions: [
          ViewModeSwitch(
            mode: _currentView,
            onChanged: (m) => setState(() => _currentView = m),
          ),
        ],
      ),
      floatingActionButton: AddEventFab(onPressed: _showAddOrEditEventDialog),
      body: _buildCalendarView(themesNotifier),
    );
  }

  Widget _buildCalendarView(ThemesNotifier themesNotifier) {
    switch (_currentView) {
      case CalendarViewMode.month:
        return MonthViewCalendar(
          themesNotifier: themesNotifier,
          focusedDay: _focusedDay,
          eventController: _eventController,
          onEventTap: _showEventDetailsDialog,
          onDateTap: (d) => setState(() => _focusedDay = d),
        );
      case CalendarViewMode.week:
        return WeekViewCalendar(
          themesNotifier: themesNotifier,
          focusedDay: _focusedDay,
          eventController: _eventController,
          onEventTap: _showEventDetailsDialog,
        );
      case CalendarViewMode.day:
        return DayViewCalendar(
          themesNotifier: themesNotifier,
          focusedDay: _focusedDay,
          eventController: _eventController,
          onEventTap: _showEventDetailsDialog,
        );
    }
  }
}
