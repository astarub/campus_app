part of 'calendar_bloc.dart';

abstract class CalendarState {
  const CalendarState();
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<CalendarEventEntity> events;
  const CalendarLoaded({required this.events});
}

class CalendarError extends CalendarState {
  final Failure failure;

  const CalendarError({
    required this.failure,
  });
}
