import 'package:flutter/material.dart';
import 'package:campus_app/pages/rubsignin/widgets/signin_button.dart';
// import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    // final utils = Utils();

    // late String _loginId;
    // late String _password;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // TODO: set password and loginID in a good way...
    String? validateLoginID(String? input) {
      if (input == null || input.isEmpty) {
        return localization.empty_input_field;
      } else {
        // _loginId = input;
        return null;
      }
    }

    String? validatePassword(String? input) {
      if (input == null || input.isEmpty) {
        return localization.empty_input_field;
      } else {
        // _password = input;
        return null;
      }
    }

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 80),
            Text(
              localization.welcome,
              style: themeData.textTheme.headline1!.copyWith(
                fontSize: 50,
                fontWeight: FontWeight.w500,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              localization.login_prompt,
              style: themeData.textTheme.headline1!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              cursorColor: themeData.secondaryHeaderColor,
              decoration: InputDecoration(labelText: localization.rubid),
              validator: validateLoginID,
            ),
            const SizedBox(height: 20),
            TextFormField(
              cursorColor: themeData.secondaryHeaderColor,
              obscureText: true,
              decoration: InputDecoration(labelText: localization.password),
              validator: validatePassword,
            ),
            const SizedBox(height: 45),
            LoginInButton(
              buttonText: localization.login,
              callback: () {},
            ),
          ],
        ),
      ),
    );
  }
}
