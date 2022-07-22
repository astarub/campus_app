part of 'moodle_bloc.dart';

@immutable
abstract class MoodleState {
  const MoodleState();
}

class MoodleInitial extends MoodleState {}

class MoodleLoadingState extends MoodleState {}

class MoodleLoadedState extends MoodleState {
  final List<MoodleCourseEntity> courses;
  const MoodleLoadedState({required this.courses});
}

class MoodleErrorState extends MoodleState {
  final Failure failure;
  const MoodleErrorState({required this.failure});
}
