import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/email_drawer/drafts.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/email_pages/folder_emails_page.dart';

class EmailDrawer extends StatelessWidget {
  const EmailDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Watch so the drawer updates when folders arrive
    final emailService = context.watch<EmailService>();

    return Drawer(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header with user info
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
                    //'Your Name',
                    'Mail', // dynamic
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    //'you@example.com',
                    'Folders from server', // dynamic
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // === Folders from server (dynamic) ===
            if (emailService.userFolders.isEmpty)
              ListTile(
                leading: Icon(Icons.folder, color: theme.iconTheme.color),
                title: Text('No folders loaded yet', style: theme.textTheme.bodyLarge),
                subtitle: Text('Check connection or refresh', style: theme.textTheme.bodySmall),
              )
            else
              ...emailService.userFolders.map((folder) {
                return ListTile(
                  leading: Icon(Icons.folder, color: theme.iconTheme.color),
                  title: Text(folder.displayName, style: theme.textTheme.bodyLarge),
                  subtitle: Text(folder.mailboxName, style: theme.textTheme.bodySmall),
                  onTap: folder == UserEmailFolder.drafts
                      ? () {
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const DraftsPage()));
                          });
                        }
                      : () {
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FolderEmailsPage(
                                  mailboxName: folder.mailboxName,
                                  title: folder.displayName,
                                ),
                              ),
                            );
                          });
                        },
                );
              }),

            const Divider(),

            //  Settings option (placeholder)
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
              Navigator.pop(context); //return to the more page

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
