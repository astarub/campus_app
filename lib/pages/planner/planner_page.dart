// lib/pages/planner/planner_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/pages/planner/planner_state.dart';
import 'package:campus_app/utils/widgets/empty_state_placeholder.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';

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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late PlannerState _plannerState;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _plannerState = Provider.of<PlannerState>(context, listen: false);
  }

  List<PlannerEventEntity> _getEventsForDay(DateTime day) {
    return _plannerState.getEventsForDay(day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _showAddEventDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final ValueNotifier<TimeOfDay> dialogStartTimeNotifier = ValueNotifier(TimeOfDay.now());

    showDialog(
      context: context,
      builder: (alertDialogContext) {
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
                const SizedBox(height: 10),
                ValueListenableBuilder<TimeOfDay>(
                  valueListenable: dialogStartTimeNotifier,
                  builder: (context, currentTime, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: alertDialogContext,
                          initialTime: currentTime,
                        );
                        if (picked != null) {
                          dialogStartTimeNotifier.value = picked;
                        }
                      },
                      child: Text('Select Start Time (${currentTime.format(alertDialogContext)})'),
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
                if (titleController.text.isNotEmpty && _selectedDay != null) {
                  final newEvent = PlannerEventEntity(
                    title: titleController.text,
                    description: descController.text.isNotEmpty ? descController.text : null,
                    date: _selectedDay!,
                    startTime: dialogStartTimeNotifier.value,
                  );
                  _plannerState.addEvent(newEvent);
                  Navigator.pop(alertDialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themesNotifier = Provider.of<ThemesNotifier>(context);
    final currentPlannerState = context.watch<PlannerState>();

    return Scaffold(
      backgroundColor: themesNotifier.currentThemeData.colorScheme.surface,
      appBar: AppBar(
        title: Text('Planner', style: themesNotifier.currentThemeData.textTheme.displayMedium),
        backgroundColor: themesNotifier.currentThemeData.colorScheme.surface,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        tooltip: 'Add Event',
        backgroundColor: themesNotifier.currentThemeData.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar<PlannerEventEntity>(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: themesNotifier.currentThemeData.primaryColor.withAlpha((255 * 0.3).round()),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: themesNotifier.currentThemeData.primaryColorDark,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: themesNotifier.currentThemeData.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: themesNotifier.currentThemeData.textTheme.titleLarge ?? const TextStyle(),
              formatButtonTextStyle: themesNotifier.currentThemeData.textTheme.bodyMedium ?? const TextStyle(),
              formatButtonDecoration: BoxDecoration(
                color: themesNotifier.currentThemeData.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedDay != null
                ? Builder(
                    builder: (context) {
                      final dayEvents = currentPlannerState.getEventsForDay(_selectedDay!);
                      if (dayEvents.isEmpty) {
                        return const EmptyStatePlaceholder(title: 'No events', text: 'No events planned for this day.');
                      }
                      return ListView.builder(
                        itemCount: dayEvents.length,
                        itemBuilder: (context, index) {
                          final event = dayEvents[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            color: themesNotifier.currentThemeData.cardColor,
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    event.startTime.format(context),
                                    style: themesNotifier.currentThemeData.textTheme.bodyMedium,
                                  ),
                                  if (event.endTime != null)
                                    Text(
                                      event.endTime!.format(context),
                                      style: themesNotifier.currentThemeData.textTheme.bodySmall,
                                    ),
                                ],
                              ),
                              title: Text(event.title, style: themesNotifier.currentThemeData.textTheme.titleSmall),
                              subtitle: event.description != null
                                  ? Text(event.description!, style: themesNotifier.currentThemeData.textTheme.bodySmall)
                                  : null,
                              tileColor: event.color.withAlpha((255 * 0.3).round()),
                            ),
                          );
                        },
                      );
                    },
                  )
                : const Center(child: Text('Select a day to see events')),
          ),
        ],
      ),
    );
  }
}
