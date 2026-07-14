import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/auth/auth_provider.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/wallet/ticket_login_screen.dart';
import 'package:campus_app/pages/wallet/ticket_warning_notifier.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Profile page just reads the global auth state and shows the current user if available.
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;
    // This connects to the AuthProvider to get the login status and user data.
    // It also makes the page rebuild whenever the login state changes.
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final bool isLoggedIn = authProvider.isLoggedIn && user != null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Profile',
          style: theme.textTheme.displaySmall,
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.onSurface,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: theme.primaryColor,
              child: Icon(
                Icons.person,
                size: 46,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isLoggedIn ? user.name : 'Not logged in',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isLoggedIn ? 'RUB LoginID: ${user.loginId}' : 'Sign in with your RUB account.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (authProvider.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                authProvider.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.redAccent,
                ),
              ),
            ],
            const SizedBox(height: 32),
            if (isLoggedIn) ...[
              // Show only the profile data that really matters for this task.
              Card(
                color: theme.cardColor,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: const Text('Name'),
                      subtitle: Text(user.name),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.account_circle_outlined),
                      title: const Text('RUB LoginID'),
                      subtitle: Text(user.loginId),
                    ),
                    if (user.matriculationNumber != null) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.numbers_outlined),
                        title: const Text('Matriculation number'),
                        subtitle: Text(user.matriculationNumber!),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: theme.cardColor,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () async {
                        await context.read<AuthProvider>().logout();
                        if (!context.mounted) return;
                        context.read<TicketWarningNotifier>().set(false);
                      },
                    ),
                  ],
                ),
              ),
            ] else ...[
              CampusButton(
                text: authProvider.isLoading ? 'Signing in...' : 'Go to login',
                onTap: () async {
                  if (authProvider.isLoading) return;

                  // We reuse the existing login screen, but the auth state stays global.
                  authProvider.clearError();

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TicketLoginScreen(
                        onTicketLoaded: _noopTicketLoaded,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void _noopTicketLoaded() {}
