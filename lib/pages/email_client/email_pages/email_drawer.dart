import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/email_drawer/drafts.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/email_pages/folder_emails_page.dart';

class EmailDrawer extends StatefulWidget {
  final VoidCallback? onLoggedOut;
  const EmailDrawer({
    super.key,
    required this.onLoggedOut,
  });

  @override
  State<EmailDrawer> createState() => _EmailDrawerState();
}

class _EmailDrawerState extends State<EmailDrawer> {
  final Set<String> _expandedFolders = {}; // list of currently expanded folders
  final ScrollController _folderScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch so the drawer updates when folders arrive
    final emailService = context.watch<EmailService>();

    // get list of folders all at depth level 1
    final topLevel = emailService.userFolders.where((f) => f.depth == 1).toList()
      ..sort((a, b) => _folderSortOrder(a).compareTo(_folderSortOrder(b)));

    // get the display Name and Address for the Header
    final authService = context.read<EmailAuthService>();
    final displayName = authService.displayName ?? '';
    final emailAddress = authService.senderEmail ?? '';

    return Drawer(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            // Drawer header with user info
            Container(
              padding: const EdgeInsets.fromLTRB(0, 40, 20, 20),
              decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName, // dynamic
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    emailAddress,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            const Divider(),

            // === Folders from server (dynamic) ===
            // these occupy a scrollable area to prevent UI clipping
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Scrollbar(
                  controller: _folderScrollController,
                  radius: const Radius.circular(10),
                  thickness: 5,
                  thumbVisibility: true,
                  child: ListView(
                    controller: _folderScrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      if (emailService.userFolders.isEmpty)
                        ListTile(
                          leading: Icon(Icons.folder, color: theme.iconTheme.color),
                          title: Text('No folders loaded yet', style: theme.textTheme.bodyLarge),
                          subtitle: Text('Check connection or refresh', style: theme.textTheme.bodySmall),
                        )
                      else
                        ...topLevel.map((folder) => _buildFolderTile(context, folder, emailService)),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(),

            // === Logout with confirmation ===
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text('Logout', style: TextStyle(color: theme.colorScheme.error)),
              onTap: () => _confirmLogout(context),
            ),

            const SizedBox(height: 60),
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
              // Call logout logic from EmailAuthService and EmailService
              final emailAuthService = context.read<EmailAuthService>();
              final emailService = context.read<EmailService>();

              Navigator.pop(ctx); // close dialog
              Navigator.pop(context); // close drawer

              await emailAuthService.logout();
              emailService.clear();

              widget.onLoggedOut?.call();
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

  // (recursive) dynamic folder creation, depending on if a folder has children
  Widget _buildFolderTile(
    BuildContext context,
    UserEmailFolder folder,
    EmailService emailService,
  ) {
    // list of a folders next depth level children
    final children = emailService.userFolders.where((f) => _isDirectChild(f.mailboxName, folder.mailboxName)).toList();

    final isExpanded = _expandedFolders.contains(folder.mailboxName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(
            _folderIcon(folder),
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(folder.displayName),
          trailing: folder.hasChildren
              ? IconButton(
                  icon: AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 400),
                    child: const Icon(Icons.expand_more),
                  ),
                  onPressed: () => setState(() {
                    if (isExpanded) {
                      _expandedFolders.remove(folder.mailboxName);
                    } else {
                      _expandedFolders.add(folder.mailboxName);
                    }
                  }),
                )
              : null,
          onTap: () => _navigateToFolder(context, folder, emailService),
        ),

        // subfolder animation
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: folder.hasChildren && isExpanded
              ? Column(
                  children: children.map((child) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: _buildFolderTile(context, child, emailService),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // determine direct children (next depth level) using mailboxname (path)
  bool _isDirectChild(String child, String parent) {
    return child.startsWith('$parent/') && child.substring(parent.length + 1).split('/').length == 1;
  }

  // map Icons to system folders, custom folders get generic folder icon
  IconData _folderIcon(UserEmailFolder folder) {
    switch (folder) {
      case UserEmailFolder.inbox:
        return Icons.inbox;
      case UserEmailFolder.drafts:
        return Icons.drafts;
      case UserEmailFolder.sent:
        return Icons.send;
      case UserEmailFolder.spam:
        return Icons.local_fire_department;
      case UserEmailFolder.trash:
        return Icons.delete;
      default:
        return Icons.folder;
    }
  }

  // Routing for Folder Opening
  void _navigateToFolder(BuildContext context, UserEmailFolder folder, EmailService emailService) {
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (folder == UserEmailFolder.drafts) {
        emailService.openFolder(UserEmailFolder.drafts);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DraftsPage(),
          ),
        );
      } else {
        emailService.openFolder(folder);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FolderEmailsPage(
              mailboxName: folder.mailboxName,
              title: folder.displayName,
            ),
          ),
        );
      }
    });
  }

  // assigns an order to the folder, so that the system folders are at the top of the list, above the custom foldersr
  int _folderSortOrder(UserEmailFolder folder) {
    switch (folder) {
      case UserEmailFolder.inbox:
        return 0;
      case UserEmailFolder.drafts:
        return 1;
      case UserEmailFolder.sent:
        return 2;
      case UserEmailFolder.spam:
        return 3;
      case UserEmailFolder.trash:
        return 4;
      default:
        return 100;
    }
  }
}
