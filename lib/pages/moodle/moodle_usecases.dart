import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/mensa/entities/moodle_course_entity.dart';
import 'package:campus_app/pages/moodle/moodle_repository.dart';
import 'package:dartz/dartz.dart';

class MoodleUsecases {
  final MoodleRepository moodleRepository;

  MoodleUsecases({required this.moodleRepository});

  /// Return a list of moodle courses or a failure.
  Future<Either<Failure, List<MoodleCourseEntity>>> getEnrolledCourses() async {
    //? Cach loaded list; on Failure return cached data

    final failureOrUserid = await moodleRepository.getUserid();
    return failureOrUserid.fold(
      (failure) {
        return Left(failure);
      },
      (userid) async {
        return moodleRepository.getEnrolledCourses(userid);
      },
    );
  }
}
