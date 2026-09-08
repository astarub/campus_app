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

enum LoginType { ticket, email }

class LoginScreen extends StatefulWidget {
  final LoginType loginType;
  final Future<void> Function(String username, String password) onLogin;
  final void Function()? onLoginSuccess;
  final String? customTitle;
  final String? customDescription;

  const LoginScreen({
    super.key,
    required this.loginType,
    required this.onLogin,
    this.onLoginSuccess,
    this.customTitle,
    this.customDescription,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();
  final WalletUtils walletUtils = sl<WalletUtils>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showErrorMessage = false;
  String errorMessage = '';
  bool loading = false;
  bool _disposed = false;

  String get _getDescription {
    if (widget.customDescription != null) return widget.customDescription!;
    return 'Deine Daten werden verschlüsselt auf deinem Gerät gespeichert und nur bei der Anmeldung an die RUB gesendet.';
  }

  String get _getUsernameLabel {
    switch (widget.loginType) {
      case LoginType.ticket:
        return 'RUB LoginID';
      case LoginType.email:
        return 'RUB LoginID';
    }
  }

  String get _getPasswordLabel {
    switch (widget.loginType) {
      case LoginType.ticket:
        return 'RUB Passwort';
      case LoginType.email:
        return 'RUB Passwort';
    }
  }

  String get _getStorageKeyPrefix {
    switch (widget.loginType) {
      case LoginType.ticket:
        return 'ticket_';
      case LoginType.email:
        return 'email_';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final savedUsername = await secureStorage.read(key: '${_getStorageKeyPrefix}loginId');
      final savedPassword = await secureStorage.read(key: '${_getStorageKeyPrefix}password');

      if (!_disposed && savedUsername != null) {
        usernameController.text = savedUsername;
      }
      if (!_disposed && savedPassword != null) {
        passwordController.text = savedPassword;
      }
    } catch (e) {
      debugPrint('Error loading credentials: $e');
    }
  }

  Future<void> _saveCredentials(String username, String password) async {
    try {
      await secureStorage.write(key: '${_getStorageKeyPrefix}loginId', value: username);
      await secureStorage.write(key: '${_getStorageKeyPrefix}password', value: password);
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }

  Future<void> _restorePreviousCredentials(String? previousUsername, String? previousPassword) async {
    try {
      if (previousUsername != null && previousPassword != null) {
        await secureStorage.write(key: '${_getStorageKeyPrefix}loginId', value: previousUsername);
        await secureStorage.write(key: '${_getStorageKeyPrefix}password', value: previousPassword);
      }
    } catch (e) {
      debugPrint('Error restoring credentials: $e');
    }
  }

  Future<void> _handleLogin() async {
    if (_disposed) return;

    final navigator = Navigator.of(context);
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Validate inputs
    if (username.isEmpty || password.isEmpty) {
      _showError('Bitte fülle beide Felder aus!');
      return;
    }

    // Check network
    final hasNetwork = await walletUtils.hasNetwork();
    if (!hasNetwork) {
      _showError('Überprüfe deine Internetverbindung!');
      return;
    }

    // Store previous credentials
    final previousLoginId = await secureStorage.read(key: '${_getStorageKeyPrefix}loginId');
    final previousPassword = await secureStorage.read(key: '${_getStorageKeyPrefix}password');

    // Save new credentials
    await _saveCredentials(username, password);

    setState(() {
      loading = true;
      showErrorMessage = false;
    });

    try {
      // Add timeout for the login operation
      await widget.onLogin(username, password).timeout(const Duration(seconds: 30));

      if (!_disposed) {
        widget.onLoginSuccess?.call();
        navigator.pop();
      }
    } on TimeoutException {
      _showError('Server antwortet nicht - bitte später versuchen');
      await _restorePreviousCredentials(previousLoginId, previousPassword);
    } on SocketException {
      _showError('Netzwerkfehler - Verbindung prüfen');
      await _restorePreviousCredentials(previousLoginId, previousPassword);
    } on InvalidLoginIDAndPasswordException {
      _showError('Falsche LoginID und/oder Passwort!');
      await _restorePreviousCredentials(previousLoginId, previousPassword);
    } catch (e) {
      debugPrint('Login error type: ${e.runtimeType}, message: $e');
      _showError(_getGenericErrorMessage());
      await _restorePreviousCredentials(previousLoginId, previousPassword);
    } finally {
      if (!_disposed) {
        setState(() => loading = false);
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
    final theme = Provider.of<ThemesNotifier>(context);
    final themeData = theme.currentThemeData;
    final isLightTheme = theme.currentTheme == AppThemes.light;

    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
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
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/icons/rub-link.png',
                      color: isLightTheme ? const Color.fromRGBO(0, 53, 96, 1) : Colors.white,
                      width: 80,
                      filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(height: 30),
                    CampusTextField(
                      textFieldController: usernameController,
                      textFieldText: _getUsernameLabel,
                      onTap: () => setState(() => showErrorMessage = false),
                    ),
                    const SizedBox(height: 10),
                    CampusTextField(
                      textFieldController: passwordController,
                      obscuredInput: true,
                      textFieldText: _getPasswordLabel,
                      onTap: () => setState(() => showErrorMessage = false),
                    ),
                    if (showErrorMessage) ...[
                      const SizedBox(height: 15),
                      _buildErrorWidget(themeData),
                    ],
                    const SizedBox(height: 15),
                    CampusButton(
                      text: 'Login',
                      onTap: _handleLogin,
                    ),
                    const SizedBox(height: 25),
                    _buildInfoWidget(themeData, isLightTheme),
                    if (loading) ...[
                      const SizedBox(height: 25),
                      CircularProgressIndicator(
                        backgroundColor: themeData.cardColor,
                        color: themeData.primaryColor,
                        strokeWidth: 3,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData themeData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/img/icons/error.svg',
          colorFilter: const ColorFilter.mode(Colors.redAccent, BlendMode.srcIn),
          width: 18,
        ),
        const SizedBox(width: 5),
        Text(
          errorMessage,
          style: themeData.textTheme.labelSmall?.copyWith(color: Colors.redAccent),
        ),
      ],
    );
  }

  Widget _buildInfoWidget(ThemeData themeData, bool isLightTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/img/icons/info.svg',
          colorFilter: ColorFilter.mode(
            isLightTheme ? Colors.black : const Color.fromRGBO(184, 186, 191, 1),
            BlendMode.srcIn,
          ),
          width: 18,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 320,
          child: Text(
            _getDescription,
            style: themeData.textTheme.labelSmall?.copyWith(
              color: isLightTheme ? Colors.black : const Color.fromRGBO(184, 186, 191, 1),
            ),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  String _getGenericErrorMessage() {
    switch (widget.loginType) {
      case LoginType.ticket:
        return 'Fehler beim Laden des Tickets! Bitte versuche es später erneut.';
      case LoginType.email:
        return 'Email-Login ist aktuell nicht verfügbar. Bitte versuche es später.';
    }
  }

  @override
  void dispose() {
    _disposed = true;
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
