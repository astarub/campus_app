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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _showAddOrEditEventDialog({PlannerEventEntity? event}) {
    final isEditing = event != null;
    final plannerState = context.read<PlannerState>();
    final titleController = TextEditingController(text: event?.title ?? '');
    final descController = TextEditingController(text: event?.description ?? '');
    final dialogStartTimeNotifier = ValueNotifier(event?.startTime ?? TimeOfDay.now());
    DateTime selectedDate = event?.date ?? _focusedDay;

    showDialog(
      context: context,
      builder: (alertDialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(DateFormat('EEE, MMM d, yy').format(selectedDate)),
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
                      if (isEditing) {
                        final updatedEvent = event.copyWith(
                          title: titleController.text,
                          description: descController.text,
                          date: selectedDate,
                          startTime: dialogStartTimeNotifier.value,
                        );
                        plannerState.updateEvent(updatedEvent);
                      } else {
                        final newEvent = PlannerEventEntity(
                          title: titleController.text,
                          description: descController.text.isNotEmpty ? descController.text : null,
                          date: selectedDate,
                          startTime: dialogStartTimeNotifier.value,
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
          content: Text(event.description ?? 'No description.'),
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
          // CORRECTED: Assert non-null on the .event property.
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
