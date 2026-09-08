import 'package:flutter/material.dart';

import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_folder_picker.dart';

/// More Options for Email
class EmailBottomPanel extends StatelessWidget {
  final Email email;
  final EmailService emailService;
  final VoidCallback? onActionComplete;

  const EmailBottomPanel({
    super.key,
    required this.email,
    required this.emailService,
    this.onActionComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isDraft = email.folder == UserEmailFolder.drafts;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // change read status
          if (!isDraft)
            ListTile(
              leading: Icon(email.isUnread ? Icons.mark_email_read : Icons.mark_email_unread),
              title: Text(email.isUnread ? 'Als gelesen markieren' : 'Als ungelesen markieren'),
              onTap: () async {
                Navigator.pop(context);
                if (email.isUnread) {
                  await emailService.markAsRead(email);
                } else {
                  await emailService.markAsUnread(email);
                }
                onActionComplete?.call();
              },
            ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('In Ordner verschieben'),
            onTap: () {
              Navigator.pop(context);
              _showFolders(context);
            },
          ),
          if (!isDraft)
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Als Spam markieren'),
              onTap: () async {
                Navigator.pop(context);
                // JUST move the email temporarily, TODO: delegate to function for spam marking which will also raise Spam flag
                await emailService.moveEmailsToFolder([email], UserEmailFolder.spam);
                onActionComplete?.call();
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showFolders(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => EmailFolderPicker(email: email, emailService: emailService, onActionComplete: onActionComplete),
    );
  }
}
