import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/calendar/calendar_event_entity.dart';
import 'package:campus_app/pages/calendar/calendar_usecases.dart';
import 'package:bloc/bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarUsecases usecases;

  CalendarBloc({required this.usecases}) : super(CalendarInitial()) {
    on<CalendarEvent>((event, emit) {});

    on<EventsRequestedEvent>((event, emit) async {
      emit(CalendarLoading());

      final eventsOrFailure = await usecases.getEventsList();

      eventsOrFailure.fold(
        (failure) => emit(CalendarError(failure: failure)),
        (events) => emit(CalendarLoaded(events: events)),
      );
    });
  }
}
