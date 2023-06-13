import 'package:flutter/material.dart';
import 'package:campus_app/pages/rubsignin/widgets/signin_button.dart';
import 'package:campus_app/utils/pages/presentation_functions.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class TOTPForm extends StatelessWidget {
  const TOTPForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

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
              style: themeData.textTheme.displayLarge!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              cursorColor: themeData.secondaryHeaderColor,
              decoration: InputDecoration(labelText: localization.enter_totp),
              validator: validateTOTP,
            ),
            const SizedBox(height: 20),
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
