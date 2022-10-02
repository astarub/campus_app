import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

class CalendarDetailPage extends StatelessWidget {
  final Event event;

  final CalendarRepository calendarRepository = sl<CalendarRepository>();

  CalendarDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white.withOpacity(0.2),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Column(
                children: [
                  if (event.hasImage)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: CachedNetworkImage(imageUrl: event.imageUrl!),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        Padding(
                          padding: const EdgeInsets.only(top: 100, bottom: 40),
                          child: Html(
                            data: event.description != '' ? event.description : 'No description given.',
                            style: {
                              '*': Style(
                                color: const Color.fromARGB(255, 129, 129, 129),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                            },
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
                            child: Html(
                              data: event.organizers.join(', '),
                              style: {
                                '*': Style(
                                  color: const Color.fromARGB(255, 129, 129, 129),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              },
                            ),
                          ),
                        // Venue
                        if (event.venue.name != '')
                          Text(
                            'Veranstaltungsort',
                            textAlign: TextAlign.left,
                            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                          ),
                        if (event.venue.name != '')
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 30),
                            child: Html(
                              data: event.venue.toString(),
                              style: {
                                '*': Style(
                                  color: const Color.fromARGB(255, 129, 129, 129),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              },
                            ),
                          ),
                        // Notification-button
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 30),
                          child: Center(
                            child: CampusButton(
                              text: 'Remind Me',
                              onTap: () {
                                // TODO: show Message / Info Alert
                                calendarRepository.updateSavedEvents(event: event);
                              },
                            ),
                          ),
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
                  // Image(
                  //   image: event.image!.image,
                  //   color: Colors.transparent,
                  // ),
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
