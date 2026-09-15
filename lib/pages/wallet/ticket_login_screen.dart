import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_auth_provider.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_auth_service.dart';
import 'package:campus_app/pages/wallet/ticket_warning_notifier.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_icon_button.dart';
import 'package:campus_app/utils/widgets/campus_textfield.dart';

class TicketLoginScreen extends StatefulWidget {
  final void Function() onTicketLoaded;

  const TicketLoginScreen({
    super.key,
    required this.onTicketLoaded,
  });

  @override
  State<TicketLoginScreen> createState() => _TicketLoginScreenState();
}

class _TicketLoginScreenState extends State<TicketLoginScreen> {
  final TicketAuthService ticketAuthService = sl<TicketAuthService>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillLoginId();
  }

  Future<void> _prefillLoginId() async {
    final String? loginId = await ticketAuthService.getStoredLoginId();

    if (!mounted || loginId == null || loginId.isEmpty) return;

    usernameController.text = loginId;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TicketAuthProvider authProvider = context.watch<TicketAuthProvider>();

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
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
                      context.read<TicketAuthProvider>().clearError();
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  CampusTextField(
                    textFieldController: passwordController,
                    obscuredInput: true,
                    textFieldText: 'RUB Password',
                    onTap: () {
                      context.read<TicketAuthProvider>().clearError();
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  if (authProvider.errorMessage != null) ...[
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
                          authProvider.errorMessage!,
                          style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelSmall!.copyWith(
                                color: Colors.redAccent,
                              ),
                        ),
                      ],
                    ),
                  ],
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  CampusButton(
                    text: authProvider.isLoading ? 'Signing in...' : 'Login',
                    onTap: () async {
                      if (authProvider.isLoading) return;

                      final NavigatorState navigator = Navigator.of(context);
                      final TicketAuthProvider authProviderNotifier = context.read<TicketAuthProvider>();
                      final TicketWarningNotifier ticketWarningNotifier = context.read<TicketWarningNotifier>();

                      final bool success = await authProviderNotifier.login(
                        loginId: usernameController.text,
                        password: passwordController.text,
                      );

                      if (!mounted) return;

                      if (success) {
                        widget.onTicketLoaded();
                        ticketWarningNotifier.set(false);
                        navigator.pop();
                      }
                    },
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
                  if (authProvider.isLoading) ...[
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
}
