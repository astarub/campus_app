import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/email_pages/compose_email_screen.dart';

class EmailView extends StatelessWidget {
  final Email email;
  final void Function(Email)? onDelete;
  final void Function(Email)? onRestore;
  final bool isInTrash;

  const EmailView({
    super.key,
    required this.email,
    this.onDelete,
    this.onRestore,
    this.isInTrash = false,
  });

  void _handleReply(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeEmailScreen(replyTo: email),
      ),
    );
  }

  void _confirmPermanentDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permanently Delete'),
        content: const Text('This action is permanent. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              if (onDelete != null) {
                onDelete!(email);
              }
              Navigator.pop(context); // Close email view
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email permanently deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleRestore(BuildContext context) {
    if (onRestore != null) {
      onRestore!(email);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email restored from trash')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeText = '${email.date.hour}:${email.date.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('RubMail'),
        actions: [
          if (!isInTrash)
            IconButton(
              icon: const Icon(Icons.reply),
              onPressed: () => _handleReply(context),
              tooltip: 'Reply',
            ),
          if (!isInTrash && onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                onDelete!(email);
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
              onPressed: () => _handleRestore(context),
              tooltip: 'Restore',
            ),
          if (isInTrash)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => _confirmPermanentDelete(context),
              tooltip: 'Permanently Delete',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
                Text(
                  timeText,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Subject
            Text(
              email.subject,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Body
            Text(
              email.body,
              style: theme.textTheme.bodyLarge,
            ),

            // Attachments
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
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.insert_drive_file, size: 30),
                        const SizedBox(height: 4),
                        Text(
                          'File ${index + 1}',
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
              onPressed: () => _handleReply(context),
              tooltip: 'Reply',
              child: const Icon(Icons.reply),
            )
          : null,
    );
  }
}
