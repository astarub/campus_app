import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/email_pages/email_view.dart';

class ArchivesPage extends StatelessWidget {
  const ArchivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailService = Provider.of<EmailService>(context, listen: false);
    final archivedEmails = emailService.filterEmails('', EmailFolder.archives);

    return Scaffold(
      appBar: AppBar(title: const Text('Archives')),
      body: archivedEmails.isEmpty
          ? const Center(child: Text('No archived emails'))
          : ListView.builder(
              itemCount: archivedEmails.length,
              itemBuilder: (context, index) {
                final email = archivedEmails[index];
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
