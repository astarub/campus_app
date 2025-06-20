import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

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
      initialDate: initialDate.toLocal(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null) return null;

    if (!mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate.toLocal()),
    );
    if (time == null) return null;

    return DateTime.utc(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _showAddOrEditEventDialog({PlannerEventEntity? event}) {
    final isEditing = event != null;
    final plannerState = context.read<PlannerState>();
    final titleController = TextEditingController(text: event?.title ?? '');
    final descController = TextEditingController(text: event?.description ?? '');

    final startDateTimeNotifier = ValueNotifier(event?.startDateTime ?? _focusedDay.toUtc());
    final endDateTimeNotifier = ValueNotifier(event?.endDateTime ?? _focusedDay.toUtc().add(const Duration(hours: 1)));
    final rruleNotifier = ValueNotifier<String?>(event?.rrule);

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
                      label: Text('Starts: ${DateFormat.yMd().add_jm().format(currentStart.toLocal())}'),
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
                      label: Text('Ends:   ${DateFormat.yMd().add_jm().format(currentEnd.toLocal())}'),
                      onPressed: () async {
                        final pickedDateTime = await _pickDateTime(initialDate: currentEnd);
                        if (pickedDateTime != null && pickedDateTime.isAfter(startDateTimeNotifier.value)) {
                          endDateTimeNotifier.value = pickedDateTime;
                        }
                      },
                    );
                  },
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: rruleNotifier,
                  builder: (context, currentRrule, child) {
                    final bool isRecurring = currentRrule != null && currentRrule.isNotEmpty;

                    return TextButton.icon(
                      icon: const Icon(Icons.repeat),
                      label: Text(isRecurring ? 'Repeats' : "Don't repeat"),
                      onPressed: () async {
                        final newRrule = await showDialog<String?>(
                          context: context,
                          builder: (_) => _RecurrenceOptionsDialog(
                            initialRrule: currentRrule,
                            eventStartDate: startDateTimeNotifier.value,
                          ),
                        );
                        if (newRrule != null) {
                          rruleNotifier.value = newRrule == 'clear' ? null : newRrule;
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
                    final updatedEvent = PlannerEventEntity(
                      id: event.id,
                      title: titleController.text,
                      description: descController.text.isNotEmpty ? descController.text : null,
                      startDateTime: startDateTimeNotifier.value,
                      endDateTime: endDateTimeNotifier.value,
                      rrule: rruleNotifier.value,
                      color: event.color,
                    );
                    plannerState.updateEvent(updatedEvent);
                  } else {
                    final newEvent = PlannerEventEntity(
                      title: titleController.text,
                      description: descController.text.isNotEmpty ? descController.text : null,
                      startDateTime: startDateTimeNotifier.value,
                      endDateTime: endDateTimeNotifier.value,
                      rrule: rruleNotifier.value,
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
              Text('From: ${DateFormat.yMMMEd().add_jm().format(event.startDateTime.toLocal())}'),
              Text('To:      ${DateFormat.yMMMEd().add_jm().format(event.endDateTime.toLocal())}'),
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
    final List<CalendarEventData<PlannerEventEntity>> calendarEvents = [];
    for (final event in plannerState.events) {
      if (event.rrule == null) {
        final daysSpanned = getDaysInBetween(event.startDateTime, event.endDateTime);
        for (final day in daysSpanned) {
          final isFirstDay = day.isAtSameMomentAs(daysSpanned.first);
          final isLastDay = day.isAtSameMomentAs(daysSpanned.last);
          final dayStartTime = isFirstDay ? event.startDateTime : DateTime.utc(day.year, day.month, day.day);
          final dayEndTime = isLastDay ? event.endDateTime : DateTime.utc(day.year, day.month, day.day, 23, 59, 59);

          calendarEvents.add(
            CalendarEventData(
              date: day.toLocal(),
              startTime: dayStartTime,
              endTime: dayEndTime,
              title: event.title,
              description: event.description ?? '',
              color: event.color,
              event: event,
            ),
          );
        }
      } else {
        try {
          final rule = RecurrenceRule.fromString(event.rrule!);
          final duration = event.endDateTime.difference(event.startDateTime);

          final occurrences = rule.getInstances(
            start: event.startDateTime,
            before: DateTime.now().toUtc().add(const Duration(days: 365 * 2)),
          );

          for (final occurrenceStart in occurrences) {
            final occurrenceEnd = occurrenceStart.add(duration);
            final daysSpanned = getDaysInBetween(occurrenceStart, occurrenceEnd);
            for (final day in daysSpanned) {
              final isFirstDay = day.isAtSameMomentAs(daysSpanned.first);
              final isLastDay = day.isAtSameMomentAs(daysSpanned.last);
              final dayStartTime = isFirstDay ? occurrenceStart : DateTime.utc(day.year, day.month, day.day);
              final dayEndTime = isLastDay ? occurrenceEnd : DateTime.utc(day.year, day.month, day.day, 23, 59, 59);

              calendarEvents.add(
                CalendarEventData(
                  date: day.toLocal(),
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
        } catch (e) {
          calendarEvents.add(
            CalendarEventData(
              date: event.startDateTime.toLocal(),
              startTime: event.startDateTime,
              endTime: event.endDateTime,
              title: event.title,
              description: event.description ?? '',
              color: event.color,
              event: event,
            ),
          );
        }
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

enum _EndCondition { never, onDate, afterCount }

class _RecurrenceOptionsDialog extends StatefulWidget {
  final String? initialRrule;
  final DateTime eventStartDate;
  const _RecurrenceOptionsDialog({this.initialRrule, required this.eventStartDate});

  @override
  State<_RecurrenceOptionsDialog> createState() => __RecurrenceOptionsDialogState();
}

class __RecurrenceOptionsDialogState extends State<_RecurrenceOptionsDialog> {
  late Frequency _frequency;
  late int _interval;
  DateTime? _until;
  int? _count;
  late _EndCondition _endCondition;

  final _intervalController = TextEditingController();
  final _countController = TextEditingController();

  final List<Frequency> _frequencies = const [
    Frequency.yearly,
    Frequency.monthly,
    Frequency.weekly,
    Frequency.daily,
  ];

  @override
  void initState() {
    super.initState();
    RecurrenceRule? initialRule;
    try {
      initialRule = RecurrenceRule.fromString(widget.initialRrule ?? '');
    } catch (_) {}

    _frequency = initialRule?.frequency ?? Frequency.daily;
    _interval = initialRule?.interval ?? 1;
    _until = initialRule?.until;
    _count = initialRule?.count;

    if (_until != null) {
      _endCondition = _EndCondition.onDate;
    } else if (_count != null) {
      _endCondition = _EndCondition.afterCount;
    } else {
      _endCondition = _EndCondition.never;
    }

    _intervalController.text = _interval.toString();
    if (_count != null) _countController.text = _count.toString();
  }

  @override
  void dispose() {
    _intervalController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _save() {
    final int? finalCount = _endCondition == _EndCondition.afterCount ? _count : null;
    final DateTime? finalUntil = _endCondition == _EndCondition.onDate ? _until : null;

    final rule = RecurrenceRule(
      frequency: _frequency,
      interval: _interval,
      until: finalUntil,
      count: finalCount,
    );
    Navigator.of(context).pop(rule.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Event repeats'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _intervalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Every'),
                    onChanged: (value) => setState(() => _interval = int.tryParse(value) ?? 1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: DropdownButton<Frequency>(
                      isExpanded: true,
                      value: _frequency,
                      underline: const SizedBox(),
                      onChanged: (value) {
                        if (value != null && _frequencies.contains(value)) {
                          setState(() => _frequency = value);
                        }
                      },
                      items: _frequencies
                          .map((f) => DropdownMenuItem(value: f, child: Text(f.toString().split('.').last)))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Ends', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<_EndCondition>(
              title: const Text('Never'),
              value: _EndCondition.never,
              groupValue: _endCondition,
              onChanged: (v) => setState(() {
                _endCondition = v!;
                _until = null;
                _count = null;
              }),
            ),
            RadioListTile<_EndCondition>(
              title: Text(
                _until == null || _endCondition != _EndCondition.onDate
                    ? 'On a date...'
                    : 'On ${DateFormat.yMd().format(_until!.toLocal())}',
              ),
              value: _EndCondition.onDate,
              groupValue: _endCondition,
              onChanged: (v) async {
                setState(() => _endCondition = v!);
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _until?.toLocal() ?? DateTime.now(),
                  firstDate: widget.eventStartDate.toLocal(),
                  lastDate: DateTime(2040),
                );
                if (pickedDate != null) {
                  setState(() {
                    _until = DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59);
                    // No need to set _count to null here as _save uses finalCount
                  });
                }
              },
            ),
            RadioListTile<_EndCondition>(
              title: const Text('After a number of occurrences'),
              value: _EndCondition.afterCount,
              groupValue: _endCondition,
              onChanged: (v) => setState(() {
                _endCondition = v!;
                _until = null;
                if (_count == null) {
                  _countController.clear();
                }
              }),
            ),
            if (_endCondition == _EndCondition.afterCount)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Occurrences'),
                  onChanged: (value) => setState(() => _count = int.tryParse(value)),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop('clear');
          },
          child: const Text('DONT REPEAT'),
        ),
        const Spacer(),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(onPressed: _save, child: const Text('Done')),
      ],
    );
  }
}
