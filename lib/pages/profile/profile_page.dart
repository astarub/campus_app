import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/auth/keycloak_auth_provider.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_auth_provider.dart';
import 'package:campus_app/pages/wallet/ticket_login_screen.dart';
import 'package:campus_app/pages/wallet/ticket_warning_notifier.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Profile page just reads the global auth state and shows the current user if available.
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;
    // This connects to Keycloak to get the login status and user data.
    // It also makes the page rebuild whenever the login state changes.
    final KeycloakAuthProvider keycloakAuthProvider =
        context.watch<KeycloakAuthProvider>();
    final TicketAuthProvider ticketAuthProvider =
        context.watch<TicketAuthProvider>();
    final keycloakUser = keycloakAuthProvider.currentUser;
    final ticketUser = ticketAuthProvider.currentUser;
    final bool isKeycloakLoggedIn =
        keycloakAuthProvider.isLoggedIn && keycloakUser != null;

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
              isKeycloakLoggedIn
                  ? keycloakUser.name
                  : 'Global login not active',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isKeycloakLoggedIn
                  ? 'RUB LoginID: ${keycloakUser.loginId}'
                  : 'Sign in.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (keycloakAuthProvider.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                keycloakAuthProvider.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.redAccent,
                ),
              ),
            ],
            const SizedBox(height: 32),
            Text(
              'Global login',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (isKeycloakLoggedIn) ...[
              // Show only the profile data that really matters for this task.
              Card(
                color: theme.cardColor,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: const Text('Name'),
                      subtitle: Text(keycloakUser.name),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.account_circle_outlined),
                      title: const Text('RUB LoginID'),
                      subtitle: Text(keycloakUser.loginId),
                    ),
                    if (keycloakUser.email != null) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Email'),
                        subtitle: Text(keycloakUser.email!),
                      ),
                    ],
                    if (keycloakUser.matriculationNumber != null) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.numbers_outlined),
                        title: const Text('Matriculation number'),
                        subtitle: Text(keycloakUser.matriculationNumber!),
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
                        await context.read<KeycloakAuthProvider>().logout();
                      },
                    ),
                  ],
                ),
              ),
            ] else ...[
              CampusButton(
                text: keycloakAuthProvider.isLoading
                    ? 'Signing in...'
                    : 'Login',
                onTap: () async {
                  if (keycloakAuthProvider.isLoading) return;

                  // Start the global Keycloak login in the browser.
                  keycloakAuthProvider.clearError();
                  await context.read<KeycloakAuthProvider>().login();
                },
              ),
            ],
            const SizedBox(height: 32),
            Text(
              'Semester ticket',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              color: theme.cardColor,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.confirmation_number_outlined),
                    title: Text(
                      ticketAuthProvider.isLoggedIn
                          ? 'Ticket active'
                          : 'Ticket not active',
                    ),
                    subtitle: ticketUser == null
                        ? null
                        : Text('RUB LoginID: ${ticketUser.loginId}'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      ticketAuthProvider.isLoggedIn
                          ? Icons.logout
                          : Icons.login,
                    ),
                    title: Text(
                      ticketAuthProvider.isLoggedIn
                          ? 'Logout from ticket'
                          : 'Open ticket login',
                    ),
                    trailing: ticketAuthProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    onTap: ticketAuthProvider.isLoading
                        ? null
                        : () async {
                            if (ticketAuthProvider.isLoggedIn) {
                              final TicketWarningNotifier warningNotifier =
                                  context.read<TicketWarningNotifier>();
                              await ticketAuthProvider.logout();
                              warningNotifier.set(false);
                              return;
                            }

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TicketLoginScreen(
                                  onTicketLoaded: () {},
                                ),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
