import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/email_view.dart';

class DraftsPage extends StatelessWidget {
  const DraftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailService = Provider.of<EmailService>(context, listen: false);
    final draftEmails = emailService.filterEmails('', EmailFolder.drafts);

    return Scaffold(
      appBar: AppBar(title: const Text('Drafts')),
      body: draftEmails.isEmpty
          ? const Center(child: Text('No draft emails'))
          : ListView.builder(
              itemCount: draftEmails.length,
              itemBuilder: (context, index) {
                final email = draftEmails[index];
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
