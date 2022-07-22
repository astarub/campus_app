import 'package:auto_route/auto_route.dart';
import 'package:campus_app/core/authentication/bloc/authentication_bloc.dart';
import 'package:campus_app/core/routes/router.gr.dart';
import 'package:campus_app/pages/home/widgets/test_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationTodoState ||
                state is Authentication2FATodoState) {
              router.replace(const RUBSignInPageRoute());
            } else if (state is Authentication2FADoneState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.greenAccent,
                  content: Text(
                    localization.login_already,
                    style: themeData.textTheme.bodyText1,
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: const TestWidget(),
    );
  }
}
