import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:campus_app/pages/planner/entities/planner_event_entity.dart';
import 'package:campus_app/core/themes.dart';

/// AUTOMATISCHE TEXTFARBE – KONTRAST
Color getReadableTextColor(Color backgroundColor) {
  double brightness = (backgroundColor.red * 0.299) +
      (backgroundColor.green * 0.587) +
      (backgroundColor.blue * 0.114);

  return brightness < 150 ? Colors.white : Colors.black;
}

// MonthViewCalendar UI widget.
class MonthViewCalendar extends StatelessWidget {
  const MonthViewCalendar({
    super.key,
    required this.themesNotifier,
    required this.focusedDay,
    required this.eventController,
    required this.onEventTap,
    required this.onDateTap,
    this.maxVisibleRows = 3,
  });

  final ThemesNotifier themesNotifier;
  final DateTime focusedDay;
  final EventController<PlannerEventEntity> eventController;
  final void Function(PlannerEventEntity) onEventTap;
  final void Function(DateTime) onDateTap;

  final int maxVisibleRows;

  void _showMoreSheet(
    BuildContext context,
    List<CalendarEventData<PlannerEventEntity>> hidden,
    void Function(PlannerEventEntity) onTap,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: hidden.length,
        itemBuilder: (_, idx) {
          final ev = hidden[idx];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: ev.color,
            ),
            title: Text(ev.title),
            onTap: () {
              Navigator.pop(context);
              onTap(ev.event!);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = themesNotifier.currentThemeData;

    return MonthView<PlannerEventEntity>(
      key: ValueKey('month_view_$focusedDay'),
      controller: eventController,
      initialMonth: focusedDay,
      borderColor: theme.dividerColor,
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: theme.cardColor),
        headerTextStyle: theme.textTheme.headlineSmall,
        leftIconConfig: IconDataConfig(
          color: theme.colorScheme.primary,
        ),
        rightIconConfig: IconDataConfig(
          color: theme.colorScheme.primary,
        ),
      ),

      // WEEKDAY HEADER
      weekDayBuilder: (dayIndex) {
        final day = DateTime(2024).add(Duration(days: dayIndex));
        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Center(
            child: Text(
              DateFormat.E().format(day),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        );
      },

      // INDIVIDUAL CELLS
      cellBuilder: (date, events, isToday, isInMonth, _) {
        if (!isInMonth) {
          return Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(3),
            child: Text('${date.day}', style: theme.textTheme.bodyMedium),
          );
        }

        return LayoutBuilder(
          builder: (ctx, constraints) {
            const rowH = 18.0;
            const maxRows = 3;
            final cellW = constraints.maxWidth;

            final rows = <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.primary,
                  ),
                ),
              ),
            ];

            final visible = events.take(maxRows).toList();
            final hidden = events.length - visible.length;

            /// EVENT BOXES
            for (final ev in visible) {
              rows.add(
                GestureDetector(
                  onTap: () => onEventTap(ev.event!),

                  child: Container(
                    width: cellW - 2,
                    height: rowH,
                    margin: const EdgeInsets.only(right: 2, top: 1),
                    decoration: BoxDecoration(
                      color: ev.color.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),

                    child: Builder(
                      builder: (context) {
                        final textColor = getReadableTextColor(ev.color);

                        return Text(
                          ev.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),
                ),
              );
            }

            /// "+ more"
            if (hidden > 0) {
              rows.add(
                GestureDetector(
                  onTap: () =>
                      _showMoreSheet(ctx, events.skip(maxRows).toList(), onEventTap),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      '+$hidden more',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onDateTap(date),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: rows,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
