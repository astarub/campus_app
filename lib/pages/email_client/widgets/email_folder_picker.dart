import 'package:flutter/material.dart';

import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/utils/widgets/bubble_message.dart';
import 'package:campus_app/utils/widgets/bubble_service.dart';

/// Dynamic Folder Picker for the Email Pull Up Sheet
class EmailFolderPicker extends StatelessWidget {
  final Email email;
  final EmailService emailService;
  final VoidCallback? onActionComplete;

  const EmailFolderPicker({
    super.key,
    required this.email,
    required this.emailService,
    this.onActionComplete,
  });

  @override
  Widget build(BuildContext context) {
    // helper function to use the global bubble notifications
    void showUpdateMessages(String message, {BubbleType type = BubbleType.info}) {
      BubbleService().show(
        context,
        message: message,
        type: type,
        top: 20,
      );
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text(
              'Ordner wählen',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ...emailService.userFolders.map(
            (folder) => ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: Text(folder.displayName),
              onTap: () async {
                Navigator.pop(context);
                await emailService.moveEmailToMailbox(email, folder.displayName);
                showUpdateMessages('Email erfolgreich verschoben!');
                onActionComplete?.call();
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
