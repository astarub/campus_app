import 'package:auto_route/auto_route.dart';
import 'package:campus_app/pages/rubsignin/bloc/rubsignin_bloc.dart';
import 'package:campus_app/pages/rubsignin/widgets/signin_button.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class TOTPForm extends StatelessWidget {
  const TOTPForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context)!;
    final router = AutoRouter.of(context);

    final utils = Utils();

    late String _totp;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String? validateTOTP(String? input) {
      if (input == null || input.isEmpty) {
        return localization.empty_input_field;
      } else if (input.length != 6) {
        return localization.login_error;
      } else {
        _totp = input;
        return null;
      }
    }

    return BlocConsumer<RUBSignInBloc, RUBSignInState>(
      listener: (context, state) {
        state.failureOrSuccessOption.fold(
          () {},
          (failureOrSuccess) => failureOrSuccess.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text(
                    utils.mapFailureToMessage(failure, context),
                    style: themeData.textTheme.bodyText1,
                  ),
                ),
              );
            },
            (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.greenAccent,
                  content: Text(
                    localization.login_success,
                    style: themeData.textTheme.bodyText1,
                  ),
                ),
              );
              router.pop();
            },
          ),
        );
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(height: 80),
                Text(
                  localization.enter_totp,
                  style: themeData.textTheme.headline1!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  cursorColor: themeData.secondaryHeaderColor,
                  decoration:
                      InputDecoration(labelText: localization.enter_totp),
                  validator: validateTOTP,
                ),
                const SizedBox(height: 20),
                LoginInButton(
                  buttonText: localization.login,
                  callback: () {
                    if (formKey.currentState!.validate()) {
                      BlocProvider.of<RUBSignInBloc>(context)
                          .add(RUBSignInWithTOTP(totp: _totp));
                    } else {
                      BlocProvider.of<RUBSignInBloc>(context)
                          .add(RUBSignInWithTOTP(totp: null));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(
                            localization.login_error,
                            style: themeData.textTheme.bodyText1,
                          ),
                        ),
                      );
                    }
                  },
                ),
                if (state.isSubmitting) ...[
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    color: themeData.colorScheme.secondary,
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
