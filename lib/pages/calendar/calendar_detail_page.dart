import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';

class CalendarDetailPage extends StatefulWidget {
  final Event event;

  const CalendarDetailPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<CalendarDetailPage> createState() => _CalendarDetailState();
}

class _CalendarDetailState extends State<CalendarDetailPage> {
  final CalendarRepository calendarRepository = sl<CalendarRepository>();

  bool savedEvent = false;

  @override
  void initState() {
    super.initState();

    calendarRepository.updateSavedEvents().then((savedEvents) {
      savedEvents.fold((failure) => null, (list) {
        if (list.contains(widget.event)) {
          setState(() => savedEvent = true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return AnnotatedRegion<SystemUiOverlayStyle>(
    //   value: SystemUiOverlayStyle(
    //     statusBarBrightness: Brightness.dark,
    //     statusBarColor: Colors.white.withOpacity(0.2),
    //     statusBarIconBrightness: Brightness.light,
    //     systemNavigationBarColor: Colors.white,
    //     systemNavigationBarIconBrightness: Brightness.dark,
    //   ),
    //   child: Scaffold(
    //     backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
    //     body: SingleChildScrollView(
    //       physics: const BouncingScrollPhysics(),
    //       child: Stack(
    //         children: [
    //Column(
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        Padding(
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 12),
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
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  if (widget.event.hasImage)
                    ClipRRect(
                      // borderRadius: const BorderRadius.only(
                      //   bottomLeft: Radius.circular(25),
                      //   bottomRight: Radius.circular(25),
                      // ),
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: CachedNetworkImage(imageUrl: widget.event.imageUrl!),
                    ),
                  // Title
                  Row(
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
                              DateFormat('LLL').format(widget.event.startDate),
                              style: Provider.of<ThemesNotifier>(context)
                                  .currentThemeData
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                            Text(
                              DateFormat('dd').format(widget.event.startDate),
                              style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 9),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledHTML(
                                text: widget.event.title,
                                textStyle: Provider.of<ThemesNotifier>(context)
                                    .currentThemeData
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontSize: 21),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                transform: Matrix4.translationValues(0, -10, 0),
                                child: StyledHTML(
                                  text: widget.event.venue.name == ''
                                      ? 'Veranstaltungsort wird noch bekannt gegeben.'
                                      : widget.event.venue.toString(),
                                  textStyle: Provider.of<ThemesNotifier>(context)
                                      .currentThemeData
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Description
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: StyledHTML(
                      text: widget.event.description != '' ? widget.event.description : 'No description given.',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  // Hosts
                  if (widget.event.organizers.isNotEmpty)
                    Text(
                      'Host',
                      textAlign: TextAlign.left,
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                    ),
                  if (widget.event.organizers.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 30),
                      child: StyledHTML(
                        text: widget.event.organizers.join(', '),
                      ),
                    ),
                  // Venue
                  if (widget.event.venue.name != '')
                    Text(
                      'Veranstaltungsort',
                      textAlign: TextAlign.left,
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.headlineSmall,
                    ),
                  if (widget.event.venue.name != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 30),
                      child: StyledHTML(
                        text: widget.event.venue.toString(),
                      ),
                    ),
                  // Notification-button
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
                    child: Center(
                      child: CampusButton(
                        text: savedEvent ? 'Unsave Me' : 'Save Me',
                        onTap: saveEventAndShowMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //),
            // // Event item
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Container(
            //       //color: Colors.transparent,
            //       transform: Matrix4.translationValues(0, -65, 0),
            //       padding: const EdgeInsets.all(10),
            //       child: CalendarEventWidget(
            //         event: widget.event,
            //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //         //boxShadow: const BoxShadow(color: Colors.transparent),
            //         openable: false,
            //       ),
            //     ),
            //   ],
            // ),
            // // Back button
            // Padding(
            //   padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       CampusIconButton(
            //         iconPath: 'assets/img/icons/arrow-left.svg',
            //         onTap: () => Navigator.pop(context),
            //       ),
            //       CampusIconButton(
            //         iconPath: 'assets/img/icons/more.png',
            //         onTap: () {},
            //       ),
            //     ],
          ),
        ),
      ],
      //),
      //),
    );
  }

  /// Function that update the saved event state and show an info
  /// message inside a SnackBar
  Future<void> saveEventAndShowMessage() async {
    await calendarRepository.updateSavedEvents(event: widget.event);

    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // Show message on top of screen:
          // margin: EdgeInsets.only(
          //   bottom: MediaQuery.of(context).size.height - 250,
          // ),
          content: Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(129, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Text(
                savedEvent ? 'Unsaved' : 'Saved',
                style: Provider.of<ThemesNotifier>(context, listen: false).currentThemeData.textTheme.displayMedium,
              ),
            ),
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          elevation: 15,
          backgroundColor: Colors.transparent,
        ),
      );

      savedEvent = !savedEvent;
    });
  }
}
