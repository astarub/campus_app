import 'package:auto_route/auto_route.dart';
import 'package:campus_app/core/authentication/bloc/authentication_bloc.dart';
import 'package:campus_app/pages/rubsignin/widgets/signin_form.dart';
import 'package:campus_app/pages/rubsignin/widgets/totp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputDecideWidget extends StatelessWidget {
  const InputDecideWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);

    Widget form = const SignInForm();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationTodoState) {
          form = const SignInForm();
        } else if (state is Authentication2FATodoState) {
          form = const TOTPForm();
        } else if (state is Authentication2FADoneState) {
          router.pop();
        }

        return form;
      },
    );
  }
}
