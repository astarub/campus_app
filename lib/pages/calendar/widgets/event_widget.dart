import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_detail_page.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

/// This widget displays an event item in the events page
class CalendarEventWidget extends StatelessWidget {
  /// The referenced event data
  final Event event;

  /// The additional padding that should be applied around the
  /// content of the card
  final EdgeInsets padding;

  /// The shadow that should be applied to the card.
  final BoxShadow boxShadow;

  /// Wether the card should open a detail page or not.
  /// Usually this is only `false` when used inside the detail page itself.
  final bool openable;

  const CalendarEventWidget({
    Key? key,
    required this.event,
    this.padding = EdgeInsets.zero,
    this.boxShadow = const BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
    this.openable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startingTime = DateFormat('Hm').format(event.startDate);
    final month = DateFormat('LLL').format(event.startDate);
    final day = DateFormat('dd').format(event.startDate);

    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 250),
      openBuilder: (context, _) => CalendarDetailPage(event: event),
      closedBuilder: (context, VoidCallback openDetailsPage) => Container(
        margin: openable ? const EdgeInsets.only(bottom: 14, left: 7, right: 7, top: 5) : EdgeInsets.only(bottom: 10),
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [boxShadow],
        ),
        child: CustomButton(
          borderRadius: BorderRadius.circular(15),
          highlightColor: const Color.fromRGBO(0, 0, 0, 0.03),
          splashColor: const Color.fromRGBO(0, 0, 0, 0.04),
          tapHandler: openable ? openDetailsPage : () {},
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(
                        data: event.title,
                        style: {
                          '*': Style(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: const FontSize(18),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            'Beginn: $startingTime Uhr\t',
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                          ),
                          Text(
                            event.cost == null ? '' : "\tKosten: ${event.cost!['value']} ${event.cost!['currency']}",
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
