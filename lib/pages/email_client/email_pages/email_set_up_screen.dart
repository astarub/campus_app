import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_md/flutter_md.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:campus_app/pages/email_client/services/email_background_service.dart';
import 'package:campus_app/utils/widgets/bubble_message.dart';
import 'package:campus_app/utils/widgets/bubble_service.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';

/// This is the Widget responsible for the privacy disclaimers as well as the terms and conditions of the email client.
class EmailSetUpScreen extends StatefulWidget {
  final Future<void> Function() onAccepted;
  const EmailSetUpScreen({super.key, required this.onAccepted});

  @override
  State<EmailSetUpScreen> createState() => _EmailSetUpScreenState();
}

class _EmailSetUpScreenState extends State<EmailSetUpScreen> {
  static const _privacyLink = 'https://mail.rub.de/mail/datenschutz';

  // set the permissions to false by default, explicit opt ins
  bool _termsAccepted = false;
  bool _publicNotifications = false;
  bool _notificationsEnabled = false;

  bool _hasContinued = false;

  late final TapGestureRecognizer _linkTap = TapGestureRecognizer()..onTap = _openPrivacyLink;
  late final TapGestureRecognizer _termsTap = TapGestureRecognizer()..onTap = _openTerms;

  @override
  void dispose() {
    _linkTap.dispose();
    _termsTap.dispose();
    super.dispose();
  }

  // helper function for the global bubble messeges
  void _showUpdateMessages(String message, {BubbleType type = BubbleType.info}) {
    if (!mounted) return;

    BubbleService().show(
      context,
      message: message,
      type: type,
      top: MediaQuery.paddingOf(context).top + 40,
    );
  }

  // hand off the link to the OS
  Future<void> _openPrivacyLink() async {
    try {
      final ok = await launchUrl(Uri.parse(_privacyLink), mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        _showUpdateMessages('Link konnte nicht geöffnet werden.', type: BubbleType.error);
      }
    } catch (_) {
      if (mounted) {
        _showUpdateMessages('Link konnte nicht geöffnet werden.', type: BubbleType.error);
      }
    }
  }

  // open the Terms and Conditions in a Dialog Widget
  Future<void> _openTerms() async {
    // get the terms and condidtions text
    final text = await rootBundle.loadString('assets/privacy/nutzungsbedingungen.md');

    if (!mounted) return;

    await showDialog(
      context: context,
      animationStyle: const AnimationStyle(
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final scrollController = ScrollController();

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.8,
              maxWidth: MediaQuery.sizeOf(ctx).width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),

                  // Header Section
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Nutzungsbedingungen',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Markdown Scrollable Body
                Flexible(
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      child: MarkdownWidget(
                        markdown: Markdown.fromString(text),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('E-Mail-Client einrichten')),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 30, right: 30, left: 30),

            // animated fade Transitions between the two "pages" (technically they are states, but for the User they function as seperate pages)
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  alignment: Alignment.center,
                  children: [...previousChildren, if (currentChild != null) currentChild],
                ),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: CurvedAnimation(parent: animation, curve: const Interval(0.5, 1, curve: Curves.easeIn)),
                  child: child,
                ),

