import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_state.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';

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

  // Dialog logic remains the same
  void _showAddEventDialog() {
    final plannerState = context.read<PlannerState>();
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final dialogStartTimeNotifier = ValueNotifier(TimeOfDay.now());
    DateTime selectedDate = _focusedDay;

    showDialog(
      context: context,
      builder: (alertDialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Event'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Description (Optional)'),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(DateFormat('EEE, MMM d, yyyy').format(selectedDate)),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != selectedDate) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    ValueListenableBuilder<TimeOfDay>(
                      valueListenable: dialogStartTimeNotifier,
                      builder: (context, currentTime, child) {
                        return TextButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: Text('Start Time: ${currentTime.format(alertDialogContext)}'),
                          onPressed: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: alertDialogContext,
                              initialTime: currentTime,
                            );
                            if (picked != null) {
                              dialogStartTimeNotifier.value = picked;
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(alertDialogContext), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final newEvent = PlannerEventEntity(
                        title: titleController.text,
                        description: descController.text.isNotEmpty ? descController.text : null,
                        date: selectedDate,
                        startTime: dialogStartTimeNotifier.value,
                      );
                      plannerState.addEvent(newEvent);
                      Navigator.pop(alertDialogContext);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  MapEntry<IconData, String> get _nextView {
    switch (_currentView) {
      case CalendarViewMode.month:
        return const MapEntry(Icons.view_week, 'Switch to Week View');
      case CalendarViewMode.week:
        return const MapEntry(Icons.view_day, 'Switch to Day View');
      case CalendarViewMode.day:
        return const MapEntry(Icons.calendar_month, 'Switch to Month View');
    }
  }

  // --- NEW: Helper methods for navigation ---
  void _previousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _focusedDay) {
      setState(() {
        _focusedDay = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themesNotifier = Provider.of<ThemesNotifier>(context);
    final plannerState = context.watch<PlannerState>();

    final List<CalendarEventData<PlannerEventEntity>> calendarEvents = plannerState.events.map((event) {
      final DateTime startTime =
          DateTime(event.date.year, event.date.month, event.date.day, event.startTime.hour, event.startTime.minute);
      final DateTime endTime = event.endTime != null
          ? DateTime(event.date.year, event.date.month, event.date.day, event.endTime!.hour, event.endTime!.minute)
          : startTime.add(const Duration(hours: 1));
      return CalendarEventData(
        date: startTime,
        startTime: startTime,
        endTime: endTime,
        title: event.title,
        description: event.description ?? '',
        color: event.color,
        event: event,
      );
    }).toList();

    _eventController.removeWhere((element) => true);
    _eventController.addAll(calendarEvents);

    return Scaffold(
      backgroundColor: themesNotifier.currentThemeData.colorScheme.surface,
      appBar: AppBar(
        title: Text('Planner', style: themesNotifier.currentThemeData.textTheme.displayMedium),
        backgroundColor: themesNotifier.currentThemeData.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: _nextView.value,
            icon: Icon(_nextView.key),
            onPressed: () {
              setState(() {
                if (_currentView == CalendarViewMode.month) {
                  _currentView = CalendarViewMode.week;
                } else if (_currentView == CalendarViewMode.week) {
                  _currentView = CalendarViewMode.day;
                } else {
                  _currentView = CalendarViewMode.month;
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        tooltip: 'Add Event',
        backgroundColor: themesNotifier.currentThemeData.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: _buildCalendarView(themesNotifier),
    );
  }

  Widget _buildCalendarView(ThemesNotifier themesNotifier) {
    switch (_currentView) {
      case CalendarViewMode.month:
        return _buildMonthView(themesNotifier);
      case CalendarViewMode.week:
        return _buildWeekView(themesNotifier);
      case CalendarViewMode.day:
        return _buildDayView(themesNotifier);
    }
  }

  Widget _buildMonthView(ThemesNotifier themesNotifier) {
    return MonthView<PlannerEventEntity>(
      key: ValueKey(_focusedDay.month),
      controller: _eventController,
      initialMonth: _focusedDay,
      headerBuilder: (date) {
        return Container(
          color: themesNotifier.currentThemeData.cardColor,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
                tooltip: 'Previous Month',
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _selectMonth(context),
                  style: TextButton.styleFrom(
                    foregroundColor: themesNotifier.currentThemeData.textTheme.titleLarge?.color,
                  ),
                  child: Text(
                    DateFormat('MMMM yyyy').format(date),
                    style: themesNotifier.currentThemeData.textTheme.titleLarge,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
                tooltip: 'Next Month',
              ),
            ],
          ),
        );
      },
      onCellTap: (events, date) {
        setState(() {
          _focusedDay = date;
          _currentView = CalendarViewMode.day;
        });
      },
    );
  }

  Widget _buildWeekView(ThemesNotifier themesNotifier) {
    return WeekView<PlannerEventEntity>(
      key: ValueKey('week_view_$_focusedDay'),
      controller: _eventController,
      initialDay: _focusedDay,
      showLiveTimeLineInAllDays: true,
      timeLineWidth: 60,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: themesNotifier.currentThemeData.colorScheme.secondary,
      ),
      // This defines the style for the day labels (e.g., "Mon", "Tue")
      weekDayStringBuilder: (int day) {
        return DateFormat.E().format(DateTime(2024, 1, day == 7 ? 8 : day + 1));
      },
      // This defines the style for the main header area of the WeekView
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: themesNotifier.currentThemeData.cardColor),
        // Use titleLarge for consistency with DayView and MonthView
        headerTextStyle: themesNotifier.currentThemeData.textTheme.titleLarge,
      ),
      eventTileBuilder: (date, events, boundary, start, end) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: events.first.color.withAlpha(220), borderRadius: BorderRadius.circular(6)),
          child: Text(
            events.first.title,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        );
      },
    );
  }

  Widget _buildDayView(ThemesNotifier themesNotifier) {
    return DayView<PlannerEventEntity>(
      key: ValueKey('day_view_$_focusedDay'),
      controller: _eventController,
      initialDay: _focusedDay,
      showLiveTimeLineInAllDays: true,
      timeLineWidth: 60,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: themesNotifier.currentThemeData.colorScheme.secondary,
      ),
      dateStringBuilder: (date, {secondaryDate}) {
        return DateFormat('EEE, MMM d').format(date);
      },
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: themesNotifier.currentThemeData.cardColor),
        headerTextStyle: themesNotifier.currentThemeData.textTheme.titleLarge,
      ),
      eventTileBuilder: (date, events, boundary, start, end) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: events.first.color.withAlpha(220), borderRadius: BorderRadius.circular(6)),
          child: Text(
            events.first.title,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        );
      },
    );
  }
}
