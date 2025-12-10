import 'package:campus_app/pages/planner/calendar_event_mapper.dart';
import 'package:campus_app/pages/planner/widgets/add_edit_event_dialog.dart';
import 'package:campus_app/pages/planner/widgets/event_details_dialog.dart';
import 'package:campus_app/pages/planner/widgets/view_mode_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_view/calendar_view.dart';

import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_state.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/planner/widgets/month_view_calendar.dart';
import 'package:campus_app/pages/planner/widgets/week_view_calendar.dart';
import 'package:campus_app/pages/planner/widgets/day_view_calendar.dart';
import 'package:campus_app/pages/planner/studytimer_page.dart';

// Fakultäten
import 'package:campus_app/pages/courses/faculties_page.dart';

enum CalendarViewMode { month, week, day }

class PlannerPage extends StatefulWidget {
  final GlobalKey<NavigatorState>? mainNavigatorKey;

  const PlannerPage({super.key, this.mainNavigatorKey});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  final EventController<PlannerEventEntity> _eventController = EventController();

  CalendarViewMode _currentView = CalendarViewMode.week;
  DateTime _focusedDay = DateTime.now();
  late final PlannerState _plannerState;
  bool _showActionOptions = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _plannerState = Provider.of<PlannerState>(context);
    _plannerState.addListener(_onPlannerStateChanged);
    _syncEventController(_plannerState.events);
  }

  void _onPlannerStateChanged() {
    _syncEventController(_plannerState.events);
  }

  void _syncEventController(List<PlannerEventEntity> events) {
    final mapped = mapPlannerEvents(events);
    _eventController.removeWhere((_) => true);
    _eventController.addAll(mapped);
  }

  Future<void> _showAddOrEditEventDialog({
    PlannerEventEntity? event,
    DateTime? date,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => AddEditEventDialog(
        focusedDay: date ?? _focusedDay,
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
    context.watch<PlannerState>();

    return Scaffold(
      backgroundColor: themesNotifier.currentThemeData.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FacultiesPage()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          'Planner',
          style: themesNotifier.currentThemeData.textTheme.displayMedium,
        ),
        backgroundColor: themesNotifier.currentThemeData.colorScheme.surface,
        elevation: 0,
        actions: [
          ViewModeSwitch(
            mode: _currentView,
            onChanged: (m) => setState(() => _currentView = m),
          ),
        ],
      ),

      // -----------------------------
      //      FLOATING ACTIONS
      // -----------------------------
      floatingActionButton: _showActionOptions
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // TIMER BUTTON
                _modernActionButton(
                  icon: Icons.timer,
                  tooltip: 'Timer',
                  onPressed: () {
                    setState(() => _showActionOptions = false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudyTimerPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // ADD EVENT BUTTON
                _modernActionButton(
                  icon: Icons.event,
                  tooltip: 'Add Event',
                  onPressed: () {
                    setState(() => _showActionOptions = false);
                    _showAddOrEditEventDialog(date: DateTime.now());
                  },
                ),
                const SizedBox(height: 12),

                // CLOSE BUTTON
                _modernActionButton(
                  icon: Icons.close,
                  tooltip: 'Close',
                  mini: true,
                  onPressed: () {
                    setState(() => _showActionOptions = false);
                  },
                ),
              ],
            )
          : _modernMainButton(),

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
          onDateTap: (d) {
            setState(() => _focusedDay = d);
            _showAddOrEditEventDialog(date: d);
          },
        );
      case CalendarViewMode.week:
        return WeekViewCalendar(
          themesNotifier: themesNotifier,
          focusedDay: _focusedDay,
          eventController: _eventController,
          onEventTap: _showEventDetailsDialog,
          onDateTap: (_, date) => _showAddOrEditEventDialog(date: date),
        );
      case CalendarViewMode.day:
        return DayViewCalendar(
          themesNotifier: themesNotifier,
          focusedDay: _focusedDay,
          eventController: _eventController,
          onEventTap: _showEventDetailsDialog,
          onDateTap: (date) => _showAddOrEditEventDialog(date: date),
        );
    }
  }

  @override
  void dispose() {
    _plannerState.removeListener(_onPlannerStateChanged);
    _plannerState.disposeWatcher();
    _eventController.dispose();
    super.dispose();
  }

  // MAIN FAB (+)
  Widget _modernMainButton() {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      elevation: 10,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 32, color: Colors.white),
      onPressed: () => setState(() => _showActionOptions = true),
    );
  }

  // SUB BUTTONS
  Widget _modernActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool mini = false,
  }) {
    const double sizeNormal = 64;
    const double sizeMini = 56;
    final double size = mini ? sizeMini : sizeNormal;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.black, // <<<< ICON-BUTTON SCHWARZ
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 14,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: Icon(
                icon,
                color: Colors.white, // Icon bleibt sichtbar auf schwarz
                size: mini ? 24 : 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
