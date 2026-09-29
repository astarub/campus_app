import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/utils/widgets/decision_popup.dart';

/// The EmailAuthPage handles both the authentication and visual progress indicator of the email login.
class EmailAuthPage extends StatefulWidget {
  final Future<void> Function() login;
  final Future<void> Function()? onLoginSuccess;

  const EmailAuthPage({super.key, required this.login, this.onLoginSuccess});

  @override
  State<EmailAuthPage> createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends State<EmailAuthPage> {
  bool _userHasAccepted = false;

  @override
  void initState() {
    super.initState();
  }

  // run the authentication and wait for the emails to load before exiting back to the email page
  Future<void> _runLogin() async {
    try {
      await widget.login();
      if (!mounted) return;

      final authService = Provider.of<EmailAuthService>(context, listen: false);

      final result = await authService.verifyEmailAddress();

      if (!mounted) return;

      // let login screen handle the error feedback
      switch (result.status) {
        case VerificationStatus.success:
          await widget.onLoginSuccess?.call();
          if (!mounted) return;
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          break;

        case VerificationStatus.bounced:
          Navigator.of(context).pop('bounced');
          break;

        case VerificationStatus.outOfAttempts:
          Navigator.of(context).pop('out_of_attempts');
          break;

        case VerificationStatus.sendFailed:
          Navigator.of(context).pop('send_failed');
          break;

        default:
          Navigator.of(context).pop('error');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(e); //give feedback to the login page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: MediaQuery.heightOf(context) * 0.075,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _userHasAccepted
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                      color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                      strokeWidth: 3,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: DecisionPopup(
                          height: MediaQuery.sizeOf(context).height * 0.6,
                          leadingTitle: 'Erlaubnis',
                          title: 'Email Verifizierung',
                          content:
                              'Um fortzufahren, müssen wir deine Email Addresse verifizieren.\n \n Dafür verschicken wir eine Email von deinem eigenen RUB Postfach an die von dir angegebenen Email. \n \n Um diesen Email Client zu benutzten, musst du diesem aus Sicherheitsgründen zustimmen. \n \n Indem du hier fortfährst, erlaubst du uns einmalig eine Email von deinem Postfach aus zu verschicken.',
                          onAccept: () {
                            setState(() {
                              _userHasAccepted = true;
                            });

                            _runLogin();
                          },
                          onDecline: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),

                      // account for navbar space
                      const SizedBox(height: 40),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
