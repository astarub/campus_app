import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/email_drawer/archives.dart';
import 'package:campus_app/pages/email_client/email_drawer/drafts.dart';
import 'package:campus_app/pages/email_client/email_drawer/sent.dart';
import 'package:campus_app/pages/email_client/email_drawer/trash.dart';

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
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person, size: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'you@example.com',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            // Inbox without navigation for example:
            ListTile(
              leading: const Icon(Icons.inbox),
              title: const Text('Inbox'),
              onTap: () => Navigator.pop(context),
            ),

            // Using helper method to reduce repetition:
            _buildDrawerItem(
              context,
              icon: Icons.send,
              title: 'Sent',
              page: const SentPage(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.archive,
              title: 'Archives',
              page: const ArchivesPage(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.drafts,
              title: 'Drafts',
              page: const DraftsPage(),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.delete,
              title: 'Trash',
              page: const TrashPage(),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add SettingsPage() navigation here later
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // close the drawer first

        // Delay navigation until after drawer closes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        });
      },
    );
  }
}
