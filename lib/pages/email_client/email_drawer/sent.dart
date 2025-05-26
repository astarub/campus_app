import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/email_view.dart';

class SentPage extends StatelessWidget {
  const SentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailService = Provider.of<EmailService>(context, listen: false);
    final sentEmails = emailService.filterEmails('', EmailFolder.sent);

    return Scaffold(
      appBar: AppBar(title: const Text('Sent Emails')),
      body: sentEmails.isEmpty
          ? const Center(child: Text('No sent emails'))
          : ListView.builder(
              itemCount: sentEmails.length,
              itemBuilder: (context, index) {
                final email = sentEmails[index];
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
