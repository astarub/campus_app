import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class CalendarDetailPage extends StatelessWidget {
  final CalendarEventEntity event;

  const CalendarDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.white.withOpacity(0.2),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Column(
                children: [
                  if (event.image != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: event.image,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        Padding(
                          padding: const EdgeInsets.only(top: 100, bottom: 40),
                          child: Text(
                            event.description != '' ? event.description : 'No description given.',
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                          ),
                        ),
                        // Hosts
                        if (event.organizers.isNotEmpty)
                          Text(
                            'Host',
                            textAlign: TextAlign.left,
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                          ),
                        if (event.organizers.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 30),
                            child: Text(
                              event.organizers.join(', '),
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            ),
                          ),
                        // Venue
                        if (event.venue != '')
                          Text(
                            'Veranstaltungsort',
                            textAlign: TextAlign.left,
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                          ),
                        if (event.venue != '')
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 30),
                            child: Text(
                              event.venue,
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                            ),
                          ),
                        // Notification-button
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 30),
                          child: Center(child: CampusButton(text: 'Remind Me', onTap: () {})),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Event item
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: event.image!.image,
                    color: Colors.transparent,
                  ),
                  Container(
                    //color: Colors.transparent,
                    transform: Matrix4.translationValues(0, -65, 0),
                    padding: const EdgeInsets.all(10),
                    child: CalendarEventWidget(
                      event: event,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      //boxShadow: const BoxShadow(color: Colors.transparent),
                      openable: false,
                    ),
                  ),
                ],
              ),
              // Back button
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CampusIconButton(
                      iconPath: 'assets/img/icons/arrow-left.svg',
                      onTap: () => Navigator.pop(context),
                    ),
                    CampusIconButton(
                      iconPath: 'assets/img/icons/more.png',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
