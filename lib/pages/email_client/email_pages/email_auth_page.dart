import 'package:campus_app/core/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The EmailAuthPage handles both the authentication and visual progress indicator of the email login.
class EmailAuthPage extends StatefulWidget {
  final Future<void> Function() login;
  final Future<void> Function()? onLoginSuccess;

  const EmailAuthPage({super.key, required this.login, this.onLoginSuccess});

  @override
  State<EmailAuthPage> createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends State<EmailAuthPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runLogin());
  }

  // run the authentication and wait for the emails to load before exiting back to the email page
  Future<void> _runLogin() async {
    try {
      await widget.login();
      if (!mounted) return;
      await widget.onLoginSuccess?.call();
      Navigator.of(context).pop(); //exit auth page
      Navigator.of(context).pop(); //exit login page to email page
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
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                strokeWidth: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
