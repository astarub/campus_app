// This is a temporary file to provide a login screen visually and basically functionally identical to the ticket login screen
// The goal is to eventually replace both the ticket and email login screen with a central login portal screen

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/utils/pages/wallet_utils.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/campus_textfield.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/pages/email_client/email_pages/email_auth_page.dart';

class EmailLoginScreen extends StatefulWidget {
  final Future<void> Function(String username, String password, String emailAddress, String displayName) onLogin;
  final Future<void> Function()? onLoginSuccess;
  const EmailLoginScreen({super.key, required this.onLoginSuccess, required this.onLogin});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  //final TicketRepository ticketRepository = sl<TicketRepository>();
  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();
  final WalletUtils walletUtils = sl<WalletUtils>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController submitButtonController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController emailDisplayNameController = TextEditingController();

  String _suggestedDisplayName = '';
  bool showErrorMessage = false;
  String errorMessage = '';
  bool emailIsValid = false;

  @override
  void initState() {
    super.initState();
    emailAddressController.addListener(_onEmailChange);
  }

  // track changes to the Email Field to generate display name and validate email format
  void _onEmailChange() {
    final emailAddress = emailAddressController.text.trim();

    // check two attributes of the email:
    // First: it contains an @ symbol that is Second: followed by a .de on which the email address ends, since all RUB email addresses end on ".de"
    if (emailAddress.contains('@') && emailAddress.endsWith('.de')) {
      setState(() {
        emailIsValid = true;
      });
    } else {
      setState(() => emailIsValid = false);
    }

    if (emailAddress.contains('@')) {
      final precurser = emailAddress.split('@').first;

      final autoDisplayName = precurser
          .split('.')
          .map((part) => part.isNotEmpty ? '${part[0].toUpperCase()}${part.substring(1)}' : '')
          .join(' ');
      setState(() {
        _suggestedDisplayName = autoDisplayName;
      });

      if (emailDisplayNameController.text.isEmpty) {
        emailDisplayNameController.text = autoDisplayName;
      }
    } else {
      setState(() {
        _suggestedDisplayName = '';
      });
    }
  }

  Future<void> _restorePreviousCredentials(String? previousUsername, String? previousPassword) async {
    try {
      if (previousUsername != null && previousPassword != null) {
        await secureStorage.write(key: 'loginId', value: previousUsername);
        await secureStorage.write(key: 'password', value: previousPassword);
      }
    } catch (e) {
      debugPrint('Error restoring credentials: $e');
    }
  }

  Future<void> _handleLogin() async {
    final navigator = Navigator.of(context);
    final userName = usernameController.text.trim();
    final password = passwordController.text.trim();
    final emailAddress = emailAddressController.text.trim();
    final emailDisplayName = emailDisplayNameController.text.trim().isNotEmpty
        ? emailDisplayNameController.text.trim()
        : _suggestedDisplayName;

    if (userName.isEmpty || password.isEmpty || emailAddress.isEmpty || !emailIsValid) {
      _showError('Bitte fülle alle Felder aus!');
      return;
    }

    if (await walletUtils.hasNetwork() == false) {
      _showError('Überprüfe deine Internetverbindung!');
      return;
    }

    if (mounted) setState(() => showErrorMessage = false);

    final previousLoginId = await secureStorage.read(key: 'loginId');
    final previousPassword = await secureStorage.read(key: 'password');

    await secureStorage.write(key: 'loginId', value: usernameController.text);
    await secureStorage.write(key: 'password', value: passwordController.text);

    if (!mounted) return;

    final error = await navigator.push<Object?>(
      MaterialPageRoute(
        builder: (_) => EmailAuthPage(
          login: () => widget.onLogin(userName, password, emailAddress, emailDisplayName).timeout(
                const Duration(seconds: 30),
              ),
          onLoginSuccess: widget.onLoginSuccess,
        ),
      ),
    );

    if (!mounted) return;

    if (error != null) {
      await _restorePreviousCredentials(previousLoginId, previousPassword);
      _handleError(error);
    }
  }

  void _handleError(Object error) {
    if (error is TimeoutException) {
      _showError('Server antwortet nicht. Versuche es später erneut.');
    } else if (error is SocketException) {
      _showError('Überprüfe deine Netzwerkverbindung!');
    } else if (error is InvalidLoginIDAndPasswordException) {
      _showError('Falsche LoginID und/oder Password!');
    } else {
      debugPrint('Login error type: ${error.runtimeType}, message: $error');
      _showError('Ein unbekannter Fehler ist aufgetreten.');
    }
  }

  void _showError(String message) {
    if (mounted) {
      setState(() {
        errorMessage = message;
        showErrorMessage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CampusIconButton(
                    iconPath: 'assets/img/icons/arrow-left.svg',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/icons/rub-link.png',
                    color: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                        ? const Color.fromRGBO(0, 53, 96, 1)
                        : Colors.white,
                    width: 80,
                    filterQuality: FilterQuality.high,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  CampusTextField(
                    textFieldController: usernameController,
                    textFieldText: 'RUB LoginID',
                    onTap: () {
                      setState(() {
                        showErrorMessage = false;
                      });
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  CampusTextField(
                    textFieldController: passwordController,
                    obscuredInput: true,
                    textFieldText: 'RUB Passwort',
                    onTap: () {
                      setState(() {
                        showErrorMessage = false;
                      });
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  CampusTextField(
                    textFieldController: emailAddressController,
                    textFieldText: 'RUB E-Mail Adresse',
                    onTap: () {
                      setState(() {
                        showErrorMessage = false;
                      });
                    },
                  ),
                  // show a warning while Email is not in valid format
                  if (!emailIsValid && emailAddressController.text.isNotEmpty)
                    const Padding(
                      padding: EdgeInsetsGeometry.only(top: 5),
                      child: Text(
                        'Gebe eine valide RUB Email Adresse an!',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  CampusTextField(
                    textFieldController: emailDisplayNameController,
                    textFieldText: 'Anzeigename (optional)',
                    onTap: () {
                      setState(() {
                        showErrorMessage = false;
                      });
                    },
                  ),
                  // Reminder Preview Suggestion text
                  if (_suggestedDisplayName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsGeometry.only(top: 5),
                      child: Text(
                        'Automatischer Anzeigename: $_suggestedDisplayName',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  if (showErrorMessage) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/img/icons/error.svg',
                          colorFilter: const ColorFilter.mode(
                            Colors.redAccent,
                            BlendMode.srcIn,
                          ),
                          width: 18,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                        ),
                        Text(
                          errorMessage,
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall!.copyWith(
                                color: Colors.redAccent,
                              ),
                        ),
                      ],
                    ),
                  ],
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  CampusButton(
                    text: 'Login',
                    onTap: _handleLogin,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/img/icons/info.svg',
                        colorFilter: ColorFilter.mode(
                          Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                              ? Colors.black
                              : const Color.fromRGBO(184, 186, 191, 1),
                          BlendMode.srcIn,
                        ),
                        width: 18,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      SizedBox(
                        width: 320,
                        child: Text(
                          'Deine Daten werden verschlüsselt auf deinem Gerät gespeichert und nur bei der Anmeldung an die RUB gesendet.',
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall!.copyWith(
                                color: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                                    ? Colors.black
                                    : const Color.fromRGBO(184, 186, 191, 1),
                              ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 25)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailAddressController.dispose();
    emailDisplayNameController.dispose();
    super.dispose();
  }
}
