import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client//email_view.dart';

class ArchivesPage extends StatelessWidget {
  final List<Email> allEmails;

  const ArchivesPage({Key? key, required this.allEmails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter emails by "archives" folder
    final archivedEmails = allEmails.where((email) => email.folder == EmailFolder.archives).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Emails'),
      ),
      body: archivedEmails.isEmpty
          ? const Center(
              child: Text('No archived emails.'),
            )
          : ListView.separated(
              itemCount: archivedEmails.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final email = archivedEmails[index];
                return EmailTile(
                  email: email,
                  isSelected: false,
                  onLongPress: () {},
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmailView(email: email),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
