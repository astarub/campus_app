import 'package:bloc/bloc.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/moodle/entities/moodle_course_entity.dart';
import 'package:campus_app/pages/moodle/moodle_usecases.dart';
import 'package:meta/meta.dart';

part 'moodle_event.dart';
part 'moodle_state.dart';

class MoodleBloc extends Bloc<MoodleEvent, MoodleState> {
  final MoodleUsecases moodleUsecases;

  MoodleBloc({required this.moodleUsecases}) : super(MoodleInitial()) {
    on<MoodleEvent>((event, emit) {});

    on<CoursesRequestedEvent>(
      (event, emit) async {
        emit(MoodleLoadingState());

        final failureOrCourses = await moodleUsecases.getEnrolledCourses();

        failureOrCourses.fold(
          (failure) => print(failure.runtimeType),
          (courses) => print(courses.runtimeType),
        );

        failureOrCourses.fold(
          (failure) => emit(MoodleErrorState(failure: failure)),
          (courses) => emit(MoodleLoadedState(courses: courses)),
        );
      },
    );
  }
}
