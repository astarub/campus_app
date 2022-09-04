import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_event_entity.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

class CalendarEventWidget extends StatelessWidget {
  final CalendarEventEntity event;

  const CalendarEventWidget({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startingTime = DateFormat('Hm').format(event.startDate);
    final month = DateFormat('LLL').format(event.startDate);
    final day = DateFormat('dd').format(event.startDate);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
      ),
      child: CustomButton(
        borderRadius: BorderRadius.circular(15),
        highlightColor: const Color.fromRGBO(0, 0, 0, 0.03),
        splashColor: const Color.fromRGBO(0, 0, 0, 0.04),
        tapHandler: () {},
        child: Row(
          children: [
            // Date
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    month,
                    style: Provider.of<ThemesNotifier>(context)
                        .currentThemeData
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 14),
                  ),
                  Text(
                    day,
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            // Title & Times
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                  ),
                  Text(startingTime),
                  Text(event.costs != 0
                      ? event.costs % 2 == 0
                          ? event.costs.toInt().toString() + ' €'
                          : event.costs.toString() + '0 €'
                      : 'kostenlos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
