part of 'moodle_bloc.dart';

@immutable
abstract class MoodleEvent {}

/// event when courses update is requested
class CoursesRequestedEvent extends MoodleEvent {}
