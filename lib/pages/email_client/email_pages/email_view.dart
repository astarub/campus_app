import 'package:campus_app/utils/widgets/styled_html.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/email_pages/compose_email_screen.dart';

// Displays a full view of an email, including sender info, subject, body, and actions (reply, delete, restore)
class EmailView extends StatelessWidget {
  final Email email; // The email being viewed
  final void Function(Email)? onDelete; // Optional callback for deletion
  final void Function(Email)? onRestore; // Optional callback for restoring from trash
  final bool isInTrash; // Whether the email is currently in the trash folder

  const EmailView({
    super.key,
    required this.email,
    this.onDelete,
    this.onRestore,
    this.isInTrash = false,
  });

  // Opens the compose screen with the current email as a reply
  void _handleReply(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeEmailScreen(replyTo: email),
      ),
    );
  }

  // Shows confirmation dialog before permanently deleting the email
  void _confirmPermanentDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permanently Delete'),
        content: const Text('This action is permanent. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Cancel action
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              if (onDelete != null) {
                onDelete!(email); // Perform delete
              }
              Navigator.pop(context); // Close email view
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email permanently deleted')),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  // Handles restoring a trashed email
  void _handleRestore(BuildContext context) {
    if (onRestore != null) {
      onRestore!(email);
      Navigator.pop(context); // Close email view
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email restored from trash')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeText = '${email.date.hour}:${email.date.minute.toString().padLeft(2, '0')}'; // Format time

    return Scaffold(
      appBar: AppBar(
        title: const Text('RubMail'),
        actions: [
          if (!isInTrash)
            IconButton(
              icon: const Icon(Icons.reply),
              onPressed: () => _handleReply(context), // Quick reply
              tooltip: 'Reply',
            ),
          if (!isInTrash && onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                onDelete!(email); // Soft delete (to trash)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email moved to trash')),
                );
              },
              tooltip: 'Delete',
            ),
          if (isInTrash)
            IconButton(
              icon: const Icon(Icons.restore_from_trash),
              onPressed: () => _handleRestore(context), // Restore from trash
              tooltip: 'Restore',
            ),
          if (isInTrash)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => _confirmPermanentDelete(context), // Permanent delete
              tooltip: 'Permanently Delete',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with sender info and timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email.sender,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: email.isUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (email.senderEmail.isNotEmpty)
                        Text(
                          email.senderEmail,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  timeText, // Display formatted time
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Subject line
            Text(
              email.subject,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Email body (HTML if available, fallback to plain text)
            if (email.htmlBody != null && email.htmlBody!.isNotEmpty)
              StyledHTML(
                text: email.htmlBody!,
                context: context,
              )
            else
              Text(
                email.body,
                style: theme.textTheme.bodyLarge,
              ),

            // Attachments section
            if (email.attachments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Attachments (${email.attachments.length})',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: email.attachments.length,
                  itemBuilder: (context, index) => Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_drive_file, size: 30, color: theme.iconTheme.color),
                        const SizedBox(height: 4),
                        Text(
                          'File ${index + 1}', // Display file number
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: !isInTrash
          ? FloatingActionButton(
              onPressed: () => _handleReply(context), // FAB for quick reply
              tooltip: 'Reply',
              child: const Icon(Icons.reply),
            )
          : null,
    );
  }
}
