import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/pages/email_client/email_view.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailService = Provider.of<EmailService>(context, listen: false);
    final trashEmails = emailService.filterEmails('', EmailFolder.trash);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          emailService.selectionController.isSelecting
              ? '${emailService.selectionController.selectionCount} selected'
              : 'Trash',
        ),
        actions: [
          if (emailService.selectionController.isSelecting) ...[
            IconButton(
              icon: const Icon(Icons.restore),
              onPressed: () {
                emailService.moveEmailsToFolder(
                  emailService.selectionController.selectedEmails,
                  EmailFolder.inbox,
                );
                emailService.selectionController.clearSelection();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                emailService.deleteEmailsPermanently(
                  emailService.selectionController.selectedEmails,
                );
              },
            ),
          ],
        ],
      ),
      body: trashEmails.isEmpty
          ? const Center(child: Text('Trash is empty.'))
          : ListView.separated(
              itemCount: trashEmails.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final email = trashEmails[index];
                return EmailTile(
                  email: email,
                  isSelected: emailService.selectionController.isSelected(email),
                  onTap: () {
                    if (emailService.selectionController.isSelecting) {
                      emailService.selectionController.toggleSelection(email);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmailView(
                            email: email,
                            isInTrash: true,
                            onDelete: (email) => emailService.deleteEmailsPermanently([email]),
                            onRestore: (email) => emailService.moveEmailsToFolder([email], EmailFolder.inbox),
                          ),
                        ),
                      );
                    }
                  },
                  onLongPress: () => emailService.selectionController.toggleSelection(email),
                );
              },
            ),
    );
  }
}
