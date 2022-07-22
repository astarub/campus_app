import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/calendar/bloc/calendar_bloc.dart';
import 'package:campus_app/pages/calendar/widgets/calendar_error_message.dart';
import 'package:campus_app/utils/pages/calendar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CalendarBloc>(),
      child: const _CalendarPage(),
    );
  }
}

class _CalendarPage extends StatelessWidget {
  const _CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = CalendarUtils();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        bloc: BlocProvider.of<CalendarBloc>(context),
        builder: (context, calendarState) {
          if (calendarState is CalendarInitial) {
            BlocProvider.of<CalendarBloc>(context).add(EventsRequestedEvent());
          } else if (calendarState is CalendarLoading) {
            return const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (calendarState is CalendarLoaded) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: utils.getEventWidgetList(calendarState.events),
              ),
            );
          } else if (calendarState is CalendarError) {
            return CalendarErrorMessage(
              message:
                  utils.mapFailureToMessage(calendarState.failure, context),
            );
          }

          return const Placeholder(); // TODO: throw an exception instead
        },
      ),
    );
  }
}
