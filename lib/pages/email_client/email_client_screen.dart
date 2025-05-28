import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/email_client_page.dart';
import 'package:campus_app/pages/wallet/ticket_login_screen.dart';

class EmailClientScreen extends StatefulWidget {
  const EmailClientScreen({super.key});

  @override
  State<EmailClientScreen> createState() => _EmailClientScreenState();
}

class _EmailClientScreenState extends State<EmailClientScreen> {
  final EmailAuthService _emailAuthService = GetIt.instance<EmailAuthService>();
  bool _isLoading = true;
  bool _hasCredentials = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final hasCredentials = await _emailAuthService.hasValidCredentials();
      if (mounted) {
        setState(() {
          _hasCredentials = hasCredentials;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasCredentials = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_hasCredentials) {
      // Navigate to login screen with callback to return to email
      return TicketLoginScreen(
        onTicketLoaded: () {
          // After successful login, navigate to email client
          if (mounted) {
            setState(() {
              _hasCredentials = true;
            });
          }
        },
      );
    }

    // User has credentials, show email client
    return const EmailClientPage();
  }
}
