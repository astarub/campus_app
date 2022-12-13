import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/authentication/authentication_handler.dart';
// import 'package:campus_app/pages/rubsignin/widgets/signin_form.dart';

class RUBSignInPage extends StatelessWidget {
  const RUBSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthState currentAuthState = Provider.of<AuthenticationHandler>(context).currentAuthState;
    // Widget form = const SignInForm();

    return Scaffold(
      body: currentAuthState == AuthState.unauthenticated ? Container() : Container(),
    );

    /* return BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
    ); */
  }
}
