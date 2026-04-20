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

class EmailLoginScreen extends StatefulWidget {
  final Future<void> Function(String username, String password) onLogin;
  final void Function()? onLoginSuccess;
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

  bool showErrorMessage = false;
  String errorMessage = '';

  bool loading = false;
  bool _disposed = false;

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
    if (_disposed) return;

    final navigator = Navigator.of(context);
    final userName = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (userName.isEmpty || password.isEmpty) {
      _showError('Bitte fülle beide Felder aus!');
      return;
    }

    if (await walletUtils.hasNetwork() == false) {
      _showError('Überprüfe deine Internetverbindung!');
      return;
    }

    setState(() {
      showErrorMessage = false;
      loading = true;
    });

    final previousLoginId = await secureStorage.read(key: 'loginId');
    final previousPassword = await secureStorage.read(key: 'password');

    await secureStorage.write(key: 'loginId', value: usernameController.text);
    await secureStorage.write(key: 'password', value: passwordController.text);

    try {
      await widget.onLogin(userName, password).timeout(const Duration(seconds: 30));

      if (!_disposed) {
        widget.onLoginSuccess?.call();
        navigator.pop();
      }
    } on TimeoutException {
      _showError('Server antwortet nicht. Versuche es später erneut.');
      await _restorePreviousCredentials(previousLoginId, previousPassword);
    } on SocketException {
      _showError('Überprüfe deine Netzwerkverbindung!');
      await _restorePreviousCredentials(previousLoginId, previousPassword);
    } on InvalidLoginIDAndPasswordException {
      _showError('Falsche LoginID und/oder Password!');
      await _restorePreviousCredentials(previousLoginId, previousPassword);
    } catch (e) {
      debugPrint('Login error type: ${e.runtimeType}, message: $e');
      await _restorePreviousCredentials(previousLoginId, previousPassword);
    } finally {
      if (!_disposed) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!_disposed) {
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
                  if (loading) ...[
                    CircularProgressIndicator(
                      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                      color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                      strokeWidth: 3,
                    ),
                  ],
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
    _disposed = true;
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
