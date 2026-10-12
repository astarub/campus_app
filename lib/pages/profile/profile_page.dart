import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/auth/keycloak_auth_provider.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_auth_provider.dart';
import 'package:campus_app/pages/wallet/ticket_login_screen.dart';
import 'package:campus_app/pages/wallet/ticket_warning_notifier.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';

/// Shows the separate Keycloak and semester-ticket sessions
/// The local Keycloak session does not provide a RUB ticket
/// StatelessWidget keeps no mutable state inside this page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // build returns the widget tree and overrides the method from StatelessWidget
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;
    // watch rebuilds this page after either provider calls notifyListeners
    final KeycloakAuthProvider keycloakAuthProvider =
        context.watch<KeycloakAuthProvider>();
    final TicketAuthProvider ticketAuthProvider =
        context.watch<TicketAuthProvider>();
    final keycloakUser = keycloakAuthProvider.currentUser;
    final ticketUser = ticketAuthProvider.currentUser;

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
            // condition ? first : second chooses the text shown to the user
            Text(
              keycloakUser != null
                  ? keycloakUser.name
                  : 'Global login not active',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              keycloakUser != null
                  ? 'RUB LoginID: ${keycloakUser.loginId}'
                  : 'Sign in.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            // if adds these widgets only when an error exists
            // ... inserts every widget from the following list
            if (keycloakAuthProvider.errorMessage != null) ...[
              const SizedBox(height: 12),
              // ! is safe here because the condition above already rejected null
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
            if (keycloakUser != null) ...[
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
                        // read accesses the provider without listening for changes here
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

/// Opens the profile from the header of each main app section
class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;

    return IconButton(
      icon: Icon(
        Icons.person_outline,
        color: theme.colorScheme.onSurface,
      ),
      onPressed: () {
        // Use the root navigator because each main section has its own navigator
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => const ProfilePage(),
          ),
        );
      },
    );
  }
}
