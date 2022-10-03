import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/calendar/widgets/event_widget.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';

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
                  if (widget.event.hasImage)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: CachedNetworkImage(imageUrl: widget.event.imageUrl!),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        Padding(
                          padding: const EdgeInsets.only(top: 100, bottom: 40),
                          child: StyledHTML(
                            text: widget.event.description != '' ? widget.event.description : 'No description given.',
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
                ],
              ),
              // Event item
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    //color: Colors.transparent,
                    transform: Matrix4.translationValues(0, -65, 0),
                    padding: const EdgeInsets.all(10),
                    child: CalendarEventWidget(
                      event: widget.event,
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
