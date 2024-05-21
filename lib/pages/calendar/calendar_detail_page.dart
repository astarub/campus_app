import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/backend/backend_repository.dart';
import 'package:campus_app/pages/calendar/calendar_repository.dart';
import 'package:campus_app/pages/calendar/entities/event_entity.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:campus_app/core/backend/analytics/aptabase.dart';

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
  final BackendRepository backendRepository = sl<BackendRepository>();

  bool savedEvent = false;

  /// Function that updates the saved event state and shows an info
  /// message inside a [SnackBar]
  Future<void> saveEventAndShowMessage() async {
    setState(() {
      savedEvent = !savedEvent;
    });
    if (savedEvent) {
      await Aptabase.instance.trackEvent('saved_event', {'name': widget.event.title});
    }
    try {
      final SettingsHandler settingsHandler = Provider.of<SettingsHandler>(context, listen: false);

      if (settingsHandler.currentSettings.useFirebase != FirebaseStatus.forbidden &&
          settingsHandler.currentSettings.useFirebase != FirebaseStatus.uncofigured) {
        if (savedEvent) {
          await backendRepository.addSavedEvent(
            settingsHandler,
            widget.event,
          );
        } else {
          await backendRepository.removeSavedEvent(
            settingsHandler,
            widget.event.id,
            Uri.parse(widget.event.url).host,
          );
        }
      }
    } catch (e) {
      debugPrint(
        'Could not save event on the backend. Retrying when connection is re-established.',
      );
    }

    // Remove the event from the saved event cache
    await calendarRepository.updateSavedEvents(event: widget.event);
  }

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
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Buttons in header
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back
                CampusIconButton(
                  iconPath: 'assets/img/icons/arrow-left.svg',
                  onTap: () => Navigator.pop(context),
                ),
                CampusIconButton(
                  iconPath: 'assets/img/icons/share.svg',
                  onTap: () {
                    // Required for iPad, otherwise the Ui crashes
                    final box = context.findRenderObject() as RenderBox?;

                    Share.share(
                      'Campus App Event: ${widget.event.title}\nURL: ${widget.event.url}',
                      subject: widget.event.title,
                      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                    );
                  },
                ),
                // More
                /* CampusIconButton(
                  iconPath: 'assets/img/icons/more.png',
                  onTap: () {},
                ), */
              ],
            ),
          ),
          // Event content
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
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        child: CachedNetworkImage(imageUrl: widget.event.imageUrl!),
                      ),
                    // Info section
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          // Date
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                                  ? Colors.black
                                  : const Color.fromRGBO(34, 40, 54, 1),
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
                          // Event title & location
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 9),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StyledHTML(
                                    context: context,
                                    text: widget.event.title,
                                    textStyle: Provider.of<ThemesNotifier>(context)
                                        .currentThemeData
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontSize: 20),
                                    textAlign: TextAlign.left,
                                  ),
                                  Container(
                                    transform: Matrix4.translationValues(0, -10, 0),
                                    child: StyledHTML(
                                      context: context,
                                      text: widget.event.venue.name == ''
                                          ? 'Veranstaltungsort wird noch bekannt gegeben.'
                                          : '${widget.event.venue}<br> ${DateFormat('Hm').format(widget.event.startDate)} Uhr - ${DateFormat('Hm').format(widget.event.endDate)} Uhr',
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
                    ),
                    // Description
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 40),
                      child: StyledHTML(
                        context: context,
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
                          context: context,
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
                          context: context,
                          text: widget.event.venue.toString(),
                        ),
                      ),
                    // Notification-button
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: Center(
                        child: CampusButton(
                          text: savedEvent ? 'Nicht mehr merken' : 'Merken',
                          onTap: saveEventAndShowMessage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        //),
        //),
      ),
    );
  }
}
