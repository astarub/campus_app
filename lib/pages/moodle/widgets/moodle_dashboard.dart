import 'package:campus_app/pages/.widgets/error_message.dart';
import 'package:campus_app/pages/moodle/bloc/moodle_bloc.dart';
import 'package:campus_app/utils/pages/moodle_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoodleDashboard extends StatelessWidget {
  const MoodleDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final moodleBloc = BlocProvider.of<MoodleBloc>(context);

    final utils = MoodleUtils();

    return BlocBuilder<MoodleBloc, MoodleState>(
      builder: (context, moodleState) {
        if (moodleState is MoodleInitial) {
          moodleBloc.add(CoursesRequestedEvent());
        } else if (moodleState is MoodleLoadingState) {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (moodleState is MoodleLoadedState) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: utils.getCourseWidgetList(moodleState.courses),
            ),
          );
        } else if (moodleState is MoodleErrorState) {
          return ErrorMessage(
            message: utils.mapFailureToMessage(moodleState.failure, context),
          );
        }

        return const Placeholder(); // TODO: throw an exception instead
      },
    );
  }
}
