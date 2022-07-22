import 'package:auto_route/auto_route.dart';
import 'package:campus_app/core/authentication/bloc/authentication_bloc.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/routes/router.gr.dart';
import 'package:campus_app/pages/moodle/bloc/moodle_bloc.dart';
import 'package:campus_app/pages/moodle/widgets/moodle_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoodlePage extends StatelessWidget {
  const MoodlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationTodoState) {
              router.replaceAll(const [RUBSignInPageRoute()]);
            } else if (state is Authentication2FATodoState) {
              router.push(const RUBSignInPageRoute());
            }
          },
        )
      ],
      child: BlocProvider(
        create: (context) => sl<MoodleBloc>(),
        child: const MoodleDashboard(),
      ),
    );
  }
}
