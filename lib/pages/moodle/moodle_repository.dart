import 'package:campus_app/core/authentication/authentication_datasource.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/moodle/entities/moodle_course_entity.dart';
import 'package:campus_app/pages/moodle/models/moodle_course_model.dart';
import 'package:campus_app/pages/moodle/moodle_datasource.dart';
import 'package:dartz/dartz.dart';

class MoodleRepository {
  final MoodleDatasource moodleDatasource;
  final AuthenticationDatasource authenticationDatasource;

  MoodleRepository({
    required this.moodleDatasource,
    required this.authenticationDatasource,
  });

  /// Return a list of moodle courses of authenticated user or failure
  Future<Either<Failure, List<MoodleCourseEntity>>> getEnrolledCourses(
    int userid,
  ) async {
    try {
      final token = await authenticationDatasource.getMoodleToken();

      if (token == null) {
        return Left(NotAuthenticatedFailure());
      }

      final jsonCourses = await moodleDatasource.getUsersCoursesAsJson(token, userid);

      final List<MoodleCourseEntity> courses = [];

      for (final Map<String, dynamic> json in jsonCourses) {
        courses.add(MoodleCourseModel.fromJson(json, token));
      }

      return Right(courses);
    } catch (e) {
      switch (e.runtimeType) {
        case ServerException:
          return Left(ServerFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }

  /// Return userid of authenticated user
  Future<Either<Failure, int>> getUserid() async {
    try {
      final token = await authenticationDatasource.getMoodleToken();

      if (token == null) {
        return Left(NotAuthenticatedFailure());
      }

      final siteInfo = await moodleDatasource.getSiteInfoAsJson(token);

      if (siteInfo['userid'] == null) {
        return Left(ServerFailure());
      }

      return Right(siteInfo['userid']);
    } catch (e) {
      switch (e.runtimeType) {
        case ServerException:
          return Left(ServerFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }
}
