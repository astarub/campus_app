import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/pages/email_client/email_drawer/archives.dart';
import 'package:campus_app/pages/email_client/email_drawer/drafts.dart';
import 'package:campus_app/pages/email_client/email_drawer/sent.dart';
import 'package:campus_app/pages/email_client/email_drawer/trash.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
// TODO: Create this page and import it
import 'package:campus_app/pages/email_client/email_drawer/spam.dart';

class EmailDrawer extends StatelessWidget {
  const EmailDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // === Drawer header with user info ===
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your Name',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'you@example.com',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // === Drawer navigation options ===
            ListTile(
              leading: Icon(Icons.inbox, color: theme.iconTheme.color),
              title: Text('Inbox', style: theme.textTheme.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(context, icon: Icons.send, title: 'Sent', page: const SentPage()),
            _buildDrawerItem(context, icon: Icons.archive, title: 'Archives', page: const ArchivesPage()),
            _buildDrawerItem(context, icon: Icons.drafts, title: 'Drafts', page: const DraftsPage()),
            _buildDrawerItem(context, icon: Icons.delete, title: 'Trash', page: const TrashPage()),

            // === NEW: Spam folder ===
            _buildDrawerItem(
              context,
              icon: Icons.report_gmailerrorred,
              title: 'Spam',
              page: const SpamPage(), // Make sure you define this page
            ),

            const Divider(),

            // === Settings option (placeholder) ===
            ListTile(
              leading: Icon(Icons.settings, color: theme.iconTheme.color),
              title: Text('Settings', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add SettingsPage navigation
              },
            ),

            // === Logout with confirmation ===
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text('Logout', style: TextStyle(color: theme.colorScheme.error)),
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to create drawer items with consistent styling and navigation
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      onTap: () {
        Navigator.pop(context); // close drawer first
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        });
      },
    );
  }

  /// Show confirmation dialog before logging the user out
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close drawer

              // Call logout logic from EmailAuthService and EmailService
              final emailAuthService = context.read<EmailAuthService>();
              final emailService = context.read<EmailService>();

              await emailAuthService.logout();
              emailService.clear();
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
