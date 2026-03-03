import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      appBar: AppBar(title: Text(title)),
      body: emails.isEmpty
          ? const Center(child: Text('No emails'))
          : ListView.builder(
              itemCount: emails.length,
              itemBuilder: (context, index) {
                final email = emails[index];
                return EmailTile(
                  email: email,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EmailView(email: email),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
