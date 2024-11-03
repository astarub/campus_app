import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_detail_page.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    super.key,
    required this.event,
    this.padding = EdgeInsets.zero,
    this.boxShadow = const BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
    this.openable = true,
  });

  @override
  Widget build(BuildContext context) {
    final startingTime = DateFormat('Hm').format(event.startDate);
    final month = DateFormat('LLL').format(event.startDate);
    final day = DateFormat('dd').format(event.startDate);

    return Container(
      margin:
          openable ? const EdgeInsets.only(bottom: 14, left: 7, right: 7, top: 5) : const EdgeInsets.only(bottom: 10),
      padding: padding,
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [boxShadow],
      ),
      child: CustomButton(
        borderRadius: BorderRadius.circular(15),
        highlightColor: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
            ? const Color.fromRGBO(0, 0, 0, 0.03)
            : const Color.fromRGBO(255, 255, 255, 0.03),
        splashColor: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
            ? const Color.fromRGBO(0, 0, 0, 0.04)
            : const Color.fromRGBO(255, 255, 255, 0.04),
        tapHandler: openable ? () => context.pushTransparentRoute(CalendarDetailPage(event: event)) : () {},
        longPressHandler: openable ? () => context.pushTransparentRoute(CalendarDetailPage(event: event)) : () {},
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
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (event.pinned) ...[
                          Icon(
                            Icons.push_pin,
                            color: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                                ? const Color.fromRGBO(34, 40, 54, 1)
                                : const Color.fromRGBO(245, 246, 250, 1),
                          ),
                        ],
                        SizedBox(
                          width: event.pinned
                              ? MediaQuery.of(context).size.width - 150
                              : MediaQuery.of(context).size.width - 130,
                          child: StyledHTML(
                            context: context,
                            text: event.title,
                            textStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: Text(
                              'Beginn: $startingTime Uhr\t',
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            child: StyledHTML(
                              context: context,
                              text: event.cost == null
                                  ? ''
                                  : "\tKosten: ${event.cost!['value']} ${event.cost!['currency']}",
                              textStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
