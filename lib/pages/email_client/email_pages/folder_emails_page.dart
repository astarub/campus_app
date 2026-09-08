import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/widgets/email_search.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/email_pages/email_view.dart';

class FolderEmailsPage extends StatelessWidget {
  final String mailboxName;
  final String title;

  const FolderEmailsPage({
    super.key,
    required this.mailboxName,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final emailService = context.watch<EmailService>();

    final emails = emailService.getEmailsForMailbox(mailboxName);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    EmailSearch(folder: UserEmailFolder(mailboxName: mailboxName, displayName: title)),
              ),
            ),
          )
        ],
      ),
      body: emails.isEmpty
          ? const Center(child: Text('No emails'))
          : ListView.separated(
              itemCount: emails.length,
              separatorBuilder: (_, __) => Divider(
                height: 0,
                thickness: 0.5,
                indent: 45,
                endIndent: 10,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
              itemBuilder: (context, index) {
                final email = emails[index];
                return EmailTile(
                  email: email,
                  onTap: () async {
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmailView(
                            email: email,
                            folder: email.folder,
                            onDelete: (email, mailboxName) {
                              emailService.moveEmailsToFolder([email], UserEmailFolder.trash);
                            },
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
