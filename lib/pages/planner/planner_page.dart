import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';

import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_state.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';

// Helper function to get all days between a start and end date.
List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  final days = <DateTime>[];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(
      DateTime(
        startDate.year,
        startDate.month,
        startDate.day + i,
      ),
    );
  }
  return days;
}

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

  Future<DateTime?> _pickDateTime({required DateTime initialDate}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null) return null;

    if (!mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _showAddOrEditEventDialog({PlannerEventEntity? event}) {
    final isEditing = event != null;
    final plannerState = context.read<PlannerState>();
    final titleController = TextEditingController(text: event?.title ?? '');
    final descController = TextEditingController(text: event?.description ?? '');

    final startDateTimeNotifier = ValueNotifier(event?.startDateTime ?? _focusedDay);
    final endDateTimeNotifier = ValueNotifier(event?.endDateTime ?? _focusedDay.add(const Duration(hours: 1)));

    showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Event' : 'Add New Event'),
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
                ValueListenableBuilder<DateTime>(
                  valueListenable: startDateTimeNotifier,
                  builder: (context, currentStart, child) {
                    return TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text('Starts: ${DateFormat.yMd().add_jm().format(currentStart)}'),
                      onPressed: () async {
                        final pickedDateTime = await _pickDateTime(initialDate: currentStart);
                        if (pickedDateTime != null) {
                          startDateTimeNotifier.value = pickedDateTime;
                          if (pickedDateTime.isAfter(endDateTimeNotifier.value)) {
                            endDateTimeNotifier.value = pickedDateTime.add(const Duration(hours: 1));
                          }
                        }
                      },
                    );
                  },
                ),
                ValueListenableBuilder<DateTime>(
                  valueListenable: endDateTimeNotifier,
                  builder: (context, currentEnd, child) {
                    return TextButton.icon(
                      icon: const Icon(Icons.timer_off_outlined),
                      label: Text('Ends:   ${DateFormat.yMd().add_jm().format(currentEnd)}'),
                      onPressed: () async {
                        final pickedDateTime = await _pickDateTime(initialDate: currentEnd);
                        if (pickedDateTime != null && pickedDateTime.isAfter(startDateTimeNotifier.value)) {
                          endDateTimeNotifier.value = pickedDateTime;
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
                  if (isEditing) {
                    final updatedEvent = event.copyWith(
                      title: titleController.text,
                      description: descController.text,
                      startDateTime: startDateTimeNotifier.value,
                      endDateTime: endDateTimeNotifier.value,
                    );
                    plannerState.updateEvent(updatedEvent);
                  } else {
                    final newEvent = PlannerEventEntity(
                      title: titleController.text,
                      description: descController.text.isNotEmpty ? descController.text : null,
                      startDateTime: startDateTimeNotifier.value,
                      endDateTime: endDateTimeNotifier.value,
                    );
                    plannerState.addEvent(newEvent);
                  }
                  Navigator.pop(alertDialogContext);
                }
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEventDetailsDialog(PlannerEventEntity event) {
    final plannerState = context.read<PlannerState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(event.title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('From: ${DateFormat.yMMMEd().add_jm().format(event.startDateTime)}'),
              Text('To:      ${DateFormat.yMMMEd().add_jm().format(event.endDateTime)}'),
              const SizedBox(height: 16),
              Text(event.description ?? 'No description.'),
            ],
          ),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                showDialog(
                  context: context,
                  builder: (confirmContext) => AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text('Are you sure you want to delete this event?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(confirmContext).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        onPressed: () {
                          plannerState.deleteEvent(event.id);
                          Navigator.of(confirmContext).pop();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Spacer(),
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showAddOrEditEventDialog(event: event);
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    final themesNotifier = Provider.of<ThemesNotifier>(context);
    final plannerState = context.watch<PlannerState>();

    // CHANGED: This logic now correctly splits multi-day events into
    // properly timed segments for each day.
    final List<CalendarEventData<PlannerEventEntity>> calendarEvents = [];
    for (final event in plannerState.events) {
      final daysSpanned = getDaysInBetween(event.startDateTime, event.endDateTime);
      for (final day in daysSpanned) {
        final isFirstDay = day.isAtSameMomentAs(daysSpanned.first);
        final isLastDay = day.isAtSameMomentAs(daysSpanned.last);

        final dayStartTime = isFirstDay ? event.startDateTime : DateTime(day.year, day.month, day.day);

        final dayEndTime = isLastDay ? event.endDateTime : DateTime(day.year, day.month, day.day, 23, 59);

        calendarEvents.add(
          CalendarEventData(
            date: day,
            startTime: dayStartTime,
            endTime: dayEndTime,
            title: event.title,
            description: event.description ?? '',
            color: event.color,
            event: event,
          ),
        );
      }
    }

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
        onPressed: _showAddOrEditEventDialog,
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
    final theme = themesNotifier.currentThemeData;
    return MonthView<PlannerEventEntity>(
      key: ValueKey('month_view_$_focusedDay'),
      controller: _eventController,
      initialMonth: _focusedDay,
      borderColor: theme.dividerColor,
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.titleLarge,
      ),
      weekDayBuilder: (dayIndex) {
        final day = DateTime(2024).add(Duration(days: dayIndex));
        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Center(
            child: Text(
              DateFormat.E().format(day),
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(204),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
      cellBuilder: (date, events, isToday, isInMonth, hideDaysNotInMonth) {
        if (!isInMonth) {
          return Container();
        }

        if (events.isNotEmpty) {
          return GestureDetector(
            onTap: () => _showEventDetailsDialog(events.first.event!),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: events.first.color.withAlpha(220),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${date.day}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white.withAlpha(230),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Text(
                        events.first.title,
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          final backgroundColor = isToday ? theme.primaryColor.withAlpha(51) : theme.colorScheme.surface;
          final textColor = isToday ? theme.primaryColor : theme.colorScheme.onSurface;
          return Container(
            color: backgroundColor,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(color: textColor, fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          );
        }
      },
      onCellTap: (events, date) {
        if (date.month != _focusedDay.month) return;
        if (events.isEmpty) {
          setState(() {
            _focusedDay = date;
          });
        }
      },
    );
  }

  Widget _buildWeekView(ThemesNotifier themesNotifier) {
    final theme = themesNotifier.currentThemeData;
    return WeekView<PlannerEventEntity>(
      key: ValueKey('week_view_$_focusedDay'),
      controller: _eventController,
      initialDay: _focusedDay,
      showLiveTimeLineInAllDays: true,
      timeLineWidth: 60,
      backgroundColor: theme.colorScheme.surface,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: theme.colorScheme.secondary,
      ),
      weekDayStringBuilder: (int day) {
        return DateFormat.E().format(DateTime(2024, 1, day == 7 ? 8 : day + 1));
      },
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.titleLarge,
      ),
      eventTileBuilder: (date, events, boundary, start, end) {
        return GestureDetector(
          onTap: () => _showEventDetailsDialog(events.first.event!),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: events.first.color.withAlpha(220), borderRadius: BorderRadius.circular(6)),
            child: Text(
              events.first.title,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayView(ThemesNotifier themesNotifier) {
    final theme = themesNotifier.currentThemeData;
    return DayView<PlannerEventEntity>(
      key: ValueKey('day_view_$_focusedDay'),
      controller: _eventController,
      initialDay: _focusedDay,
      showLiveTimeLineInAllDays: true,
      timeLineWidth: 60,
      backgroundColor: theme.colorScheme.surface,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: theme.colorScheme.secondary,
      ),
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.titleLarge,
      ),
      eventTileBuilder: (date, events, boundary, start, end) {
        return GestureDetector(
          onTap: () => _showEventDetailsDialog(events.first.event!),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: events.first.color.withAlpha(220), borderRadius: BorderRadius.circular(6)),
            child: Text(
              events.first.title,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        );
      },
    );
  }
}
