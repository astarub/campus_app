import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/email_client/widgets/progressbar_view.dart';
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
  String? _emailAddress;

  @override
  void initState() {
    super.initState();
    _loadUserEmailAddress();
  }

  Future<void> _loadUserEmailAddress() async {
    final authService = Provider.of<EmailAuthService>(context, listen: false);
    final address = await authService.getSenderEmail();

    if (!mounted) return;

    setState(() {
      _emailAddress = address;
    });
  }

  // run the authentication and wait for the emails to load before exiting back to the email page
  Future<void> _runLogin() async {
    try {
      final authService = Provider.of<EmailAuthService>(context, listen: false);
      authService.verifyProgress.value = const EmailProgress(0.02, 'Anmeldedaten werden geprüft');
      await widget.login();
      if (!mounted) return;

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
                    child:
                        ProgressbarView(progress: Provider.of<EmailAuthService>(context, listen: false).verifyProgress),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: DecisionPopup(
                          height: MediaQuery.sizeOf(context).height * 0.65,
                          leadingTitle: 'Erlaubnis',
                          title: 'Email Verifizierung',
                          acceptButtonText: 'Bestätigungs-E-Mail jetzt senden',
                          declineButtonText: 'Abbrechen',
                          content:
                              'Um zu prüfen, dass der Versand funktioniert und die Adresse dir gehört, senden wir einmalig eine E-Mail aus deinem Postfach an deine eigene Adresse [$_emailAddress]. Die E-Mail enthält nur einen Bestätigungscode und erscheint in deinem Ordner „Gesendet“ und im Posteingang. Du kannst sie danach löschen.',
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