                // depending on the step in the process, display the terms and conditions page (Step 1) or
                // Notification Setup/Route to Login page (Step 2)
                child: _hasContinued
                    ? KeyedSubtree(key: const ValueKey('login'), child: _buildLogin())
                    : KeyedSubtree(key: const ValueKey('terms'), child: _buildTerms()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // This is the Terms Page where the User has to agree to the terms and conditions before proceeding
  Widget _buildTerms() {
    final theme = Theme.of(context);
    final linkStyle = TextStyle(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: theme.colorScheme.primary,
    );

    return Column(
      children: [
        // Terms and Conditions Dialog text
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              const TextSpan(
                text:
                    'Mit dem E-Mail-Client greifst du über die Campus APP auf dein RUB-Postfach zu. Bitte beachte:\n\n'
                    '•    Wir können nicht garantieren, dass deine E-Mails ankommen. Für Prüfungsanmeldungen und andere fristgebundene Erklärungen nutze bitte die offiziellen Wege oder lass dir den Eingang bestätigen.\n\n'
                    '•    Deine E-Mails und Zugangsdaten bleiben auf deinem Gerät. Die App verbindet sich direkt mit dem Mailserver der RUB; der AStA erhält keine Inhalte.'
                    ' Details gibt es hier: ',
              ),
              TextSpan(text: _privacyLink, style: linkStyle, recognizer: _linkTap),
              const TextSpan(text: '.'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // checkbox for the User to agree to the Terms and Conditions
        //
        // the terms and conditions themselves are accessible by tapping on the "Nutzungsbedingungen" which is visually desgined like a link
        Row(
          children: [
            Checkbox(
              value: _termsAccepted,
              onChanged: (value) {
                setState(() {
                  _termsAccepted = value ?? false;
                });
              },
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: 'Ich akzeptiere die '),
                    TextSpan(text: 'Nutzungsbedingungen', style: linkStyle, recognizer: _termsTap),
                    const TextSpan(text: '.'),
                    const TextSpan(
                      text: '(Pflicht)',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // the continue button only activates when the User has agreed to the Terms and Conditions
        AnimatedOpacity(
          opacity: _termsAccepted ? 1.0 : 0.4,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: CampusButton(
            text: 'Weiter',
            onTap: () {
              if (_termsAccepted) {
                setState(() {
                  _hasContinued = true;
                });
              } else {
                _showUpdateMessages('Akzeptiere die Nutzungsbedingungen um fortzufahren!');
              }
            },
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  // build the "login" state of the Setup Screen
  Widget _buildLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: const [
              TextSpan(
                text: 'In den Einstellungen, standardmäßig aus:\n',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),

        // disclaimer for notification support, currently notifications are only supported for Android since this flow does not user Firebase
        //
        // in future updates we aim to expand to IOS notifications
        Column(
          spacing: 5,
          children: [
            const Row(
              spacing: 10,
              children: [
                Icon(Icons.info_outline),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Benachrichtigungen werden aktuell nur für Android unterstützt.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),

            // optional selections for notifications and public notifications
            Row(
              children: [
                Checkbox(
                  value: _notificationsEnabled,
                  onChanged: (value) async {
                    final enabled = value ?? false;
                    setState(() {
                      _notificationsEnabled = enabled;
                      // if notifications are disabled also disable private notification setting
                      if (!enabled) {
                        _publicNotifications = false;
                      }
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Benachrichtigungen über neue E-Mails erhalten.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            AnimatedOpacity(
              opacity: _notificationsEnabled ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 250),
              child: IgnorePointer(
                ignoring: !_notificationsEnabled,
                child: Row(
                  children: [
                    Checkbox(
                      value: _publicNotifications,
                      onChanged: (value) async {
                        setState(() {
                          _publicNotifications = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Absender und Betreff in Benachrichtigungen anzeigen. Diese sind dann auch auf dem Sperrbildschirm für andere sichtbar.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            CampusButton(
              text: 'Anmelden',
              onTap: () async {
                if (_notificationsEnabled) {
                  // check if notification permissions are granted, if not request the permission
                  var status = await Permission.notification.status;
                  if (!status.isGranted) {
                    status = await Permission.notification.request();
                  }

                  // if the permission request failed, reset the User selections and inform the User of the failure (bubble message)
                  //
                  // requests might be denied in these cases:
                  //     - the User manually turned the Notifications Permissions for the App off in their phone settings
                  //     - the OS request window has already been called multiple times
                  //     - the User has already denied the permissions through firebase during the on boarding
                  // -> if the request is denied the User has to manually set the Notification Permission in their phone settings
                  if (!status.isGranted) {
                    if (mounted) {
                      setState(() {
                        _notificationsEnabled = false;
                        _publicNotifications = false;
                      });
                    }

                    _showUpdateMessages(
                      status.isPermanentlyDenied
                          ? 'Benachrichtigungen sind in den Systemeinstellungen blockiert.'
                          : 'Benachrichtigungen wurden nicht erlaubt.',
                      type: BubbleType.error,
                    );
                  }
                }

                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool(EmailNotificationsPrefs.enabled, _notificationsEnabled);
                await prefs.setBool(EmailNotificationsPrefs.showDetails, _publicNotifications);

                await widget.onAccepted();
              },
            ),

            const SizedBox(height: 8),

            // when going back to the first page, reset all User selections
            CampusButton(
              text: 'Zurück',
              onTap: () {
                setState(() {
                  _hasContinued = false;
                  _termsAccepted = false;
                  _notificationsEnabled = false;
                  _publicNotifications = false;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
